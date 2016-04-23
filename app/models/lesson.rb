class Lesson < ActiveRecord::Base
  belongs_to :student
  
  def status
    self.complete == true ? "Complete" : "Incomplete"
  end
  
end