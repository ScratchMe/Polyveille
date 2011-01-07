class ArticlesController < ApplicationController
  require "postrank-api"

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])

    if @article.save
      # clef Post rank : db233481d596f23895813487370ed088
      api = PostRank::API.new('db233481d596f23895813487370ed088')
      metrics = api.metrics(@article.url)

      @article.twitter = metrics[@article.url]["twitter"]
      @article.comments = metrics[@article.url]["comments"]
      @article.save

      redirect_to ajouterArticle_path
    else
      render "new"
    end

  end
end
