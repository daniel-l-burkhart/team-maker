class AddFacultyToCourse < ActiveRecord::Migration[5.0]
  def change
    add_reference :courses, :faculty, index: true, foreign_key: true
  end
end
