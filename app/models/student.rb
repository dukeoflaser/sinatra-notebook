class Student < ActiveRecord::Base
  belongs_to :teacher
  has_many :lessons
  
  has_secure_password
end