Rails.application.routes.draw do
  #resources :states
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	root 'states#summary'
	get '/states.csv', to: 'states#export_csv'
	get '/lskdjfskffesd.csv', to: 'states#export_all'
end
