class ChangeDataTypeForUrl < ActiveRecord::Migration
  def self.up
    change_table :images do |t|
      t.change :url, :text, limit: nil
    end
  end
  def self.down
    change_table :images do |t|
      t.change :url, :string
    end
  end
end
