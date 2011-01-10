# == Schema Information
# Schema version: 20110107094734
#
# Table name: articles
#
#  id              :integer         not null, primary key
#  url             :string(255)
#  facebook        :integer
#  twitter         :integer
#  pagerank        :integer
#  backlinks       :integer
#  comments        :integer
#  created_at      :datetime
#  updated_at      :datetime
#  nbIndicateursPR :integer
#

class Article < ActiveRecord::Base

	attr_accessible :url, :facebook, :twitter, :pagerank, :backlinks, :comments, :nbIndicateursPR

  #url_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :url,  :presence => true #,
#                   :format	 => { :with => url_regex }
  validates :facebook, :presence   => true
  validates :twitter, :presence   => true
  validates :pagerank, :presence   => true
  validates :backlinks, :presence   => true
  validates :comments, :presence   => true
  validates :nbIndicateursPR, :presence   => true
  
end














