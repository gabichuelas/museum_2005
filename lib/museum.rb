class Museum
  attr_reader :name, :exhibits
  def initialize(name)
    @name = name
    @exhibits = []
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    recs = []
    @exhibits.each do |exhibit|
      recs << exhibit if patron.interests.include?(exhibit.name)
    end
    recs
  end

end
