Rails.application.routes.draw do
  get 'pagesummary/allpages'

  get 'pagesummary/individualpage'

  resources :projects
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/', to: redirect('/projects')
end
