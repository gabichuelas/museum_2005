class Museum
  attr_reader :name, :exhibits, :patrons, :patrons_of_exhibits, :revenue
  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
    # add for ITERATION 4
    @patrons_of_exhibits = {}
    @revenue = 0
  end

  def add_exhibit(exhibit)
    @exhibits << exhibit
  end

  def recommend_exhibits(patron)
    # @exhibits.reduce([]) do |recs, exhibit|
    #   recs << exhibit if patron.interests.include?(exhibit.name)
    #   recs
    # end

    # REFACTOR WITH FIND_ALL BC WHY USE REDUCE
    @exhibits.find_all do |exhibit|
      patron.interests.include?(exhibit.name)
    end
  end

  def admit(patron)
    @patrons << patron

    # ADD FOR ITERATION 4
    exhibits_by_cost.each do |exhibit|
      if patron.interests.include?(exhibit.name) && patron.spending_money >= exhibit.cost
        @patrons_of_exhibits[exhibit] ||= []
        @patrons_of_exhibits[exhibit] << patron
        patron.spend_money(exhibit.cost)
        @revenue += exhibit.cost
      end
    end

  end

  def exhibits_by_cost
    # ADD FOR ITERATION 4
    @exhibits.sort_by do |exhibit|
      -exhibit.cost
      # that - sign reverses the sort from least to greatest
      # to greatest to least by turning the absolute value of cost
      # to negatives.
      # Equivalent is end.reverse, but that's slower
    end
  end

  def patrons_by_exhibit_interest
    # results = {}
    # @exhibits.reduce(results) do |results, exhibit|
    #   results[exhibit] ||= []
    #   results
    # end
    #
    # results.each do |exhibit, patrons|
    #   results[exhibit] =
    #   @patrons.find_all do |patron|
    #     patron if patron.interests.include?(exhibit.name)
    #   end
    # end

    # REFACTOR
    @exhibits.reduce({}) do |results, exhibit|
      results[exhibit] ||= []
      results[exhibit] =
      @patrons.find_all do |patron|
        patron if patron.interests.include?(exhibit.name)
      end
      results
    end
  end

  def ticket_lottery_contestants(exhibit)
    # patrons_by_exhibit_interest[exhibit].reduce([]) do |contestants, patron|
    #   contestants << patron if patron.spending_money < exhibit.cost
    #   contestants
    # end

    # REFACTOR: reduce is unecessary, use find_all?
    patrons_by_exhibit_interest[exhibit].find_all do |patron|
      patron.spending_money < exhibit.cost
    end

  end

  def draw_lottery_winner(exhibit)
    # ticket_lottery_contestants(exhibit).sample.name

    # REFACTOR TO ACCOUNT FOR NIL RESULT (in the case of no contestants)
    # if ticket_lottery_contestants(exhibit).count > 0
    #   ticket_lottery_contestants(exhibit).sample.name
    # else
    #   return nil
    # end

    #REFACTOR 2 (with megan)
    contestants = ticket_lottery_contestants(exhibit)
    return nil if contestants.empty?
    contestants.sample.name
  end

  def announce_lottery_winner(exhibit)
    # if ticket_lottery_contestants(exhibit).count > 0
    #   winner = draw_lottery_winner(exhibit)
    #   "#{winner} has won the #{exhibit.name} exhibit lottery"
    # else
    #   "No winners for this lottery"
    # end

    #REFACTOR
    return "No winners for this lottery" if draw_lottery_winner(exhibit).nil?
    "#{draw_lottery_winner(exhibit)} has won the #{exhibit.name} exhibit lottery"
  end

end
