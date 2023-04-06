# Day 16: Ticket Translation
# https://adventofcode.com/2020/day/16


tickets_path = "2020/data/day_16.txt"
classes_path = "2020/data/day_16_classes.txt"

function clean_input(tickets=tickets_path, classes=classes_path)
    out = []
    classes = Dict()
    
    for line in readlines(tickets_path) # parse the tickets
        push!(out, parse.(Int, split(line, ",")))
    end

    for line in readlines(classes_path) # parse the classes
        line = split(line, ": ")
        ranges = split(line[2], " or ")
        range1 = parse.(Int, split(ranges[1], "-"))
        range2 = parse.(Int, split(ranges[2], "-"))
        classes[line[1]] = range1[1]:range1[2], range2[1]:range2[2]
    end
    return out, classes
end

validity_check(number,classes) = any([number in v[2][1]||number in v[2][2] for v in classes]) # check if a number is valid for any of the class rules
ticket_check(ticket, classes) = all([validity_check(number, classes) for number in ticket]) # make sure all numbers on a ticket are potentially valid for some class

function solve(input = clean_input())
    tickets, classes = input
    my_ticket = tickets[1]
    out = 0
    good_tickets = copy(tickets)

    for ticket in tickets
        for number in ticket
            if !validity_check(number, classes)
                out += number
                filter!(x -> x != ticket, good_tickets)
            end
        end
    end

    assigned_classes = Dict()
    unassigned_classes = copy(classes)
    assigned_ticket_positions = []

    while length(unassigned_classes) > 0
        for (key, value) in unassigned_classes
            potential_positions = class_potential_positions(key, good_tickets, classes)
            if length(setdiff(potential_positions, assigned_ticket_positions)) == 1
                assigned_classes[key] = setdiff(potential_positions, assigned_ticket_positions)[1]
                push!(assigned_ticket_positions, setdiff(potential_positions, assigned_ticket_positions)[1])
                delete!(unassigned_classes, key)
            end
        end
    end

    return out, prod([my_ticket[assigned_classes[key]] for key in keys(assigned_classes) if contains(key, "departure")])
end

class_position_check(class, position, tickets, classes) = all([ticket[position] in classes[class][1] || ticket[position] in classes[class][2] for ticket in tickets]) # check if a position on a ticket is valid for a class
class_potential_positions(class, tickets, classes) = [position for position in eachindex(tickets[1]) if class_position_check(class, position, tickets, classes)] # find all positions on a ticket that are valid for a class


@show solve()
