class ScoreOfArticleFromIntegerToFloat < ActiveRecord::Migration
  def self.up
    remove_column :articles, :score
    add_column :articles, :score, :float
  end

  def self.down
    remove_column :articles, :score
    add_column :articles, :score, :integer
  end
end
