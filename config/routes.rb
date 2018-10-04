Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users, :skip => [:sessions, :passwords, :registrations]

  namespace :api, defaults: { format: :json }, path: '/api' do
    namespace :v1, path: '/v1' do
      devise_for :users, only: [:sessions], controllers: { sessions: 'api/v1/sessions' }
      resources :users, only: [:show, :create, :update, :destroy]
      resources :semesters, only: [:index, :show, :create, :update, :destroy] do |semesters|
        resources :courses, only: [:index, :show] do |courses|
          resources :tasks,  only: [:index, :show, :create, :update, :destroy], :name_prefix => 'courses_'
          resources :absences,  only: [:index, :show, :create, :destroy], :name_prefix => 'courses_'
        end
      end
# http://weblog.jamisbuck.org/2007/2/5/nesting-resources
#      resources :courses, only: [:index, :show, :create, :update, :destroy] do
#        resources :tasks, :name_prefix => 'courses_'
#      end
    end

    # for to create new api version
    # namespace :vX, path: '/vX' do
    #   resources :whatever, only: [:show, :create, :update, :destroy, ...]
    # end
  end
end
