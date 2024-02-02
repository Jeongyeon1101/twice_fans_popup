Rails.application.routes.draw do
  #管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  #顧客用
  devise_for :customers, skip: [:passwords], controllers: {
    resistrations: "public/resistrations",
    sessions: "public/sessionss"
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
