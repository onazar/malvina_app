Rails.application.routes.draw do
  #get 'static_pages/home'
  #match '/', to: 'static_pages#home', via: 'get'
  root to: 'static_pages#home'

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
    get 'update_order_in_rent_state', :on => :member
    get 'update_order_rent_returned_state', :on => :member
    #collection do
    #  get 'search'
    #end
  end

end
