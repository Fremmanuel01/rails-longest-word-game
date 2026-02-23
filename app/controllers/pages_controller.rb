require "open-uri"
class PagesController < ApplicationController
  VOWELS = %w[A E I O U]

  def new
    @letters = Array.new(5) { VOWELS.sample }
    @letters += Array.new(5) { (("A".."Z").to_a - VOWELS).sample }
    @letters.shuffle!
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].split
    @included = word_in_grid?(@word, @letters)
    @english_word = @included ? english_word?(@word) : false
  end

  private

  def word_in_grid?(word, grid)
    word.chars.all? do |letter|
      word.count(letter) <= grid.count(letter)
    end
  end

  def english_word?(word)
    return false if word.strip.empty?

    url = "https://dictionary.lewagon.com/#{word}"
    response = URI.open(url).read
    json = JSON.parse(response)
    json["found"] == true
  rescue
    false
  end
end
