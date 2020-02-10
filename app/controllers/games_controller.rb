require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
    @time = Time.now
  end

  def score
    @start_time = Time.parse(params["time"])
    @end_time = Time.now
    @grid_letters = params["letters"]
    @guessed_word = params["word"]
    @parsed_word = parse(@guessed_word)
    @english = english_word?(@parsed_word)
    @include = included?(@guessed_word.downcase, @grid_letters.downcase)
    @points = score_calc(@guessed_word, @start_time, @end_time)
  end

  def parse(word)
    @word_checker = open("https://wagon-dictionary.herokuapp.com/#{word}").read
    @attempt_word = JSON.parse(@word_checker)
  end

  def included?(word, letters)
    grid = letters.chars
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    word["found"] ? true : false
  end

  def score_calc(word, time_start, time_end)
    @total_time = time_end - time_start
    @score = (word.length * 10) - @total_time
    @score.round
  end
end
