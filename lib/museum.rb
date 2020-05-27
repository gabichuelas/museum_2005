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
    patrons_by_exhibit_interest[exhibit].reduce([]) do |contestants, patron|
      contestants << patron if patron.spending_money < exhibit.cost
      contestants
    end
  end

  def draw_lottery_winner(exhibit)
    ticket_lottery_contestants(exhibit).sample.name
  end

  def announce_lottery_winner(exhibit)
    if ticket_lottery_contestants(exhibit).count > 0
      winner = draw_lottery_winner(exhibit)
      "#{winner} has won the #{exhibit.name} exhibit lottery"
    else
      "No winners for this lottery"
    end
  end

end
