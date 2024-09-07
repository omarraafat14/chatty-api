class ChatsController < ApplicationController
  before_action :set_chat, only: %i[ show update destroy ]

  # GET /applications/:application_token/chats
  def index
    @chats = Chat.all

    render json: @chats
  end

  # GET /applications/:application_token/chats/:id
  def show
    render json: @chat
  end

  # POST /applications/:application_token/chats
  def create
    @application = Application.find_by!(token: params[:application_id])
    @chat = @application.chats.create(chat_params)
    render json: { number: @chat.number }, status: :created
  end

  # PATCH/PUT /applications/:application_token/chats/:id
  def update
    @application = Application.find_by!(token: params[:application_id])
    @chat = @application.chats.update(chat_params)
    render json: @chat
  end

  # DELETE /applications/:application_token/chats/:id
  def destroy
    @application = Application.find_by!(token: params[:application_id])
    @chat = @application.chats.find(params[:id])
    @chat.destroy

    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.fetch(:chat, {})
    end
end
