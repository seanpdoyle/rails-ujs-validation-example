class MessagesController < ApplicationController
  def new
    message = Message.new

    render locals: {message: message}
  end

  def create
    message = Message.new(message_params)

    if message.valid?
      redirect_back fallback_location: new_message_url
    else
      render :new, locals: {message: message}, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:subject, :content, :recipient)
  end
end
