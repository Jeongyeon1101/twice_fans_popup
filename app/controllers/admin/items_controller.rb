class Admin::ItemsController < ApplicationController
  before_action :authenticate_admin!

  def new
    @item = Item.new
  end

  def create
    @item = Item.new(item_params)
    #新しいitemを保存する
    if @item.save
      #成功したらリダイレクトする
      redirect_to admin_item_path(@item)
    else
      #失敗したら新規登録画面をrender(上書き表示)する
      render :new
    end
  end

  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  private

  def item_params
    params.require(:item).permit(:image, :name, :introduction, :genre_id, :price, :is_active)
  end
end
