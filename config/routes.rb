Rails.application.routes.draw do
  namespace :api, defaults: { format: :json }, path: 'api' do
    resources :projects, only: :update do
      resources :activities, only: [:index, :create, :update]
    end
    resources :users, only: :update, constraints: { id: /[^\/]+/ }
  end

  devise_for :users

  get 'explore', to: 'explore#index'
  get 'people', to: 'people#index'
  get 'discourse/sso' => 'discourse_sso#sso'

  resources :projects

  match ':username' => 'projects#index', via: :get, as: 'username_projects'
  match ':username/:id' => 'projects#show', via: :get, as: 'username_project'

  root 'home#index'
end
