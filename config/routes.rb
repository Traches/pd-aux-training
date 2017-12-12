Rails.application.routes.draw do
  root to: 'pages#home'
  # Routes for users to register and edit their logins & profiles
  devise_for :users
  scope '/admin' do
    resources :users, except: [:new, :create]
    # Custom route to allow trainers to approve pending users, but not change other users' roles. 
    put 'users/:id/accept', to: 'users#approve', as: 'accept_user'
    # Custom route that allows trainers to delete users who haven't been approved yet, but nobody else. 
    delete 'users/:id/reject', to: 'users#reject', as: 'reject_user'
  end
  
end