require './config/environment'

class ApplicationController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'notebook'
  end

  get '/' do
    erb :index
  end
  
  get '/signup' do
    erb :signup
  end
  
  post 'signup' do
    redirect '#'
  end
  
  get '/login' do
    erb :login
  end
  
  get '/logout' do
    session.clear
    redirect '/'
  end
  
  get '/student/lessons' do #/:id/lessons
    erb :'/student/lessons'
  end
  
  get '/student/edit' do #/:id/edit
    erb :'/user-edit'
  end
  
  get '/student/lesson' do #/:id
    erb :'/student/lesson'
  end
  
  get '/teacher/home' do #/:id/home
    erb :'/teacher/home'
  end
  
  get '/teacher/edit' do #/:id/edit
    erb :'/user-edit'
  end
  
  get '/teacher/student/lessons' do #/:id/lessons
    erb :'/teacher/student/lessons'
  end
  
  get '/teacher/student/lesson' do #/:id/lesson/:id
    erb :'/teacher/student/lesson'
  end
  
  get '/teacher/student/lesson/edit' do #/:id/lesson/:id/edit
    erb :"/teacher/student/lesson/edit"
  end  
  
  get '/teacher/student/lesson/new' do #/:id/lesson/new
    erb :'/teacher/student/lesson/new'
  end
  
end