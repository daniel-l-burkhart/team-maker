class CreateSurveys < ActiveRecord::Migration[5.0]
  def change
    create_table :surveys do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps null: false
    end
  end
end
