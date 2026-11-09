-- Violet Hub | Functional client diagnostics
-- Local UI, ESP, FOV, crosshair, and replicated-object scanner.
local Players = game:GetService('Players')
local UIS = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local Workspace = game:GetService('Workspace')
local me = Players.LocalPlayer
if not me then return end
local pg = me:WaitForChild('PlayerGui', 10)
if not pg then warn('Violet Hub: PlayerGui unavailable') return end
local old = pg:FindFirstChild('VioletHubDiagnostics')
if old then old:Destroy() end
local gui = Instance.new('ScreenGui')
gui.Name='VioletHubDiagnostics'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.DisplayOrder=900; gui.Parent=pg
local function mk(class,parent,props)
 local x=Instance.new(class)
 for k,v in pairs(props or {}) do x[k]=v end
 x.Parent=parent; return x
end
local bg=Color3.fromRGB(17,13,27)
local panel=Color3.fromRGB(29,23,43)
local accent=Color3.fromRGB(164,93,255)
local muted=Color3.fromRGB(180,170,198)
local function round(o,r) mk('UICorner',o,{CornerRadius=UDim.new(0,r or 9)}) end
local function stroke(o,c) mk('UIStroke',o,{Color=c or Color3.fromRGB(70,52,93),Thickness=1}) end
local root=mk('Frame',gui,{Size=UDim2.fromOffset(700,440),Position=UDim2.new(.5,-350,.5,-220),BackgroundColor3=bg,BorderSizePixel=0,Active=true})
round(root,14); stroke(root,accent)
local title=mk('Frame',root,{Size=UDim2.new(1,0,0,54),BackgroundColor3=panel,BorderSizePixel=0,Active=true}); round(title,14)
mk('TextLabel',title,{Size=UDim2.new(1,-150,1,0),Position=UDim2.fromOffset(18,0),Text='VIOLET HUB   •   CLIENT DIAGNOSTICS',Font=Enum.Font.GothamBold,TextSize=16,TextColor3=Color3.new(1,1,1),TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1})
local function btn(parent,text,pos,size,callback)
 local b=mk('TextButton',parent,{Text=text,Size=size,Position=pos,Font=Enum.Font.GothamBold,TextSize=15,TextColor3=Color3.new(1,1,1),BackgroundColor3=Color3.fromRGB(70,47,102),BorderSizePixel=0,AutoButtonColor=true})
 round(b,8); b.MouseButton1Click:Connect(callback); return b
end
local reopen=btn(gui,'V',UDim2.fromOffset(18,190),UDim2.fromOffset(42,42),function() root.Visible=true end)
reopen.Visible=false
local function hide() root.Visible=false; reopen.Visible=true end
btn(title,'×',UDim2.new(1,-42,0,9),UDim2.fromOffset(32,32),hide)
btn(title,'–',UDim2.new(1,-80,0,9),UDim2.fromOffset(32,32),hide)
local drag=false; local dragStart; local startPos
local function beginDrag(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
  drag=true; dragStart=input.Position; startPos=root.Position
  input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then drag=false end end)
 end
end
title.InputBegan:Connect(beginDrag)
UIS.InputChanged:Connect(function(input)
 if drag and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
  local d=input.Position-dragStart
  root.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
 end
end)
local sidebar=mk('ScrollingFrame',root,{Position=UDim2.fromOffset(10,64),Size=UDim2.fromOffset(158,365),BackgroundColor3=panel,BorderSizePixel=0,ScrollBarThickness=3,CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y})
round(sidebar,10)
mk('UIListLayout',sidebar,{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
mk('UIPadding',sidebar,{PaddingTop=UDim.new(0,8),PaddingLeft=UDim.new(0,7),PaddingRight=UDim.new(0,7),PaddingBottom=UDim.new(0,8)})
local content=mk('ScrollingFrame',root,{Position=UDim2.fromOffset(180,64),Size=UDim2.new(1,-190,1,-75),BackgroundColor3=panel,BorderSizePixel=0,ScrollBarThickness=4,CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y})
round(content,10)
local layout=mk('UIListLayout',content,{Padding=UDim.new(0,9),SortOrder=Enum.SortOrder.LayoutOrder})
mk('UIPadding',content,{PaddingTop=UDim.new(0,13),PaddingLeft=UDim.new(0,14),PaddingRight=UDim.new(0,14),PaddingBottom=UDim.new(0,14)})
local active={}
local function clear()
 for _,v in ipairs(content:GetChildren()) do if v:IsA('GuiObject') then v:Destroy() end end
end
local function textline(s,sz,color)
 return mk('TextLabel',content,{Size=UDim2.new(1,-5,0,sz and 34 or 27),BackgroundTransparency=1,Text=s,TextColor3=color or muted,Font=sz and Enum.Font.GothamBold or Enum.Font.Gotham,TextSize=sz or 13,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true})
end
local function action(label,fn)
 local b=mk('TextButton',content,{Size=UDim2.new(1,-6,0,38),BackgroundColor3=Color3.fromRGB(65,43,97),Text=label,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamSemibold,TextSize=14,BorderSizePixel=0})
 round(b,8); b.MouseButton1Click:Connect(fn); return b
end
local function toggle(label,key,fn)
 local b=action('',function() active[key]=not active[key]; fn(active[key]); if b and b.Parent then b.Text=label..'  '..(active[key] and 'ON' or 'OFF') end end)
 b.Text=label..'  '..(active[key] and 'ON' or 'OFF')
 return b
end
local function slider(label,min,max,initial,callback)
 local v=initial
 local b=action(label..': '..tostring(v)..'  (click to increase)',function()
  v=v+5; if v>max then v=min end; callback(v); b.Text=label..': '..tostring(v)..'  (click to increase)'
 end)
end
local highlights={}
local function setESP(on)
 for _,h in pairs(highlights) do pcall(function() h:Destroy() end) end
 table.clear(highlights)
 if not on then return end
 for _,p in ipairs(Players:GetPlayers()) do
  if p~=me and p.Character then
   local h=Instance.new('Highlight'); h.Name='VioletLocalESP'; h.FillColor=accent; h.OutlineColor=Color3.new(1,1,1); h.FillTransparency=.7; h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop; h.Adornee=p.Character; h.Parent=gui
   highlights[p]=h
  end
 end
end
local crosshair=mk('TextLabel',gui,{Size=UDim2.fromOffset(34,34),Position=UDim2.new(.5,-17,.5,-17),BackgroundTransparency=1,Text='+',Font=Enum.Font.GothamBold,TextSize=28,TextColor3=accent,Visible=false})
local tabs={}
local function page(name)
 clear(); textline(name,19,Color3.new(1,1,1))
 if name=='Home' then
  textline('Functional local diagnostics and visuals for Roblox experiences.')
  textline('This build does not automate combat, fling players, or collect rewards.')
  textline('Use the left sidebar to explore the tools.')
 elseif name=='Combat' then
  textline('Weapon diagnostics')
  action('Inspect equipped tool',function()
   local char=me.Character; local t=char and char:FindFirstChildOfClass('Tool'); textline('Equipped: '..(t and t.Name or 'None'))
  end)
  action('Inspect backpack',function()
   local bag=me:FindFirstChildOfClass('Backpack'); local names={}
   if bag then for _,t in ipairs(bag:GetChildren()) do if t:IsA('Tool') then table.insert(names,t.Name) end end end
   textline('Backpack: '..(#names>0 and table.concat(names,', ') or 'No tools'))
  end)
  textline('Attack automation and player-targeting controls are not included.')
 elseif name=='ESP' then
  toggle('Player highlights','esp',setESP)
  action('Refresh highlights',function() setESP(active.esp) end)
  textline('Highlights are client-side visual overlays only.')
 elseif name=='Visuals' then
  toggle('Crosshair','cross',function(v) crosshair.Visible=v end)
  slider('Camera FOV',50,110,70,function(v) if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView=v end end)
  action('Reset camera FOV',function() if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView=70 end end)
 elseif name=='Players' then
  action('Refresh player list',function()
   local names={}; for _,p in ipairs(Players:GetPlayers()) do table.insert(names,p.DisplayName..' (@'..p.Name..')') end
   textline(table.concat(names,'\n'))
  end)
  textline('Connected: '..tostring(#Players:GetPlayers()))
 elseif name=='Teleports' then
  action('Read my coordinates',function()
   local c=me.Character; local part=c and c:FindFirstChild('HumanoidRootPart')
   textline(part and tostring(part.Position) or 'Character not loaded')
  end)
  textline('Teleportation to other players is not included.')
 elseif name=='Autofarm' then
  action('Scan visible coin-like objects',function()
   local n=0
   for _,o in ipairs(Workspace:GetDescendants()) do if o.Name:lower():find('coin',1,true) then n=n+1 end end
   textline('Replicated coin-name matches: '..n)
  end)
  action('Scan dropped gun objects',function()
   local n=0
   for _,o in ipairs(Workspace:GetDescendants()) do if o.Name:lower():find('gun',1,true) then n=n+1 end end
   textline('Replicated gun-name matches: '..n)
  end)
  textline('Scanners inspect replicated names; they do not collect items.')
 elseif name=='Survival' then
  action('Inspect character health',function()
   local c=me.Character; local h=c and c:FindFirstChildOfClass('Humanoid')
   textline(h and ('Health: '..math.floor(h.Health)..' / '..math.floor(h.MaxHealth)) or 'Humanoid unavailable')
  end)
 elseif name=='Boxes' then
  action('Inspect inventory tools',function()
   local bag=me:FindFirstChildOfClass('Backpack'); textline('Backpack entries: '..tostring(bag and #bag:GetChildren() or 0))
  end)
 elseif name=='Servers' then
  textline('Place ID: '..tostring(game.PlaceId))
  textline('Server ID: '..tostring(game.JobId))
  textline('Player count: '..tostring(#Players:GetPlayers()))
 elseif name=='Settings' then
  action('Recenter window',function() root.Position=UDim2.new(.5,-350,.5,-220) end)
  action('Hide window',hide)
  textline('Right Shift toggles window visibility.')
 end
end
for _,name in ipairs({'Home','Combat','ESP','Visuals','Players','Teleports','Autofarm','Survival','Boxes','Servers','Settings'}) do
 local b=mk('TextButton',sidebar,{Size=UDim2.new(1,-2,0,34),BackgroundColor3=Color3.fromRGB(48,35,70),Text=name,TextColor3=Color3.new(1,1,1),Font=Enum.Font.GothamSemibold,TextSize=13,BorderSizePixel=0})
 round(b,7); b.MouseButton1Click:Connect(function() page(name) end)
end
UIS.InputBegan:Connect(function(input,processed)
 if not processed and input.KeyCode==Enum.KeyCode.RightShift then root.Visible=not root.Visible; reopen.Visible=not root.Visible end
end)
Players.PlayerAdded:Connect(function() if active.esp then task.defer(function() setESP(true) end) end end)
Players.PlayerRemoving:Connect(function() if active.esp then task.defer(function() setESP(true) end) end end)
page('Home')
print('Violet Hub client diagnostics loaded')
