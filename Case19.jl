using HorizonSideRobots
function toborder!(robot,side)
    isborder(robot,side) && return
    move!(robot,side)
    toborder!(robot,side)
end