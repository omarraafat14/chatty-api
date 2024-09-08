class ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: %i[ show update destroy ]
  before_action :new_chat, only: :create
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :missing_paramter

  # GET /applications/:application_token/chats
  def index
    @chats = @application.cached_chats

    render json: @chats
  end

  # GET /applications/:application_token/chats/:chat_number
  def show
    render json: @chat
  end

  # POST /applications/:application_token/chats
  def create
    ActiveRecord::Base.transaction do
      if @chat.valid?
        chat_number = @chat.number
        ChatCreationJob.perform_async(@application.id, chat_number, params[:name])
        render json: { chat_number: @chat.number }, status: :created
      else
        render json: { errors: @chat.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  # PATCH/PUT /applications/:application_token/chats/:chat_number
  def update
    if @chat.update(chat_params)
      render json: @chat
    else
      render json: @chat.errors.full_messages, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:application_token/chats/:chat_number
  def destroy
    @chat.destroy

    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by!(token: params[:application_token])
    end

    def set_chat
      @chat = Chat.find_by_number!(params[:number])
    end

    def new_chat
      @chat = @application.chats.new(chat_params)
    end
    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:name)
    end

    def record_not_found
      render json: { errors: "Chat not found" }, status: :not_found
    end

    def missing_paramter
      render json: { errors: "'name' param is missing or the value is empty" }, status: :unprocessable_entity
    end
end
