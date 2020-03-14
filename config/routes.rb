Rails.application.routes.draw do
  #resources :states
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
	root 'states#summary'
	get '/testxyz', to: 'states#summary_test'
	get '/states.csv', to: 'states#export_csv'
	get '/time_series.csv', to: 'states#export_time_series_csv'
	get '/lskdjfskffesd.csv', to: 'states#export_all'
end
