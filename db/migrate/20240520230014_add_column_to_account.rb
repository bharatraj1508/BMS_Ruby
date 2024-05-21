class AddColumnToAccount < ActiveRecord::Migration[7.1]
  def change
    add_column :accounts, :time_zone, :string
  end
end
