Rails.application.routes.draw do
  #get 'sessions/new'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
  
  get 'profile', to: 'users#show'
  #get 'search', to: 'books#find'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get 'reset', to: 'sessions#reset_password'
  get 'register', to: 'users#new'
  
  #get 'users/:user_id/appointments', to: 'appointments#user_index'
  get 'me/appointments', to: 'appointments#user_index'
  #get 'users/:user_id/appointments/new', to: 'appointments#user_new'
  # need '?page=xxx'
  resources :appointments
  resources :books
  #get 'books/:id', to: 'books#show', as: 'book'
  resources :users
  # need a record controller?
  # really need!
  #get 'users/:user_id/records', to: 'records#user_index'
  get 'enpower', to: "users#enpower"
  get 'me/records', to: 'records#user_index'
  get 'me/information', to: 'users#info'
  get 'me/information/edit', to: 'users#edit'
  get 'me/password/edit', to: 'users#change_password'
  get 'statistics', to: 'users#statistics'
  put 'me/password', to: 'users#write_password'
  put 'enpowerment', to: 'users#set_admin'
  post 'book/increment', to: 'books#increment'
  post 'book/out', to: 'books#out'
  post 'verification', to: 'users#verify'
  post 'login/ask-code', to: 'users#ask_code'
  post 'login/message', to: 'sessions#message_login'
  get 'users/:school_id/information', to: 'users#show_info'

  root 'welcome#index'
end
