Rails.application.routes.draw do
  concern :collaboratable do
    resources :collaborations, only: [:create, :destroy, :index, :show]
  end

  concern :activities do
    resources :activities, only: [:index]
  end
  
  get 'edam/terms' => 'edam#terms'
  get 'edam/topics' => 'edam#topics'
  get 'edam/operations' => 'edam#operations'
  
  get 'blob/terms' => 'blob#terms'
  get 'blob/topics' => 'blob#topics'
  get 'blob/operations' => 'blob#operations'
  resources :workflows

  #get 'static/home'
  get 'about' => 'about#tess', as: 'about'
  get 'about/registering' => 'about#registering', as: 'registering_resources'
  get 'about/requesting' => 'about#requesting', as: 'requesting_resources'
  get 'about/developers' => 'about#developers', as: 'developers'
  get 'about/us' => 'about#us', as: 'us'
  get 'about/create' => 'about#create', as: 'create'


  get 'privacy' => 'static#privacy', as: 'privacy'



  post 'materials/check_exists' => 'materials#check_exists'
  post 'zenodomaterials/check_exists' => 'zenodomaterials#check_exists'  
  post 'events/check_exists' => 'events#check_exists'
  post 'content_providers/check_exists' => 'content_providers#check_exists'
  post 'unscrapeds/check_exists' => 'unscrapeds#check_exists'
  post 'eventunscrapeds/check_exists' => 'eventunscrapeds#check_exists'
    
  #devise_for :users
  # Use custom registrations controller that subclasses devise's
  if (ActiveRecord::Base.connection rescue false)
    devise_for :users, :controllers => {
        :registrations => 'tess_devise/registrations',
        :omniauth_callbacks => 'callbacks'
    }
  end

  devise_scope :user do
    post 'users/auth/:provider', :to => 'callback#umbrella_aai'
  end
  #Redirect to users index page after devise user account update
  # as :user do
  #   get 'users', :to => 'users#index', :as => :user_root
  # end

  patch 'users/:id/change_token' => 'users#change_token', as: 'change_token'

  #mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  authenticate :user, lambda { |u| u.is_admin? } do
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end
  
  
  authenticate :user, lambda { |u| u.is_admin? || u.is_curator?  } do
    mount Blazer::Engine, at: "blazer"   
  end

  root 'static#home'

  get 'static/home'

  resources :users do
    resource :ban, only: [:create, :new, :destroy]
  end

  resources :nodes, concerns: :activities

  resources :events, concerns: :activities do
    collection do
      get 'count'
    end
    member do
      get 'redirect'
      post 'add_term'
      post 'add_data'
      post 'reject_term'
      post 'reject_data'
      get 'report'
      patch 'report', to: 'events#update_report'
    end
  end

  resources :packages, concerns: :activities

  resources :workflows, concerns: [:collaboratable, :activities] do
    member do
      get 'fork'
      get 'embed'
    end
  end

  resources :content_providers, concerns: :activities

  resources :materials, concerns: :activities do
    member do
      post :reject_term
      post :reject_data
      post :add_term
      post :add_data
    end
    collection do
      get 'count'
    end
  end

  resources :zenodomaterials, concerns: :activities do
    member do
      post :reject_term
      post :reject_data
      post :add_term
      post :add_data
    end
    collection do
      get 'count'
    end
  end

  resources :elearning_materials, concerns: :activities do
    member do
      post :reject_term
      post :reject_data
      post :add_term
      post :add_data
    end
    collection do
      get 'count'
    end
  end

  resources :subscriptions, only: [:show, :index, :create, :destroy] do
    member do
      get 'unsubscribe'
    end
  end
  
  get 'zenodomaterials/:id/newversionedit' => 'zenodomaterials#newversionedit', as: 'newversion'  
  put 'zenodomaterials/:id/newversionupdate' => 'zenodomaterials#newversionupdate', as: 'newversionupdate'
  #zenodo shows file lists so showing this should not be an issue
  get 'zenodomaterials/:id/listfiles' => 'zenodomaterials#listfiles', as: 'list_files'  
  #zenodo delete file, check this is not a security issue, could very well be
  post 'zenodomaterials/:id/deletezenodofile' => 'zenodomaterials#deletezenodofile', as: 'deletezenodofile'        
  post 'zenodomaterials/:id/newversionzenodo' => 'zenodomaterials#newversionzenodo', as: 'newversionzenodo'        
  get 'zenodomaterials/:id/aaaaaaaaaaaaaaaaa' => 'zenodomaterials#aaaaaaaaaaaaaaaaa', as: 'aaaaaaaaaaaaaaaaa'      #delete at a later date         
    
  get 'stars' => 'stars#index'
  post 'stars' => 'stars#create'
  delete 'stars' => 'stars#destroy'

  get 'likes' => 'likes#index'
  post 'likes' => 'likes#create'
  delete 'likes' => 'likes#destroy'
  
  #patch 'users/:id/change_token' => 'users#change_token', as: 'change_token'
  post 'materials/:id/unscrape' => 'materials#unscrape', as: 'unscrape_me'
  post 'zenodomaterials/:id/unscrape' => 'zenodomaterials#unscrape', as: 'zenodounscrape_me'  
  post 'events/:id/unscrape' => 'events#unscrape', as: 'eventunscrape_me'
      
  post 'materials/:id/update_packages' => 'materials#update_packages'
  post 'zenodomaterials/:id/update_packages' => 'zenodomaterials#update_packages'  
  post 'events/:id/update_packages' => 'events#update_packages'

  get 'search' => 'search#index'
  get 'test_url' => 'application#test_url'

  get 'zenodowebhook' => 'zenodowebhook#webhooks'
  put 'zenodowebhook' => 'zenodowebhook#refresh_token'
  
  get 'zenodomaterialredirect' => 'zenodomaterials#zenodoredirect'
    
  # error pages
  %w( 404 422 500 503 ).each do |code|
    get code, :to => "application#handle_error", :status_code => code
  end

  get 'curate/topic_suggestions' => 'curator#topic_suggestions'
  get 'curate/users' => 'curator#users'
  get 'curate' => 'curator#index'

  get 'cookies/consent' => 'cookies#consent'
  post 'cookies/consent' => 'cookies#set_consent'

  require 'sidekiq/web'
  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web, at: '/sidekiq'
  end

  get 'resolve/:prefix:type:id' => 'resolution#resolve', constraints: { prefix: /(.+\:)?/, type: /[a-zA-Z]/, id: /\d+/ }


  #maybe add curators too?
  #with authorize/policies we already block the unsigned user and non admin user from viewing index, show etc but might as well add it here too
  authenticate :user, lambda { |u| u.is_admin? } do
      resources :unscrapeds, only: [:show, :index,  :destroy], concerns: :activities do  
      end
  end  
    
  authenticate :user, lambda { |u| u.is_admin? } do
      resources :eventunscrapeds, only: [:show, :index,  :destroy], concerns: :activities do
      end    
  end
 
  get 'users/:id/zenodoedit' => 'users#zenodoedit' , as: 'zenodochoiceedit'  
  patch 'users/:id/zenodoupdate' => 'users#zenodoupdate' , as: 'zenodochoiceupdate'
  
=begin
  authenticate :user do
    resources :materials, only: [:new, :create, :edit, :update, :destroy]
  end
  resources :materials, only: [:index, :show]
=end

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
end
