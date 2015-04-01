Calendar::Application.routes.draw do

  resources :activities, :except => [:index] do
    collection do
      get 'search', to: 'activities#search', :as => :search
    end
  end
  resources :tags
  resources :departments, :except => [:destroy]
  # namespace :admin do
  #   resources :departments, :only => [:new, :create, :destroy]
  # end
  resources :users, :only => [:new, :create, :show] do
    member do
      put 'departments', :to => 'users#add_department', :as => :add_department_to
    end
    resources :activities, :only => [:index]
    resource :calendar, :only => [:show]  
  end

  resource :session, :only => [:create, :destroy, :new]
  root to: "sessions#new"
  
end
