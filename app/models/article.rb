# == Schema Information
# Schema version: 20110116160550
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
#  score           :float
#

class Article < ActiveRecord::Base

	attr_accessible :url, :facebook, :twitter, :pagerank, :backlinks, :comments, :nbIndicateursPR, :score

  url_regex = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix

  validates :url,  :presence 	 => true,
                   :format		 => { :with => url_regex },
                   :uniqueness => true
  validates :facebook, :presence   => true
  validates :twitter, :presence   => true
  validates :pagerank, :presence   => true
  validates :backlinks, :presence   => true
  validates :comments, :presence   => true
  validates :nbIndicateursPR, :presence   => true
  validates :score, :presence   => true
							#			:inclusion	=> { :in => 0..6 }
  
end














