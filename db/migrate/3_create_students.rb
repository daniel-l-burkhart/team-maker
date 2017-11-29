class CreateStudents < ActiveRecord::Migration[5.0]
  def change
    create_table :students do |t|
      t.string :name
      t.string :phone
      t.string :email, unique: true
      t.string :password

      t.timestamps null: false
    end
  end
end
