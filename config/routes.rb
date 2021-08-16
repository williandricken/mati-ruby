Rails.application.routes.draw do
  resources :identities
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/mati', to: 'mati#index', as: :index_mati
  post '/mati/send_input', to: 'mati#send_input', as: :send_input

  get '/mati/webhook', to: 'webhook#index', as: :index_webhook
  post '/mati/webhook/receive', to: 'webhook#receive', as: :receive_webhook
end
