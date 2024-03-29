EIP::Application.routes.draw do

  resources :backoffice
  get "categories/new"
  get "categories/show"
  resources :settings
  resources :flows
  resources :report_comments
  resources :report_publications
  resources :followed_places
  resources :tokens,:only => [:create, :destroy]
  resources :webservices
  resources :reports
  resources :votes
  resources :users
  resources :publications
  resources :places
  resources :password_resets
  resources :alpha_users
  resources :comments
  resources :sessions
  resources :conversations
  resources :messages
  resources :categories

  get "search/users" => "users#search"
  get "search/places" => "places#search"

  get "feed" => "flows#index"


  get "password_resets/new"

  post "authenticate" => "sessions#create", :as => "authenticate"
  get "log_out" => "sessions#destroy", :as => "log_out"
  get "admin" => "sessions#new", :as => "log_in"
  get "sign_up" => "users#new", :as => "sign_up"


  get "resetpassword" => "password_resets#new", :as => "resetpassword"

  get "welcome/index"

  get "webservice-advertising"  => "webservices#advertising"
  get "webservice-user"         => "webservices#user"
  get "webservice-vote"         => "webservices#vote"
  get "webservice-place"        => "webservices#place"
  get "webservice-company"      => "webservices#company"
  get "webservice-category"     => "webservices#category"
  get "webservice-media"        => "webservices#media"
  get "webservice-placemessage" => "webservices#placemessage"
  get "webservice-publication"  => "webservices#publication"
  get "webservice-relationship" => "webservices#relationship"
  get "webservice-report"       => "webservices#report"
  get "webservice-login"        => "webservices#login"
  get "webservice-comment"      => "webservices#comment"
  get "webservice-resetpassword"=> "webservices#resetpassword"
  
  get "faq"=> "welcome#faq"
  get "place/:id" => "place#index"
  get "alpha_users_destroy" => "alpha_users#destroy"

  root to: "webservices#index"

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
