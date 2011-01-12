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
    
    
    # Nombre d'article ajoutés à la BD
    nbArticle = 0
    
    # On parcoure les URL rentrées par l'utilisateur. Pour chacune, on crée un nouvel article 
    urls = params[:article][:url].split(";")
    urls.each do |urlCourante|
    
		  @article = Article.new(:url => urlCourante)
		
			# Ajout de "http://" devant l'URL si non-présent
			unless @article.url.start_with?("http://", "https://")
		    @article.url = "http://" + @article.url
		  end
			uri = Addressable::URI.parse(@article.url)
		
		
			# Détermination des indicateurs "backlinks" et "PageRank" :		    
		  if(@article.backlinks = PageRankr.backlinks(uri.host, :google)[:google]).nil?
		  	@article.backlinks = 0
		  end

		  @article.pagerank = PageRankr.ranks(uri.host, :google)[:google]
		  if (@article.pagerank).nil? or (@article.pagerank == -1) 
		  	@article.pagerank = 0
		  end		
		  
		  
		  # Détermination de l'indicateur FaceBook :
		  facebookPluginContent = open("http://www.facebook.com/plugins/like.php?href=" + @article.url)
			facebook = facebookPluginContent.string.match("(([0-9]\s?)*)\s(likes|personnes\saiment)") #parfois likes
			if facebook.nil?
			  if facebookPluginContent.string.include?("One like") or facebookPluginContent.string.include?("Une personne aime")
				  @article.facebook = 1
				else
				  @article.facebook = 0
				end
			else
				@article.facebook = facebook[1].delete("\s").to_i
			end	
		
		
			# Détermination des indicateurs "comments" et "twitter" (API Post rank) :
		
		  # clef Post rank : db233481d596f23895813487370ed088
		  api = PostRank::API.new('db233481d596f23895813487370ed088')
		  metrics = api.metrics(@article.url)

		  if (@article.twitter = metrics[@article.url]["twitter"]).nil?
		  	@article.twitter = 0
		  end
		  if (@article.comments = metrics[@article.url]["comments"]).nil?
		  	@article.comments = 0
		  end
		  if (@article.nbIndicateursPR = metrics[@article.url].length).nil?
		  	@article.nbIndicateursPR = 0
		  end
		  
		  
		  # Ajout des valeurs de chaque indicateurs dans la BD, redirection de l'utilisateur vers l'écran d'ajout de nouvelles URL et affichage d'informations sur le déroulement des opérations :
		  if @article.save
		  	nbArticle = nbArticle + 1
		  else
		  	flash[@article.url] = "Une erreur est survenu lors de l'ajout de l'URL #{@article.url}."
		  end
		end
		
		if nbArticle > 0
			flash[:success] = "#{nbArticle} article(s) correctement ajoute(s)."
			redirect_to ajouterArticle_path
		else
			redirect_to ajouterArticle_path
		end
  end
end



