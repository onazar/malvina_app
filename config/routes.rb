Rails.application.routes.draw do
  resources :clients
  resources :part_types
  resources :parts
  resources :costumes
  resources :orders
end
