#4
using HorizonSideRobots

function cross!(robot)
    for side1 in (Nord, Sud)
        for side2 in (Ost, West)
            step=marker!(robot, side1, side2)
            move!(robot, inverse(side1), step)
            move!(robot, inverse(side2), step)
        end
    end
    putmarker!(robot)
end

inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)

function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(robot, side)          
    end
end

function marker!(robot, side1, side2)
    step=0::Int
    while (!isborder(robot, side1) && !isborder(robot, side2))
        move!(robot, side1)
        move!(robot, side2)
        putmarker!(robot)
        step+=1
    end
    return step
end
#5
using HorizonSideRobots

function finish!(robot)
    step_Sud=do_upora!(robot, Sud)
    step_West=do_upora!(robot, West)
    perimetr!(robot)
    side1=find!(robot)
    perimetr!(robot, side1)
    do_upora!(robot, Sud)
    do_upora!(robot, West)
    move!(robot, Ost, step_West)
    move!(robot, Nord, step_Sud)
end

function perimetr!(robot, side1)
    if side1==West
        for side2 in (Nord, West, Sud, Ost)
            while isborder(robot, reverse(side2, 2))
                putmarker!(robot)
                move!(robot, side2)
            end
            putmarker!(robot)
            move!(robot, reverse(side2, 2))
        end
    else
        for side2 in (Nord, Ost, Sud, West)
            while isborder(robot, reverse(side2, 1))
                putmarker!(robot)
                move!(robot, side2)
            end
            putmarker!(robot)
            move!(robot, reverse(side2, 1))
        end
    end
end

function find!(robot)
    side=Ost
    while (!isborder(robot, side) && !isborder(robot, Nord))
        do_upora!(robot, side)
        side=inverse(side)
        if !ismarker(robot)
            break
        else 
            move!(robot, Nord)
        end
    end
    return inverse(side)
end

function do_upora!(robot::Robot, send::HorizonSide)
    n::Int=0
    while !isborder(robot, send)
        move!(robot, send)
        n+=1
    end
    return n
end

reverse(side::HorizonSide, n)=HorizonSide((4+Int(side)+(-1)^n)%4)
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)

function perimetr!(robot)
    for side ∈ (Nord, Ost, Sud, West)
        while isborder(robot, side)==false
            move!(robot, side)
            putmarker!(robot)
        end
    end
end   

function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(robot, side)
    end
end
#6a
using HorizonSideRobots

function perimetr!(robot)
    find!(robot)
    marker!(robot)
end

function find!(robot)
     while !isborder(robot, West) || !isborder(robot, Sud)
        while !isborder(robot, West)
            move!(robot, West)
        end
        while !isborder(robot, Sud)
            move!(robot, Sud)
        end
     end
end

function marker!(robot)
    for side ∈ (Nord, Ost, Sud, West)
        while isborder(robot, side)==false
            move!(robot, side)
            putmarker!(robot)
        end
    end
end   
#6b
using HorizonSideRobots

function perimetr!(robot)
    step_Sud, step_West=find!(robot)
    marker!(robot, step_Sud, step_West)
end

function find!(robot)
    step_West=0::Int
    step_Sud=0::Int
     while !isborder(robot, West) || !isborder(robot, Sud)
        while !isborder(robot, West)
            move!(robot, West)
            step_West+=1
        end
        while !isborder(robot, Sud)
            move!(robot, Sud)
            step_Sud+=1
        end
     end
    return step_Sud, step_West
end

function marker!(robot, step_Sud, step_West)
    k=0
    t=0
    move!(robot, Nord, step_Sud)
    putmarker!(robot)
    while isborder(robot, Nord)==false
        move!(robot, Nord)
        k+=1
    end
    move!(robot, Ost, step_West)
    putmarker!(robot)
    while isborder(robot, Ost)==false
        move!(robot, Ost)
        t+=1
    end
    move!(robot, Sud, k)
    putmarker!(robot)
    while isborder(robot, Sud)==false
        move!(robot, Sud)
    end
    move!(robot, West, t)
    putmarker!(robot)
    while isborder(robot, West)==false
        move!(robot, West)
    end
end   

function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        if !ismarker(robot)
            move!(robot, side) 
        end
    end
end