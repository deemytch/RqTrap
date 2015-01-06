Rails.application.routes.draw do
  get '/' => 'hello#home' # trap_id generator
  put '/' => 'hello#newtrap', :as => :save_trap # saving and redirecting to requests

  match '/:trap_name', to: 'hello#trap', :via => :all
  get '/:id/requests', to: 'hello#trap_full', :as => :trap_list
  get '/request/:id', to: 'hello#trap_oneline', :as => :single_request

  root to: 'hello#home'
end
