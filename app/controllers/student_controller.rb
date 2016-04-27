class StudentController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'notebook'
    register Sinatra::Flash
  end
  
  get '/student/lessons' do
    if valid_student
      @user = Student.find_by_id(session[:user_id])
      erb :"/student/lessons"
    else
      redirect '/login'
    end
  end
  
  get '/student/lesson/:l_id' do
    if valid_student
      @user = Student.find_by_id(session[:user_id])
      @lesson = Lesson.find_by_id(params[:l_id])
      @lesson_notes_html = @lesson.notes.split("\n").join("<br>")
      @lesson_goal_html = @lesson.goal.split("\n").join("<br>")    
      erb :'/student/lesson'
    else
      redirect '/login'
    end      
  end
  
  
  get '/student/edit' do
    if valid_student
      @user = Student.find_by_id(session[:user_id])
      erb :'/student-edit'
    else
      redirect '/login'
    end      
  end
  

  patch '/student/edit' do
    if params["name"].empty?
      flash[:name] = "Please enter your name."
      redirect '/student/edit'
    end
    
    if invalid_email?(params["email"])
      flash[:email] = "#{params["email"]} is not a valid email address."
      redirect '/student/edit'
    end
    
    @user = Student.all.find_by_id(session[:user_id])
    @user.name = params["name"]
    @user.email = params["email"]
    @user.save
    
    redirect "/student/lessons"
  end
  
  
  helpers do
    def invalid_email?(submitted_email)
      #michael hartl's regex
      valid_email = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      submitted_email.match(valid_email).nil?
    end
    
    def valid_student
      session[:user_id].nil? || session[:user_type] != 'student' ? false : true
    end
  end
  
end