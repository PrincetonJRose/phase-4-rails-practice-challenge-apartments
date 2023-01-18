Rails.application.routes.draw do
  resources :apartments
  resources :tenants
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  
  post "/apartments/:id/new_lease", to: "apartments#new_lease"
  delete "/apartments/:apartment_id/end_lease/:lease_id", to: "apartments#end_lease"

end
