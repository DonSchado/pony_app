PonyApp::Application.routes.draw do
  root :to => 'pages#index', as: :home_page

  resources :ponies

  # See how all your routes lay out with "rake routes"
end
