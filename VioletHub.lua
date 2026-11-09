-- Violet Hub v10 | Client-side QA and visual tools
-- No combat exploitation, reward automation, or remote-event abuse.
local Players = game:GetService('Players')
local UIS = game:GetService('UserInputService')
local Tween = game:GetService('TweenService')
local Lighting = game:GetService('Lighting')
local RunService = game:GetService('RunService')
local Workspace = game:GetService('Workspace')
local LP = Players.LocalPlayer
if not LP then warn('Violet Hub: LocalPlayer unavailable'); return end
local pg = LP:WaitForChild('PlayerGui',10)
if not pg then warn('Violet Hub: PlayerGui unavailable'); return end
local old=pg:FindFirstChild('VioletHubV10')
if old then old:Destroy() end
local C={bg=Color3.fromRGB(10,9,16),panel=Color3.fromRGB(23,21,30),field=Color3.fromRGB(33,30,43),accent=Color3.fromRGB(215,29,112),text=Color3.fromRGB(245,241,250),muted=Color3.fromRGB(166,160,176)}
local gui=Instance.new('ScreenGui'); gui.Name='VioletHubV10'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.DisplayOrder=900; gui.Parent=pg
local state={esp=false,names=false,gun=false,coins=false,crosshair=false,fps=false,watermark=false,darken=false,blur=false,bloom=false,rays=false,cc=false,ambient=false,fullbright=false,rolecolors=false,menu=true,autoSave=false}
local conns,highlights,markers={}, {}, {}
local original={brightness=Lighting.Brightness,ambient=Lighting.Ambient,outdoor=Lighting.OutdoorAmbient,clock=Lighting.ClockTime,fov=70}
local function obj(typ,props,parent)
 local o=Instance.new(typ)
 for k,v in pairs(props or {}) do o[k]=v end
 o.Parent=parent
 return o
end
local function corner(p,r) obj('UICorner',{CornerRadius=UDim.new(0,r or 8)},p) end
local function label(p,t,h,bold,color)
 return obj('TextLabel',{Size=UDim2.new(1,0,0,h or 25),BackgroundTransparency=1,Text=t,TextColor3=color or C.text,Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true},p)
end
local function button(p,t,fn,h)
 local b=obj('TextButton',{Size=UDim2.new(1,0,0,h or 32),BackgroundColor3=C.field,Text=t,TextColor3=C.text,Font=Enum.Font.GothamBold,TextSize=13,AutoButtonColor=true},p);corner(b,7)
 b.MouseButton1Click:Connect(function() local ok,e=pcall(fn);if not ok then warn('Violet Hub action:',e) end end)
 return b
end
local function stack(p,gap)
 return obj('UIListLayout',{Padding=UDim.new(0,gap or 7),SortOrder=Enum.SortOrder.LayoutOrder},p)
end
local function pad(p,n) obj('UIPadding',{PaddingLeft=UDim.new(0,n),PaddingRight=UDim.new(0,n),PaddingTop=UDim.new(0,n),PaddingBottom=UDim.new(0,n)},p) end
local main=obj('Frame',{Size=UDim2.fromOffset(900,580),Position=UDim2.new(.5,-450,.5,-290),BackgroundColor3=C.bg,BorderSizePixel=0,ClipsDescendants=true},gui);corner(main,13)
local stroke=obj('UIStroke',{Color=C.accent,Thickness=1,Transparency=.35},main)
local scale=obj('UIScale',{Scale=1},main)
local bar=obj('Frame',{Size=UDim2.new(1,0,0,52),BackgroundColor3=C.panel,BorderSizePixel=0},main)
label(bar,'  ◆  VIOLET HUB   /   CLIENT QA',50,true)
local close=obj('TextButton',{Size=UDim2.fromOffset(35,30),Position=UDim2.new(1,-42,0,11),Text='×',TextSize=24,Font=Enum.Font.GothamBold,TextColor3=C.text,BackgroundColor3=C.field},bar);corner(close)
local mini=obj('TextButton',{Size=UDim2.fromOffset(35,30),Position=UDim2.new(1,-82,0,11),Text='–',TextSize=24,Font=Enum.Font.GothamBold,TextColor3=C.text,BackgroundColor3=C.field},bar);corner(mini)
local floating=obj('TextButton',{Size=UDim2.fromOffset(55,55),Position=UDim2.new(0,20,.5,-27),Text='◆',TextSize=27,TextColor3=C.text,BackgroundColor3=C.accent,Visible=false},gui);corner(floating,15)
local sidebar=obj('ScrollingFrame',{Size=UDim2.new(0,172,1,-52),Position=UDim2.fromOffset(0,52),BackgroundColor3=C.panel,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new()},main);pad(sidebar,9);stack(sidebar,6)
local area=obj('Frame',{Size=UDim2.new(1,-172,1,-52),Position=UDim2.fromOffset(172,52),BackgroundTransparency=1},main)
local heading=obj('TextLabel',{Size=UDim2.new(1,-30,0,42),Position=UDim2.fromOffset(16,0),Text='HOME',TextXAlignment=Enum.TextXAlignment.Left,BackgroundTransparency=1,TextColor3=C.text,Font=Enum.Font.GothamBold,TextSize=21},area)
local search=obj('TextBox',{Size=UDim2.new(1,-32,0,35),Position=UDim2.fromOffset(16,42),Text='',PlaceholderText='Search settings in this tab...',ClearTextOnFocus=false,BackgroundColor3=C.field,TextColor3=C.text,PlaceholderColor3=C.muted,Font=Enum.Font.Gotham,TextSize=13},area);corner(search)
local pages=obj('ScrollingFrame',{Size=UDim2.new(1,-32,1,-96),Position=UDim2.fromOffset(16,87),BackgroundTransparency=1,ScrollBarThickness=4,ScrollBarImageColor3=C.accent,CanvasSize=UDim2.new()},area)
local layout=obj('UIListLayout',{Padding=UDim.new(0,10),SortOrder=Enum.SortOrder.LayoutOrder},pages)
layout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()pages.CanvasSize=UDim2.fromOffset(0,layout.AbsoluteContentSize.Y+20)end)
local function clearPage() for _,v in ipairs(pages:GetChildren()) do if v:IsA('GuiObject') then v:Destroy() end end end
local function section(name)
 local outer=obj('Frame',{Size=UDim2.new(1,-7,0,40),BackgroundColor3=C.panel,AutomaticSize=Enum.AutomaticSize.Y},pages);corner(outer,9)
 local holder=obj('Frame',{Size=UDim2.new(1,-24,0,0),Position=UDim2.fromOffset(12,43),BackgroundTransparency=1,AutomaticSize=Enum.AutomaticSize.Y},outer)
 local sl=stack(holder,7)
 local header=obj('TextButton',{Size=UDim2.new(1,-24,0,35),Position=UDim2.fromOffset(12,4),BackgroundTransparency=1,Text=name..'   ▾',TextColor3=C.text,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,TextSize=14},outer)
 local open=true
 local function resize()outer.Size=UDim2.new(1,-7,0,open and (sl.AbsoluteContentSize.Y+55) or 43)end
 sl:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(resize)
 header.MouseButton1Click:Connect(function()open=not open;holder.Visible=open;header.Text=name..(open and '   ▾' or '   ▸');resize()end)
 task.defer(resize)
 return holder
end
local function info(p,text)label(p,text,37,false,C.muted)end
local function toggle(p,text,key,callback)
 local row=obj('Frame',{Size=UDim2.new(1,0,0,34),BackgroundTransparency=1},p)
 local t=label(row,text,34,false)
 t.Size=UDim2.new(1,-85,1,0)
 local b=obj('TextButton',{Size=UDim2.fromOffset(66,28),Position=UDim2.new(1,-66,0,3),BackgroundColor3=C.field,Text='',AutoButtonColor=false},row);corner(b,14)
 local dot=obj('Frame',{Size=UDim2.fromOffset(22,22),Position=UDim2.fromOffset(4,3),BackgroundColor3=C.muted},b);corner(dot,11)
 local function render()local on=state[key];b.BackgroundColor3=on and C.accent or C.field;Tween:Create(dot,TweenInfo.new(.13),{Position=UDim2.fromOffset(on and 40 or 4,3)}):Play()end
 b.MouseButton1Click:Connect(function()state[key]=not state[key];render();if callback then local ok,e=pcall(callback,state[key]);if not ok then warn(e) end end end)
 render();return row
end
local function slider(p,text,min,max,initial,callback)
 local value=initial
 local box=obj('Frame',{Size=UDim2.new(1,0,0,58),BackgroundTransparency=1},p)
 local name=label(box,text..': '..tostring(value),24,true)
 local track=obj('TextButton',{Size=UDim2.new(1,0,0,13),Position=UDim2.fromOffset(0,34),Text='',BackgroundColor3=C.field,AutoButtonColor=false},box);corner(track,7)
 local fill=obj('Frame',{Size=UDim2.new((value-min)/(max-min),0,1,0),BackgroundColor3=C.accent},track);corner(fill,7)
 local dragging=false
 local function set(x)
  local fraction=math.clamp((x-track.AbsolutePosition.X)/math.max(1,track.AbsoluteSize.X),0,1)
  value=math.floor((min+(max-min)*fraction)*10+.5)/10
  name.Text=text..': '..tostring(value);fill.Size=UDim2.new(fraction,0,1,0)
  if callback then pcall(callback,value) end
 end
 track.MouseButton1Down:Connect(function(x)dragging=true;set(x)end)
 table.insert(conns,UIS.InputChanged:Connect(function(i)if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then set(i.Position.X)end end))
 table.insert(conns,UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end))
 return box
end
local function dropdown(p,text,options,callback)
 label(p,text,24,true)
 local idx=1
 button(p,options[idx]..'  ▸',function()
  idx=idx%#options+1
  local parent=p
  for _,ch in ipairs(parent:GetChildren()) do if ch:IsA('TextButton') and ch:GetAttribute('Drop_'..text) then ch.Text=options[idx]..'  ▸' end end
  if callback then callback(options[idx]) end
 end):SetAttribute('Drop_'..text,true)
end
local function unavailable(p,text)
 local b=button(p,text..'  ·  developer server required',function()warn('Violet Hub: '..text..' requires developer-authorized server testing APIs')end)
 b.TextColor3=C.muted
end
local function clearHighlights()
 for _,h in pairs(highlights) do pcall(function()h:Destroy()end)end;table.clear(highlights)
end
local function refreshESP()
 clearHighlights()
 if not state.esp then return end
 for _,pl in ipairs(Players:GetPlayers()) do
  if pl~=LP and pl.Character then
   local h=obj('Highlight',{Name='VioletDebugHighlight',Adornee=pl.Character,FillTransparency=.85,OutlineTransparency=0,OutlineColor=C.accent,FillColor=C.accent,DepthMode=Enum.HighlightDepthMode.Occluded},gui)
   highlights[pl]=h
  end
 end
end
local function clearMarkers()for _,v in ipairs(markers) do pcall(function()v:Destroy()end)end;table.clear(markers)end
local function scan(name,show)
 local count=0;clearMarkers()
 for _,v in ipairs(Workspace:GetDescendants()) do
  if count>=100 then break end
  if v:IsA('BasePart') and string.find(v.Name:lower(),name,1,true) then
   count=count+1
   if show then local bb=obj('BillboardGui',{Size=UDim2.fromOffset(90,25),AlwaysOnTop=false,StudsOffset=Vector3.new(0,2,0),Adornee=v},gui)
    local tx=label(bb,name:upper(),25,true,C.accent);tx.TextXAlignment=Enum.TextXAlignment.Center;table.insert(markers,bb)end
  end
 end
 return count
end
local cross=obj('TextLabel',{Size=UDim2.fromOffset(36,36),Position=UDim2.new(.5,-18,.5,-18),BackgroundTransparency=1,Text='+',Font=Enum.Font.GothamBold,TextSize=27,TextColor3=C.accent,Visible=false},gui)
local watermark=obj('TextLabel',{Size=UDim2.fromOffset(200,24),Position=UDim2.new(1,-210,0,12),BackgroundTransparency=1,Text='VIOLET HUB · QA',Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.accent,Visible=false},gui)
local fpsLabel=obj('TextLabel',{Size=UDim2.fromOffset(110,24),Position=UDim2.new(1,-120,0,40),BackgroundTransparency=1,Text='FPS: --',Font=Enum.Font.GothamBold,TextSize=13,TextColor3=C.text,Visible=false},gui)
local function effect(class,name,on)
 local e=Lighting:FindFirstChild('Violet_'..name)
 if not e and on then e=obj(class,{Name='Violet_'..name},Lighting)end
 if e then e.Enabled=on end
end
local pagespec={}
pagespec.Home=function()
 local p=section('Welcome');info(p,'Violet Hub v10 · local visual tools and authorized QA diagnostics');button(p,'Refresh player highlights',refreshESP)
 local q=section('Live session');info(q,'Place ID: '..tostring(game.PlaceId));info(q,'Job ID: '..tostring(game.JobId));info(q,'Players: '..#Players:GetPlayers())
end
pagespec.Combat=function()
 local p=section('sheriff');info(p,'Weapon and dropped-gun inspection works locally. Combat actions require developer server support.')
 button(p,'Inspect equipped tools',function()local ch=LP.Character;local a={};if ch then for _,v in ipairs(ch:GetChildren())do if v:IsA('Tool')then table.insert(a,v.Name)end end end;warn('Equipped tools: '..(#a>0 and table.concat(a,', ') or 'none'))end)
 button(p,'Scan dropped guns',function()warn('Gun-like parts found: '..scan('gun',state.gun))end)
 unavailable(p,'Auto Kill Murderer');unavailable(p,'Auto Shoot Murderer');unavailable(p,'Auto Grab Drop Gun');unavailable(p,'Wallbang')
 local m=section('murderer');unavailable(m,'Knife Kill All');unavailable(m,'Silent Throw');unavailable(m,'Kill Selected');unavailable(m,'Kill Sheriff')
 slider(m,'Reach visualization (studs)',2,30,15,function(v)state.reach=v end)
 slider(m,'Equip timing test (s)',0,3,1.1,function(v)state.delay=v end)
 slider(m,'Hitbox display scale',1,10,1,function(v)state.hitbox=v end)
 local a=section('aim diagnostics');toggle(a,'Crosshair visualizer','crosshair',function(v)cross.Visible=v end)
 slider(a,'Camera FOV',40,110,70,function(v)if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView=v end end)
 unavailable(a,'Silent Aim');unavailable(a,'Camera Aimbot')
 local f=section('physics diagnostics');info(f,'Use controlled test dummies and server-side physics logging for knockback tests.');unavailable(f,'Fling Player');unavailable(f,'Fling All')
end
pagespec.Farm=function()
 local p=section('coins');button(p,'Scan coin objects',function()warn('Coin-like parts found: '..scan('coin',state.coins))end)
 toggle(p,'Show coin markers','coins',function(v)if v then scan('coin',true)else clearMarkers()end end)
 slider(p,'Route preview speed',1,50,16,function(v)state.routeSpeed=v end)
 slider(p,'Route preview height',0,20,5,function(v)state.routeHeight=v end)
 slider(p,'Route preview delay',0,5,0,function(v)state.routeDelay=v end)
 dropdown(p,'Route preview mode',{'Tween','Instant','Waypoints'},function(v)state.routeMode=v end)
 unavailable(p,'Coin Farm');unavailable(p,'Auto Collect Rewards');unavailable(p,'Coin Hitbox Modification')
 local m=section('map vote');info(m,'Map vote testing requires server-authorized voting APIs.');unavailable(m,'Auto Vote Map');unavailable(m,'Vote Duplication')
 local b=section('boxes / prestige');unavailable(b,'Auto Open Boxes');unavailable(b,'Auto Prestige')
end
pagespec.HUD=function()
 local p=section('hud buttons');toggle(p,'Show Crosshair','crosshair',function(v)cross.Visible=v end)
 toggle(p,'Show Watermark','watermark',function(v)watermark.Visible=v end)
 slider(p,'Crosshair size',14,65,36,function(v)cross.Size=UDim2.fromOffset(v,v);cross.Position=UDim2.new(.5,-v/2,.5,-v/2);cross.TextSize=v*.75 end)
 local q=section('keybinds');info(q,'Right Shift toggles Violet Hub.');info(q,'All combat keybinds require authorized server testing actions.')
end
pagespec.ESP=function()
 local p=section('player esp');toggle(p,'Enabled','esp',function()refreshESP()end)
 toggle(p,'Show name labels (Roblox nameplates)','names',function(v)for _,pl in ipairs(Players:GetPlayers())do if pl.Character then local h=pl.Character:FindFirstChildOfClass('Humanoid');if h then h.DisplayDistanceType=v and Enum.HumanoidDisplayDistanceType.Viewer or Enum.HumanoidDisplayDistanceType.None end end end end)
 button(p,'Refresh player outlines',refreshESP)
 local q=section('object markers');toggle(q,'Dropped Gun ESP','gun',function(v)if v then scan('gun',true)else clearMarkers()end end)
 toggle(q,'Coin Object Markers','coins',function(v)if v then scan('coin',true)else clearMarkers()end end)
 local r=section('role information');info(r,'Roles cannot be reliably inferred from public client data. Connect your own authorized role-state API for exact roles.')
end
pagespec.Visuals=function()
 local p=section('lighting / world');toggle(p,'Lighting Override','fullbright',function(v)Lighting.Brightness=v and 3 or original.brightness;Lighting.ClockTime=v and 14 or original.clock;Lighting.Ambient=v and Color3.fromRGB(180,180,180) or original.ambient end)
 toggle(p,'Motion Blur','blur',function(v)effect('BlurEffect','Blur',v);local e=Lighting:FindFirstChild('Violet_Blur');if e then e.Size=10 end end)
 toggle(p,'Bloom','bloom',function(v)effect('BloomEffect','Bloom',v)end)
 toggle(p,'Sun Rays','rays',function(v)effect('SunRaysEffect','Rays',v)end)
 toggle(p,'Color Correction','cc',function(v)effect('ColorCorrectionEffect','CC',v)end)
 local q=section('camera');slider(q,'Field of View',40,110,70,function(v)if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView=v end end)
 toggle(q,'Crosshair','crosshair',function(v)cross.Visible=v end)
 local r=section('skybox / weather');info(r,'Custom skybox and weather assets need approved asset IDs from your experience.');info(r,'No external assets are loaded automatically.')
end
pagespec.Players=function()
 local p=section('player information');button(p,'List players in output',function()for _,pl in ipairs(Players:GetPlayers())do warn(pl.DisplayName..' (@'..pl.Name..')')end end)
 button(p,'Inspect local character',function()local c=LP.Character;local h=c and c:FindFirstChildOfClass('Humanoid');warn('Character:',c and c.Name or 'none','Health:',h and h.Health or 'none')end)
 local q=section('performance');toggle(q,'FPS counter','fps',function(v)fpsLabel.Visible=v end)
 toggle(q,'Hide 3D rendering locally','render',function(v)pcall(function()RunService:Set3dRenderingEnabled(not v)end)end)
 local r=section('movement testing');info(r,'WalkSpeed, fly, noclip, and movement bypass tests need developer-approved character controls.')
end
pagespec.Servers=function()
 local p=section('server');info(p,'Place ID: '..tostring(game.PlaceId));info(p,'Game ID: '..tostring(game.GameId));info(p,'Job ID: '..tostring(game.JobId));info(p,'Players: '..#Players:GetPlayers())
 button(p,'Refresh player count',function()warn('Players:',#Players:GetPlayers())end)
 local q=section('teleports');info(q,'Teleport destinations require server-authorized map waypoints.');info(q,'Current position: use Players → Inspect local character.')
 local r=section('roles');info(r,'Sheriff: unavailable without authorized role data');info(r,'Murderer: unavailable without authorized role data');info(r,'Hero: unavailable without authorized role data')
end
pagespec.Settings=function()
 local p=section('general');button(p,'Unload Violet Hub',function()clearHighlights();clearMarkers();for _,c in ipairs(conns)do pcall(function()c:Disconnect()end)end;gui:Destroy()end)
 button(p,'Reset window position',function()main.Position=UDim2.new(.5,-450,.5,-290)end)
 slider(p,'Menu scale',.6,1.2,1,function(v)scale.Scale=v end)
 toggle(p,'Show menu button','menu',function(v)floating.Visible=v and not main.Visible end)
 toggle(p,'Show watermark','watermark',function(v)watermark.Visible=v end)
 local a=section('appearance');slider(a,'Background transparency',0,.65,0,function(v)main.BackgroundTransparency=v end)
 slider(a,'Fade speed (seconds)',.05,.6,.2,function(v)state.fade=v end)
 dropdown(a,'Theme preset',{'Violet','Rose','Blue'},function(v)C.accent=(v=='Blue' and Color3.fromRGB(70,120,240))or(v=='Rose' and Color3.fromRGB(235,70,125))or Color3.fromRGB(215,29,112);stroke.Color=C.accent;floating.BackgroundColor3=C.accent end)
 local b=section('configs');info(b,'Session settings only. Persistent config files require a trusted, supported storage system.');button(b,'Print current config to output',function()for k,v in pairs(state)do warn(k,v)end end)
end
local tabs={'Home','Combat','Farm','HUD','ESP','Visuals','Players','Servers','Settings'}
local tabButtons={}
local current='Home'
local function show(tab)
 current=tab;heading.Text=tab:upper();clearPage();pagespec[tab]()
 for n,b in pairs(tabButtons)do b.BackgroundColor3=n==tab and C.accent or C.field end
 pages.CanvasPosition=Vector2.zero
end
for _,name in ipairs(tabs)do
 local b=button(sidebar,name,function()show(name)end,39)
 tabButtons[name]=b
end
local function visibility(v)
 if v then main.Visible=true;floating.Visible=false;main.BackgroundTransparency=1;Tween:Create(main,TweenInfo.new(state.fade or .2),{BackgroundTransparency=0}):Play()
 else main.Visible=false;floating.Visible=state.menu end
end
close.MouseButton1Click:Connect(function()visibility(false)end)
mini.MouseButton1Click:Connect(function()visibility(false)end)
floating.MouseButton1Click:Connect(function()visibility(true)end)
local dragging=false,startPos,startInput
bar.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true;startInput=i.Position;startPos=main.Position end end)
table.insert(conns,UIS.InputChanged:Connect(function(i)if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local d=i.Position-startInput;main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)end end))
table.insert(conns,UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end))
table.insert(conns,UIS.InputBegan:Connect(function(i,gp)if not gp and i.KeyCode==Enum.KeyCode.RightShift then visibility(not main.Visible)end end))
search:GetPropertyChangedSignal('Text'):Connect(function()
 local query=search.Text:lower()
 for _,v in ipairs(pages:GetChildren())do if v:IsA('Frame')then
  if query=='' then v.Visible=true else
   local found=false
   for _,x in ipairs(v:GetDescendants())do if (x:IsA('TextLabel') or x:IsA('TextButton')) and x.Text:lower():find(query,1,true)then found=true;break end end
   v.Visible=found
  end
 end end
end)
local frames,elapsed=0,0
table.insert(conns,RunService.RenderStepped:Connect(function(dt)
 frames=frames+1;elapsed=elapsed+dt
 if elapsed>=.75 then if state.fps then fpsLabel.Text='FPS: '..math.floor(frames/elapsed+.5)end;frames=0;elapsed=0 end
end))
table.insert(conns,Players.PlayerAdded:Connect(function()task.delay(1,refreshESP)end))
table.insert(conns,Players.PlayerRemoving:Connect(function()task.delay(.1,refreshESP)end))
show('Home')
print('Violet Hub v10 loaded. Right Shift toggles menu.')
