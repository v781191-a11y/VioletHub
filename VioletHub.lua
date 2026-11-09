-- Violet Hub V9.3 | preserves V9 layout; client-side QA and authorized integrations
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
local old = pg:FindFirstChild('VioletHubV9')
if old then old:Destroy() end
if _G.VioletHubCleanup then pcall(_G.VioletHubCleanup) end
local gui = Instance.new('ScreenGui')
gui.Name='VioletHubV9'; gui.ResetOnSpawn=false; gui.IgnoreGuiInset=true; gui.DisplayOrder=999
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
local subtitle=label(header,'v9.3  •  CLIENT TOOLKIT',10,C.muted); subtitle.Position=UDim2.fromOffset(20,31); subtitle.Size=UDim2.fromOffset(200,15)
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
local function connect(signal,callback) local c=signal:Connect(callback); table.insert(cleaners,c); return c end
local originalLighting={Brightness=Lighting.Brightness, ClockTime=Lighting.ClockTime, FogEnd=Lighting.FogEnd, Ambient=Lighting.Ambient}
local violetEffects={}
local cross, fps
local originalFOV=workspace.CurrentCamera and workspace.CurrentCamera.FieldOfView or 70
local function effect(class,name)
 local obj=Lighting:FindFirstChild(name)
 if not obj then obj=Instance.new(class); obj.Name=name; obj.Parent=Lighting end
 violetEffects[name]=obj; return obj
end
local function setEffect(class,name,on)
 local obj=effect(class,name); obj.Enabled=on
end
local function countNamed(pattern)
 local n=0
 for _,obj in ipairs(workspace:GetDescendants()) do
  if obj:IsA('BasePart') and obj.Name:lower():find(pattern,1,true) then n=n+1 end
 end
 return n
end
local function localTools()
 local out={}
 local backpack=player:FindFirstChildOfClass('Backpack')
 for _,container in ipairs({backpack,player.Character}) do
  if container then for _,obj in ipairs(container:GetChildren()) do if obj:IsA('Tool') then table.insert(out,obj.Name) end end end
 end
 return out
end
local function resetVisuals()
 for name,obj in pairs(violetEffects) do if obj and obj.Parent then obj:Destroy() end end
 table.clear(violetEffects)
 for k,v in pairs(originalLighting) do Lighting[k]=v end
 if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=originalFOV end
 if cross then cross.Visible=false end; if fps then fps.Visible=false end
end

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
local function selector(name,detail,options)
 local f=card(73)
 local a=label(f,name,13,C.white,true); a.Position=UDim2.fromOffset(14,8); a.Size=UDim2.new(1,-30,0,20)
 local b=label(f,detail,11,C.muted); b.Position=UDim2.fromOffset(14,31); b.Size=UDim2.new(1,-190,0,24)
 local selected=state[name] or 1
 local btn=new('TextButton',{Position=UDim2.new(1,-181,0,32),Size=UDim2.fromOffset(165,29),BackgroundColor3=C.panel2,TextColor3=C.light,TextSize=11,Font=Enum.Font.GothamBold,Text=''},f)
 round(btn,7)
 local function update() btn.Text=tostring(options[selected])..'  ▾'; state[name]=selected end
 update()
 btn.MouseButton1Click:Connect(function() selected=selected%#options+1; update() end)
 return f
end
local function preview(name,detail)
 toggle(name,detail..' (preview only)',false,function() notify('Preview only • connect your game API') end)
end
local function previewAction(name,detail)
 action(name,detail,'Preview',function() notify('Requires authorized game API') end)
end
local function note(t) textrow('Integration required',t) end
local highlights={}
local worldMarkers={}
local xrayOriginal={}
local function clearESP()
 for _,h in pairs(highlights) do pcall(function() h:Destroy() end) end
 table.clear(highlights)
end
local function visibleRole(p)
 -- A role is only inferred from a Tool visible in replicated character data.
 local char=p.Character
 if not char then return 'Unknown' end
 for _,item in ipairs(char:GetChildren()) do
  if item:IsA('Tool') then
   local n=item.Name:lower()
   if n:find('knife',1,true) then return 'Knife equipped' end
   if n:find('gun',1,true) or n:find('revolver',1,true) then return 'Gun equipped' end
  end
 end
 return 'Unknown'
end
local function refreshESP()
 clearESP()
 if not state['Player outlines'] then return end
 for _,p in ipairs(Players:GetPlayers()) do
  if p~=player and p.Character then
   local h=Instance.new('Highlight')
   h.Name='VioletLocalOutline'; h.Adornee=p.Character
   h.FillTransparency=.85; h.OutlineTransparency=.1
   local role=visibleRole(p)
   h.FillColor=role=='Knife equipped' and Color3.fromRGB(230,75,105) or (role=='Gun equipped' and Color3.fromRGB(75,155,250) or C.purple)
   h.OutlineColor=h.FillColor
   h.DepthMode=Enum.HighlightDepthMode.Occluded
   h.Parent=gui; highlights[p]=h
  end
 end
end
local function clearMarkers()
 for _,marker in pairs(worldMarkers) do pcall(function() marker:Destroy() end) end
 table.clear(worldMarkers)
end
local function updateMarkers()
 clearMarkers()
 if not state['Coin markers'] and not state['Dropped gun markers'] then return end
 local maxMarkers=80
 for _,obj in ipairs(workspace:GetDescendants()) do
  if #worldMarkers>=maxMarkers then break end
  if obj:IsA('BasePart') then
   local n=obj.Name:lower()
   local coin=state['Coin markers'] and n=='coin'
   local gun=state['Dropped gun markers'] and (n=='gundrop' or n=='droppedgun')
   if coin or gun then
    local marker=Instance.new('BillboardGui')
    marker.Name='VioletWorldMarker'; marker.Adornee=obj
    marker.Size=UDim2.fromOffset(100,24); marker.StudsOffsetWorldSpace=Vector3.new(0,2,0)
    marker.AlwaysOnTop=false; marker.MaxDistance=120
    local t=Instance.new('TextLabel'); t.Size=UDim2.fromScale(1,1); t.BackgroundTransparency=.3
    t.BackgroundColor3=C.panel; t.TextColor3=coin and Color3.fromRGB(255,218,95) or C.light
    t.Font=Enum.Font.GothamBold; t.TextSize=12; t.Text=coin and 'COIN' or 'DROPPED GUN'; t.Parent=marker
    marker.Parent=gui; table.insert(worldMarkers,marker)
   end
  end
 end
end
local function setXray(enabled)
 if not enabled then
  for part,value in pairs(xrayOriginal) do
   if part and part.Parent then pcall(function() part.LocalTransparencyModifier=value end) end
  end
  table.clear(xrayOriginal)
  return
 end
 for _,part in ipairs(workspace:GetDescendants()) do
  if part:IsA('BasePart') and not (part:FindFirstAncestorOfClass('Model') and part:FindFirstAncestorOfClass('Model'):FindFirstChildOfClass('Humanoid')) then
   if xrayOriginal[part]==nil then xrayOriginal[part]=part.LocalTransparencyModifier end
   part.LocalTransparencyModifier=.65
  end
 end
end
local function cleanup()
 clearESP(); clearMarkers(); setXray(false)
 for _,c in ipairs(cleaners) do pcall(function() c:Disconnect() end) end
 if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=originalFOV end
 for _,e in pairs(violetEffects) do if e and e.Parent then e:Destroy() end end
 for k,v in pairs(originalLighting) do pcall(function() Lighting[k]=v end) end
 if gui.Parent then gui:Destroy() end
end
_G.VioletHubCleanup=cleanup
connect(Players.PlayerAdded,function(p)
 connect(p.CharacterAdded,function() task.wait(.4); if gui.Parent then refreshESP() end end)
end)
for _,p in ipairs(Players:GetPlayers()) do
 connect(p.CharacterAdded,function() task.wait(.4); if gui.Parent then refreshESP() end end)
end
connect(Players.PlayerRemoving,function() task.defer(function() if gui.Parent then refreshESP() end end) end)
task.spawn(function()
 while gui.Parent do
  task.wait(2.5)
  if state['Player outlines'] then refreshESP() end
  if state['Coin markers'] or state['Dropped gun markers'] then updateMarkers() end
 end
end)
cross=new('Frame',{AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=UDim2.fromOffset(5,5),BackgroundColor3=C.purple,Visible=false},gui); round(cross,4)
fps=label(gui,'',13,C.light,true); fps.Position=UDim2.fromOffset(12,12); fps.Size=UDim2.fromOffset(240,25); fps.Visible=false
local frameCount=0; local accum=0
connect(RunService.RenderStepped,function(dt)
 if not gui.Parent then return end
 frameCount=frameCount+1; accum=accum+dt
 if accum>=.6 then fps.Text='VIOLET  •  '..math.floor(frameCount/accum)..' FPS'; accum=0; frameCount=0 end
end)
local pages={
 {'Home','layout-dashboard','Dashboard','Overview and quick actions'},
 {'Combat','crosshair','Combat','Sheriff, murderer and practice settings'},
 {'ESP','eye','ESP','Local player visibility tools'},
 {'Visuals','palette','Visuals','Camera and display customization'},
 {'Players','users','Players','Session information'},
 {'Teleports','map-pin','Teleports','Waypoint and position tools'},
 {'Autofarm','coins','Autofarm','Coin diagnostics and farm configuration'},
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
  section('Welcome'); textrow('Violet Hub • v9.3','Responsive client-side toolkit','ONLINE')
  textrow('Connected as',player.DisplayName,player.Name)
  section('Quick access'); action('Refresh player outlines','Rebuild local visual highlights','Refresh',refreshESP)
  action('Reset camera FOV','Restore standard 70-degree camera','Reset',function() state['Camera FOV']=70; if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=originalFOV end; notify('Camera reset') end)
  section('Status'); textrow('Players online','Current server population',#Players:GetPlayers())
 elseif tab=='Combat' then
  section('Live equipment diagnostics')
  action('Inspect equipped tools','Read locally visible Tool objects','Inspect',function() local t=localTools(); notify(#t>0 and table.concat(t,', '):sub(1,75) or 'No tools visible') end)
  action('Find dropped guns','Scan visible object names','Scan',function() notify('Gun-named parts: '..countNamed('gun')) end)
  section('Sheriff • training controls')
  preview('Auto target murderer','Target selection for your own practice NPC')
  preview('Grab gun and shoot','Server-authorized training integration')
  preview('Auto shoot','Training dummy integration')
  preview('Auto grab dropped gun','Dropped-tool detector integration')
  preview('Wallbang','Line-of-sight testing preview')
  section('Murderer • training controls')
  preview('Knife kill all','Practice targets only; no player attacks')
  preview('Knife reach','Visualize intended range in your own game')
  slider('Knife reach distance','Preview distance in studs',1,40,12)
  preview('Auto equip knife','Equipment-state integration')
  slider('Equip knife delay','Delay preview in tenths of a second',0,30,5)
  preview('Silent throw','Practice projectile integration')
  slider('Knife hitbox size','Training dummy visualization size',1,30,5)
  selector('Target selection','Preview target selector',{'None','Training dummy A','Training dummy B'})
  previewAction('Target action','Practice dummy target action')
  previewAction('Sheriff action','Practice role test action')
  section('Silent aim • visual settings')
  preview('Silent aim preview','Reticle display only')
  slider('Aim FOV radius','Visual range size',10,250,90)
  toggle('Crosshair','Centered aim-training marker',false,function(v) cross.Visible=v end)
  slider('Crosshair size','Adjust marker diameter',3,25,5,function(v) cross.Size=UDim2.fromOffset(v,v) end)
  section('Fling • interface preview')
  preview('Fling selected','Non-operational player action')
  preview('Auto fling','Non-operational player action')
  preview('Anti fling','Game-specific movement integration')
  slider('Fling speed preview','Interface value only',1,100,25)
  note('Combat actions need server-authorized game code. No attacks against live players are implemented.')
 elseif tab=='ESP' then
  section('Player highlights'); toggle('Player outlines','Visible local outlines (no wall visibility)',false,refreshESP)
  action('Refresh outlines','Update outlines for current players','Refresh',refreshESP)
  action('Clear outlines','Remove all Violet outlines','Clear',function() state['Player outlines']=false; clearESP(); render('ESP') end)
  section('MM2 object markers')
  toggle('Coin markers','Show labels for nearby replicated coins',false,updateMarkers)
  toggle('Dropped gun markers','Show labels for visible dropped guns',false,updateMarkers)
  action('Refresh world markers','Re-scan currently replicated map objects','Refresh',updateMarkers)
  section('Notes'); textrow('Visible equipment only','Role colors reflect equipped tools, not secret server roles')
  textrow('Occluded highlights','Player outlines do not show through walls')
 elseif tab=='Visuals' then
  section('World lighting')
  toggle('Lighting override','Local brightness and ambient lighting',false,function(v)
   Lighting.Brightness=v and 3 or originalLighting.Brightness
   Lighting.Ambient=v and Color3.fromRGB(145,115,180) or originalLighting.Ambient
  end)
  toggle('Bloom effect','Local post-processing glow',false,function(v) setEffect('BloomEffect','VioletBloom',v) end)
  toggle('Sun rays','Local sun ray post-processing',false,function(v) setEffect('SunRaysEffect','VioletSunRays',v) end)
  toggle('Color correction','Local purple-toned post-processing',false,function(v)
   local e=effect('ColorCorrectionEffect','VioletColorCorrection'); e.Enabled=v; e.TintColor=Color3.fromRGB(235,220,255)
  end)
  slider('Clock time','Local lighting hour',0,24,12,function(v) Lighting.ClockTime=v end)
  action('Restore visual defaults','Reset Violet-created visual effects','Reset',function() resetVisuals(); notify('Visuals restored') end)
  section('Camera'); slider('Camera FOV','Field of view for local camera',50,100,70,function(v) if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=v end end)
  toggle('Crosshair','Show a centered marker',false,function(v) cross.Visible=v end)
  slider('Crosshair size','Adjust marker diameter',3,25,5,function(v) cross.Size=UDim2.fromOffset(v,v) end)
  section('Local map transparency')
  toggle('X-ray environment','Temporarily fade non-character map parts',false,setXray)
  section('Overlays'); toggle('FPS counter','Display a small performance indicator',false,function(v) fps.Visible=v end)
  toggle('Low graphics','Disable local post-processing effects',false,function(v)
   for _,e in ipairs(Lighting:GetChildren()) do if e:IsA('PostEffect') then if e:GetAttribute('VioletOriginalEnabled')==nil then e:SetAttribute('VioletOriginalEnabled',e.Enabled) end; e.Enabled=v and false or e:GetAttribute('VioletOriginalEnabled') end end
  end)
 elseif tab=='Players' then
  section('Equipment')
  action('Inspect my tools','Show tool names in backpack and character','Inspect',function() local t=localTools(); notify(#t>0 and table.concat(t,', '):sub(1,75) or 'No tools visible') end)
  section('MM2 equipment observations')
  action('Refresh visible equipment','Recheck tools held by other characters','Refresh',function() render('Players') end)
  for _,other in ipairs(Players:GetPlayers()) do if other~=player then textrow(other.DisplayName,'Equipped tool observation',visibleRole(other)) end end
  section('Session'); textrow('Current players','Active players in this server',#Players:GetPlayers())
  for _,p in ipairs(Players:GetPlayers()) do textrow(p.DisplayName,'@'..p.Name,p==player and 'YOU' or '') end
  section('Actions'); action('Refresh player list','Rebuild the live player listing','Refresh',function() render('Players') end)
 elseif tab=='Teleports' then
  section('Position'); local pos=player.Character and player.Character:FindFirstChild('HumanoidRootPart'); textrow('Your coordinates','Current character position',pos and tostring(pos.Position) or 'Not spawned')
  action('Copy coordinates','Show coordinates for map debugging','Show',function() local p=player.Character and player.Character:FindFirstChild('HumanoidRootPart'); notify(p and tostring(p.Position) or 'Character not available') end)
  section('Waypoints'); note('Server-authorized waypoint travel can be connected to your own game.')
 elseif tab=='Autofarm' then
  section('Live world diagnostics')
  action('Scan all coin-named parts','Search replicated workspace objects','Scan',function() notify('Coin-named parts: '..countNamed('coin')) end)
  toggle('Coin markers','Label replicated coins in the map',false,updateMarkers)
  section('Coin system • diagnostics')
  local folder=workspace:FindFirstChild('Coins')
  textrow('Coin container','Checks workspace.Coins',folder and 'FOUND' or 'NOT FOUND')
  action('Scan coin objects','Count coin objects in your experience','Scan',function()
   local f=workspace:FindFirstChild('Coins'); notify(f and ('Coin objects: '..#f:GetChildren()) or 'workspace.Coins not found')
  end)
  section('Coin farm • configuration preview')
  preview('Auto collect coins','Requires your own coin collection API')
  preview('Float above coins','Movement integration preview')
  preview('Avoid threats','Role and distance integration preview')
  preview('Noclip mode','Movement integration preview')
  preview('Coin hitbox preview','Coin detector visualization')
  slider('Coin hitbox size','Visual preview in studs',1,30,6)
  slider('Tween speed','Preview speed value',1,100,25)
  slider('Collect distance','Preview distance in studs',1,50,10)
  slider('Teleport delay','Preview delay in tenths of a second',0,50,10)
  selector('Travel method','Configuration only',{'Tween','Instant','Path','None'})
  previewAction('Test collection route','Requires server-authorized collection')
  section('Survival farm • configuration preview')
  preview('Survival mode','Round-manager integration')
  preview('Avoid murderer','Requires server-provided role data')
  preview('Auto restart route','Round-manager integration')
  note('Collection, rewards and movement automation are not active in this client toolkit.')
 elseif tab=='Survival' then
  section('Character status')
  local hum=player.Character and player.Character:FindFirstChildOfClass('Humanoid')
  textrow('Current health','Locally replicated humanoid health',hum and math.floor(hum.Health)..' / '..math.floor(hum.MaxHealth) or 'Unknown')
  section('Round overview'); textrow('Character status','Current local player',player.Character and 'SPAWNED' or 'WAITING')
  action('Refresh status','Recheck character state','Refresh',function() render('Survival') end)
  section('Testing'); note('Round simulation and role state require your game round manager.')
 elseif tab=='Boxes' then
  section('Inventory'); textrow('Local inventory','Game-specific inventory integration','NOT LINKED')
  action('Inspect backpack','Count Roblox Tool objects','Inspect',function() local b=player:FindFirstChild('Backpack'); notify('Backpack tools: '..(b and #b:GetChildren() or 0)) end)
  section('Shop'); note('Box purchases and prestige require your game shop API.')
 elseif tab=='Servers' then
  section('Server actions')
  action('Rejoin current place','Uses Roblox TeleportService','Rejoin',function()
   local ok,err=pcall(function() game:GetService('TeleportService'):Teleport(game.PlaceId,player) end)
   if not ok then notify('Rejoin unavailable: '..tostring(err):sub(1,45)) end
  end)
  section('Current session'); textrow('Place ID','Current experience',game.PlaceId)
  textrow('Job ID','Current server identifier',game.JobId:sub(1,14)..'…')
  textrow('Population','Players currently connected',#Players:GetPlayers())
  action('Refresh server stats','Update the server information','Refresh',function() render('Servers') end)
 elseif tab=='Settings' then
  section('Theme & appearance')
  selector('Theme preset','Choose a menu accent preset',{'Violet','Pink','Blue'})
  action('Apply theme preset','Update UI accent for next render','Apply',function()
   local choice=state['Theme preset'] or 1
   C.purple=({Color3.fromRGB(153,91,255),Color3.fromRGB(225,42,129),Color3.fromRGB(65,145,255)})[choice]
   for _,o in ipairs(root:GetDescendants()) do
    if o:IsA('UIStroke') then o.Color=C.purple end
   end
   notify('Theme accent applied')
  end)
  section('Maintenance')
  action('Unload Violet Hub','Remove overlays and restore modified local visuals','Unload',cleanup)
  section('Configuration')
  action('Reset visual settings','Return camera and lighting to defaults','Reset',function() resetVisuals(); notify('Visual settings reset') end)
  textrow('Configuration storage','Settings are session-only; persistence requires your own game data store')
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
notify('Violet Hub v9.3 loaded • Drag title bar to move')
