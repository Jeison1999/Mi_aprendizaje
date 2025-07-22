class OrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "orders_channel" if current_user&.admin?
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
