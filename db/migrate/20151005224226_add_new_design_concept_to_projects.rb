class AddNewDesignConceptToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :gen_bank, :string, null: false
    add_column :projects, :gen_bank_content, :binary, null: false
    add_column :projects, :price, :money
    add_column :projects, :estimated_delivery_days, :integer
    add_column :projects, :report, :string
    add_column :projects, :report_content, :binary
  end
end
