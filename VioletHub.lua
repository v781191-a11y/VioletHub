-- Violet Hub V9.5 | preserves V9 layout; client-side QA and authorized integrations
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
local subtitle=label(header,'v9.5  •  CLIENT TOOLKIT',10,C.muted); subtitle.Position=UDim2.fromOffset(20,31); subtitle.Size=UDim2.fromOffset(200,15)
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
