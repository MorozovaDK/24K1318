#8
using HorizonSideRobots

function cross!(robot)
    side1=Nord
    side2=West
    for step in 1: 10
        for side in (side1, side2)
            move!(robot, side, step)
        end
        side1=inverse(side1)
        side2=inverse(side2)
    end 
end

function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        if !ismarker(robot)
            move!(robot, side) 
        end
    end
end

inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)

#9
using HorizonSideRobots

function chess!(robot)
    step_Sud=do_upora!(robot, Sud)
    step_West=do_upora!(robot, West)
    n=step_Sud+step_West
    if n%2==0
        mark_direct!(robot, Ost)
    else 
        do_upora!(robot, Ost)
        mark_direct!(robot, West)
    end
    do_upora!(robot, Sud)
    do_upora!(robot, West)
    move!(robot, Nord, step_Sud)
    move!(robot, Ost, step_West)
end

function do_upora!(robot::Robot, send::HorizonSide)
    n::Int=0
    while !isborder(robot, send)
        move!(robot, send)
        n+=1
    end
    return n
end 

function mark_direct!(robot, side)
    while !isborder(robot, Nord)
        marker!(robot, side)
        side=inverse(side)
        move!(robot, Nord)
    end
    marker!(robot, side)
end

function marker!(robot, side)
    putmarker!(robot)
    while !isborder(robot, side)
        move!(robot, side)
        if !isborder(robot, side)
            move!(robot, side)
            putmarker!(robot)
        end  
    end
end

inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)

function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
        move!(robot, side)          
    end
end

#10

using HorizonSideRobots

function chess!(robot, n)
    step_West=do_upora!(robot, Ost)
    step_Sud=do_upora!(robot, Nord)
    a=do_upora!(robot, Sud)+1
    a=(a-(a%n))/n
    b=do_upora!(robot, West)+1
    b=(b-(b%n))/n
    mark_perimetr!(robot, a, b, n)
    do_upora!(robot, Ost)
    do_upora!(robot, Nord)
    move!(robot, West, step_West)
    move!(robot, Sud, step_Sud)
end

function mark_perimetr!(robot, a, b, n)
    b1=b
    while b1>0
        a1=a
        while a1>0
            mark_kletka!(robot, n)
            a1-=1
            if a1>0
                move!(robot, Nord, n)
                a1-=1
            end
        end
        a1=a
        b1-=1
        if b1>0
            move!(robot, Ost, n)
            do_upora!(robot, Sud)
            while a1>0
                move!(robot, Nord, n)
                a1-=1
                if a1>0
                    mark_kletka!(robot, n)
                    a1-=1
                end
            end
            b1-=1
        if b1>0
            move!(robot, Ost, n)
            do_upora!(robot, Sud)
        end
        end
    end
end

function mark_kletka!(robot, n)
    side=Ost
    for _ in 1:n
        for _ in 1:n-1             
            putmarker!(robot)
            move!(robot, side)
        end
        putmarker!(robot)
        move!(robot, Nord)
        side=inverse(side)
    end
    if n%2==1
        move!(robot, West, n-1)
    end
 end
