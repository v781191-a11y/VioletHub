-- VioletHub | standalone client-side Luau UI
-- Intended for authorized testing. No remote calls, trades, combat automation, or item transfers.
local Players = game:GetService('Players')
local UIS = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local player = Players.LocalPlayer
local parent = (type(gethui) == 'function' and gethui()) or player:WaitForChild('PlayerGui')
local old = parent:FindFirstChild('VioletHubStandalone')
if old then old:Destroy() end
local gui = Instance.new('ScreenGui')
gui.Name = 'VioletHubStandalone'; gui.ResetOnSpawn = false; gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; gui.Parent = parent
local function new(class, props, into)
    local obj = Instance.new(class)
    for k,v in pairs(props or {}) do obj[k]=v end
    obj.Parent=into
    return obj
end
local bg=Color3.fromRGB(8,6,13)
local panel=Color3.fromRGB(22,15,35)
local purple=Color3.fromRGB(91,33,182)
local light=Color3.fromRGB(235,225,255)
local frame=new('Frame',{Name='Window',Size=UDim2.fromOffset(530,355),Position=UDim2.new(.5,-265,.5,-177),BackgroundColor3=bg,BorderSizePixel=0},gui)
new('UICorner',{CornerRadius=UDim.new(0,12)},frame)
new('UIStroke',{Color=purple,Thickness=2},frame)
local top=new('Frame',{Size=UDim2.new(1,0,0,44),BackgroundColor3=panel,BorderSizePixel=0},frame)
new('UICorner',{CornerRadius=UDim.new(0,12)},top)
new('TextLabel',{Size=UDim2.new(1,-95,1,0),Position=UDim2.fromOffset(15,0),BackgroundTransparency=1,Text='VIOLET HUB  •  Client Lab',TextColor3=light,TextSize=17,Font=Enum.Font.GothamBold,TextXAlignment=Enum.TextXAlignment.Left},top)
local close=new('TextButton',{Size=UDim2.fromOffset(36,28),Position=UDim2.new(1,-42,0,8),Text='×',TextSize=24,Font=Enum.Font.GothamBold,TextColor3=light,BackgroundColor3=purple},top)
new('UICorner',{CornerRadius=UDim.new(0,6)},close)
local sidebar=new('Frame',{Position=UDim2.fromOffset(8,53),Size=UDim2.fromOffset(124,292),BackgroundColor3=panel,BorderSizePixel=0},frame)
new('UICorner',{CornerRadius=UDim.new(0,8)},sidebar)
local sideLayout=new('UIListLayout',{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder},sidebar)
new('UIPadding',{PaddingTop=UDim.new(0,8),PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7)},sidebar)
local content=new('ScrollingFrame',{Position=UDim2.fromOffset(141,53),Size=UDim2.new(1,-150,1,-62),BackgroundColor3=panel,BorderSizePixel=0,ScrollBarThickness=4,CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y},frame)
new('UICorner',{CornerRadius=UDim.new(0,8)},content)
local layout=new('UIListLayout',{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder},content)
new('UIPadding',{PaddingTop=UDim.new(0,12),PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12),PaddingBottom=UDim.new(0,12)},content)
local connections={}
local function clear()
    for _,c in ipairs(connections) do c:Disconnect() end
    table.clear(connections)
    for _,v in ipairs(content:GetChildren()) do if v:IsA('GuiObject') then v:Destroy() end end
end
local function label(txt, height)
    return new('TextLabel',{Size=UDim2.new(1,-4,0,height or 40),BackgroundTransparency=1,Text=txt,TextWrapped=true,TextColor3=light,TextSize=13,Font=Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Top},content)
end
local function button(txt,fn)
    local b=new('TextButton',{Size=UDim2.new(1,-4,0,35),BackgroundColor3=purple,TextColor3=light,Text=txt,TextSize=13,Font=Enum.Font.GothamBold},content)
    new('UICorner',{CornerRadius=UDim.new(0,7)},b)
    b.MouseButton1Click:Connect(fn)
    return b
end
local function toggle(txt, initial,fn)
    local enabled=initial
    local b=button('',function() enabled=not enabled; fn(enabled); end)
    local function refresh() b.Text=txt..'  ['..(enabled and 'ON' or 'OFF')..']' end
    b.MouseButton1Click:Connect(refresh)
    refresh()
    return b
end
local state={highlight=false,roleLabels=false}
local roleFolder=Instance.new('Folder');roleFolder.Name='VioletHubLocalHighlights';roleFolder.Parent=gui
local function updateHighlights()
    roleFolder:ClearAllChildren()
    if not state.highlight then return end
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player and p.Character then
            local h=Instance.new('Highlight')
            h.Name='PlayerHighlight';h.FillColor=purple;h.OutlineColor=Color3.fromRGB(220,180,255)
            h.FillTransparency=.8;h.Adornee=p.Character;h.Parent=roleFolder
        end
    end
end
local tabs={}
tabs.Home=function()
    label('VioletHub • standalone client interface',30)
    label('Player: '..player.Name..'\nPlace ID: '..tostring(game.PlaceId)..'\nExecutor-independent Roblox UI (no external downloads).',76)
    button('Refresh local session information',function() clear();tabs.Home() end)
    label('Features are client-side diagnostics, visuals, and simulations. No real item transfers or attack automation.',75)
end
tabs.Visuals=function()
    label('Local player visualization',26)
    toggle('Highlight other players',state.highlight,function(v)state.highlight=v;updateHighlights()end)
    button('Refresh highlights',updateHighlights)
    button('Clear highlights',function()state.highlight=false;updateHighlights();clear();tabs.Visuals()end)
    label('Highlights are local-only and do not change player roles, health, or server state.',55)
end
tabs.Voting=function()
    label('Map voting simulation (no server votes sent)',48)
    local options={'Map A','Map B','Map C'}
    for _,name in ipairs(options) do
        button('Simulate vote: '..name,function() label('Local test vote selected: '..name,35) end)
    end
end
tabs.Inventory=function()
    label('Client-visible inventory inspector',32)
    local function inspect()
        local backpack=player:FindFirstChildOfClass('Backpack')
        local found={}
        if backpack then for _,item in ipairs(backpack:GetChildren()) do if item:IsA('Tool') then table.insert(found,item.Name) end end end
        if player.Character then for _,item in ipairs(player.Character:GetChildren()) do if item:IsA('Tool') then table.insert(found,item.Name) end end end
        label(#found>0 and ('Visible tools: '..table.concat(found,', ')) or 'No local Tools currently visible.',65)
    end
    button('Inspect visible Tools',inspect)
    label('This reads locally replicated Tool names only; it does not access private inventories or trade items.',70)
end
tabs.Security=function()
    label('Security Lab — mock item-transfer validation',52)
    local dummy={owner='TestPlayer',item='MockGodly',count=1}
    button('Simulate unauthorized transfer',function()
        local requester='UnknownPlayer'
        local allowed=(requester==dummy.owner)
        label((allowed and 'Allowed' or 'BLOCKED')..': '..requester..' requested '..dummy.item..'. Owner remains '..dummy.owner..'.',75)
    end)
    button('Simulate authorized inventory read',function()
        label('Allowed: owner '..dummy.owner..' has '..dummy.count..' × '..dummy.item..'.',55)
    end)
    label('Dummy data only. No hidden trade, network call, or real item modification.',60)
end
tabs.Settings=function()
    label('Interface settings',30)
    button('Center window',function()frame.Position=UDim2.new(.5,-265,.5,-177)end)
    button('Remove all local highlights',function()state.highlight=false;updateHighlights()end)
    button('Unload VioletHub',function()gui:Destroy()end)
end
local order={'Home','Visuals','Voting','Inventory','Security','Settings'}
local function show(tab)clear();tabs[tab]()end
for i,tab in ipairs(order) do
    local b=new('TextButton',{LayoutOrder=i,Size=UDim2.new(1,0,0,34),BackgroundColor3=bg,TextColor3=light,Text=tab,TextSize=13,Font=Enum.Font.GothamBold},sidebar)
    new('UICorner',{CornerRadius=UDim.new(0,6)},b)
    b.MouseButton1Click:Connect(function()show(tab)end)
end
local dragging,dragStart,startPos=false,nil,nil
top.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true;dragStart=input.Position;startPos=frame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local d=input.Position-dragStart
        frame.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
close.MouseButton1Click:Connect(function()gui:Destroy()end)
Players.PlayerAdded:Connect(updateHighlights)
Players.PlayerRemoving:Connect(updateHighlights)
show('Home')
