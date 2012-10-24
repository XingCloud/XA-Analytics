Analytic::Application.routes.draw do

  root :to => "template/projects#index"
  match "/logout" => "application#logout"
  mount Resque::Server.new, :at => "/resque"

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
    resources :broadcastings
  end
end
