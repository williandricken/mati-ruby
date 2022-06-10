Rails.application.routes.draw do
  resources :identities
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/mati', to: 'mati#index', as: :index_mati
  # post '/mati/send_input', to: 'mati#send_input', as: :send_input
  post '/identities/verification', to: 'identities#verification', as: :verification
  get '/govcheck', to: 'govcheck#index', as: :govcheck_index
  get '/govcheck/webhooks', to: 'govcheck#webhooks', as: :govcheck_webhooks
  # post '/identities/verification_flow_simple', to: 'identities#verification_flow_simple', as: :verification_flow_simple

  get '/flow_step1', to: 'identities#flow_step1', as: :flow_step1
  get '/flow_step2', to: 'identities#flow_step2', as: :flow_step2
  get '/flow_step3', to: 'identities#flow_step3', as: :flow_step3
  # get '/flow_simple', to: 'identities#flow_simple', as: :flow_simple

  get '/webhook', to: 'webhook#index', as: :index_webhook
  post '/webhook/receive', to: 'webhook#receive', as: :receive_webhook
  post '/webhook/receive_govcheck', to: 'webhook#receive_govcheck', as: :receive_govcheck_webhook
end
