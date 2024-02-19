class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
    @order = Order.new
    @customer = current_customer
  end

  def confirm
    #パラメータから送信されたオーダー情報を受け取る
    @order = Order.new(order_params)
    #customer_idカラムにcurrent_customer.idを入れる
    @order.customer_id = current_customer.id
    #cart_itemsをログインしているcustomerのもののみに絞る
    @cart_items = current_customer.cart_items
    #@total_paymentの初期値を設定する
    @total_payment = 0
    #shipping_costの値を設定する
    @order.shipping_cost = 800
    #orderのselect_addressメソッドが"registered_address"の時の処理
    if params[:order][:select_address] =="registered_address"
      #@address = パラメータから送信されたorderの中のaddress_id
      @address = Address.find(params[:order][:address_id])
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name
    #orderのselect_addressメソッドが"current_address"の時の処理  
    elsif params[:order][:select_address] == "current_address"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
    else
      @order.save
    end
    @order_new = Order.new
    render :confirm
  end

  def create
    #パラメータから送信されたオーダー情報を受け取る
    order = Order.new(order_params)
    #customer_idカラムにcurrent_customer.idを入れる
    order.customer_id = current_customer.id
    #オーダー情報を保存する
    order.save!
    @cart_items = current_customer.cart_items.all
    #カート内商品ごとに注文詳細を作成していく
    @cart_items.each do |cart_item|
      @order_detail = OrderDetail.new
      @order_detail.order_id = order.id
      @order_detail.item_id = cart_item.item.id
      @order_detail.price = cart_item.item.with_tax_price
      @order_detail.amount = cart_item.amount
      @order_detail.making_status = 0
      @order_detail.save
    end
    #注文が完了し、注文詳細を作成したのでカート内商品を一括削除する
    CartItem.destroy_all
    redirect_to orders_complete_path
  end

  def index
    @orders = current_customer.orders.all
  end

  def show
    @order = Order.find(params[:id])
    #送信されたパラメータのidからそのorder_idのorder_detailsを取得する
    @order_details = OrderDetail.where(order_id: params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:payment_method, :postal_code, :address, :name, :shipping_cost, :total_payment)
  end
end
