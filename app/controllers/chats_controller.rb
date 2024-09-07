class ChatsController < ApplicationController
  before_action :set_application
  before_action :set_chat, only: %i[ show update destroy ]

  # GET /applications/:application_token/chats
  def index
    @chats = @application.chats.all

    render json: @chats
  end

  # GET /applications/:application_token/chats/:chat_number
  def show
    render json: @chat
  end

  # POST /applications/:application_token/chats
  def create
    @chat = @application.chats.create(chat_params)
    render json: { number: @chat.number }, status: :created
  end

  # PATCH/PUT /applications/:application_token/chats/:chat_number
  def update
    @chat = @application.chats.update(chat_params)
    render json: @chat
  end

  # DELETE /applications/:application_token/chats/:chat_number
  def destroy
    @chat = @application.chats.find_by!(number: params[:chat_number])
    @chat.destroy

    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_application
      @application = Application.find_by!(token: params[:application_token])
    end

    def set_chat
      @chat = Chat.find_by!(number: params[:number])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.fetch(:chat, {})
    end
end
