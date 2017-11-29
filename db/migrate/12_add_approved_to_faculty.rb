class AddApprovedToFaculty < ActiveRecord::Migration[5.0]
  def change
    add_column :faculties, :approved, :boolean, :default => false, :null => false
  end
end
