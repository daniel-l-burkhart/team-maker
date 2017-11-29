class CreateQuestions < ActiveRecord::Migration[5.0]
  def change
    create_table :questions do |t|
      t.string :content
      t.integer :priority
      t.references :survey, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
