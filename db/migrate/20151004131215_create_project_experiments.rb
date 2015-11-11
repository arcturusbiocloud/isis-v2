class CreateProjectExperiments < ActiveRecord::Migration
  def change
    create_table :project_experiments do |t|
      t.references :project,    null: false, index: true
      t.references :experiment, null: false, index: true

      t.timestamps null: false
    end

    add_foreign_key :project_experiments, :projects,    on_delete: :cascade
    add_foreign_key :project_experiments, :experiments, on_delete: :cascade
  end
end
