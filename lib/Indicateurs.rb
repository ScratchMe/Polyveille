module Indicateurs

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
