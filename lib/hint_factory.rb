class HintFactory
  FILLER_CHAR = '-'.freeze

  def self.generate_hints(answer)
    hint_num = (answer.length / 5.0).ceil
    # Hardcoded 6 MAX HINTS
    hint_num = hint_num < 6 ? hint_num : 6

    # blank starting hint
    last_hint = answer.gsub(/[^ ]/, FILLER_CHAR)

    hints = []
    hints << last_hint.clone

    (0..hint_num - 1).each do
      last_hint = replace_letters(answer, last_hint)
      hints << last_hint.clone
    end

    p hints
    return { 'hints' => hints, 'hint_num' => hint_num }
  end

  def self.replace_letters(answer, last_hint)
    letters_done = 0
    # replace three spaces in the hint with letters
    while letters_done < 3
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
