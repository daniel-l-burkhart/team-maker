class AddReleasedToTeams < ActiveRecord::Migration[5.0]
  def change
    add_column :teams, :released, :boolean, default: false
  end
end
