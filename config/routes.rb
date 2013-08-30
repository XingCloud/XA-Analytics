Analytic::Application.routes.draw do

  root :to => "application#home"
  match "/logout" => "application#logout"
  match "/503" => "maintenance_plans#index"
  match "/projects_summary" => "application#projects_summary"
  match "/projects_details" => "application#projects_details"
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
      get :description
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
    resources :ads
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
        get :sync_user_attributes
      end
    end
  end

  match "/projects/:id/*other" => redirect {|params| "/projects/#{params[:id]}##{params[:other]}"}
  match "/template/projects/*other" => redirect {|params| "/template/projects##{params[:other]}"}
end
