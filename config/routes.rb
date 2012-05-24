Analytic::Application.routes.draw do

  root :to => "template/projects#index"
  match "/logout" => "application#logout"

  resources :projects do

    member do
      post :event_item
      post :chart
      post :dimensions
      post :user_attributes
    end

    resources :metrics
    resources :reports do
      member do
        get :set_category
        get :clone
      end
      resources :report_tabs
    end
    resources :report_categories
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
    resources :report_categories
    resources :metrics
    resources :projects
    resources :segments
    #resources :widgets
  end
end
