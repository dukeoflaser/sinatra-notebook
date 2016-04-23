require 'pry'

class StudentController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'notebook'
    register Sinatra::Flash
  end
  
  get '/student/:id/lessons' do
    @user = Student.find_by_id(session[:user_id])
    erb :"/student/lessons"
  end
  
  get '/student/:s_id/edit' do
    @user = Student.find_by_id(session[:user_id])
    erb :'/student-edit'
  end
  
  get '/student/:s_id/lesson/:l_id' do
    @user = Student.find_by_id(session[:user_id])
    @lesson = Lesson.find_by_id(params[:l_id])
    erb :'/student/lesson'
  end
  
  patch '/student/:id/edit' do
    if params["name"].empty?
      flash[:name] = "Please enter your name."
      redirect '/student/:id/edit'
    end
    
    if invalid_email?(params["email"])
      flash[:email] = "#{params["email"]} is not a valid email address."
      redirect '/student/:id/edit'
    end
    
    @user = Student.all.find_by_id(session[:user_id])
    @user.name = params["name"]
    @user.email = params["email"]
    @user.save
    
    redirect "/student/#{@user.id}/lessons"
  end
  
  
  helpers do
    def invalid_email?(submitted_email)
      #michael hartl's regex
      valid_email = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      submitted_email.match(valid_email).nil?
    end
  end
  
end