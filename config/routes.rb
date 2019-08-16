Rails.application.routes.draw do
  resources :users, shallow: true do
    resources :movements
  end
end
