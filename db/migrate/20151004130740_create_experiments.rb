class CreateExperiments < ActiveRecord::Migration
  def change
    create_table :experiments do |t|
      t.string :name,  null: false
      t.money  :price, null: false

      t.timestamps null: false
    end
  end
end
