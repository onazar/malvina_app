Rails.application.routes.draw do
  #get 'static_pages/home'
  match '/', to: 'static_pages#home', via: 'get'

  resources :part_types

  resources :parts do
    get 'part_names', :on => :collection
  end

  resources :costumes do
    get 'costume_names', :on => :collection
    get 'costume_parts', :on => :collection
  end

  resources :orders do
    get 'search', :on => :collection
    #collection do
    #  get 'search'
    #end
  end

end
