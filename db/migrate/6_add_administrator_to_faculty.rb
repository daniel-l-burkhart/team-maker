class AddAdministratorToFaculty < ActiveRecord::Migration[5.0]
  def change
    add_reference :faculties, :administrator, index: true, foreign_key: true
  end
end
