class CreateLesson < ActiveRecord::Migration
  def change
    create_table :lessons do |t|
      t.string :name
      t.date :date
      t.string :notes
      t.string :goal
      t.boolean :complete
      t.integer :student_id
    end
  end
end
