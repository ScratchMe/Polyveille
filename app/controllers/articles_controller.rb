class ArticlesController < ApplicationController
  require "postrank-api"
  require "page_rankr"

  def show
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(params[:article])
		
		# Ajout de "http://" devant l'URL si non-présent
		unless @article.url.index("http://") == 0
      @article.url = "http://" + @article.url
    end
		
		
		# Détermination des indicateurs "backlinks" et "PageRank" :
		
		# Si l'URL, sans prendre en compte "http://" contient "/", alors url prend pour valeur...
    if @article.url["http://".length.. @article.url.length].include?("/")
    	# index prend pour valeur la position du "/"
    	index = @article.url["http://".length.. @article.url.length].index("/")
    	# url prend pour valeur la chaine se trouvant entre "http://" et "/" (intervals compris)
    	url = @article.url[0.. index+"http://".length]
    else
    	url = @article.url
    end
    
    @article.backlinks = PageRankr.backlinks(url, :google)[:google]
    @article.pagerank = PageRankr.ranks(url, :google)[:google]		
		
		
		# Détermination des indicateurs "comments" et "twitter" (API Post rank) :
		
    # clef Post rank : db233481d596f23895813487370ed088
    api = PostRank::API.new('db233481d596f23895813487370ed088')
    metrics = api.metrics(@article.url)

    @article.twitter = metrics[@article.url]["twitter"]
    @article.comments = metrics[@article.url]["comments"]
    
    
    # Ajout des valeurs de chaque indicateurs dans la BD et redirection de l'utilisateur vers l'écran d'ajout de nouvelles URL :
    if @article.save
      flash[:success] = "Article correctement ajoute."
      redirect_to ajouterArticle_path
    else
      render "new"
    end

  end
end
