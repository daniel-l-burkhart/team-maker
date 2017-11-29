class AddCourseToSurvey < ActiveRecord::Migration[5.0]
  def change
    add_reference :surveys, :course, index: true, foreign_key: true
  end
end
