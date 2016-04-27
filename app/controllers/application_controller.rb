require './config/environment'

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

    if user_exists?(params["user_type"], params["email"])
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
    
    if user.save
      session[:user_id] = user.id
      redirect "teacher/home" if user.is_a? Teacher
      redirect "student/lessons" if user.is_a? Student
    else  
      flash[:password] = "Please enter a valid password."
      redirect '/signup'
    end
    
  end
  
  get '/login' do
    erb :login
  end
  
  post '/login' do
    user_type = params["user_type"]
    email = params["email"]

    unless user_exists?(user_type, email)
      flash[:user] = "No #{user_type} account with the email address of #{email} exists."
      redirect '/login'
    else
      if user_type == "teacher"
        user = Teacher.all.find_by(email: email)
      else
        user = Student.all.find_by(email: email)
      end
      
      if user && user.authenticate(params["password"])
        session[:user_id] = user.id
        if user.is_a? Teacher
          session[:user_type] = 'teacher'
          redirect "/teacher/home"
        elsif user.is_a? Student
          session[:user_type] = 'student'
          redirect "/student/lessons"
        end
      else
        flash[:password] = "Incorrect Password"
        redirect '/login'
      end
    end

  end
  
  get '/logout' do
    session.clear
    redirect '/'
  end
  
  not_found do
    status 404
    erb :oops
  end
  
  helpers do
    
    def user_exists?(user_type, submitted_email)
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