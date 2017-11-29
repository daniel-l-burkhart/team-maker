class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.references :survey, index: true, foreign_key: true
      t.index [:id, :survey_id], unique: true

      t.timestamps null: false
    end
  end
end
