Rails.application.routes.draw do
  #get 'static_pages/home'
  match '/', to: 'static_pages#home', via: 'get'

  resources :part_types
  resources :parts
  resources :costumes

  resources :orders do
    get 'search', :on => :collection
    #collection do
    #  get 'search'
    #end
  end

end
