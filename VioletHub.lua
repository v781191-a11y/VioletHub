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
