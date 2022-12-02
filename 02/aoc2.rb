class Game
    attr_accessor :me, :opponent, :outcome
    MOVES = %i{paper rock scissors} 
    OPPONENT_TRANSLATION = {A: :rock, B: :paper, C: :scissors}
    OUTCOME_TRANSLATION = {X: :loss, Y: :draw, Z: :win}

   
    def initialize(outcome:, opponent:)
        @opponent=OPPONENT_TRANSLATION[opponent.intern]
        @outcome=OUTCOME_TRANSLATION[outcome.intern]
        @me=me_move_for(@outcome)
    end

    def me_move_for(outcome)
        case outcome
        when :win
            MOVES[MOVES.index(opponent)-1]
        when :loss
            MOVES[MOVES.index(opponent)-2]
        else
            opponent
        end
    end

    # 0=tie
    def me_outcome_score
        # -1 or +2 is win
        # +1 or -2 is loss 
        return case MOVES.index(me) - MOVES.index(opponent)
        when 2, -1
            6
        when 1, -2
            0
        else
            3
        end
    end

    def me_choice_score
        %i{rock paper scissors} .index(me)+1
    end

    def me_score
        me_choice_score + me_outcome_score
    end

    def to_s
        "OUTCOME\t#{outcome}\tME: #{me}\tOPP: #{opponent}\t#{me_choice_score}\t#{me_outcome_score}=#{me_score}"
    end

end

total = File.read('input.txt').split("\n").each.map do |line|
    opponent, outcome = line.split(' ')
    g= Game.new(outcome: outcome, opponent: opponent)
    puts g.to_s
    g.me_score
end.sum

puts "player 1 has #{total} points"
    