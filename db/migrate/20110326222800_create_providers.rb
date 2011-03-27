class CreateProviders < ActiveRecord::Migration
  def self.up
    create_table :providers do |t|
      t.string :title
      t.text :description
      t.string :url
      t.string :endpoint
      t.string :metadata_prefix
      t.string :set
      t.string :stylesheet

      t.timestamps
    end
  end

  def self.down
    drop_table :providers
  end
end
