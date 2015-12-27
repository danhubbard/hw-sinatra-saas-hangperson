class HangpersonGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/hangperson_game_spec.rb pass.

  # Get a word from remote "random word" service

  # def initialize()
  # end
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word.downcase
    @guesses = ''
    @wrong_guesses = ''
  end

  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://watchout4snakes.com/wo4snakes/Random/RandomWord')
    Net::HTTP.post_form(uri ,{}).body
  end

  def guess(letter)
    raise ArgumentError.new("Must be a valid letter") if !(valid_letter?(letter))
    letter.downcase!
    return false if already_guessed?(letter)
    correct_guess?(letter) ? @guesses << letter : @wrong_guesses << letter
  end

  def check_win_or_lose
    return :lose if game_lost
    return :win if game_won
    return :play
  end

  def word_with_guesses
    substitute_not_guessed
  end

  private

  def already_guessed?(letter)
    (@guesses.count(letter) > 0) || (@wrong_guesses.count(letter) > 0)
  end

  def correct_guess?(letter)
    @word.include?(letter) && @guesses.count(letter) == 0
  end#

  def valid_letter?(letter)
    (letter =~ /^[A-Za-z]+$/) && (letter.length > 0) && !(letter.nil?)
  end

  def substitute_not_guessed
    displayed = ""
    @word.each_char do |letter|
      displayed << (@guesses.include?(letter) ? letter : "-")
    end
    displayed
  end

  def game_lost
    @wrong_guesses.length >= 7
  end

  def game_won
    !word_with_guesses.include?("-")
  end

end
