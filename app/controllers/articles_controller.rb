class ArticlesController < ApplicationController

  def show
  end

  def new
    @article = Article.new
  end

  def create
    require 'postrank-api'
    require 'page_rankr'
    require 'open-uri'
    
    
    @article = Article.new(params[:article])
		
		# Ajout de "http://" devant l'URL si non-présent
		unless @article.url.start_with?("http://", "https://")
      @article.url = "http://" + @article.url
    end
		uri = Addressable::URI.parse(@article.url)
		
		# Détermination des indicateurs "backlinks" et "PageRank" :
		
    
    @article.backlinks = PageRankr.backlinks(uri.host, :google)[:google]
    @article.pagerank = PageRankr.ranks(uri.host, :google)[:google]		
    
    
    # Détermination de l'indicateur FaceBook :
    
    facebookPluginContent = open("http://www.facebook.com/plugins/like.php?href=" + @article.url)
		facebook = facebookPluginContent.string.match("(([0-9]\s?)*)\s(likes|personnes\saiment)") #parfois likes
		if facebook
		  @article.facebook = facebook[1].delete("\s").to_i
		else
		  if facebookPluginContent.string.include?("One like") or facebookPluginContent.string.include?("Une personne aime")
		    @article.facebook = 1
		  else
		    @article.facebook = 0
		  end
	  end
		
		
		# Détermination des indicateurs "comments" et "twitter" (API Post rank) :
		
    # clef Post rank : db233481d596f23895813487370ed088
    api = PostRank::API.new('db233481d596f23895813487370ed088')
    metrics = api.metrics(@article.url)

    @article.twitter = metrics[@article.url]["twitter"]
    @article.comments = metrics[@article.url]["comments"]
    @article.nbIndicateursPR = metrics[@article.url].length
    
    
    # Ajout des valeurs de chaque indicateurs dans la BD et redirection de l'utilisateur vers l'écran d'ajout de nouvelles URL :
    if @article.save
      flash[:success] = "Article correctement ajoute."
      redirect_to ajouterArticle_path
    else
      render "new"
    end

  end
end
