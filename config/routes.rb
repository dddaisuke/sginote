Sginote::Application.routes.draw do
  mount Mercury::Engine => '/'
  namespace :mercury do
    resources :images
  end

  resources :notes do
    collection do
      get 'find_word'
      get 'morpheme'
    end
  end
  resources :notebooks

  root 'top#index'
end
