Rails.application.routes.draw do
  # Authentication routes
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "logout", to: "sessions#destroy"
  get "about", to: "about#index"
  get "home/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Blog routes
  resources :articles do
    member do
      patch :publish
      patch :unpublish
      delete "remove_image/:image_id", action: :remove_image, as: :remove_image
    end
  end

  # Defines the root path route ("/")
  root "home#index"
end
