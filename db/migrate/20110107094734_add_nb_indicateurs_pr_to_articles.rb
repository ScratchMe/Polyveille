class AddNbIndicateursPrToArticles < ActiveRecord::Migration
  def self.up
    add_column :articles, :nbIndicateursPR, :integer
  end

  def self.down
    remove_column :articles, :nbIndicateursPR
  end
end
