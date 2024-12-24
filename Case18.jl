using HorizonSideRobots
left(side::HorizonSide)=HorizonSide((Int(side)+1)%4)
inverse(side::HorizonSide)=HorizonSide(mod((Int(side)+2),4))
function HorizonSideRobots.move!(robot,side,num_steps)
    if (!ismarker(robot))
        for _ in  1:num_steps
            (ismarker(robot) && break)
            move!(robot,side)
        end
    end
end
function throughinfborder(robot,side)
    steps=1
    s=left(side)
    while (isborder(robot,side))
        move!(robot,s,steps)
        s=inverse(s)
        steps+=1
    end
    (!ismarker(robot))&&(move!(robot,side))
    (!ismarker(robot))&&(move!(robot,s,floor(steps/2)))
end
function movetoend!(stop_condition::Function,robot,side)
    n=0
    while (!stop_condition())
        move!(robot,side)
        n+=1
    end
    return n
end

function find_direct!(stop_condition,robot,side,nmax_steps)
    n=0
    while (!stop_condition() && n<nmax_steps)
        (!isborder(robot,side))&&(move!(robot,side))
        (isborder(robot,side)) && (throughinfborder(robot,side))
        n+=1
    end
    return stop_condition()
end

function spiral!(stop_condition::Function,robot)
    nmax_steps=1
    s=Nord
    while !find_direct!(stop_condition,robot,s,nmax_steps)
        (s in (Nord,Sud)) && (nmax_steps+=1)
        s=left(s)
    end
end
function main(robot)
    spiral!(()->ismarker(robot),robot)
end