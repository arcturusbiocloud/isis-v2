Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, path: 'api' do
    resources :projects, only: :update do
      resources :activities, only: :create
    end
  end

  devise_for :users

  get 'explore', to: 'explore#index'

  resources :projects

  match ':username' => 'projects#index', via: :get, as: 'username_projects'
  match ':username/:id' => 'projects#show', via: :get, as: 'username_project'

  root 'explore#index'
end
