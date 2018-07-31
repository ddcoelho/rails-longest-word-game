require 'open-uri'
require 'json'

class PagesController < ApplicationController

  ALPHABET = ("A".."Z").to_a
  VOWELS = ["A", "E", "I", "O", "U"]

  def game
    @time_start = Time.now
    @letters = generate_grid(10)
  end

  def score
    @time_submit = Time.now
    @input = params[:word]
    @letters = params["letters"]
    @time_start = Time.parse(params["start_time"])
    @message = run_game(@input, @letters, @time_start, @time_submit)
  end

  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    grid = []
    grid = (0...grid_size).map do
      ALPHABET[rand(ALPHABET.size )]
    end
    grid << VOWELS[rand(VOWELS.length)]
    grid
  end

  def in_grid?(attempt, grid)
    puts "got in: attempt"
    p grid
    attempt_arr = attempt.upcase.split("")

    attempt_arr.each do |letter|
      return false if attempt_arr.count(letter) > grid.count(letter)
      # true
    end
  end

  def valid_word?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    validation_serialized = open(url).read
    is_valid = JSON.parse(validation_serialized)
    is_valid["found"]
  end

  def run_game(attempt, grid, start_time, end_time)
    result = { time: 0, score: 0, message: "" }

    if !in_grid?(attempt, grid)
      result[:message] = "Your word is not in the grid"
    elsif !valid_word?(attempt)
      result[:message] = "That is not an english word"
    else
      result[:message] = "Well done"
      result[:score] = (5 + (100 - (end_time - start_time)) + attempt.length).to_i
      result[:time] = end_time - start_time
    end

    result
  end
end
