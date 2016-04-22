 require './config/environment'
 require 'pry'

class ApplicationController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'notebook'
    register Sinatra::Flash
  end

  get '/' do
    erb :index
  end
  
  get '/signup' do
    erb :signup
  end
  
  post '/signup' do
    
    if params["name"].empty?
      flash[:name] = "Please enter your name."
      redirect '/signup'
    end

    if user_unavailable?(params["user_type"], params["email"])
      flash[:user] = "That email address is already in use."
      redirect '/signup'
    end
    
    if invalid_email?(params["email"])
      flash[:email] = "#{params["email"]} is not a valid email address."
      redirect '/signup'
    end
    
    if pw_mismatch?(params["password"], params["conf_password"])
      flash[:pw_mismatch] = "Passwords don't match."
      redirect '/signup'
    end
    
    if params["user_type"] == "teacher"
      user = Teacher.new(name: params["name"])
    else
      user = Student.new(name: params["name"])
    end
    
    user.email = params["email"]
    user.password = params["password"]
    user.save
    
    unless user.save
      flash[:password] = "Please enter a valid password."
      redirect '/signup'
    end
    
    if params["user_type"] == "teacher"
      redirect '/teacher/home'
    else
      redirect "student/lessons/#{user.id}"
    end
    
  end
  
  get '/login' do
    erb :login
  end
  
  post '/login' do
    
  end
  
  get '/logout' do
    session.clear
    redirect '/'
  end
  
  helpers do
    
    def user_unavailable?(user_type, submitted_email)
      if user_type == "teacher"
        user = Teacher.all.find_by email: submitted_email
        !!user
      else
        user = Student.all.find_by email: submitted_email
        !!user
      end  
    end
    
    def invalid_email?(submitted_email)
      #michael hartl's regex
      valid_email = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      submitted_email.match(valid_email).nil?
    end
    
    def pw_mismatch?(pw_a, pw_b)
      pw_a == pw_b ? false : true
    end
    
  end
  
end