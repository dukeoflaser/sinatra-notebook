class CreateStudent < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.integer :teacher_id
      t.integer :lesson_id
    end
  end
end
