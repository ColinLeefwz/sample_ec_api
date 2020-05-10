class OrdersController < ApplicationController
  def purchase
    user = User.find(order_params[:user_id])
    product = Product.find(order_params[:product_id])
    order = Order.create!(user: user, product: product)
    if order&.id&.present?
      render json: { transaction_id: order.id, purchased_date: order.ready_at }.to_json, status: :ok
    else
      render json: { error_message: "#{product.name} is out of stock" }.to_json, status: :unprocessable_entity
    end
  end

  private

  def order_params
    params.permit(:user_id, :product_id)
  end
end
