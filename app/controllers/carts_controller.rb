class CartsController < ApplicationController
  before_action :category_all, only: :viewcart
  before_action :load_product, :check_vaild_quanity?,
    :update_quantity, only: :update_quantity_in_cart
  def show; end

  def addcart
    @product = Product.find params[:product_id]
    session[:cart] = [] unless session[:cart].present?
    add_attribute_to_cart session[:cart]
  end

  def viewcart
    total_price_cat = 0
    unless session[:cart].blank?
      session[:cart].each do |k|
        total_price_cat += k["total_price"].to_f
      end
    end
    @carts = session[:cart]
    respond_to do |format|
      format.html {}
      format.json{render json: {total_price_cat: total_price_cat, cart: @carts}}
    end
  end

  def destroy
    session[:cart].each do |p|
      if p["product_id"].to_i == params[:product_id].to_i
        session[:cart].delete p
      end
    end
  end

  def update_cart_quantity _cart, quantity, unitprice
    session[:cart].each do |t|
      if t["product_id"].to_i == params[:id].to_i
        t["quantity"] = quantity.to_i
        t["total_price"] = quantity.to_i * unitprice.to_f
      end
    end
  end

  def add_attribute_to_cart _cart
    if !session[:cart].empty?
      has_product_in_cart? session[:cart]
    else
      session[:cart].push(product_id: @product.id, name: @product.name,
        price: @product.price, quantity: 1, total_price: @product.price)
    end
  end

  def has_product_in_cart? _cart
    if session[:cart].any?{|c| c["product_id"] == @product.id}
      add_attribute session[:cart]
    else
      session[:cart].push(product_id: @product.id, name: @product.name,
        price: @product.price, quantity: 1, total_price: @product.price)
    end
  end

  def add_attribute _cart
    session[:cart].each do |p|
      next unless p["product_id"].to_i == params[:product_id].to_i
      p["quantity"] = p["quantity"].to_i + 1
      p["price"] = p["price"].to_f
      p["total_price"] = p["total_price"].to_f + @product.price.to_f
    end
  end

  def update_quantity_in_cart; end

  private

  def load_product
    @product = Product.find_by id: params[:id]
    return if @product
    flash[:danger] = t "error.product_not_found"
    redirect_to root_path
  end

  def check_vaild_quanity?
    return unless @product.quantity.to_i < params[:quantity].to_i
    session[:cart].each do |item|
      @total_price_cart = @total_price_cart.to_f + item["total_price"].to_f
    end
    render(json: {message: @product, notice: t(".notice"), total_price_cart: @total_price_cart}) && return
  end

  def update_quantity
    session[:cart].each do |item|
      if item["product_id"].to_i == @product.id
        item["quantity"] = params[:quantity].to_i
        item["total_price"] = params[:quantity].to_i * @product.price
      end
      @total_price_in_cart = @total_price_in_cart.to_f + item["total_price"]
    end
    return_cat
  end

  def return_cat
    @carts = session[:cart]
    render json: {message: @carts}
  end
end
