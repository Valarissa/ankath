Ankath::Application.routes.draw do
  resources :photos

  root :to => 'static#index'
  match ':action' => 'static#:action'
end
