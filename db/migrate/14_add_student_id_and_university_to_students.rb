class AddStudentIdAndUniversityToStudents < ActiveRecord::Migration[5.0]
  def change
    add_column :students, :student_id, :string
    add_column :students, :university, :string
    add_index :students, [:student_id, :university], unique: true
  end
end
