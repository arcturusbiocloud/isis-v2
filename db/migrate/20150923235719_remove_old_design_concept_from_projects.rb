class RemoveOldDesignConceptFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :anchor
    remove_column :projects, :promoter
    remove_column :projects, :rbs
    remove_column :projects, :gene
    remove_column :projects, :terminator
    remove_column :projects, :cap
    remove_column :projects, :virtual_experiment_collection
    remove_column :projects, :slot
    remove_column :projects, :last_picture_taken_at
    remove_column :projects, :recording_file_name
  end
end
