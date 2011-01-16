module Indicateurs

  class CalculateurPolyScore
  
    attr_accessor :article
    
    def initialize(article)
      @article = article
    end
    
    def scoreBacklinksAjuste
      backlinksAjuste = 0
      if @article.pagerank == 0
	  	  backlinksAjuste = @article.backlinks
	  	else
	  	  backlinksAjuste = @article.backlinks * @article.pagerank
	  	end
	  	
	  	case backlinksAjuste
	  	  when 0..600, nil
	  	    return 0
	  	  when 601..1250
	  	    return 1
	  	  when 1251..2200
	  	    return 2
	  	  when 2201..3800
	  	    return 3
	  	  when 3801..7000
	  	    return 4
	  	  when 7001..12000
	  	    return 5  
	  	  else #Donc, supérieur à 12000
	  	    return 6
	  	end
    end
    
    def scoreFacebook  	
	  	case @article.facebook
	  	  when 0..1, nil
	  	    return 0
	  	  when 2..11
	  	    return 1
	  	  when 12..50
	  	    return 2
	  	  when 51..200
	  	    return 3
	  	  when 201..600
	  	    return 4
	  	  when 601..1500
	  	    return 5  
	  	  else #Donc supérieur à 1500
	  	    return 6
	  	end
    end
    
    def scoreTwitter 	
	  	case @article.twitter
	  	  when 0..5, nil
	  	    return 0
	  	  when 6..15
	  	    return 1
	  	  when 16..35
	  	    return 2
	  	  when 36..75
	  	    return 3
	  	  when 76..150
	  	    return 4
	  	  when 151..250
	  	    return 5  
	  	  else #Donc supérieur à 250
	  	    return 6
	  	end
    end
    
    def scoreComments	
	  	case @article.comments
	  	  when 0, nil
	  	    return 0
	  	  when 1..5
	  	    return 1
	  	  when 6..25
	  	    return 2
	  	  when 26..50
	  	    return 3
	  	  when 51..100
	  	    return 4
	  	  when 101..250
	  	    return 5  
	  	  else #Donc supérieur à 250
	  	    return 6
	  	end
    end
    
    def scoreNbIndicateursPR	
	  	case @article.nbIndicateursPR
	  	  when 0..1, nil
	  	    return 0
	  	  when 2
	  	    return 1
	  	  when 3
	  	    return 2
	  	  when 4
	  	    return 3
	  	  when 5
	  	    return 4
	  	  when 6..7
	  	    return 5  
	  	  else #Donc supérieur à 7
	  	    return 6
	  	end
    end
    
    def polyscore
      tableauScores = Array.new(5)
      tableauScores[0] = scoreBacklinksAjuste
      tableauScores[1] = scoreFacebook
      tableauScores[2] = scoreTwitter
      tableauScores[3] = scoreComments
      tableauScores[4] = scoreNbIndicateursPR
      
      tableauScores = tableauScores.sort
      tableauScores = tableauScores.reverse
      
      scoreFinal = (tableauScores[1]*4 + tableauScores[2]*3 + tableauScores[3]*2 + tableauScores[4] + tableauScores[0]*5) / 15.0
    
      return scoreFinal
    end

    #private :scoreBacklinksAjuste, :scoreFacebook, :scoreTwitter, :scoreComments, :scoreNbIndicateursPR
  end


  class Recuperateur

    @@api_postrank_key = "db233481d596f23895813487370ed088"
    
    def set_uri(uri)
      @uri = Addressable::URI.parse(uri)
      #Nouvelle URI, on remet les metrics à nil.
      @metrics = nil
    end
    
    def initialize(uri)
      @uri = Addressable::URI.parse(uri)
      @metric = nil
    end
    
    def backlinks
      require 'page_rankr'
      
      resultat = PageRankr.backlinks(@uri.host, :google)[:google]
      
      if resultat.nil?
        return 0
      else
        return resultat
      end
	  end
	
	  def pagerank
	    require 'page_rankr'
	    
	    resultat = PageRankr.ranks(@uri.host, :google)[:google]
	    
	    if (resultat.nil?) or (resultat == -1)
	      return 0
	    else
	      return resultat
	    end
    end
    
    def facebook
      require 'facebook-graph'
      
      client = FacebookGraph::Client.new
	    resultat = client.get_node(@uri.to_s)
	    
	    if resultat.properties[:shares].nil?
	      return 0
	    else
	      return resultat.properties[:shares]
	    end
	  end
	
	  def postrank(indicateur)
	    if @metrics.nil?
	      require 'postrank-api'
	      
        api = PostRank::API.new(@@api_postrank_key)
	      @metrics = api.metrics(@uri.to_s)
	    end
	    
	    resultat = @metrics[@uri.to_s][indicateur]
	    
	    if resultat.nil?
	      return 0
	    else
	      return resultat
	    end
	  end
	
	  def postrank_nb_indicateurs
	    if @metrics.nil?
	      require 'postrank-api'
	      
        api = PostRank::API.new(@@api_postrank_key)
	      @metrics = api.metrics(@uri.to_s)
	    end
	    
	    resultat = @metrics[@uri.to_s].length
	    
	    if resultat.nil?
	      return 0
	    else
	      return resultat
	    end
	  end
  end
end

