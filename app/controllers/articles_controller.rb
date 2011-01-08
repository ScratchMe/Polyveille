class ArticlesController < ApplicationController
  require "postrank-api"

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])

    # clef Post rank : db233481d596f23895813487370ed088
    api = PostRank::API.new('db233481d596f23895813487370ed088')
    metrics = api.metrics(@article.url)

    @article.twitter = metrics[@article.url]["twitter"]
    @article.comments = metrics[@article.url]["comments"]
    
    require 'PageRank'
    unless @article.url.include?("http://")
      @article.url = "http://" + @article.url
    end
    uri = Addressable::URI.parse(@article.url)
    @pagerank = PageRank::GooglePR.new(uri.host).page_rank
    @article.pagerank = @pagerank
    
    if @article.save
      flash[:success] = "Article correctement ajoute."
      redirect_to ajouterArticle_path
    else
      render "new"
    end

  end
end
