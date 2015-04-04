class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string   :name,                                null: false
      t.string   :slug,                                null: false, index: true
      t.string   :description
      t.boolean  :is_public,            default: true, null: false
      t.text     :design
      t.integer  :status,               default: 0,    null: false
      t.string   :icon_url_path,                       null: false
      t.datetime :last_picture_taken_at

      t.references :user, null: false, index: true

      t.timestamps null: false
    end

    add_foreign_key :projects, :users, on_delete: :cascade
  end
end
