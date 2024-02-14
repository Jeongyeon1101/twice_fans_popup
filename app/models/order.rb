class Order < ApplicationRecord
  has_many :order_details, dependent: :destroy
  belongs_to :customer

  #支払方法選択
  enum payment_method: { credit_card: 0, transfer: 1 }
  #配送先選択(自宅, 登録済み住所, 新しい住所)
  enum select_address: { curent_address: 0, registered_address: 1, new_address: 2}
end
