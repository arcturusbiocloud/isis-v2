Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, path: 'api' do
    resources :projects, only: :update do
      resources :activities, only: :create
    end
  end

  resources :projects

  devise_for :users

  get 'explore', to: 'explore#index'

  root 'explore#index'
end
