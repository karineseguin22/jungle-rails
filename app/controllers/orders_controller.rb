class OrdersController < ApplicationController

  def show
    @order = Order.find(params[:id])
  end

  def create
    @user = User.new(params[:user])
  
    charge = perform_stripe_charge
    order  = create_order(charge)

    
    respond_to do |format|
    if order.valid?
      UserMailer.welcome_email(@user,order).deliver_now
      empty_cart!
      format.html {   redirect_to order, notice: 'Your Order has been placed.'}
      format.json {   redirect_to order, notice: 'Your Order has been placed.'}
    else
      format.html {  redirect_to cart_path, flash: { error: order.errors.full_messages.first }}
      format.json {  redirect_to cart_path, flash: { error: order.errors.full_messages.first }}
    end
  end 

  rescue Stripe::CardError => e
    redirect_to cart_path, flash: { error: e.message }
  end

  private

  def empty_cart!
    # empty hash means no products in cart :)
    update_cart({})
  end

  def perform_stripe_charge
    Stripe::Charge.create(
      source:      params[:stripeToken],
      amount:      cart_subtotal_cents,
      description: "Khurram Virani's Jungle Order",
      currency:    'cad'
    )
  end

  def create_order(stripe_charge)
    order = Order.new(
      email: params[:stripeEmail],
      total_cents: cart_subtotal_cents,
      stripe_charge_id: stripe_charge.id, # returned by stripe
    )

    enhanced_cart.each do |entry|
      product = entry[:product]
      quantity = entry[:quantity]
      order.line_items.new(
        product: product,
        quantity: quantity,
        item_price: product.price,
        total_price: product.price * quantity
      )
    end
    order.save!
    order
  end

end
