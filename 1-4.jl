#1
using HorizonSideRobots

function do_upora!(robot,side)
    n=0
    while !isborder(robot,side)
        move!(robot,side)
        putmarker!(robot)
        n=n+1
    end
    return n
end

function HorizonSideRobots.move!(robot,side,steps::Integer)
    for _ in 1:steps
        move!(robot,side)
    end
end

inverse(side::HorizonSide) = HorizonSide((Int(side)+2)%4)

function crest!(robot)
    for side in (Nord,Ost,Sud,West)
        p=do_upora!(robot,side)
        side = inverse(side)
        move!(robot,side,p)
    end
end





#2
using HorizonSideRobots

function mark_direct!(robot)
    for side in (Nord,Ost,Sud,West)
        while !isborder(robot,side)
            move!(robot,side)
            putmarker!(robot)
        end
    end
end

function do_upora!(robot::Robot,side::HorizonSide)
    n::Int=0
    while !isborder(robot,side)
        move!(robot,side)
        n=n+1
    end
    return n 
end

function HorizonSideRobots.move!(robot,side,num_steps::Integer)
    for _ in 1:num_steps
        move!(robot,side)
    end
end

function marker_pr!(robot)
    steps_Sud=do_upora!(robot,Sud)
    steps_West=do_upora!(robot,West)
    mark_direct!(robot)
    move!(robot,West,steps_West)
    move!(robot,Sud,steps_Sud)
end



#3
using HorizonSideRobots

inverse(side::HorizonSide)=HorizoneSide((Int(side)+2)%4)

function do_upora(robot,side)
    n::Int=0
    while !isborder(robot,side)
        move!(robot,side)
        n=n+1
    end
    return n 
end

function HorizonSideRobots.move!(robot,side,num_step::Integer)
    for _ in 1:num_step
        move!(robot,side)
    end
end

 function mark_direct!(robot,side)
    while isborder(robot, Ost)==false
        for side in  (Nord, Sud)
            putmarker!(robot)
            move!(robot,Ost)
            while isborder(robot, side)==false
                move!(robot, side)
                putmarker!(robot)
            end
        end
    end
end
function marker_all(robot)
    step_Sud=do_upora!(robot,Sud)
    step_West=do_upora!(robot,West)
    mark_direct!(robot)
    do_upora(robot,West)
    move!(robot,Nord,step_Sud)
    move!(robot,Ost,step_West)
end

    
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