# https://adventofcode.com/2021/day/21

using QuickHeaps

p1_position = 6
p2_position = 1

roll(i, sides=100) = sum(([i-1, i, i+1] .% sides) .+ 1), i + 2 % sides + 1


function move(position, die, track_length=10)
    p_roll, die = roll(die)
    return (position + p_roll) % track_length == 0 ? track_length : (position + p_roll) % track_length, die
end

function part1(p1_position, p2_position, winning_score=1000)
    die = 1
    die_rolls = 0
    player = 1
    p1_score, p2_score = 0, 0
    while true
        if player == 1
            p1_position, die = move(p1_position, die)
            p1_score += p1_position
        else
            p2_position, die = move(p2_position, die)
            p2_score += p2_position
        end 
        player = player == 1 ? 2 : 1
        die_rolls += 3
        if p1_score >= winning_score || p2_score >= winning_score
            return min(p1_score, p2_score) * die_rolls
        end
    end
end
@show part1(p1_position, p2_position)

function part2(p1_position, p2_position, winning_score=21)
    frontier = PriorityQueue()
    state = p1_position, p2_position, 0, 0, 1, 1
    frontier[state] = 1
    seen = Dict()
    seen[state] = 1
    p1_wins = 0
    p2_wins = 0

while !isempty(frontier)
   (p1_position, p2_position, p1_score, p2_score, die, player_turn), n = pop!(frontier)
   if p1_score >= winning_score
        p1_wins +=1
        continue
   elseif p2_score >= winning_score
        p2_wins +=1
        continue
   end
   
   for next in neighbours()
      if next ∉ seen
        seen[next] = 1
        frontier[next] = 1
      else
        seen[next] += 1
      end
    end 
end