class ChangeDateType < ActiveRecord::Migration
  def change
    change_column :lessons, :date, :string
  end
end
