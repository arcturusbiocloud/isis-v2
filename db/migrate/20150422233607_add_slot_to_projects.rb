class AddSlotToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :slot, :integer
  end
end
