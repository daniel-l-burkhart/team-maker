class CreateFaculties < ActiveRecord::Migration[5.0]
  def change
    create_table :faculties do |t|
      t.string :name
      t.string :phone
      t.string :department
      t.string :university
      t.string :email, unique: true
      t.string :password

      t.timestamps null: false
    end
  end
end
