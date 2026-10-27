
local Hidden = {}

local HiddenMethods = {
    -- children / descendants
    ["GetChildren"] = true,
    ["GetDescendants"] = true,
    ["QueryDescendants"] = true,

    -- find child
    ["FindFirstChild"] = true,
    ["FindFirstChildOfClass"] = true,
    ["FindFirstChildWhichIsA"] = true,
    ["FindFirstDescendant"] = true,
    ["WaitForChild"] = true,

    -- find ancestor
    ["FindFirstAncestor"] = true,
    ["FindFirstAncestorOfClass"] = true,
    ["FindFirstAncestorWhichIsA"] = true,

    ["GetTouchingParts"] = true,
    ["GetConnectedParts"] = true,
    ["GetPartsInPart"] = true,
    ["GetPartBoundsInBox"] = true,
    ["GetPartBoundsInRadius"] = true,

    -- deprecated lowercase aliases (still work)
    ["children"] = true,
    ["getChildren"] = true,
    ["findFirstChild"] = true,
}

do
    local OldNamecall
    OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
        if not checkcaller() then
            local Method = getnamecallmethod()

            if Method ~= nil and HiddenMethods[Method] then
                local Output = OldNamecall(...)
                local OutputType = typeof(Output)

                if OutputType == "table" then
                    for ii = #Output, 1, -1 do
                        local vv = Output[ii]
                        if typeof(vv) == "Instance" then
                            if Hidden[vv] == true then
                                table.remove(Output, ii)
                            end
                        end
                    end
                elseif OutputType == "Instance" then
                    if Hidden[Output] then
                        return nil
                    end
                end

                return Output
            end

        end
        return OldNamecall(...)
    end))
end



local function appendConnections(list, signal)
    for _, connection in pairs(getconnections(signal)) do
        list[#list + 1] = connection
    end

    return list
end

getgenv().disableC = function(connections)
    local changed = {}

    for _, connection in pairs(connections) do
        if connection.Function ~= nil and connection.State ~= nil and connection.Enabled == true then
            changed[#changed + 1] = connection
            connection:Disable()
        end
    end

    return changed
end

getgenv().enableC = function(connections)
    local changed = {}

    for _, connection in pairs(connections) do
        changed[#changed + 1] = connection
        connection:Enable()
    end

    return changed
end

getgenv().isdescendant = function(instance, ancestor)
    local current = instance.Parent

    while true do
        if current == ancestor then
            return true
        elseif current == nil then
            return false
        else
            current = current.Parent
        end
    end
end

getgenv().getparents = function(instance)
    local parents = {}
    local current = instance.Parent

    while current ~= nil do
        parents[#parents + 1] = current
        current = current.Parent
    end

    return parents
end

getgenv().hideinstance = function(instance, props)
    if typeof(instance) == "Instance" then
        Hidden[instance] = true
    elseif typeof(instance) == "string" then
        local obj = Instance.new(instance)
        Hidden[obj] = true

        if props then
            for prop, value in props do
                obj[prop] = value
            end
        end

        return obj
    end
end

getgenv().unhideinstance = function(instance)
    if typeof(instance) == "Instance" then
        Hidden[instance] = nil
    end
end

getgenv().hideobject = getgenv().hideinstance
getgenv().hiddeninstance = getgenv().hideinstance
getgenv().createinstance = getgenv().hideinstance

getgenv().unhideobject = getgenv().unhideinstance



do
    local OldNewIndex
    OldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(...)
        local Args = {...}
        local Self = Args[1]
        if Hidden[Self] then
            local Method = Args[2]

            if Method == "Parent" then
                setparent(Args[1], Args[3])
                return
            end
        end

        return OldNewIndex(...)
    end))

    getgenv().setrawproperty = function(instance, property, value)
        local connections = {}
        appendConnections(connections, instance.Changed)
        appendConnections(connections, instance:GetPropertyChangedSignal(property))

        local disabled = disableC(connections)
        OldNewIndex(instance, property, value)
        enableC(disabled)
    end

    getgenv().setparent = function(instance, newParent)
        local connections = {}
        appendConnections(connections, newParent.DescendantAdded)
        appendConnections(connections, newParent.ChildAdded)
    
        for _, parent in pairs(getparents(newParent)) do
            appendConnections(connections, parent.DescendantAdded)
            appendConnections(connections, parent.ChildAdded)
        end
    
        local disabled = disableC(connections)
        OldNewIndex(instance, "Parent", newParent)
        enableC(disabled)
    end
end
