Rails.application.routes.draw do
  get 'sessions/new'
  root 'static_pages#home'
  get 'signup' => 'users#new'
  get 'help' => 'static_pages#help'
  get 'contacts' => 'static_pages#contacts'

  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
