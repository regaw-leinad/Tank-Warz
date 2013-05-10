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

function polygonCut(midX, midY, poly)
    local t = {}

    local count = 1
    local tCount = 1

    t[tCount] = { poly[count], poly[count + 1], midX, midY, poly[#poly - 1], poly[#poly] }

    tCount = tCount + 1

    while count < #poly - 4 do
        t[tCount] = { poly[count], poly[count + 1], midX, midY, poly[count + 2], poly[count + 3] }

        tCount = tCount + 1
        count = count + 2
    end

    return t
end
