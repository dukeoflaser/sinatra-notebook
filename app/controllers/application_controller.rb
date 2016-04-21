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
  
end