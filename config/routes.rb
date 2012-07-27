Ankath::Application.routes.draw do
  devise_for :users

  resources :photos

  root :to => 'static#index'
  match ':action' => 'static#:action'
end
