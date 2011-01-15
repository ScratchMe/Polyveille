class AddScoreToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :score, :integer
  end

  def self.down
    remove_column :articles, :score
  end
end
