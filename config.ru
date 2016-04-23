require './app/controllers/application_controller'

use Rack::MethodOverride
use StudentController
use TeacherController 
run ApplicationController