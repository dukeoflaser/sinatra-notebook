class TeacherController < Sinatra::Base
  
  configure do
    set :views, 'app/views'
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