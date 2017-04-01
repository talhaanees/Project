Rails.application.routes.draw do
  resources :assignments
  resources :employees
  resources :stores
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
