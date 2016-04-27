class TeacherController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'notebook'
    register Sinatra::Flash
  end
  
  
  get '/teacher/home' do
    if valid_teacher
      @user = Teacher.find_by_id(session[:user_id])
      session[:student_id] = nil
      erb :'/teacher/home'
    else
      redirect '/login'
    end
  end
  
  
  post '/teacher/select' do
    if valid_teacher
      user = Teacher.find_by_id(session[:user_id])
      session[:student_id] = params["student_id"].to_i
      student = Student.find_by_id(session[:student_id])
      
      if params.has_key?("remove")
        user.students.delete(student)
        
        flash[:removed] = "Student has been removed."
        redirect "/teacher/home"
      end
      
      unless user.students.include? student
        user.students << student
      end
      
      redirect "/teacher/student/lessons"
    else
      redirect '/login'
    end
  end
  
  
  get '/teacher/edit' do
    if valid_teacher
      @user = Teacher.find_by_id(session[:user_id])
      erb :'/teacher-edit'
    else
      redirect '/login'
    end    
  end
  
  
  patch '/teacher/edit' do
    if params["name"].empty?
      flash[:name] = "Please enter your name."
      redirect '/teacher/edit'
    end
    
    if invalid_email?(params["email"])
      flash[:email] = "#{params["email"]} is not a valid email address."
      redirect '/teacher/edit'
    end
    
    @user = Teacher.all.find_by_id(session[:user_id])
    @user.name = params["name"]
    @user.email = params["email"]
    @user.save
    
    redirect "/teacher/home"
  end
  
  
  get '/teacher/student/lessons' do
    if valid_teacher
      @user = Teacher.find_by_id(session[:user_id])
      @student = Student.find_by_id(session[:student_id])
      erb :'/teacher/student/lessons'
    else
      redirect '/login'
    end    
  end
  
  
  get '/teacher/student/lesson/new' do
    if valid_teacher
      @user = Teacher.find_by_id(session[:user_id])
      @student = Student.find_by_id(session[:student_id])
      erb :'/teacher/student/lesson/new'
    else
      redirect '/login'
    end    
  end
  
  
  post '/lesson/new' do
    @user = Teacher.find_by_id(session[:user_id])
    @student = Student.find_by_id(session[:student_id])
    
    @lesson = Lesson.new
    @lesson.name = params["name"]
    @lesson.date = params["date"]
    @lesson.notes = params["notes"]
    @lesson.goal = params["goal"]
    @lesson.save
    @student.lessons << @lesson
    
    redirect "/teacher/student/lesson/#{@lesson.id}"
  end
  
  
  get '/teacher/student/lesson/:l_id' do
    if valid_teacher
      @user = Teacher.find_by_id(session[:user_id])
      @student = Student.find_by_id(session[:student_id])
      @lesson = Lesson.find_by_id(params[:l_id])
      @lesson_notes_html = @lesson.notes.split("\n").join("<br>")
      @lesson_goal_html = @lesson.goal.split("\n").join("<br>")
      erb :'/teacher/student/lesson'
    else
      redirect '/login'
    end    
  end
  
  
  get '/teacher/student/lesson/:l_id/edit' do
    if valid_teacher
      @user = Teacher.find_by_id(session[:user_id])
      @student = Student.find_by_id(session[:student_id])
      @lesson = Lesson.find_by_id(params[:l_id])
      erb :"/teacher/student/lesson/edit"
    else
      redirect '/login'
    end    
  end
  
  
  patch '/teacher/student/lesson/:l_id/edit' do
    if valid_teacher
      @user = Teacher.find_by_id(session[:user_id])
      @student = Student.find_by_id(session[:student_id])    
      @lesson = Lesson.find_by_id(params[:l_id])
      @lesson.name = params["name"]
      @lesson.notes = params["notes"]
      @lesson.goal = params["goal"]
      complete = params["complete"]
      complete == "true" ? @lesson.complete = true : @lesson.complete = false
      @lesson.save
      
      redirect "/teacher/student/lesson/#{@lesson.id}"
    else
      redirect '/login'
    end    
  end
  
  
  patch '/teacher/student/lesson/:l_id/status' do
    @user = Teacher.find_by_id(session[:user_id])
    @student = Student.find_by_id(session[:student_id])    
    @lesson = Lesson.find_by_id(params[:l_id])
    complete = params["complete"]
    complete == "true" ? @lesson.complete = true : @lesson.complete = false
    @lesson.save
    
    redirect "/teacher/student/lesson/#{@lesson.id}"
  end
  
  
  delete '/teacher/student/lesson/:l_id/delete' do
    @user = Teacher.find_by_id(session[:user_id])
    @student = Student.find_by_id(session[:student_id])
    @lesson = Lesson.find_by_id(params[:l_id])
    @lesson.delete
    flash[:deleted] = "A lesson has been deleted."
    
    redirect "/teacher/student/lessons"
  end
  
  
  helpers do
    def invalid_email?(submitted_email)
      #michael hartl's regex
      valid_email = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      submitted_email.match(valid_email).nil?
    end
    
    def valid_teacher
      session[:user_id].nil? || session[:user_type] != 'teacher' ? false : true
    end
  end
  
end