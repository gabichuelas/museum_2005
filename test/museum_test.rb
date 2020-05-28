require 'minitest/autorun'
require 'minitest/pride'
require 'mocha/minitest'
require './lib/museum'
require './lib/patron'
require './lib/exhibit'

class MuseumTest < Minitest::Test
  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")
    @gems_and_minerals = Exhibit.new({name: "Gems and Minerals", cost: 0})
    @dead_sea_scrolls = Exhibit.new({name: "Dead Sea Scrolls", cost: 10})
    @imax = Exhibit.new({name: "IMAX",cost: 15})

    @patron_1 = Patron.new("Bob", 20)
    @patron_2 = Patron.new("Sally", 20)
    @patron_3 = Patron.new("Johnny", 5)
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_has_a_name
    assert_equal "Denver Museum of Nature and Science", @dmns.name
  end

  def test_it_starts_with_no_exhibits
    assert_equal [], @dmns.exhibits
  end

  def test_has_patrons_of_exhibits
    assert_equal ({}), @dmns.patrons_of_exhibits
  end

  def test_it_can_add_exhibits
    # skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_equal [@gems_and_minerals, @dead_sea_scrolls, @imax], @dmns.exhibits
  end

  def test_it_can_recommend_exhibits
    # skip
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_1.add_interest("Gems and Minerals")
    @patron_2.add_interest("IMAX")

    assert_equal [@gems_and_minerals, @dead_sea_scrolls], @dmns.recommend_exhibits(@patron_1)

    assert_equal [@imax], @dmns.recommend_exhibits(@patron_2)
  end

  def test_it_starts_with_no_patrons
    assert_equal [], @dmns.patrons
  end

  def test_can_admit_patrons
    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    assert_equal [@patron_1, @patron_2, @patron_3], @dmns.patrons
  end

  def test_can_group_patrons_by_exhibit_interest

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_equal 3, @dmns.exhibits.count

    @patron_1.add_interest("Gems and Minerals")
    @patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(@patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    assert_equal 3, @dmns.patrons.count
    assert_instance_of Hash, @dmns.patrons_by_exhibit_interest
    assert_equal [], @dmns.patrons_by_exhibit_interest[@imax]
    assert_equal 3, @dmns.patrons_by_exhibit_interest[@dead_sea_scrolls].count

    patrons_for_dead_sea = @dmns.patrons_by_exhibit_interest[@dead_sea_scrolls]

    assert_equal true, patrons_for_dead_sea.include?(@patron_2)
  end

  def test_has_lottery_ticket_contestants
    # for this test, Bob has no money
    patron_1 = Patron.new("Bob", 0)

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    assert_equal 3, @dmns.exhibits.count

    patron_1.add_interest("IMAX")
    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    # assert_equal [patron_1, @patron_3], @dmns.ticket_lottery_contestants(@dead_sea_scrolls)
    #
    # @dmns.stubs(:draw_lottery_winner).returns(patron_1.name)
    # assert_equal "Bob", @dmns.draw_lottery_winner(@dead_sea_scrolls)
    #
    # assert_equal "Bob has won the IMAX exhibit lottery", @dmns.announce_lottery_winner(@imax)
    #
    # @dmns.stubs(:draw_lottery_winner).returns(nil)
    # assert_nil @dmns.draw_lottery_winner(@gems_and_minerals)
    #
    # assert_equal "No winners for this lottery", @dmns.announce_lottery_winner(@gems_and_minerals)

    #REFACTOR
    # don't stub the draw_lottery_winner method, stub the
    # announce_lottery_winner bc it USES draw_lottery_winner.

    lotto_contestants = [patron_1.name, @patron_3.name]
    lotto_winner = @dmns.draw_lottery_winner(@dead_sea_scrolls)

    assert_equal true, lotto_winner == "Bob" || lotto_winner == "Johnny"
    assert_equal true, lotto_contestants.include?(lotto_winner)
    assert_equal false, lotto_contestants.include?(@patron_2.name)
    assert_nil @dmns.draw_lottery_winner(@gems_and_minerals)

    # NOW TEST THE ANNOUNCE METHOD
  end

  def test_has_lottery_ticket_contestants
    # for this test, Bob has no money
    patron_1 = Patron.new("Bob", 0)

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    assert_equal 3, @dmns.exhibits.count

    patron_1.add_interest("Gems and Minerals")
    patron_1.add_interest("Dead Sea Scrolls")
    @patron_2.add_interest("Dead Sea Scrolls")
    @patron_3.add_interest("Dead Sea Scrolls")

    @dmns.admit(patron_1)
    @dmns.admit(@patron_2)
    @dmns.admit(@patron_3)

    # dmns.stubs(:draw_lottery_winner).returns(nil)
    assert_equal "No winners for this lottery", @dmns.announce_lottery_winner(@gems_and_minerals)

    @dmns.stubs(:draw_lottery_winner).returns(patron_1.name)

    assert_equal 'Bob has won the Dead Sea Scrolls exhibit lottery', @dmns.announce_lottery_winner(@dead_sea_scrolls)
  end

  def test_when_admitted_patrons_spending_money_is_reduced
    # this test should live in a separate test file for
    # "USER STORY BASED TESTS"
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@dead_sea_scrolls)

    # This Patron is interested in two exhibits but none are in their price range, so they attend none :(
    tj = Patron.new("TJ", 7)

    tj.add_interest("IMAX")
    tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(tj)

    assert_equal 7, tj.spending_money
    patron_1 = Patron.new("Bob", 10)

    patron_1.add_interest("Dead Sea Scrolls")
    patron_1.add_interest("IMAX")
    @dmns.admit(patron_1)

    assert_equal 0, patron_1.spending_money

    @patron_2.add_interest("IMAX")
    @patron_2.add_interest("Dead Sea Scrolls")
    @dmns.admit(@patron_2)

    assert_equal 5, @patron_2.spending_money

    morgan = Patron.new("Morgan", 15)
    morgan.add_interest("Gems and Minerals")
    morgan.add_interest("Dead Sea Scrolls")
    @dmns.admit(morgan)

    assert_equal 5, morgan.spending_money

    expected = {
      @gems_and_minerals => [morgan],
      @dead_sea_scrolls => [patron_1, morgan],
      @imax => [@patron_2]
    }

    assert_equal expected, @dmns.patrons_of_exhibits
    assert_equal 35, @dmns.revenue

  end

end
