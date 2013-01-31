PonyApp::Application.routes.draw do
  root :to => 'pages#index', as: :home_page

  resources :ponies

  get "kill_all_ponies" => "ponies#delete_all", :as => "kill_all_ponies"


  # See how all your routes lay out with "rake routes"
end
