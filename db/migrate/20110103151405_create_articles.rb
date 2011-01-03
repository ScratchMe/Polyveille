class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.string :url
      t.integer :facebook
      t.integer :twitter
      t.integer :pagerank
      t.integer :backlinks
      t.integer :comments

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
