Rails.application.routes.draw do
  devise_for :users
  root "static_pages#home"

  resources :cards, only: %i[index new create]
  resources :groups, only: %i[index show new create]

  # 招待リンクからの参加
  # asオプションで、/groups/join/:invite_tokenのURLを生成するヘルパーを定義
  get '/groups/join/:invite_token', to: 'groups#join', as: :join_group
end
