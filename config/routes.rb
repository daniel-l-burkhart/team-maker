Rails.application.routes.draw do

  resources :teams
  resources :answers
  resources :questions

  devise_for :students, controllers: {
      confirmations: 'students/confirmations',
      registrations: 'students/registrations',
      passwords: 'students/passwords',
      sessions: 'students/sessions',
      unlocks: 'students/unlocks'
  }

  devise_for :faculties, controllers: {
      confirmations: 'faculties/confirmations',
      registrations: 'faculties/registrations',
      passwords: 'faculties/passwords',
      sessions: 'faculties/sessions',
      unlocks: 'faculties/unlocks'
  }

  devise_for :administrators, controllers: {
      confirmations: 'administrators/confirmations',
      registrations: 'administrators/registrations',
      passwords: 'administrators/passwords',
      sessions: 'administrators/sessions',
      unlocks: 'administrators/unlocks'
  }

  as :student do
    patch '/students/confirmation' => 'students/confirmations#update', :via => :patch, :as => :update_student_confirmation
  end

  as :faculty do
    patch '/faculties/confirmation' => 'faculties/confirmations#update', :via => :patch, :as => :update_faculty_confirmation
  end

  resources :courses do

    resources :students do
      get 'delete_student' => 'courses#delete_student_from_course'
    end

    resources :surveys do
      get 'send_new_survey_mail' => 'courses#send_new_survey_mail'

      get 'create_teams' => 'surveys#create_teams'

      put 'create_teams' => 'surveys#create_teams'

      get 'edit_team' => 'surveys#edit_teams'
      get 'remove_student' => 'surveys#remove_student'
      put 'edit_team' => 'surveys#edit_teams'

      get 'add_student_to_team_from_form' => 'surveys#add_student_to_team_from_form'
      post 'add_student_to_team_from_form' => 'surveys#add_student_to_team_from_form'

      get 'save_team' => 'surveys#save_team'
      get 'show_created_teams' => 'surveys#show_created_teams'
      get 'release_teams' => 'surveys#release_teams'

      get 'create_new_team' => 'surveys#create_new_team'

      get 'delete_team' => 'surveys#delete_team'
    end
  end

  resources :surveys, only: :none do
    resources :responses
  end

  resources :faculties
  resources :administrators

  get 'welcome/index'
  root 'welcome#index'

  get 'student/home' => 'students#home', :as => :student_home
  get 'faculty/home' => 'faculties#home', :as => :faculty_home

  get 'admin/home' => 'administrators#home', :as => :admin_home
  post 'admin/home' => 'administrators#home', :as => :admin_post_home

  get 'forgot_password' => 'welcome#forgot'

  get 'about' => 'welcome#about'

end
