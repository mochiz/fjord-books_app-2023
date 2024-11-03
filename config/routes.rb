Rails.application.routes.draw do
  devise_for :users
  resources :users, only: %i[index show]
  resources :books

  root 'users#index'
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
