class Item < ApplicationRecord
  has_one_attached :image
  belongs_to :genre
  
  #アップロードされた画像を指定されたサイズにリサイズするメソッド
  def get_image(width,height)
    #imageが存在しているか?
    unless image.attached?
      #存在していない場合に表示する画像
      #ファイルパスをRails.root.joinで取得
      file_path = Rails.root.join("app/assets/imgages/no_image.jpeg")
      #File.openはファイルを開くためのメソッド
      image.attach(io: File.open(file_path), filename: "default-image.jpg", content_type: "image/jpeg")
    end  
    #variantの使い方 variant(処理: 値)
    #画像を制限内(width, height)でリサイズする
    #processed: 既に指定された(制限内の)ものがあれば処理を省くことができる
    image.variant(resize_to_limit: [width, height]).processed
  end  
  
  #税込価格を求めるメソッド
  def with_tax_price
    #税抜価格(price)に1.1をかける(税率10%)
    #floor: 小数点以下を切り捨てることができる
    (price * 1.1).floor
  end  
end
