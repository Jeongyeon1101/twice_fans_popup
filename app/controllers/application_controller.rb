class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  #AdminとCustomerでサインイン後の遷移先を分けている
  def after_sign_in_path_for(resource)
    case resource
    when Admin
      admin_root_path
    when Customer
      my_page_path
    end
  end

  #サインイン時と同様だが、サインアウト時はモデルではなくシンボルが返ってくるため:admin,:customerになっている
  def after_sign_out_path_for(resource)
    case resource
    when :admin
      new_admin_session_path
    when :customer
      root_path
    end
  end

  #beforeアクションで指定した処理を下記コードで実行し、パラメータを許可している
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:last_name, :first_name, :last_name_kana, :first_name_kana, :postal_code, :address, :telephone_number])
  end
end
