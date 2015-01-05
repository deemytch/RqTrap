Rails.application.routes.draw do
  get '/' => 'hello#home' # trap_id generator
  match '/:trap_id', to: 'hello#trap', :via => :all
  get '/:trap_id/requests', to: 'hello#trap_full'
  get '/:trap_id/requests/:id', to: 'hello#trap_oneline'

  root to: 'hello#home'
end
