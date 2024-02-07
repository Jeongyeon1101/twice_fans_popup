# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  before_action :customer_state, only: [:create]
  #createする前にcustomer_stateを実行する

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  private
  #ログインするcustomerがアクティブであるか
  def customer_state
    #取得したcustomerのアカウント=入力されたメールアドレスで登録されたアカウント
    @customer = Customer.find_by(email: params[:customer][:email])
    #customerのアカウントがメールアドレスと一致しなければreturn(終了)する
    return if !@customer
    #customerがアクティブなら終了する
    if @customer.is_active?
    else
      #アクティブでないならアラートを表示し登録画面にリダイレクトする
      flash[:alert] = "既に退会済みです。再度登録してからログインしてください。"
      redirect_to new_customer_registration_path
    end
  end
end
