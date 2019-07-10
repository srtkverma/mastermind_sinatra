# frozen_string_literal: true

class Mastermind
  attr_reader :tries, :random_number
  def initialize
    @random_number = generate_random_number
    @tries = 12
  end

  def generate_random_number
    random_number = []
    until random_number.length == 4
      random_digit = [1, 2, 3, 4, 5, 6].sample
      random_number << random_digit unless random_number.include? random_digit
    end
    random_number.join('').to_i
  end

  def feedback(a, b)
    a = a.to_s.split('').map(&:to_i)
    b = b.to_s.split('').map(&:to_i)
    hint = { 'digits' => 0, 'places' => 0 }
    (0...a.length).each do |i|
      if b.include? a[i]
        if b[i] == a[i]
          hint['places'] += 1
        else
          hint['digits'] += 1
          end
      end
    end
    hint
  end

  def check_guess(guess, correct_number)
    @end = true if guess == correct_number || @tries == 12
  end

  def possible_combinations(sample, _n)
    collection = []
    starting_number = 1111
    end_number = 6666
    count = 0
    (starting_number..end_number).each do |i|
      number = i.to_s.split('').map(&:to_i)
      flag = true
      (0...number.length).each do |n|
        flag = false unless sample.include? number[n]
      end
      (0...number.length).each do |a|
        (a + 1...number.length).each do |b|
          flag = false if number[a] == number[b]
        end
      end
      if flag
        count += 1
        collection << i
      end
    end
    collection
  end

  def get_next_guess(possible_guesses)
    result = {}
    min_array = []
    (0...possible_guesses.length).each do |i|
      current_number = {}
      (0...possible_guesses.length).each do |j|
        next unless possible_guesses[j] != possible_guesses

        hint = feedback possible_guesses[j], possible_guesses[i]
        digits_places = "#{hint['digits']},#{hint['places']}"
        current_number[digits_places] ||= 0
        current_number[digits_places] += 1
      end
      max = 0
      min = 100
      current_number.each do |_key, value|
        max = value if value > max
        min = value if value < max
      end
      result[possible_guesses[i].to_s] = max
      min_array << min
    end
    result = result.sort_by do |_key, value|
      value
    end
    result[0][0]
  end

  def play(guess)
    @tries-=1
    hint = feedback guess, @random_number
    return hint
  end

  def computer_play
    @tries = 0
    found = false
    possible_guesses = possible_combinations [1, 2, 3, 4, 5, 6], 4
    unless @end
      loop do
        computer_guess = get_next_guess possible_guesses unless @tries == 0
        computer_guess ||= 1234
        puts "computer guess = #{computer_guess}"
        print 'places,digits: '
        input = gets.chomp
        input = input.split(',')
        hint = { 'places' => input[0].to_i, 'digits' => input[1].to_i }
        @tries += 1
        break if hint['places'] == 4

        backup_hint = { 'digits' => hint['digits'], 'places' => hint['places'] }
        (0...possible_guesses.length).each do |i|
          break if possible_guesses[i].nil?

          hint = feedback possible_guesses[i], computer_guess
          if backup_hint['digits'] != hint['digits'] || backup_hint['places'] != hint['places']
            possible_guesses.delete possible_guesses[i]
          end
        end
        if possible_guesses.length == 1
          puts "computer guess = #{possible_guesses[0]}"
          @tries += 1
          break
        end
        break if @end
      end
    end
  end
end
