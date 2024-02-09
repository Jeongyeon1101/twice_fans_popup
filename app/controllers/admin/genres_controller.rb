class Admin::GenresController < ApplicationController
  before_action :authenticate_admin!

  def index
    @genre = Genre.new
    @genres = Genre.all
  end



  def create
    #データを受け取り登録するためのインスタンス作成
    @genre = Genre.new(genre_params)
    #saveメソッドを実行する
    if @genre.save
      #成功したらリダイレクトする
      redirect_to admin_genres_path
    else
      #renderするための@genre再定義
      @genres = Genre.all
      #失敗したらrender(indexを上書き)する
      render :index
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    #urlのidからgenreを一件取得
    @genre = Genre.find(params[:id])
    #genre_paramsで許可されたカラムを更新
    @genre.update(genre_params)
    #リダイレクトする
    redirect_to admin_genres_path(@genre)
  end

  private

  def genre_params
    params.require(:genre).permit(:name)
  end
end
