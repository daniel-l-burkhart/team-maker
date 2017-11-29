class CreateAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :answers do |t|
      t.references :response, index: true, foreign_key: true
      t.references :question, index: true, foreign_key: true
      t.string :content
      t.index [:response_id, :question_id], unique: true

      t.timestamps null: false
    end
  end
end
