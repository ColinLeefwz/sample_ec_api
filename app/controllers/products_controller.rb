class ProductsController < ApplicationController
  before_action :authorize_request, only: :create
  before_action :check_admin_role, only: :create

  def index
    products = Product.all.select(:id, :name, :brand, :price, :stock)

    render json: products.to_json, status: :ok
  end

  def create
    product = Product.create!(product_params)
    product = product.reload

    render json: { id: product.id, name: product.name, brand: product.brand, price: product.price, stock: product.stock }.to_json, status: :ok
  end

  private

  def product_params
    params.permit(:name, :brand, :price, :stock)
  end
end
