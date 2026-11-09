-- Violet Hub V6 | client-side UI and visual QA toolkit
-- Run in a Roblox client context. No executor-specific APIs required.
local Players = game:GetService('Players')
local UIS = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local Lighting = game:GetService('Lighting')
local player = Players.LocalPlayer
if not player then warn('Violet Hub: LocalPlayer unavailable'); return end
local pg = player:WaitForChild('PlayerGui', 10)
if not pg then warn('Violet Hub: PlayerGui unavailable'); return end
local old = pg:FindFirstChild('VioletHubV6')
if old then old:Destroy() end
local gui = Instance.new('ScreenGui')
gui.Name='VioletHubV6'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.DisplayOrder=999
pcall(function() gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling end)
gui.Parent=pg
local C={bg=Color3.fromRGB(12,10,23),panel=Color3.fromRGB(22,18,38),panel2=Color3.fromRGB(31,25,51),purple=Color3.fromRGB(153,91,255),light=Color3.fromRGB(220,205,255),muted=Color3.fromRGB(157,148,177),white=Color3.fromRGB(245,240,255),green=Color3.fromRGB(100,229,169)}
local function new(class,props,parent)
 local o=Instance.new(class)
 for k,v in pairs(props or {}) do o[k]=v end
 o.Parent=parent; return o
end
local function round(o,r) new('UICorner',{CornerRadius=UDim.new(0,r or 10)},o) end
local function stroke(o,color,trans) new('UIStroke',{Color=color or C.purple,Thickness=1,Transparency=trans or .65},o) end
local function label(parent,text,size,color,bold)
 return new('TextLabel',{BackgroundTransparency=1,Text=text,TextColor3=color or C.white,TextSize=size or 13,Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham,TextXAlignment=Enum.TextXAlignment.Left},parent)
end
local root=new('Frame',{Name='Window',Size=UDim2.fromOffset(720,485),Position=UDim2.new(.5,-360,.5,-242),BackgroundColor3=C.bg,BorderSizePixel=0,ClipsDescendants=true},gui)
round(root,15); stroke(root,C.purple,.4)
local scale=new('UIScale',{Scale=1},root)
local function rescale()
 local cam=workspace.CurrentCamera
 if cam then local v=cam.ViewportSize; scale.Scale=math.clamp(math.min(v.X/780,v.Y/550),.58,1) end
end
rescale()
if workspace.CurrentCamera then workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'):Connect(rescale) end
local header=new('Frame',{Size=UDim2.new(1,0,0,53),BackgroundColor3=C.panel,BorderSizePixel=0},root)
local title=label(header,'✦  VIOLET HUB',18,C.light,true); title.Position=UDim2.fromOffset(18,8); title.Size=UDim2.fromOffset(230,25)
local subtitle=label(header,'v6  •  CLIENT TOOLKIT',10,C.muted); subtitle.Position=UDim2.fromOffset(20,31); subtitle.Size=UDim2.fromOffset(200,15)
local function topBtn(text,x)
 local b=new('TextButton',{Size=UDim2.fromOffset(34,30),Position=UDim2.new(1,x,0,11),BackgroundColor3=C.panel2,Text=text,TextSize=19,TextColor3=C.white,Font=Enum.Font.GothamBold,AutoButtonColor=true},header)
 round(b,8); return b
end
local mini=topBtn('–',-84); local close=topBtn('×',-43)
local sidebar=new('ScrollingFrame',{Position=UDim2.fromOffset(0,54),Size=UDim2.new(0,168,1,-54),BackgroundColor3=C.panel,BorderSizePixel=0,ScrollBarThickness=2,CanvasSize=UDim2.new()},root)
new('UIPadding',{PaddingTop=UDim.new(0,12),PaddingLeft=UDim.new(0,9),PaddingRight=UDim.new(0,9)},sidebar)
local navLayout=new('UIListLayout',{Padding=UDim.new(0,5),SortOrder=Enum.SortOrder.LayoutOrder},sidebar)
navLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function() sidebar.CanvasSize=UDim2.fromOffset(0,navLayout.AbsoluteContentSize.Y+20) end)
local content=new('Frame',{Position=UDim2.fromOffset(169,54),Size=UDim2.new(1,-169,1,-54),BackgroundTransparency=1},root)
local heading=label(content,'Dashboard',21,C.white,true); heading.Position=UDim2.fromOffset(20,14); heading.Size=UDim2.new(1,-35,0,28)
local desc=label(content,'Your client controls and status',12,C.muted); desc.Position=UDim2.fromOffset(21,43); desc.Size=UDim2.new(1,-40,0,18)
local scroll=new('ScrollingFrame',{Position=UDim2.fromOffset(16,73),Size=UDim2.new(1,-32,1,-87),BackgroundTransparency=1,BorderSizePixel=0,ScrollBarThickness=4,ScrollBarImageColor3=C.purple,CanvasSize=UDim2.new()},content)
new('UIPadding',{PaddingTop=UDim.new(0,2),PaddingBottom=UDim.new(0,12),PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,8)},scroll)
local stack=new('UIListLayout',{Padding=UDim.new(0,9),SortOrder=Enum.SortOrder.LayoutOrder},scroll)
stack:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function() scroll.CanvasSize=UDim2.fromOffset(0,stack.AbsoluteContentSize.Y+20) end)
local toast=label(gui,'',13,C.white,true); toast.Size=UDim2.fromOffset(340,38); toast.Position=UDim2.new(.5,-170,1,-60); toast.BackgroundColor3=C.panel2; toast.BackgroundTransparency=1; toast.TextTransparency=1; toast.TextXAlignment=Enum.TextXAlignment.Center; round(toast,9)
local function notify(t)
 toast.Text=t; TweenService:Create(toast,TweenInfo.new(.2),{TextTransparency=0,BackgroundTransparency=.05}):Play()
 task.delay(2.5,function() if toast.Parent then TweenService:Create(toast,TweenInfo.new(.3),{TextTransparency=1,BackgroundTransparency=1}):Play() end end)
end
local function clear()
 for _,v in ipairs(scroll:GetChildren()) do if v:IsA('GuiObject') then v:Destroy() end end
 scroll.CanvasPosition=Vector2.new(0,0)
end
local function section(t)
 local l=label(scroll,string.upper(t),11,C.purple,true); l.Size=UDim2.new(1,-8,0,22); return l
end
local function card(height)
 local f=new('Frame',{Size=UDim2.new(1,-8,0,height or 60),BackgroundColor3=C.panel,BorderSizePixel=0},scroll); round(f,10); stroke(f,C.purple,.87); return f
end
local function textrow(name,detail,value)
 local f=card(63); local a=label(f,name,13,C.white,true); a.Position=UDim2.fromOffset(14,9); a.Size=UDim2.new(1,-140,0,20)
 local b=label(f,detail,11,C.muted); b.Position=UDim2.fromOffset(14,31); b.Size=UDim2.new(1,-24,0,22)
 if value then local v=label(f,tostring(value),12,C.light,true); v.TextXAlignment=Enum.TextXAlignment.Right; v.Position=UDim2.new(1,-138,0,10); v.Size=UDim2.fromOffset(122,22) end
 return f
end
local state={}; local cleaners={}
local function toggle(name,detail,default,callback)
 local f=card(65); local a=label(f,name,13,C.white,true); a.Position=UDim2.fromOffset(14,9); a.Size=UDim2.new(1,-100,0,20)
 local b=label(f,detail,11,C.muted); b.Position=UDim2.fromOffset(14,32); b.Size=UDim2.new(1,-100,0,24)
 local sw=new('TextButton',{Position=UDim2.new(1,-68,.5,-14),Size=UDim2.fromOffset(52,28),Text='',BackgroundColor3=C.panel2},f); round(sw,14)
 local dot=new('Frame',{Size=UDim2.fromOffset(20,20),Position=UDim2.fromOffset(4,4),BackgroundColor3=C.muted},sw); round(dot,10)
 local val=state[name]; if val==nil then val=default or false; state[name]=val end
 local function paint(animate)
  local props={BackgroundColor3=state[name] and C.purple or C.panel2}; local dp={Position=UDim2.fromOffset(state[name] and 28 or 4,4),BackgroundColor3=state[name] and C.white or C.muted}
  if animate then TweenService:Create(sw,TweenInfo.new(.18),props):Play(); TweenService:Create(dot,TweenInfo.new(.18),dp):Play() else for k,v in pairs(props) do sw[k]=v end; for k,v in pairs(dp) do dot[k]=v end end
 end
 paint(false)
 sw.MouseButton1Click:Connect(function() state[name]=not state[name]; paint(true); if callback then local ok,err=pcall(callback,state[name]); if not ok then notify('Setting error: '..tostring(err):sub(1,55)) end end end)
 return f
end
local function slider(name,detail,min,max,default,callback)
 local f=card(88); local a=label(f,name,13,C.white,true); a.Position=UDim2.fromOffset(14,8); a.Size=UDim2.new(1,-90,0,19)
 local b=label(f,detail,11,C.muted); b.Position=UDim2.fromOffset(14,28); b.Size=UDim2.new(1,-28,0,20)
 local v=label(f,'',12,C.light,true); v.TextXAlignment=Enum.TextXAlignment.Right; v.Position=UDim2.new(1,-76,0,8); v.Size=UDim2.fromOffset(60,20)
 local track=new('Frame',{Position=UDim2.new(0,16,0,65),Size=UDim2.new(1,-32,0,7),BackgroundColor3=C.panel2},f); round(track,4)
 local fill=new('Frame',{Size=UDim2.new(),BackgroundColor3=C.purple},track); round(fill,4)
 local knob=new('Frame',{Size=UDim2.fromOffset(16,16),BackgroundColor3=C.light},track); round(knob,8)
 local current=state[name] or default; local dragging=false
 local function set(n)
  current=math.floor(math.clamp(n,min,max)+.5); state[name]=current; v.Text=tostring(current)
  local t=(current-min)/(max-min); fill.Size=UDim2.new(t,0,1,0); knob.Position=UDim2.new(t,-8,.5,-8)
  if callback then pcall(callback,current) end
 end
 set(current)
 local function fromX(x) set(min+(max-min)*((x-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1))) end
 local hit=new('TextButton',{Position=UDim2.new(0,0,0,-10),Size=UDim2.new(1,0,1,20),BackgroundTransparency=1,Text=''},track)
 hit.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true; fromX(i.Position.X) end end)
 UIS.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then fromX(i.Position.X) end end)
 UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
 return f
end
local function action(name,detail,btn,callback)
 local f=card(64); local a=label(f,name,13,C.white,true); a.Position=UDim2.fromOffset(14,9); a.Size=UDim2.new(1,-135,0,20)
 local b=label(f,detail,11,C.muted); b.Position=UDim2.fromOffset(14,31); b.Size=UDim2.new(1,-140,0,25)
 local go=new('TextButton',{Position=UDim2.new(1,-124,.5,-16),Size=UDim2.fromOffset(110,32),BackgroundColor3=C.panel2,Text=btn or 'Run',TextSize=12,TextColor3=C.light,Font=Enum.Font.GothamBold},f); round(go,8); stroke(go,C.purple,.5)
 go.MouseButton1Click:Connect(function() local ok,err=pcall(callback or function() notify('Not connected to game server') end); if not ok then notify(tostring(err):sub(1,55)) end end)
 return f
end
local function note(t) textrow('Integration required',t) end
local highlights={}
local function clearESP()
 for _,h in pairs(highlights) do pcall(function() h:Destroy() end) end; table.clear(highlights)
end
local function refreshESP()
 clearESP(); if not state['Player outlines'] then return end
 for _,p in ipairs(Players:GetPlayers()) do
  if p~=player and p.Character then local h=Instance.new('Highlight'); h.Name='VioletLocalOutline'; h.Adornee=p.Character; h.FillTransparency=.8; h.OutlineTransparency=.05; h.FillColor=C.purple; h.OutlineColor=C.light; h.DepthMode=Enum.HighlightDepthMode.Occluded; h.Parent=gui; highlights[p]=h end
 end
end
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(.3); refreshESP() end) end)
Players.PlayerRemoving:Connect(function() task.defer(refreshESP) end)
local cross=new('Frame',{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(5,5),BackgroundColor3=C.purple,Visible=false},gui); round(cross,4)
local fps=label(gui,'',13,C.light,true); fps.Position=UDim2.fromOffset(12,12); fps.Size=UDim2.fromOffset(240,25); fps.Visible=false
local frameCount=0; local accum=0
RunService.RenderStepped:Connect(function(dt)
 if not gui.Parent then return end
 frameCount=frameCount+1; accum=accum+dt
 if accum>=.6 then fps.Text='VIOLET  •  '..math.floor(frameCount/accum)..' FPS'; accum=0; frameCount=0 end
end)
local pages={
 {'Home','layout-dashboard','Dashboard','Overview and quick actions'},
 {'Combat','crosshair','Combat','Target-practice UI settings'},
 {'ESP','eye','ESP','Local player visibility tools'},
 {'Visuals','palette','Visuals','Camera and display customization'},
 {'Players','users','Players','Session information'},
 {'Teleports','map-pin','Teleports','Waypoint and position tools'},
 {'Autofarm','coins','Autofarm','Coin-system QA overview'},
 {'Survival','shield','Survival','Round testing dashboard'},
 {'Boxes','package','Boxes','Inventory and shop integration'},
 {'Servers','server','Servers','Session information'},
 {'Settings','settings','Settings','Interface preferences'}
}
local navButtons={}; local active='Home'; local hide
local function render(tab)
 active=tab; clear()
 for name,b in pairs(navButtons) do b.BackgroundColor3=name==tab and C.panel2 or C.panel; b.TextColor3=name==tab and C.light or C.muted end
 for _,p in ipairs(pages) do if p[1]==tab then heading.Text=p[3]; desc.Text=p[4]; break end end
 if tab=='Home' then
  section('Welcome'); textrow('Violet Hub • v6','Responsive client-side toolkit','ONLINE')
  textrow('Connected as',player.DisplayName,player.Name)
  section('Quick access'); action('Refresh player outlines','Rebuild local visual highlights','Refresh',refreshESP)
  action('Reset camera FOV','Restore standard 70-degree camera','Reset',function() state['Camera FOV']=70; if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=70 end; notify('Camera reset') end)
  section('Status'); textrow('Players online','Current server population',#Players:GetPlayers())
 elseif tab=='Combat' then
  section('Practice reticle'); toggle('Crosshair','Centered aim-training marker',false,function(v) cross.Visible=v end)
  slider('Crosshair size','Adjust marker diameter',3,25,5,function(v) cross.Size=UDim2.fromOffset(v,v) end)
  action('Reset practice reticle','Return marker to default size','Reset',function() state['Crosshair size']=5; cross.Size=UDim2.fromOffset(5,5); notify('Reticle reset; reopen tab to refresh slider') end)
  section('Game integration'); note('Target detection and weapon mechanics require authorized game-server APIs.')
 elseif tab=='ESP' then
  section('Player highlights'); toggle('Player outlines','Visible local outlines (no wall visibility)',false,refreshESP)
  action('Refresh outlines','Update outlines for current players','Refresh',refreshESP)
  action('Clear outlines','Remove all Violet outlines','Clear',function() state['Player outlines']=false; clearESP(); render('ESP') end)
  section('Notes'); textrow('Privacy-friendly view','Uses Roblox Highlight with occluded depth')
 elseif tab=='Visuals' then
  section('Camera'); slider('Camera FOV','Field of view for local camera',50,100,70,function(v) if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=v end end)
  toggle('Crosshair','Show a centered marker',false,function(v) cross.Visible=v end)
  slider('Crosshair size','Adjust marker diameter',3,25,5,function(v) cross.Size=UDim2.fromOffset(v,v) end)
  section('Overlays'); toggle('FPS counter','Display a small performance indicator',false,function(v) fps.Visible=v end)
  toggle('Low graphics','Disable local post-processing effects',false,function(v)
   for _,e in ipairs(Lighting:GetChildren()) do if e:IsA('PostEffect') then if e:GetAttribute('VioletOriginalEnabled')==nil then e:SetAttribute('VioletOriginalEnabled',e.Enabled) end; e.Enabled=v and false or e:GetAttribute('VioletOriginalEnabled') end end
  end)
 elseif tab=='Players' then
  section('Session'); textrow('Current players','Active players in this server',#Players:GetPlayers())
  for _,p in ipairs(Players:GetPlayers()) do textrow(p.DisplayName,'@'..p.Name,p==player and 'YOU' or '') end
  section('Actions'); action('Refresh player list','Rebuild the live player listing','Refresh',function() render('Players') end)
 elseif tab=='Teleports' then
  section('Position'); local pos=player.Character and player.Character:FindFirstChild('HumanoidRootPart'); textrow('Your coordinates','Current character position',pos and tostring(pos.Position) or 'Not spawned')
  action('Copy coordinates','Show coordinates for map debugging','Show',function() local p=player.Character and player.Character:FindFirstChild('HumanoidRootPart'); notify(p and tostring(p.Position) or 'Character not available') end)
  section('Waypoints'); note('Server-authorized waypoint travel can be connected to your own game.')
 elseif tab=='Autofarm' then
  section('Coin diagnostics'); local folder=workspace:FindFirstChild('Coins'); textrow('Coin container','Looks for workspace.Coins',folder and 'FOUND' or 'NOT FOUND')
  action('Scan coin objects','Count children in the Coins folder','Scan',function() local f=workspace:FindFirstChild('Coins'); notify(f and ('Coin objects: '..#f:GetChildren()) or 'workspace.Coins not found') end)
  section('Collection integration'); note('Automatic collection and rewards need your own server-side coin system.')
 elseif tab=='Survival' then
  section('Round overview'); textrow('Character status','Current local player',player.Character and 'SPAWNED' or 'WAITING')
  action('Refresh status','Recheck character state','Refresh',function() render('Survival') end)
  section('Testing'); note('Round simulation and role state require your game round manager.')
 elseif tab=='Boxes' then
  section('Inventory'); textrow('Local inventory','Game-specific inventory integration','NOT LINKED')
  action('Inspect backpack','Count Roblox Tool objects','Inspect',function() local b=player:FindFirstChild('Backpack'); notify('Backpack tools: '..(b and #b:GetChildren() or 0)) end)
  section('Shop'); note('Box purchases and prestige require your game shop API.')
 elseif tab=='Servers' then
  section('Current session'); textrow('Place ID','Current experience',game.PlaceId)
  textrow('Job ID','Current server identifier',game.JobId:sub(1,14)..'…')
  textrow('Population','Players currently connected',#Players:GetPlayers())
  action('Refresh server stats','Update the server information','Refresh',function() render('Servers') end)
 elseif tab=='Settings' then
  section('Appearance'); slider('UI opacity','Window background opacity',0,40,0,function(v) root.BackgroundTransparency=v/100 end)
  slider('UI scale','Adjust overall interface size',60,110,100,function(v) scale.Scale=v/100 end)
  section('Window'); action('Minimize hub','Hide panel and keep floating button','Minimize',function() if hide then hide() end end)
  action('Reset position','Move window back to screen center','Reset',function() root.Position=UDim2.new(.5,-360,.5,-242); notify('Position reset') end)
  section('Help'); textrow('Keyboard shortcut','Right Shift toggles the hub')
 end
end
for i,p in ipairs(pages) do
 local b=new('TextButton',{Name=p[1],LayoutOrder=i,Size=UDim2.new(1,0,0,34),BackgroundColor3=C.panel,Text='   '..p[1],TextColor3=C.muted,TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,Font=Enum.Font.GothamBold,AutoButtonColor=true},sidebar)
 round(b,8); navButtons[p[1]]=b; b.MouseButton1Click:Connect(function() render(p[1]) end)
end
local floating=new('TextButton',{Size=UDim2.fromOffset(53,53),Position=UDim2.new(0,16,.5,-26),BackgroundColor3=C.panel,Text='✦',TextSize=28,TextColor3=C.light,Visible=false,AutoButtonColor=true},gui); round(floating,15); stroke(floating,C.purple,.2)
local busy=false
hide=function()
 if busy or not root.Visible then return end; busy=true
 local t=TweenService:Create(root,TweenInfo.new(.2,Enum.EasingStyle.Quad),{BackgroundTransparency=1})
 t:Play(); t.Completed:Wait(); root.Visible=false; root.BackgroundTransparency=state['UI opacity'] and state['UI opacity']/100 or 0; floating.Visible=true; busy=false
end
local function show()
 if busy or root.Visible then return end; busy=true; floating.Visible=false; root.Visible=true; root.BackgroundTransparency=1
 local t=TweenService:Create(root,TweenInfo.new(.23,Enum.EasingStyle.Quad),{BackgroundTransparency=state['UI opacity'] and state['UI opacity']/100 or 0})
 t:Play(); t.Completed:Wait(); busy=false
end
mini.MouseButton1Click:Connect(hide)
close.MouseButton1Click:Connect(hide)
floating.MouseButton1Click:Connect(show)
UIS.InputBegan:Connect(function(i,processed) if not processed and i.KeyCode==Enum.KeyCode.RightShift then if root.Visible then hide() else show() end end end)
-- Dragging supports mouse and touch, and never steals sidebar interactions.
local dragging=false; local dragStart,windowStart,dragInput
header.InputBegan:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
  dragging=true; dragStart=i.Position; windowStart=root.Position; dragInput=i
 end
end)
UIS.InputChanged:Connect(function(i)
 if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or (dragInput and i==dragInput)) then
  local delta=i.Position-dragStart
  root.Position=UDim2.new(windowStart.X.Scale,windowStart.X.Offset+delta.X,windowStart.Y.Scale,windowStart.Y.Offset+delta.Y)
 end
end)
UIS.InputEnded:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 or (dragInput and i==dragInput) then dragging=false; dragInput=nil end
end)
render('Home')
root.BackgroundTransparency=1
TweenService:Create(root,TweenInfo.new(.35,Enum.EasingStyle.Quad),{BackgroundTransparency=0}):Play()
notify('Violet Hub v6 loaded • Drag title bar to move')
