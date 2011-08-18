class Article < CachedModel
  
  def self.featured
    last
  end
  
  def self.first_to_display
    limit(1).to_a
  end
    
end