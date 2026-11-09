-- Violet Hub v7 | Visual UI + authorized local testing controls
-- No remote combat, player manipulation, or reward automation.
local Players = game:GetService('Players')
local TweenService = game:GetService('TweenService')
local UIS = game:GetService('UserInputService')
local RunService = game:GetService('RunService')
local player = Players.LocalPlayer
if not player then return end
local parent = player:WaitForChild('PlayerGui', 10)
if not parent then return end
local old = parent:FindFirstChild('VioletHubV7')
if old then old:Destroy() end
local gui = Instance.new('ScreenGui')
gui.Name='VioletHubV7'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.DisplayOrder=9999; gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; gui.Parent=parent
local C={bg=Color3.fromRGB(12,10,18),panel=Color3.fromRGB(23,21,30),card=Color3.fromRGB(28,25,36),line=Color3.fromRGB(51,43,64),txt=Color3.fromRGB(240,237,245),muted=Color3.fromRGB(163,157,173),pink=Color3.fromRGB(220,35,122),purple=Color3.fromRGB(151,69,247),off=Color3.fromRGB(47,43,56)}
local function mk(class,props,parentObj)
 local o=Instance.new(class)
 for k,v in pairs(props or {}) do o[k]=v end
 o.Parent=parentObj
 return o
end
local function corner(o,r) mk('UICorner',{CornerRadius=UDim.new(0,r or 9)},o) end
local function stroke(o,col,th) mk('UIStroke',{Color=col or C.line,Thickness=th or 1},o) end
local function tw(o,p,t) local x=TweenService:Create(o,TweenInfo.new(t or .19,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),p);x:Play();return x end
local function textlabel(parentObj,str,size,color,bold)
 return mk('TextLabel',{BackgroundTransparency=1,Text=str,TextColor3=color or C.txt,Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,TextSize=size or 14,TextXAlignment=Enum.TextXAlignment.Left,TextYAlignment=Enum.TextYAlignment.Center},parentObj)
end
local main=mk('Frame',{Name='Window',Size=UDim2.fromOffset(930,565),Position=UDim2.new(.5,-465,.5,-282),BackgroundColor3=C.bg,BorderSizePixel=0,ClipsDescendants=true},gui)
corner(main,15);stroke(main,C.purple,1)
local scale=mk('UIScale',{Scale=1},main)
local header=mk('Frame',{Size=UDim2.new(1,0,0,57),BackgroundColor3=C.panel,BorderSizePixel=0},main)
local headTitle=textlabel(header,'◆  VIOLET HUB',20,C.txt,true);headTitle.Position=UDim2.fromOffset(18,0);headTitle.Size=UDim2.new(1,-175,1,0)
local subtitle=textlabel(header,'v7  •  UI + testing controls',11,C.muted);subtitle.Position=UDim2.new(0,196,0,0);subtitle.Size=UDim2.fromOffset(225,57)
local function topButton(str,x)
 local b=mk('TextButton',{Text=str,TextColor3=C.txt,Font=Enum.Font.GothamBold,TextSize=19,Size=UDim2.fromOffset(34,30),Position=UDim2.new(1,x,0,13),BackgroundColor3=C.card,AutoButtonColor=false},header)
 corner(b,7);return b
end
local mini=topButton('−',-83);local close=topButton('×',-44)
local sidebar=mk('Frame',{Size=UDim2.new(0,174,1,-57),Position=UDim2.fromOffset(0,57),BackgroundColor3=C.panel,BorderSizePixel=0},main)
local nav=mk('ScrollingFrame',{Size=UDim2.new(1,-14,1,-20),Position=UDim2.fromOffset(7,10),CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ScrollBarThickness=3,BackgroundTransparency=1,BorderSizePixel=0},sidebar)
mk('UIListLayout',{Padding=UDim.new(0,7),SortOrder=Enum.SortOrder.LayoutOrder},nav)
local content=mk('Frame',{Size=UDim2.new(1,-174,1,-57),Position=UDim2.fromOffset(174,57),BackgroundTransparency=1},main)
local toast=textlabel(main,'',12,C.txt);toast.Size=UDim2.fromOffset(460,26);toast.Position=UDim2.new(.5,-230,1,-34);toast.BackgroundColor3=C.card;toast.BackgroundTransparency=.06;toast.TextXAlignment=Enum.TextXAlignment.Center;toast.Visible=false;corner(toast,8)
local toastSerial=0
local function notify(s)
 toastSerial=toastSerial+1; local n=toastSerial;toast.Text=s;toast.Visible=true
 task.delay(2.4,function() if n==toastSerial and toast.Parent then toast.Visible=false end end)
end
local open=true;local busy=false
local launcher=mk('TextButton',{Text='◆',TextColor3=C.txt,Font=Enum.Font.GothamBold,TextSize=23,BackgroundColor3=C.purple,Size=UDim2.fromOffset(48,48),Position=UDim2.new(0,20,.5,-24),Visible=false,AutoButtonColor=false},gui)
corner(launcher,14)
local function show(v)
 if busy then return end
 busy=true
 if v then
  launcher.Visible=false;main.Visible=true;scale.Scale=.93;main.BackgroundTransparency=1
  tw(scale,{Scale=1},.23);tw(main,{BackgroundTransparency=0},.23)
  task.delay(.24,function()busy=false end)
 else
  tw(scale,{Scale=.93},.18);tw(main,{BackgroundTransparency=1},.18)
  task.delay(.19,function() if main.Parent then main.Visible=false;launcher.Visible=true end;busy=false end)
 end
 open=v
end
mini.MouseButton1Click:Connect(function()show(false)end)
close.MouseButton1Click:Connect(function()show(false)end)
launcher.MouseButton1Click:Connect(function()show(true)end)
UIS.InputBegan:Connect(function(i,processed)
 if not processed and i.KeyCode==Enum.KeyCode.RightShift then show(not open) end
end)
-- Dragging from title bar
local dragging=false;local dragStart;local startPos
header.InputBegan:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
  dragging=true;dragStart=i.Position;startPos=main.Position
 end
end)
UIS.InputEnded:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)
UIS.InputChanged:Connect(function(i)
 if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
  local d=i.Position-dragStart
  main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
 end
end)
local tabs={};local navButtons={};local active
local function newTab(name)
 local page=mk('ScrollingFrame',{Name=name,Size=UDim2.new(1,-22,1,-20),Position=UDim2.fromOffset(11,10),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,ScrollBarImageColor3=C.purple,CanvasSize=UDim2.fromOffset(0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,Visible=false},content)
 local list=mk('UIListLayout',{Padding=UDim.new(0,12),SortOrder=Enum.SortOrder.LayoutOrder},page)
 tabs[name]=page
 local b=mk('TextButton',{Size=UDim2.new(1,-5,0,37),Text='   '..name,TextXAlignment=Enum.TextXAlignment.Left,TextColor3=C.muted,Font=Enum.Font.GothamMedium,TextSize=14,BackgroundColor3=C.panel,AutoButtonColor=false},nav)
 corner(b,8);navButtons[name]=b
 b.MouseButton1Click:Connect(function()
  if active then tabs[active].Visible=false;navButtons[active].BackgroundColor3=C.panel;navButtons[active].TextColor3=C.muted end
  active=name;page.Visible=true;b.BackgroundColor3=C.purple;b.TextColor3=C.txt
 end)
 return page
end
local function columns(page)
 local row=mk('Frame',{Size=UDim2.new(1,-6,0,10),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},page)
 local layout=mk('UIListLayout',{FillDirection=Enum.FillDirection.Horizontal,Padding=UDim.new(0,12),SortOrder=Enum.SortOrder.LayoutOrder},row)
 local a=mk('Frame',{Size=UDim2.new(.5,-6,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},row)
 local b=mk('Frame',{Size=UDim2.new(.5,-6,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},row)
 mk('UIListLayout',{Padding=UDim.new(0,12),SortOrder=Enum.SortOrder.LayoutOrder},a)
 mk('UIListLayout',{Padding=UDim.new(0,12),SortOrder=Enum.SortOrder.LayoutOrder},b)
 return a,b
end
local function section(parentObj,name)
 local outer=mk('Frame',{Size=UDim2.new(1,0,0,48),AutomaticSize=Enum.AutomaticSize.Y,BackgroundColor3=C.panel,BorderSizePixel=0},parentObj);corner(outer,10)
 local lay=mk('UIListLayout',{Padding=UDim.new(0,0),SortOrder=Enum.SortOrder.LayoutOrder},outer)
 local title=mk('TextButton',{Text=name..'     ▾',TextColor3=C.txt,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamMedium,TextSize=16,Size=UDim2.new(1,-24,0,48),Position=UDim2.fromOffset(12,0),BackgroundTransparency=1,AutoButtonColor=false},outer)
 local wrap=mk('Frame',{Size=UDim2.new(1,-24,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1},outer)
 local list=mk('UIListLayout',{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},wrap)
 local pad=mk('UIPadding',{PaddingLeft=UDim.new(0,12),PaddingRight=UDim.new(0,12),PaddingBottom=UDim.new(0,12)},wrap)
 title.MouseButton1Click:Connect(function()wrap.Visible=not wrap.Visible;title.Text=name..(wrap.Visible and '     ▾' or '     ▸')end)
 return wrap
end
local function toggle(parentObj,name,enabled,callback)
 local row=mk('Frame',{Size=UDim2.new(1,0,0,37),BackgroundTransparency=1},parentObj)
 local l=textlabel(row,name,13,C.muted);l.Size=UDim2.new(1,-82,1,0)
 local b=mk('TextButton',{Text='',AutoButtonColor=false,Size=UDim2.fromOffset(57,27),Position=UDim2.new(1,-58,.5,-13),BackgroundColor3=enabled and C.pink or C.off},row);corner(b,14)
 local dot=mk('Frame',{Size=UDim2.fromOffset(21,21),Position=UDim2.fromOffset(enabled and 33 or 3,3),BackgroundColor3=enabled and C.txt or C.muted},b);corner(dot,11)
 local state=enabled
 b.MouseButton1Click:Connect(function()
  state=not state;tw(b,{BackgroundColor3=state and C.pink or C.off});tw(dot,{Position=UDim2.fromOffset(state and 33 or 3,3),BackgroundColor3=state and C.txt or C.muted});l.TextColor3=state and C.txt or C.muted
  if callback then callback(state) else notify(name..' is a UI preview') end
 end)
 return function()return state end
end
local function button(parentObj,name,callback)
 local b=mk('TextButton',{Size=UDim2.new(1,0,0,34),Text=name,TextColor3=C.txt,Font=Enum.Font.GothamMedium,TextSize=13,BackgroundColor3=C.card,AutoButtonColor=false},parentObj);corner(b,7)
 b.MouseEnter:Connect(function()tw(b,{BackgroundColor3=Color3.fromRGB(60,42,74)},.13)end)
 b.MouseLeave:Connect(function()tw(b,{BackgroundColor3=C.card},.13)end)
 b.MouseButton1Click:Connect(function()if callback then callback()else notify(name..' requires game-side integration')end end)
 return b
end
local function slider(parentObj,name,min,max,initial,suffix,callback)
 local row=mk('Frame',{Size=UDim2.new(1,0,0,58),BackgroundTransparency=1},parentObj)
 local label=textlabel(row,name,12,C.txt);label.Size=UDim2.new(1,-80,0,24)
 local val=textlabel(row,'',12,C.txt,true);val.Size=UDim2.fromOffset(78,24);val.Position=UDim2.new(1,-78,0,0);val.TextXAlignment=Enum.TextXAlignment.Right
 local track=mk('Frame',{Size=UDim2.new(1,-4,0,10),Position=UDim2.fromOffset(2,35),BackgroundColor3=C.off,BorderSizePixel=0},row);corner(track,5)
 local fill=mk('Frame',{Size=UDim2.fromScale(0,1),BackgroundColor3=C.pink,BorderSizePixel=0},track);corner(fill,5)
 local knob=mk('Frame',{Size=UDim2.fromOffset(16,16),Position=UDim2.new(0,-8,.5,-8),BackgroundColor3=C.txt,BorderSizePixel=0},track);corner(knob,8)
 local draggingSlider=false
 local function set(v)
  v=math.clamp(v,min,max);local pct=(v-min)/(max-min)
  fill.Size=UDim2.fromScale(pct,1);knob.Position=UDim2.new(pct,-8,.5,-8)
  val.Text=(math.abs(v-math.floor(v))<.01 and tostring(math.floor(v)) or string.format('%.1f',v))..(suffix or '')
  if callback then callback(v)end
 end
 local function fromInput(x)
  if track.AbsoluteSize.X>0 then local pct=math.clamp((x-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1);set(math.floor((min+(max-min)*pct)*10+.5)/10)end
 end
 track.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then draggingSlider=true;fromInput(i.Position.X)end end)
 UIS.InputChanged:Connect(function(i)if draggingSlider and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then fromInput(i.Position.X)end end)
 UIS.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then draggingSlider=false end end)
 set(initial)
end
local function dropdown(parentObj,name,options,callback)
 local title=textlabel(parentObj,name,13,C.txt);title.Size=UDim2.new(1,0,0,23)
 local selected=1
 local b=button(parentObj,(options[1] or 'Select')..'  ▸',function()
  selected=selected%#options+1;b.Text=options[selected]..'  ▸';if callback then callback(options[selected])else notify('Selected: '..options[selected])end
 end)
 return b
end
local combat=newTab('Combat')
local left,right=columns(combat)
local sheriff=section(left,'sheriff')
for _,n in ipairs({'Auto Kill Murderer','Grab Gun & Shoot','Auto Shoot Murderer','Auto Grab Drop Gun','Wallbang','Camera Aimbot'})do toggle(sheriff,n,false)end
local murderer=section(left,'murderer')
for _,n in ipairs({'Knife Kill All','Knife Reach'})do toggle(murderer,n,false)end
slider(murderer,'Reach Distance',1,30,15,' studs')
toggle(murderer,'Auto Equip Knife',false)
slider(murderer,'Equip Knife Delay',0,3,1.1,'s')
toggle(murderer,'Silent Throw',false)
slider(murderer,'Knife Hitbox Size',1,10,1,'x')
toggle(murderer,'Show Hitbox',false)
dropdown(murderer,'Kill Target',{'Select player','Practice dummy','All players (preview)'})
button(murderer,'Kill Selected');button(murderer,'Kill Sheriff')
local aim=section(right,'silent aim')
for _,n in ipairs({'Silent Aim','Wall Check Shoot Button','Shoot When Knife Visible','Aim Visualizer'})do toggle(aim,n,false)end
slider(aim,'FOV Circle Radius',30,500,180,' px')
local fling=section(right,'fling')
for _,n in ipairs({'Auto Fling Sheriff','Touch Fling','Fling Spin','Anti Fling','Spam Fling'})do toggle(fling,n,false)end
for _,n in ipairs({'Fling Murderer','Fling Sheriff','Fling All'})do button(fling,n)end
dropdown(fling,'Player',{'Select player','Practice dummy'})
for _,n in ipairs({'Fling Selected Player','Teleport To Murderer','Teleport To Sheriff'})do button(fling,n)end
local farm=newTab('Autofarm')
local farmLeft,farmRight=columns(farm)
local coins=section(farmLeft,'coins')
for _,n in ipairs({'Coin Farm','End Round When Full','Avoid Mode','Kill All After Bag Full','Kill Murderer On Bag Full','Fling Murderer On Bag Full','Die After Bag Full','Die As Murderer On Full'})do toggle(coins,n,false)end
slider(coins,'Tween Speed',1,50,16,' speed')
slider(coins,'Distance',0,20,5,' Y')
slider(coins,'TP Delay',0,5,0,'s')
dropdown(coins,'Teleport Method',{'Tween','Instant (preview)','Path (preview)'})
toggle(coins,'Coin Hitbox',false)
slider(coins,'Coin Hitbox Size',1,30,10,'')
local survive=section(farmRight,'survive')
toggle(survive,'Auto Survive Round',false)
local scan=section(farmRight,'coin scanner')
button(scan,'Count Coin Objects',function()
 local count=0
 for _,v in ipairs(workspace:GetDescendants())do if v:IsA('BasePart') and string.find(string.lower(v.Name),'coin',1,true)then count=count+1 end end
 notify('Coin-named parts detected: '..count)
end)
button(scan,'Show Current Position',function()
 local root=player.Character and player.Character:FindFirstChild('HumanoidRootPart')
 if root then local p=root.Position;notify(string.format('Position: %.0f, %.0f, %.0f',p.X,p.Y,p.Z))end
end)
local visual=newTab('Visuals');local vl,vr=columns(visual)
local camera=section(vl,'camera')
slider(camera,'Camera FOV',50,110,70,'°',function(v)if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=v end end)
local overlay=section(vr,'overlay')
local crosshair
local function cross(v)
 if crosshair then crosshair:Destroy();crosshair=nil end
 if v then crosshair=textlabel(gui,'+',28,C.purple,true);crosshair.Size=UDim2.fromOffset(28,28);crosshair.Position=UDim2.new(.5,-14,.5,-14);crosshair.TextXAlignment=Enum.TextXAlignment.Center end
end
toggle(overlay,'Crosshair',false,cross)
local esp=newTab('ESP');local el,er=columns(esp)
local names=section(el,'player labels')
local labels={}
local function clearLabels()for _,v in pairs(labels)do if v then v:Destroy()end end;table.clear(labels)end
local labelsOn=false
local function refreshLabels()
 clearLabels();if not labelsOn then return end
 for _,p in ipairs(Players:GetPlayers())do
  if p~=player and p.Character then
   local head=p.Character:FindFirstChild('Head')
   if head then
    local b=mk('BillboardGui',{Size=UDim2.fromOffset(150,25),StudsOffset=Vector3.new(0,2.6,0),AlwaysOnTop=true,Adornee=head},gui)
    local l=textlabel(b,p.DisplayName,13,C.purple,true);l.Size=UDim2.fromScale(1,1);l.TextXAlignment=Enum.TextXAlignment.Center
    labels[p]=b
   end
  end
 end
end
toggle(names,'Show Player Names',false,function(v)labelsOn=v;refreshLabels()end)
button(names,'Refresh Labels',refreshLabels)
button(names,'Clear Labels',function()labelsOn=false;clearLabels()end)
local playersPage=newTab('Players');local pl=section(playersPage,'players')
button(pl,'Count Players',function()notify('Players: '..#Players:GetPlayers())end)
button(pl,'List Player Names',function()local namesArr={};for _,p in ipairs(Players:GetPlayers())do table.insert(namesArr,p.DisplayName)end;notify(table.concat(namesArr,', '):sub(1,100))end)
local tele=newTab('Teleports');local tl=section(tele,'waypoints')
button(tl,'Show My Coordinates',function()local r=player.Character and player.Character:FindFirstChild('HumanoidRootPart');if r then notify(tostring(r.Position))end end)
button(tl,'Map Waypoints (game integration)')
local survival=newTab('Survival');local sl=section(survival,'round information')
button(sl,'Check Character Health',function()local h=player.Character and player.Character:FindFirstChildOfClass('Humanoid');notify(h and ('Health: '..math.floor(h.Health)) or 'No humanoid found')end)
toggle(sl,'Round Status Overlay (preview)',false)
local boxes=newTab('Boxes');local bl=section(boxes,'inventory')
button(bl,'Count Backpack Tools',function()local b=player:FindFirstChildOfClass('Backpack');notify('Tools: '..(b and #b:GetChildren() or 0))end)
button(bl,'Shop Integration (requires game support)')
local servers=newTab('Servers');local sv=section(servers,'session')
button(sv,'Show Place ID',function()notify('Place ID: '..game.PlaceId)end)
button(sv,'Show Job ID',function()notify('Job ID: '..game.JobId:sub(1,25)..'…')end)
button(sv,'Show Player Count',function()notify('Players: '..#Players:GetPlayers())end)
local settings=newTab('Settings');local st=section(settings,'interface')
slider(st,'UI Scale',.7,1.2,1,'x',function(v)scale.Scale=v end)
button(st,'Minimize Hub',function()show(false)end)
button(st,'Reset Window Position',function()main.Position=UDim2.new(.5,-465,.5,-282);notify('Window position reset')end)
button(st,'Close Hub',function()show(false)end)
local home=newTab('Home');local hm=section(home,'welcome')
local welcome=textlabel(hm,'Violet Hub v7 — Select Combat or Autofarm to view detailed panels.',14,C.txt)
welcome.Size=UDim2.new(1,0,0,58);welcome.TextWrapped=true
local note=textlabel(hm,'Pink toggles and sliders are interactive UI. Features requiring authorized server integration are previews.',12,C.muted)
note.Size=UDim2.new(1,0,0,62);note.TextWrapped=true
-- Start on Combat to immediately show the requested sections.
active='Combat';tabs.Combat.Visible=true;navButtons.Combat.BackgroundColor3=C.purple;navButtons.Combat.TextColor3=C.txt
-- Responsive size adjustment for smaller screens.
local cam=workspace.CurrentCamera
if cam then local vp=cam.ViewportSize;scale.Scale=math.min(1,math.max(.68,math.min(vp.X/1000,vp.Y/650)))end
notify('Violet Hub v7 loaded')
