class Api::V1::ProductsController < ApplicationController
  def index
    render json: Product.all, status: :ok
  end

  def fetch
    product = Product.find_by_url!(params[:url])
    render json: product.serialize!, status: :ok
  end

  def update
    product = Product.create_or_update(product_params[:url])
    render json: product.serialize!, status: :ok
  end

  private
  def product_params
    params.require(:products).permit(:url)
  end
end
