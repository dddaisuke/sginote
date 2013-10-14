Sginote::Application.routes.draw do
  mount Mercury::Engine => '/'
  namespace :mercury do
    resources :images
  end

  resources :notes
  resources :notebooks

  root 'top#index'
end
