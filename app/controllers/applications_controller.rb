class ApplicationsController < ApplicationController
  before_action :set_application, only: %i[ show update destroy ]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found


  # GET /applications
  def index
    @applications = Application.cached_all_applications
    render json: @applications
  end

  # GET /applications/{token}
  def show
    render json: @application
  end

  # POST /applications
  def create
    @application = Application.new(application_params)

    if @application.save
      render json: @application, status: :created, location: application_url(@application)
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/{token}
  def update
    puts "Updating application"
    if @application.update(application_params)
      render json: @application
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/{token}
  def destroy
    @application.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def record_not_found
      render json: { error: "Application not found" }, status: :not_found
    end
    def set_application
      @application = Application.find_by_token!(params[:token])
    end


    # Only allow a list of trusted parameters through.
    def application_params
      params.require(:application).permit(:name)
    end
end
