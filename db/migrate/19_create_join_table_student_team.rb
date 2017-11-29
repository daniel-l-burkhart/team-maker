class CreateJoinTableStudentTeam < ActiveRecord::Migration[5.0]
  def change
    create_join_table :students, :teams do |t|
      t.index [:student_id, :team_id], unique: true
      # t.index [:team_id, :student_id]
    end
  end
end
