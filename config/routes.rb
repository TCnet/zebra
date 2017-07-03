Rails.application.routes.draw do
   

 

  get 'password_resets/new'

  get 'password_resets/edit'

  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    member do
      get :following, :followers, :active
      match :active, to: :active, via: [:post, :patch]
      match :unactive, to: :unactive, via: [:post, :patch]
    end
  end

  

  
  get '/clearw', to: 'clears#new'
  post '/clearw', to: 'clears#create'
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :albums
  resources :photos,          only: [:new, :create, :destroy]

  post '/upload', to: 'upload#create'
  post '/uploads_finish', to: 'upload#finish'
  delete '/delete_uploads', to: 'upload#destroy'

  resources :products

  resources :upcs
  
  resources :albums do
    member do
      
      match :exportexcel, to: :exportexcel, via: [:post, :patch]
    end
  end
  

  
  
  
end
