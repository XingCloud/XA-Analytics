Analytic::Application.routes.draw do

  root :to => "template/projects#index"
  resources :projects do

    member do
      post :event_item
      get  :dashboard
    end

    resources :metrics
    resources :reports do
      member do
        get :set_category
      end
      get :render_segment, :as => :collection
      resources :report_tabs do
        member do
          get :data
          get :dimensions
        end
      end
    end
    resources :report_categories do
      member do
        get :shift_up
        get :shift_down
      end
    end
    resources :segments do
      collection do
        get 'template'
      end
    end
  end

  namespace :template do
    resources :reports do
      member do
        get :set_category
      end
      resources :report_tabs
    end
    resources :report_categories do
      member do
        get :shift_up
        get :shift_down
      end
    end
    resources :metrics
    resources :projects
    resources :segments
  end
  match "segments/template"

  match "/js_templates/:package.:extension",
        :to => 'js_templates#package', :as => :jammit, :constraints => {
          # A hack to allow extension to include "."
          :extension => /.+/
      }

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
