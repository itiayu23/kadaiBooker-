Rails.application.routes.draw do
 devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
root to: "homes#top"
get "home/about" => "homes#about"
get "search" => "searches#search"

# カテゴリー分けに関するところのみ記載
get 'books/comic' => 'books#comic'
get 'books/business' => 'books#business'
get 'books/novel' => 'books#novel'

resources :books do
  resource :favorites, only: [:create, :destroy]
  resources :book_comments, only: [:create, :destroy]
 end


resources :users do
 resource :relationships, only: [:create, :destroy]
 # フォローする
 get 'followings' => 'relationships#followings', as: 'followings'
 # フォローされる
 get 'followers' => 'relationships#followers', as: 'followers'

end

resources :messages, only: [:create]
resources :rooms, only: [:create, :index, :show]

end

