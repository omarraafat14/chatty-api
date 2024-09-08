class MessagesController < ApplicationController
  before_action :set_chat
  before_action :set_message, only: %i[ show update destroy ]

  # GET applications/:application_token/chats/:chat_number/messages
  def index
    @messages = @chat.cached_messages

    render json: @messages
  end

  # GET /applications/:application_token/chats/:chat_number/messages/:message_number
  def show
    render json: @message
  end

  # POST applications/:application_token/chats/:chat_number/messages
  def create
    @message = @chat.messages.new(message_params)

    if @message.save
      render json: @message, status: :created, location: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /applications/:application_token/chats/:chat_number/messages/:message_number
  def update
    if @message.update(message_params)
      render json: @message
    else
      render json: @message.errors, status: :unprocessable_entity
    end
  end

  # DELETE /applications/:application_token/chats/:chat_number/messages/:message_number
  def destroy
    @message.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find_by!(number: params[:chat_number])
    end

    def set_message
      @message = Message.find_by!(number: params[:number])
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:body)
    end
end
