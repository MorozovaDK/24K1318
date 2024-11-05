using HorizonSideRobots

function square!(robot)
    for s in (Ost, Sud, West, Nord)
        do_stenki!(robot, s, 1)
    end
end 

function do_stenki!(robot, side, p)
    while isborder!(robot, side)
        if p == 1
            putmarker!(robot)
        end 
        move!(robot, side)
    end
end

function shagi!(robot, side, p)
    s=0
    while isborder!(robot, side)
        move!(robot, side)
        if p == 1 
            putmarker!(robot)
        end 
        s = s + 1 
    end
    return s
end

function marsh!(robot)
    ar=[]
    while !isborder(robot, West)||!isborder(robot, Nord)
        push!(ar, shagi!(robot, West, 0))
        push!(ar, shagi!(robot, Nord, 0))
    end
    p=0
    for i in 1:length(ar)
        side = [Sud, Ost]
        move!(robot, side[p%2+1], ar[length[ar]-i+1])
        p += 1
    end 
end

function HorizonSideRobots.move!(robot, side, num_steps::Integer)
    for _ in 1:num_steps
            move!(robot, side)
    end
end

inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)