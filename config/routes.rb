Analytic::Application.routes.draw do

  root :to => "template/projects#index"
  match "/logout" => "application#logout"
  match "/503" => "maintenance_plans#index"
  mount Resque::Server.new, :at => "/resque"

  resources :maintenance_plans
  resources :user_preferences

  resources :projects do

    member do
      post :event_item
      post :timelines
      post :dimensions
      post :ups
      post :update_project_widgets
    end

    resource :settings
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
    resources :widgets
    resources :user_attributes
    resources :action_logs
    resources :translations
    resources :project_users
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
    resources :widgets
    resources :maintenance_plans
    resources :translations
  end

  namespace :service do
    resources :projects do
      member do
        get :sync_metrics
      end
    end
  end
end
