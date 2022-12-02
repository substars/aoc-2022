class Game
    attr_accessor :me, :opponent
    MOVES = %i{paper rock scissors} 
    ME_TRANSLATION = {X: :rock, Y: :paper, Z: :scissors}
    OPPONENT_TRANSLATION = {A: :rock, B: :paper, C: :scissors}
   
    def initialize(me:, opponent:)
        @me=ME_TRANSLATION[me.intern] 
        @opponent=OPPONENT_TRANSLATION[opponent.intern]
        
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
        "ME: #{me}\tOPP: #{opponent}\t#{me_choice_score}\t#{me_outcome_score}=#{me_score}"
    end

end

total = File.read('input.txt').split("\n").each.map do |line|
    opponent, me = line.split(' ')
    g= Game.new(me: me, opponent: opponent)
    puts g.to_s
    g.me_score
end.sum

puts "player 1 has #{total} points"
    