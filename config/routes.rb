Analytic::Application.routes.draw do

  root :to => "template/projects#index"
  match "/logout" => "application#logout"

  resources :projects do

    member do
      post :event_item
    end

    resources :metrics
    resources :reports do
      member do
        get :set_category
        get :clone
      end
      resources :report_tabs do
        member do
          post :data
          post :dimensions
        end
      end
    end
    resources :report_categories do
      member do
        get :shift_up
        get :shift_down
      end
    end
    resources :segments
    #resources :widgets
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
    #resources :widgets
  end
end
