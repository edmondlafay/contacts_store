Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: 'api/contacts#index'

  namespace :api do
    delete 'contacts', to: 'contacts#destroy'
    resources :contacts, only: %i[index create] do
    end
  end
end
