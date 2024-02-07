Rails.application.routes.draw do
  #管理者用
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  #顧客用
  devise_for :customers, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: "public/sessions"
  }

  namespace :admin do
    root to: "homes#top"
    resources :customers, only: [:index, :show, :edit, :update]
    resources :items, only: [:new, :create, :index, :show, :edit, :update]
    resources :genres, only: [:create, :index, :edit, :update]
    resources :orders, only: [:show, :update]
    resources :order_details, only: [:update]
  end

  scope module: :public do
    root to: "homes#top"
    get "abount" => "homes#about"
    get "customers/my_page" => "customers#show", as: "my_page"
    get "customers/information/edit" => "customers#edit", as: "my_page_edit"
    patch "customers/information" => "customers#update", as: "my_page_update"
    patch "customers/withdraw"
    get "customers/confirm"
    delete "cart_items/destroy_all"
    post "orders/confirm"
    get "orders/complete"
    resources :items, only: [:index, :show]
    resources :cart_items, only: [:index, :create, :update, :destroy]
    resources :orders, only: [:new, :create, :index, :show]
    resources :addresses, only: [:index, :create, :edit, :update, :destroy]
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
