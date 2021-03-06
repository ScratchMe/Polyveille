class ArticlesController < ApplicationController

  def show
  	@articles = Article.all(:order => "score DESC").paginate(:page => params[:page] || 1, :per_page => 30)
  	@articles.each do |article|
  		article.score = (article.score * 1000).round
		end
		
		#Débutation de numérotation de la liste ol
		if params[:page].nil?
		  @start = 1
		else
		  @start = ((params[:page].to_i-1)*30)+1
		end
  end


  def new
    @article = Article.new
  end


  def create
    require 'Indicateurs'
    
    
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
		
		
		
		  recuperateur = Indicateurs::Recuperateur.new(@article.url)
		
			# Détermination des indicateurs "backlinks" et "PageRank" :		    
		  @article.backlinks = recuperateur.backlinks
		  @article.pagerank = recuperateur.pagerank
		  
		  # Détermination de l'indicateur FaceBook :
		  @article.facebook = recuperateur.facebook
		
			# Détermination des indicateurs "comments" et "twitter" (API Post rank) :
		  @article.twitter = recuperateur.twitter
		  @article.comments = recuperateur.comments
		  @article.nbIndicateursPR = recuperateur.nbIndicateursPR
		  
		  #Calcul du score
		  calculateur = Indicateurs::CalculateurPolyScore.new(@article)
		  @article.score = calculateur.polyscore
		  
		  # Ajout des valeurs de chaque indicateurs dans la BD, redirection de l'utilisateur vers l'écran d'ajout de nouvelles URL et affichage d'informations sur le déroulement des opérations :
		  if @article.save
		  	nbArticle = nbArticle + 1
		  else
		  	flash[@article.url] = "Une erreur est survenue lors de l'ajout de l'URL #{@article.url}."
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



