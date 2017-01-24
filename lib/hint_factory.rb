class HintFactory
  FILLER_CHAR = '-'.freeze

  def self.generate_hints(answer)
    if answer.length < 5
      hint_letters = 1
      hint_num = 1
    else
      hint_letters = (answer.length / 4.0).ceil
      hint_num = (answer.length / hint_letters).floor
    end

    p "Length #{answer.length}, Letters: #{hint_letters}, Num: #{hint_num}"

    # blank starting hint
    last_hint = answer.gsub(/[^ ]/, FILLER_CHAR)

    hints = []
    hints << last_hint.clone

    (1..hint_num - 1).each do
      last_hint = replace_letters(answer, last_hint, hint_letters)
      hints << last_hint.clone
    end

    p "Hint Length True: #{hints.length}"

    return { 'hints' => hints, 'hint_num' => hint_num }
  end

  def self.replace_letters(answer, last_hint, hint_letters)
    letters_done = 0
    # replace three spaces in the hint with letters
    while letters_done < hint_letters
      rand = Random.rand(0..answer.length)
      # if the location contains an underscore, increase letters counter
      if last_hint[rand] == FILLER_CHAR
        last_hint[rand] = answer[rand]
        letters_done += 1
      end
    end
    return last_hint
  end
end
