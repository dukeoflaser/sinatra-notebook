class TeacherController < Sinatra::Base
  
  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'notebook'
    register Sinatra::Flash
  end
  
  
  get '/teacher/:id/home' do
    @user = Teacher.find_by_id(session[:user_id])
    session[:student_id] = nil
    erb :'/teacher/home'
  end
  
  
  post '/teacher/:id/select' do
    user = Teacher.find_by_id(session[:user_id])
    session[:student_id] = params["student_id"].to_i
    student = Student.find_by_id(session[:student_id])
    
    if params.has_key?("remove")
      user.students.delete(student)
      
      flash[:removed] = "Student has been removed."
      redirect "/teacher/#{user.id}/home"
    end
    
    unless user.students.include? student
      user.students << student
    end
    
    redirect "/teacher/#{user.id}/student/#{student.id}/lessons"
  end
  
  
  get '/teacher/:id/edit' do
  @user = Teacher.find_by_id(session[:user_id])
    erb :'/user-edit'
  end
  
  
  patch '/teacher/:id/edit' do
    if params["name"].empty?
      flash[:name] = "Please enter your name."
      redirect '/teacher/:id/edit'
    end
    
    if invalid_email?(params["email"])
      flash[:email] = "#{params["email"]} is not a valid email address."
      redirect '/teacher/:id/edit'
    end
    
    @user = Teacher.all.find_by_id(session[:user_id])
    @user.name = params["name"]
    @user.email = params["email"]
    @user.save
    
    redirect "/teacher/#{@user.id}/home"
  end
  
  
  get '/teacher/:t_id/student/:s_id/lessons' do
    @user = Teacher.find_by_id(session[:user_id])
    @student = Student.find_by_id(session[:student_id])
    erb :'/teacher/student/lessons'
  end
  
  
  get '/teacher/:t_id/student/:s_id/lesson/new' do
    @user = Teacher.find_by_id(session[:user_id])
    @student = Student.find_by_id(session[:student_id])
    erb :'/teacher/student/lesson/new'
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
    
    redirect "/teacher/#{@user.id}/student/#{@student.id}/lesson/#{@lesson.id}"
  end
  
  
  get '/teacher/:t_id/student/:s_id/lesson/:l_id' do
    @user = Teacher.find_by_id(session[:user_id])
    @student = Student.find_by_id(session[:student_id])
    @lesson = Lesson.find_by_id(params[:l_id])
    @lesson_notes_html = @lesson.notes.split("\n").join("<br>")
    @lesson_goal_html = @lesson.goal.split("\n").join("<br>")
    erb :'/teacher/student/lesson'
  end
  
  
  get '/teacher/:t_id/student/:s_id/lesson/:l_id/edit' do
    @user = Teacher.find_by_id(session[:user_id])
    @student = Student.find_by_id(session[:student_id])
    @lesson = Lesson.find_by_id(params[:l_id])
    erb :"/teacher/student/lesson/edit"
  end
  
  
  patch '/teacher/:t_id/student/:s_id/lesson/:l_id/edit' do
    @user = Teacher.find_by_id(session[:user_id])
    @student = Student.find_by_id(session[:student_id])    
    @lesson = Lesson.find_by_id(params[:l_id])
    @lesson.name = params["name"]
    @lesson.notes = params["notes"]
    @lesson.goal = params["goal"]
    complete = params["complete"]
    complete == "true" ? @lesson.complete = true : @lesson.complete = false
    @lesson.save
    
    redirect "/teacher/#{@user.id}/student/#{@student.id}/lesson/#{@lesson.id}"
  end
  
  
  patch '/teacher/:t_id/student/:s_id/lesson/:l_id/status' do
    @user = Teacher.find_by_id(session[:user_id])
    @student = Student.find_by_id(session[:student_id])    
    @lesson = Lesson.find_by_id(params[:l_id])
    complete = params["complete"]
    complete == "true" ? @lesson.complete = true : @lesson.complete = false
    @lesson.save
    
    redirect "/teacher/#{@user.id}/student/#{@student.id}/lesson/#{@lesson.id}"
  end
  
  
  delete '/teacher/:t_id/student/:s_id/lesson/:l_id/delete' do
    @user = Teacher.find_by_id(session[:user_id])
    @student = Student.find_by_id(session[:student_id])
    @lesson = Lesson.find_by_id(params[:l_id])
    @lesson.delete
    flash[:deleted] = "A lesson has been deleted."
    
    redirect "/teacher/#{@user.id}/student/#{@student.id}/lessons"
  end
  
  
  helpers do
    def invalid_email?(submitted_email)
      #michael hartl's regex
      valid_email = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      submitted_email.match(valid_email).nil?
    end
  end
  
end