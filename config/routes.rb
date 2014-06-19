Rails.application.routes.draw do

  root 'welcome#index'
  get '/oauth2' => 'welcome#oauth2'
  get '/oauth2_callback' => 'welcome#oauth2_callback'

  post '/logout' => 'welcome#logout'

  get '/sales' => 'sales#index'
  get '/sales/targets' => 'sales#targets'
  get '/sales/schedule' => 'sales#schedule'
  get '/sales/profile' => 'sales#profile'
  get '/sales/payment' => 'sales#payment'
  get '/customer' => 'customer#index'

end
