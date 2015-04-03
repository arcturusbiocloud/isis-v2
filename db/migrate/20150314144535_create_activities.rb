class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.integer :key,        default: 0, null: false
      t.string  :detail

      t.references :project, null: false, index: true

      t.timestamps null: false
    end

    add_foreign_key :activities, :projects, on_delete: :cascade
  end
end
