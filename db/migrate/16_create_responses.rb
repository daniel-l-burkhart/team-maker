class CreateResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :responses do |t|
      t.references :survey, index: true, foreign_key: true
      t.references :student, index: true, foreign_key: true
      t.boolean :completed, default: false
      t.index [:survey_id, :student_id], unique: true

      t.timestamps null: false
    end
  end
end
