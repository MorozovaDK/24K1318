#15
using HorizonSideRobots
HorizonSideRobots.move!(robot,side,num_steps)=for _ in 1:num_steps move!(robot,side) end
inverse(side::HorizonSide)=HorizonSide((Int(side)+2)%4)
mutable struct CoordCrossRobot
    robot::Robot
    x0::Int
    y0::Int
    x::Int
    y::Int
    
end
function HorizonSideRobots.move!(robot::CoordCrossRobot,side)
    (abs(robot.x-robot.x0)==abs(robot.y-robot.y0)) && (putmarker!(robot.robot))
    if (side==Nord)
        robot.y+=1
    elseif (side==Sud)
        robot.y-=1
    elseif (side==Ost)
        robot.x+=1
    else
        robot.x-=1
    end
    move!(robot.robot,side)
end

HorizonSideRobots.isborder(robot::CoordCrossRobot,side)=isborder(robot.robot,side)
function do_upora!(robot,side)
    counter=0
    while (!isborder(robot,side))
        move!(robot,side)
        counter+=1
    end
    return counter
end
function to_start!(robot)
    path=[]
    x0=0
    y0=0
    while (!isborder(robot,West) || !isborder(robot,Sud))
        y=do_upora!(robot,Sud)
        x=do_upora!(robot,West)
        push!(path,[Nord,y])
        push!(path,[Ost,x])
        
        x0+=x
        y0+=y
    end
    return [path,x0,y0]
end
function to_dot!(robot,path)
    for i in length(path):-1:1
        move!(robot,path[i][1],path[i][2])
    end
end
function movetoend!(stop_condition::Function,robot,side)
    counter=0
    while (!stop_condition())
        move!(robot,side)
        counter+=1
    end
    return counter
end
function snake!(stop_condition::Function,robot,sides::NTuple{2,HorizonSide},x)
    s=sides[1]
    
    while ((!(stop_condition())) && (!isborder(robot,sides[2])))
        c=0
        while (c<x)
            c+=movetoend!(()->stop_condition() || isborder(robot,s),robot,s)
            if c<x
                c+=throughborder!(robot,s)
            end
        end
        movetoend!(()->stop_condition() || isborder(robot,s),robot,s)
        s=inverse(s)
        move!(robot,sides[2])
    end
    movetoend!(()->stop_condition() || isborder(robot,s),robot,s)
end

function borderside(robot,side1,side2,side3)
    return (isborder(robot,side3) && (isborder(robot,side1) || isborder(robot,side2)))
end

function f(x::Int)
    return (x^2)<-1
end

function throughborder!(robot,side)
    c=0
    c1=0
    while (isborder(robot,side))
        move!(robot,Nord)
        c+=1
    end
    move!(robot,side)
    c1+=1
    while (isborder(robot,Sud))
        move!(robot,side)
        c1+=1
    end
    move!(robot,Sud,c)
    return c1
end

function make(robot)
    path,x0,y0=to_start!(robot)
    robot=CoordCrossRobot(robot,x0,y0,0,0)
    x=do_upora!(r,Ost)
    move!(r,West,x)
    snake!(()->f(2),robot,(Ost,Nord),x)
    to_start!(r)
    to_dot!(robot,path)
end

#16




#17
using HorizonSideRobots
left(side::HorizonSide)=HorizonSide((Int(side)+1)%4)
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
        move!(robot,side)
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