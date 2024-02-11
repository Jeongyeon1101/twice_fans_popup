class Public::AddressesController < ApplicationController
  before_action :authenticate_customer!
  def index
    @customer = current_customer
    @address = Address.new
    @addresses = @customer.addresses.all
  end

  def create
    #newアクションで入力したデータをparamsから取得
    @address = Address.new(address_params)
    #customer_idカラムに値を入れる(current_customer)
    @address.customer_id = current_customer.id
    if @address.save
      redirect_to addresses_path
    else
      @customer = current_customer
      @addresses = @customer.addresses.all
      render :index
    end
  end

  private

  def address_params
    params.require(:address).permit(:postal_code, :address, :name, :customer_id)
  end

end
