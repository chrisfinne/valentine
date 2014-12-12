class ChangePoemAddFields < ActiveRecord::Migration
  def change
    add_column :poems, :from_name, :string
    add_column :poems, :to_name, :string
    add_column :poems, :to_email, :string
  end
end
