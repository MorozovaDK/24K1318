using HorizonSideRobots
inverse(side::HorizonSide)=HorizonSide(mod(Int(side)+2,4))
function markborder!(robot,side)
    if (!isborder(robot,side))
        move!(robot,side)
        markborder!(robot,side)
    elseif (isborder(robot,side))
        putmarker!(robot)
    end
    if (!isborder(robot,inverse(side)))
        move!(robot,inverse(side))
    end
end