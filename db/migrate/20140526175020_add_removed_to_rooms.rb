class AddRemovedToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :removed, :boolean, :default => false
  end
end
