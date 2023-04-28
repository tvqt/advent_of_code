# https://adventofcode.com/2022/day/19

file_path = "2022/data/day_19.txt"

function clean_input(file_path=file_path)
    [parse.(Int, match(r"Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian.", line).captures) for line in readlines(file_path)]
end

input = clean_input()

function blueprint()
end