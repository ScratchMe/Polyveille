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
      :nbIndicateursPR => 1,
      :score => 5
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
  
  it "should accept valid URL" do
    url = %w[https://www.Blog42.fr http://blog.com/SECTION/article http://www.mon-b.l.o.g.ca/a_r_t_i_c_l_e42]
    url.each do |url|
      valid_url = Article.new(@attr.merge(:url => url))
      valid_url.should be_valid
    end
  end

  it "should reject invalid URL" do
    url = %w[www.Blog.fr http://www.bl_og.com http://www.blog.a]
    url.each do |url|
      invalid_url = Article.new(@attr.merge(:url => url))
      invalid_url.should_not be_valid
    end
  end
  
  it "should reject duplicate URL" do
    Article.create!(@attr)
    article_with_duplicate_url = Article.new(@attr)
    article_with_duplicate_url.should_not be_valid
  end
  
end





