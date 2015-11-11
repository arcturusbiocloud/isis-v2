Rails.application.routes.draw do
  devise_for :users

  get 'dashboard', to: 'dashboard#index'
  get 'dashboard/:status', to: 'dashboard#index', as: 'dashboard_status'
  get 'explore', to: 'explore#index'
  get 'people', to: 'people#index'
  get 'terms', to: 'terms#index', path: 'terms-of-service'
  get 'discourse/sso' => 'discourse_sso#sso'
  get 'terms/index'

  resources :projects do
    get 'download/:asset', to: 'projects#download', as: 'download_asset'
  end

  resources :experiments, except: [:show]

  match ':username' => 'projects#index', via: :get, constraints: { username: /[^\/]+/ }, as: 'username_projects'
  match ':username/:id' => 'projects#show', via: :get, constraints: { username: /[^\/]+/ }, as: 'username_project'

  root 'home#index'
end
