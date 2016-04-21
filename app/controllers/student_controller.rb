class StudentController < Sinatra::Base
  
  configure do
    set :views, 'app/views'
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
  
  
end