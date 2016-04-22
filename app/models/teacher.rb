class Teacher < ActiveRecord::Base
  has_many :students
  has_many :lessons, through: :students
  
  has_secure_password
end