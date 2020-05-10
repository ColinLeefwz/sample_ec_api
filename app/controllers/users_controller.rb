class UsersController < ApplicationController
  before_action :authorize_request
  before_action :check_admin_role, only: %i[create find]

  def create
    user = User.create!(user_params)
    user = user.reload

    render json: { id: user.id, name: user.name, email: user.email, role: user.role }.to_json, status: :ok
  end

  def find
    user = User.find_by(email: user_params[:email])

    return render json: { error: 'not_found' }.to_json, status: :not_found unless user.present?

    render json: { id: user.id, name: user.name, email: user.email, role: user.role, last_purchased_date: user.last_purchase_date }.to_json, status: :ok
  end

  def me
    render json: { id: @current_user.id, name: @current_user.name, email: @current_user.email, role: @current_user.role, last_purchased_date: @current_user.last_purchase_date, customer_rank: @current_user.customer_rank }.to_json, status: :ok
  end

  def products_list
    result = @current_user.orders.map do |order|
      {
        product_id: order.product_id,
        name: order.product_name,
        brand: order.product_brand,
        purchased_date: order.ready_at,
      }
    end

    render json: result.to_json, status: :ok
  end

  private

  def user_params
    params.permit(:name, :email, :password, :role)
  end
end
