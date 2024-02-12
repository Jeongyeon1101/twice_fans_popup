class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  #小径を計算するメソッド
  def subtotal
    #商品の税込価格 * 数量
    item.with_tax_price * amount
  end
end
