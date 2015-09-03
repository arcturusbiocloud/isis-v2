class AddVirtualExperimentCollectionToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :virtual_experiment_collection, :string
  end
end
