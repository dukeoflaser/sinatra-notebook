class Student < ActiveRecord::Base
  belongs_to :teacher
  has_many :lessons
  
  has_secure_password
  
  def self.has_no_teacher
    no_teacher = []
    self.all.each do |student|
      no_teacher << student if student.teacher.nil?
    end
    
    no_teacher
  end
  
end