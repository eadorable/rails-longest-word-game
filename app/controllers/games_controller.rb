require "open-uri"

class GamesController < ApplicationController

  def new
    # call generate_grid method and join them to look a bit nice(not array)
    @letters = generate_grid
  end

  def score
    @word = (params[:word] || '').upcase # player input
    @letters = params[:letters] # put array
    @valid_word = word_valid?(@word)
    @included = word_included?(@word, @letters)
  end

  private

  def word_valid?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    open_url = URI.open(url)
    read_url = open_url.read
    parse_url = JSON.parse(read_url)
    parse_url['found']
  end

  def word_included?(word, letters)
    # letters came from generate_grid and word came from player input
    # convert to array of arrays of chars
    letters_char = letters.chars
    word_char = word.chars

    word_char.each do |letter|
      # count the occurence of letter from the word(player input)
      letters_char_count = letters_char.count(letter)
      word_char_count = word_char.count(letter)

      return false if word_char_count > letters_char_count
    end
    true
  end

  def generate_grid
    # generate array of vowels
    vowels = %w(A E I O U)
    vowels_random = Array.new(5) { vowels.sample }
    # generate array of complete letters
    complete_letters = ('A'..'Z').to_a
    # generate array of letters without vowels
    letters_no_vowels = complete_letters - vowels
    letters_no_vowels_random = Array.new(5) { letters_no_vowels.sample }
    # combine random vowels and random letters(without vowels)
    letters_array = vowels_random + letters_no_vowels_random
    letters_array.shuffle!
  end
end
