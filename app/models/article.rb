class Article < CachedModel
  
  def self.featured
    Rails.cache.fetch("featured", :expires_in => 30.minutes) do
      self.last
    end
  end
  
  def self.first_to_display
    Rails.cache.fetch("first_to_display", :expires_in => 30.minutes) do
      limit(1).to_a
    end
  end
    
end