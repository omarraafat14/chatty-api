class MessagesController < ApplicationController
  before_action :set_chat
  before_action :set_message, only: %i[ show update destroy ]
  before_action :new_message, only: :create
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found


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
    ActiveRecord::Base.transaction do
      if @message.valid?
        message_number = @message.number
        MessageCreationJob.perform_async(@chat.id, message_number, params[:body])
        render json: { message_number: message_number }, status: :created
      else
        render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
      end
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

  def search
    application = Application.find_by!(token: params[:application_token])
    chat = application.chats.find_by!(number: params[:chat_number])
    query = params[:query]

    results = Message.search({
      query: {
        bool: {
          must: {
            match: {
              body: {
                query: query,
                fuzziness: "AUTO"
              }
            }
          },
          filter: {
            term: { chat_id: chat.id }
          }
        }
      },
    })
    puts results.records
    render json: results.records
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find_by!(number: params[:chat_number])
    end

    def set_message
      @message = Message.find_by!(number: params[:number])
    end

    def new_message
      @message = @chat.messages.new(message_params)
    end

    # Only allow a list of trusted parameters through.
    def message_params
      params.require(:message).permit(:body)
    end

    def record_not_found
      render json: { errors: "Message not found" }, status: :not_found
    end
end
