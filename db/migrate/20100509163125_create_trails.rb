class CreateTrails < ActiveRecord::Migration
  def self.up
    create_table :trails do |t|
      t.string :text
      t.date :when

      t.timestamps
    end
  end

  def self.down
    drop_table :trails
  end
end
