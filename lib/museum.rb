class Museum
  attr_reader :name, :exhibits, :patrons
  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
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

  def admit(patron)
    @patrons << patron
  end

  def patrons_by_exhibit_interest
    results = {}
    @exhibits.reduce(results) do |results, exhibit|
      results[exhibit] ||= []
      results
    end

    results.each do |exhibit, patrons|
      results[exhibit] =
      @patrons.find_all do |patron|
        patron if patron.interests.include?(exhibit.name)
      end
    end
  end

  def ticket_lottery_contestants(exhibit)
    contestants = []
    patrons_by_exhibit_interest[exhibit].each do |patron|
      if patron.spending_money < exhibit.cost
        contestants << patron
      end
    end
    contestants
  end

  def draw_lottery_winner(exhibit)
    # require "pry"; binding.pry
    ticket_lottery_contestants(exhibit).sample.name
  end

end
