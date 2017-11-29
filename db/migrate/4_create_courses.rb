class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :semester
      t.string :section

      t.timestamps null: false
    end
  end
end
