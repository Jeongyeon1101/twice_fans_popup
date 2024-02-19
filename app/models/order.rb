class Order < ApplicationRecord
  has_many :order_details, dependent: :destroy
  belongs_to :customer

  #支払方法選択(クレジットカード, 銀行振込)
  enum payment_method: { credit_card: 0, transfer: 1 }
  #配送先選択(自宅, 登録済み住所, 新しい住所)
  enum select_address: { curent_address: 0, registered_address: 1, new_address: 2 }
  #注文ステータス(支払い待ち, 支払い済, 出荷準備中, 出荷済み )
  enum status: { wait_payment: 0, confirm_payment: 1, preparing_ship: 2, finish_prepare: 3 }
end
