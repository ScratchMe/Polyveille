require 'spec_helper'

describe Article do

  before(:each) do
    @attr = {
      :url => "http://www.blog.com/mon_article",
      :facebook => 1,
      :twitter => 1,
      :pagerank => 1,
      :backlinks => 1,
      :comments => 1,
      :nbIndicateursPR => 1
    }
  end
  
  it "should create a new instance given valid attributes" do
    Article.create!(@attr)
  end

  it "should require a url" do
    no_url_article = Article.new(@attr.merge(:url => ""))
    no_url_article.should_not be_valid
  end
  
  it "should require the facebook indicator" do
    no_url_article = Article.new(@attr.merge(:facebook => nil))
    no_url_article.should_not be_valid
  end

  it "should require the twitter indicator" do
    no_url_article = Article.new(@attr.merge(:twitter => nil))
    no_url_article.should_not be_valid
  end
  
  it "should require the comments indicator" do
    no_url_article = Article.new(@attr.merge(:comments => nil))
    no_url_article.should_not be_valid
  end  
  
	it "should require the pagerank indicator" do
    no_url_article = Article.new(@attr.merge(:pagerank => nil))
    no_url_article.should_not be_valid
  end
  
  it "should require the backlinks indicator" do
    no_url_article = Article.new(@attr.merge(:url => nil))
    no_url_article.should_not be_valid
  end
  
  it "should require the nbIndicateursPR indicator" do
    no_url_article = Article.new(@attr.merge(:nbIndicateursPR => nil))
    no_url_article.should_not be_valid
  end


end





