class AddOaiStatusFieldsToProvider < ActiveRecord::Migration
  def self.up
    add_column :providers, :last_consumed_at, :datetime
    add_column :providers, :interval, :integer
    add_column :providers, :identify, :text
  end

  def self.down
    remove_column :providers, :identify
    remove_column :providers, :interval
    remove_column :providers, :last_consumed_at
  end
end
