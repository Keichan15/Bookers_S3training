Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  devise_for :users
  root to: "homes#top"
  get 'home/about' => 'homes#about', as: 'about'

  # except 記載アクション以外のルーティングを作成
  # only 記載アクションのみルーティングを作成
  resources :books, only: [:index, :create, :show, :edit, :update, :destroy] do
    resources :book_comments, only: [:create, :destroy]

    resource :favorites, only: [:create, :destroy]
  end

  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  resources :groups do
    get "join" => "groups#join"
    get "mail/new" => "groups#mail_new"
    get "mail" => "groups#mail_create"
  end

  get '/search' => 'searches#search'
end
