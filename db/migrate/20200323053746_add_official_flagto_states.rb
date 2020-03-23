class AddOfficialFlagtoStates < ActiveRecord::Migration[6.0]
  def change
    add_column :states, :official_flag, :boolean, :default => true
    add_column :states, :crawled_at, :datetime
    add_index :states, :crawled_at
  end
end
