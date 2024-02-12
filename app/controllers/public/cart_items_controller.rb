class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  def create
    #カート内商品を新規作成する
    #ログインしている顧客のカート内商品を作成するため、(顧客一人につきたくさんのカート内商品が存在する)複数形になる
    @cart_item = current_customer.cart_items.new(cart_item_params)
    @cart_items = current_customer.cart_items.all
    #カート内商品の会員ID = ログインしている会員のID
    @cart_item.customer_id = current_customer.id
    #item_idカラムに値を入れる(item.id)
    @cart_item.item_id = @cart_item.item.id
      #モデル内から(カート内の商品IDとパラメータから送信されたカートに入れる予定の商品IDと同じもの)が存在するか?
      if cart_item = @cart_items.find_by(item_id: params[:cart_item][:item_id])
        #存在する場合は下記処理を実行
        #更新された数量(new_amount) = 元の数量 + 追加された数量
        new_amount = cart_item.amount + @cart_item.amount
        #数量を更新されたものにupdateする
        cart_item.update_attribute(:amount, new_amount)
        #更新したら重複しているデータを削除する
        @cart_item.delete
      else
        #存在しない場合は下記処理を実行
        #新規に追加するのでupdateではなくsave
        @cart_item.save
      end
    redirect_to cart_items_path
  end

  def index
    @cart_items = current_customer.cart_items
    @total_payment = 0
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    cart_item.destroy
    redirect_to cart_items_path
  end

  def destroy_all
    #destroy_allでidを取得した一つだけでなく全てのデータを削除できる
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:item_id, :amount)
  end

end
