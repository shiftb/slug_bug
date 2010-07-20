class CreateSlugs < ActiveRecord::Migration
  def self.up
    create_table :slugs do |t|
      t.string :name, :null => false
      t.references :sluggable, :polymorphic => true
      t.timestamps
		end

    add_index :slugs, [:name], :unique => true
    add_index :slugs, :sluggable_type
    add_index :slugs, :sluggable_id
  end

  def self.down
    drop_table :slugs
  end
end
