function string.starts(String, Start)
   return string.sub(String, 1, string.len(Start)) == Start
end

function string.ends(String, End)
   return End == '' or string.sub(String, -string.len(End)) == End
end

function round(val, decimal)
    if (decimal) then
        return math.floor((val * 10 ^ decimal) + 0.5) / (10 ^ decimal)
    end
    -- if no place specified, round to nearest whole number
    return math.floor(val + 0.5)
end

-- Checks if point px,py is inside of a defined box
function insideBox(px, py, bx, by, bw, bh)
    if px > bx and px < bx + bw then
        if py > by and py < by + bh then
            return true
        end
    end

    return false
end

local insert= table.insert

local function cross(dx,dy,dx2,dy2)
    return dx*dy2-dy*dx2
end

function polygonCut(cvertices, pvertices)
    local plen     = #pvertices
    local x,y,x2,y2= unpack(cvertices)
    local dx,dy    = x2-x,y2-y
    local polygons = {{},{}}
    local set      = polygons[1]
    local intersections = 0
    for i = 1,plen,2 do
        local x3,y3,x4,y4= pvertices[i],pvertices[i+1],pvertices[i+2] or pvertices[1],pvertices[i+3] or pvertices[2]
        insert(set,x3) insert(set,y3)
        local dx2,dy2    = x4-x3,y4-y3
        local denom      = cross(dx,dy,dx2,dy2)
        if denom ~= 0 then
            local tnum = cross((x3-x),(y3-y),dx2,dy2)
            local unum = cross((x3-x),(y3-y),dx,dy)
            local ct,pt= tnum/denom,unum/denom
            if ct >= 0 and ct <= 1 and pt >= 0 and pt <= 1 then
                local ix,iy = x+ct*dx,y+ct*dy
                if pt ~= 1 then
                    if pt ~= 0 then
                        insert(set,ix) insert(set,iy)
                    end
                    set = set == polygons[1] and polygons[2] or polygons[1]
                    insert(set,ix) insert(set,iy)
                    intersections = intersections+1

                end
            end
        end
    end
    if intersections == 2 then return polygons end
end

return polygonCut