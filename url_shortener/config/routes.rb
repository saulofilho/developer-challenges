# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :v1 do
    resources :urls, only: %i[create show], param: :short_url do
      member do
        get 'accesses', to: 'urls#accesses'
      end
    end

    post '/login', to: 'authentication#login'
    delete '/logout', to: 'authentication#logout'
  end
end
