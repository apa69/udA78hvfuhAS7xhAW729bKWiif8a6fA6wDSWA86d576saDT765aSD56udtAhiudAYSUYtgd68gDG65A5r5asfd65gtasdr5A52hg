--=============================================================================
-- ACCESS CONTROL
-- you can run the script if ANY of these is true:
--   * your user id is the owner id
--   * your user id is in the whitelist (useWhitelist)
--   * you are friends with the owner id (useFriendCheck, this asks Roblox for your friend list, so it follows the owner's friend list)
-- everybody else gets kicked. set one of the two checks to false to turn it off.
-- (this runs on the client, so it keeps casual users out, it does not stop someone who edits the script)
--=============================================================================
local AUTH={
	owner=11814716094,
	whitelist={
		0,
	},
	useWhitelist=true,
	useFriendCheck=true,
	kickMessage="You're not whitelisted"
}
do
	if not game:IsLoaded() then
		game.Loaded:Wait()
	end
	local players=game:GetService("Players")
	local me=players.LocalPlayer
	while not me do
		players:GetPropertyChangedSignal("LocalPlayer"):Wait()
		me=players.LocalPlayer
	end
	local allowed=(me.UserId==AUTH.owner)
	if (not allowed) and AUTH.useWhitelist then
		allowed=table.find(AUTH.whitelist,me.UserId)~=nil
	end
	if (not allowed) and AUTH.useFriendCheck then
		--IsFriendsWith yields and errors when roblox is down, in that case nobody gets in
		local ok,friends=pcall(function()
			return me:IsFriendsWith(AUTH.owner)
		end)
		allowed=ok and (friends==true)
	end
	if not allowed then
		pcall(function()
			me:Kick(AUTH.kickMessage)
		end)
		return
	end
end

--no need to get and index the library tables with function names every time the script uses them
local osclock=os.clock
local tspawn=task.spawn
local tdelay=task.delay
local twait=task.wait
local schar=string.char
local ssub=string.sub
local sfind=string.find
local supper=string.upper
local mrandom=math.random
local sin=math.sin
local cos=math.cos
local abs=math.abs
local min=math.min
local sqrt=math.sqrt
local clamp=math.clamp
local tinsert=table.insert
local tclear=table.clear
local tclone=table.clone
local tfind=table.find
local cyield=coroutine.yield
local cresume=coroutine.resume
local crunning=coroutine.running
local vmagnitude=vector.magnitude --faster than indexing with Magnitude
local vnormalize=vector.normalize --faster than indexing with Unit

--the script doesnt have to read global varaibles every time to get them
--why not have them saved in local varaibles for faster access times
local next=next
local pcall=pcall
local xpcall=xpcall
local type=type
local typeof=typeof
local game=game
local sethiddenproperty=sethiddenproperty or set_hidden_property or sethiddenprop
local setscriptable=setscriptable or set_scriptable
local replicatesignal=replicatesignal or replicate_signal

local i=Instance.new 
local v2=Vector2.new 
local v3=Vector3.new
local c3=Color3.new 
local cf=CFrame.new
local cfl=CFrame.lookAt
local angles=CFrame.fromEulerAngles --faster than .Angles
local u2=UDim2.new 
local e=Enum 
local rp=RaycastParams.new 
local cs=ColorSequence.new 
local csk=ColorSequenceKeypoint.new 

local sine=osclock()
local deltaTime=0
local v3_0=v3()
local v3_101=v3(1,0,1)
local v3_010=v3(0,1,0)
local cf_0=cf()
local v3_xz=v3_101*10
local v3_xzL=v3_101*250.1
local v3_net=v3_010*25.01

local enumphysics=e.HumanoidStateType.Physics
local enumragdoll=e.HumanoidStateType.Ragdoll
local enumrunning=e.HumanoidStateType.Running
local enumseated=e.HumanoidStateType.Seated
local enumMD=e.MouseBehavior.Default

local sm=v3_010/2
local dense=PhysicalProperties.new(100,0,0,100,100)
local light=PhysicalProperties.new(0.0001,0,0,100,100)
local humstatesbl=e.HumanoidStateType:GetEnumItems()
table.remove(humstatesbl,tfind(humstatesbl,enumrunning))
table.remove(humstatesbl,tfind(humstatesbl,e.HumanoidStateType.None))

--not "local function rs" to not assign debug names
local rs=function()
	local s=""
	for i=1,mrandom(8,15) do
		if mrandom(2)==2 then
			s=s..schar(mrandom(65,90))
		else
			s=s..schar(mrandom(97,122))
		end
	end
	return s
end

--it runs even faster if u call __index and __newindex metamethods directly
local getMetamethodFromErrorStack=function(userdata,f,test)
	local ret=nil
	xpcall(f,function()
		ret=debug.info(2,"f")
	end,userdata,nil,0)
	if (type(ret)~="function") or not test(ret) then
		return f
	end
	return ret
end
local insSet=getMetamethodFromErrorStack(game,function(a,b,c) a[b]=c end,function(f) local a=i("Folder") local b=rs() f(a,"Name",b) return a.Name==b end)
local insGet=getMetamethodFromErrorStack(game,function(a,b) return a[b] end,function(f) local a=i("Folder") local b=rs() a.Name=b return f(a,"Name")==b end)
local cfGet=getMetamethodFromErrorStack(cf_0,function(a,b) return a[b] end,function(f) return f(cf(1,2,3),"Position")==v3(1,2,3) end)
local cfMul=getMetamethodFromErrorStack(cf_0,function(a,b) return a*b end,function(f) return angles(1,2,3)*angles(1,2,3)==f(angles(1,2,3),angles(1,2,3)) end)
local cfAdd=getMetamethodFromErrorStack(cf_0,function(a,b) return a+b end,function(f) return cf(1,2,3)+v3(1,2,3)==f(cf(1,2,3),v3(1,2,3)) end)
local v3Get=getMetamethodFromErrorStack(v3_0,function(a,b) return a[b] end,function(f) return v3(1,2,3).Unit==f(v3(1,2,3),"Unit") end)
local v2Get=getMetamethodFromErrorStack(v2(),function(a,b) return a[b] end,function(f) return f(v2(1,2),"Y")==2 end)
--multiplying and adding vector3 is faster if you use the * and + operators
--its faster to multiply X and Y of vector2 than to multiply vector2 and then get X and Y from it

--no need to index instances every time to call their functions
local Clone=insGet(game,"Clone")
local ClearAllChildren=insGet(game,"ClearAllChildren")
local Destroy=insGet(game,"Destroy")
local IsA=insGet(game,"IsA")
local FindFirstChildOfClass=insGet(game,"FindFirstChildOfClass")
local FindFirstChildWhichIsA=insGet(game,"FindFirstChildWhichIsA")
local GetChildren=insGet(game,"GetChildren")
local IsDescendantOf=insGet(game,"IsDescendantOf")
local QueryDescendants=insGet(game,"QueryDescendants")
local GetPropertyChangedSignal=insGet(game,"GetPropertyChangedSignal")

--findfirstchildofclass faster than getservice
local plrs=FindFirstChildOfClass(game,"Players")
local rus=FindFirstChildOfClass(game,"RunService")
local ws=FindFirstChildOfClass(game,"Workspace")
local uis=FindFirstChildOfClass(game,"UserInputService")
local gs=FindFirstChildOfClass(game,"GuiService")
local sg=FindFirstChildOfClass(game,"StarterGui")
local lp=insGet(plrs,"LocalPlayer")
local pg=FindFirstChildOfClass(lp,"PlayerGui")
local mouse=insGet(lp,"GetMouse")(lp)
local preanimation=insGet(rus,"PreAnimation")
local stepped=insGet(rus,"Stepped")
local heartbeat=insGet(rus,"Heartbeat")
local renderstepped=insGet(rus,"RenderStepped")

local GetPlayers=insGet(plrs,"GetPlayers")
local BreakJoints=insGet(i("Model"),"BreakJoints")
local ChangeState=insGet(i("Humanoid"),"ChangeState")
local SetStateEnabled=insGet(i("Humanoid"),"SetStateEnabled")
local GetJoints=insGet(insGet(ws,"Terrain"),"GetJoints")
local SetCoreGuiEnabled=insGet(sg,"SetCoreGuiEnabled")
local GetCoreGuiEnabled=insGet(sg,"GetCoreGuiEnabled")
local Raycast=insGet(ws,"Raycast")
local Connect=heartbeat.Connect
local Disconnect=Connect(GetPropertyChangedSignal(game,"CreatorId"),type).Disconnect
local Wait=heartbeat.Wait
local GetMouseLocation=insGet(uis,"GetMouseLocation")
local GetFocusedTextBox=insGet(uis,"GetFocusedTextBox")
local GetMouseDelta=insGet(uis,"GetMouseDelta")
local IsMouseButtonPressed=insGet(uis,"IsMouseButtonPressed")
local IsKeyDown=insGet(uis,"IsKeyDown")

local Inverse=cfGet(cf_0,"Inverse")
local Lerp=cfGet(cf_0,"Lerp")

local aligns={
	--[[
		example: 
		{PartName="Right Arm",meshid="123456789",textureid="123456789",AccessoryName="Name",C0=cf(1,2,3)*angles(1,2,3)},

		PartName (required) - the name of the body part you want to align the hat to
		meshid (optional) - mesh id of the mesh of the accessory you want to align
		textureid (optional) - texture id of the mesh of the accessory you want to align
		AccessoryName (optional) - instance name of the accessory you want to align 
		C0 (optional) - offset from the target body part to the accessory (defaults to cf(0,0,0) if unspecified)
		
		accessories will align to the first entry whose criteria they match
		(unspecified meshid/textureid/accessoryname accepts all accessories)
		
		each entry aligns one accessory at most
	]]

	-- unknown head
	{PartName="Head",meshid="11601535857",C0=angles(0,3.141592653589793,0)},

	-- patchma gear arms
	{PartName="Left Arm",meshid="13831073174",C0=cfMul(cf(0.017,0,-0.23),angles(-1.4835298641951802,-0.15707963267948966,2.199114857512855))},
	{PartName="Right Arm",meshid="13839903766",C0=cfMul(cf(0,-0.62,-0.01),angles(1.6580627893946132,0.15707963267948966,-2.199114857512855))},

	-- patchma yellow leg
	{PartName="Left Leg",meshid="11159370334",textureid="11159285454",C0=angles(1.5707963267948966,0,1.5707963267948966)},

	-- patchma lego piece leg
	{PartName="Right Leg",meshid="12652772399",textureid="12652775021",C0=cf(0,-0.125,0)},

	-- offsale white rig
	-- a ton of offsaled black torso's
	{PartName="Torso",meshid="14768666349"},
	{PartName="Torso",meshid="14241018198"},
	{PartName="Torso",meshid="13421774668"},
	{PartName="Left Leg",meshid="14255522247",C0=angles(1.5707963267948966,0,1.5707963267948966)},
	{PartName="Right Leg",meshid="14255522247",C0=angles(-1.5707963267948966,0,1.5707963267948966)},
	{PartName="Left Arm",meshid="14768684979",C0=angles(0,0,1.5707963267948966)},
	{PartName="Right Arm",meshid="14768684979",C0=angles(0,0,1.5707963267948966)},

	-- og fur body, r15 arms, smiley legs rig
	{PartName="Head",meshid="13953154391"},
	{PartName="Torso",meshid="13778226115"},
	{PartName="Left Leg",meshid="11159370334",textureid="11159284657",C0=angles(1.5707963267948966,0,1.5707963267948966)},
	{PartName="Right Leg",meshid="11263221350",textureid="11263219250",C0=angles(-1.5707963267948966,0,1.5707963267948966)},
	{PartName="Left Arm",meshid="12344207333",C0=angles(2,0,0)},
	{PartName="Right Arm",meshid="12344206657",C0=angles(2,0,0)},

	-- torso for both "white limbs black torso rig" and "black rig"
	{PartName="Torso",meshid="110684113028749"},
	-- white limbs black torso rig
	{PartName="Head",meshid="13058343355",C0=angles(0,3.141592653589793,0)},
	{PartName="Left Leg",meshid="139733645770094",C0=angles(0,0,1.5707963267948966)},
	{PartName="Right Leg",meshid="99608462237958",C0=angles(0,0,1.5707963267948966)},
	{PartName="Left Arm",meshid="90736849096372",C0=angles(0,0,1.5707963267948966)},
	{PartName="Right Arm",meshid="105141400603933",C0=angles(0,0,1.5707963267948966)},
	-- head for black rigs
	{PartName="Head",meshid="13953153289"},
	-- lay offsale black rig
	{PartName="Left Leg",meshid="17387586286",C0=angles(1.5707963267948966,0,1.5707963267948966)},
	{PartName="Right Leg",meshid="17387586286",C0=angles(-1.5707963267948966,0,1.5707963267948966)},
	{PartName="Left Arm",meshid="17374767929",C0=angles(1.5707963267948966,0,1.5707963267948966)},
	{PartName="Right Arm",meshid="17374767929",C0=angles(-1.5707963267948966,0,1.5707963267948966)},
	-- 7ws offsale black rig
	{PartName="Left Leg",meshid="125405780718494",C0=angles(1.5707963267948966,0,1.5707963267948966)},
	{PartName="Right Leg",meshid="125405780718494",C0=angles(-1.5707963267948966,0,1.5707963267948966)},
	{PartName="Left Arm",meshid="125405780718494",C0=angles(1.5707963267948966,0,1.5707963267948966)},
	{PartName="Right Arm",meshid="125405780718494",C0=angles(-1.5707963267948966,0,1.5707963267948966)},

	-- meshless rig
	{PartName="Head",meshid="13953094351"},
	{PartName="Torso",meshid="127552124837034",C0=angles(0,0,1.5707963267948966)},
	{PartName="Left Leg",meshid="121304376791439"},
	{PartName="Right Leg",meshid="121304376791439"},
	{PartName="Left Arm",meshid="117287001096396"},
	{PartName="Right Arm",meshid="117287001096396"},

	-- head for noob rig
	{PartName="Head",meshid="13058309233",C0=angles(0,3.141592653589793,0)},
	-- lay offsale noob rig
	{PartName="Torso",meshid="18640899369"},
	{PartName="Left Leg",meshid="18640901641"},
	{PartName="Right Leg",meshid="18640901641"},
	{PartName="Left Arm",meshid="18640914129"},
	{PartName="Right Arm",meshid="18640914129"},
	-- 7ws offsale noob rig
	{PartName="Torso",meshid="126825022897778"},
	{PartName="Left Leg",textureid="73798034827573",C0=angles(0,0,1.5707963267948966)},
	{PartName="Right Leg",textureid="73798034827573",C0=angles(0,0,1.5707963267948966)},
	{PartName="Left Arm",textureid="135650240593878",C0=angles(0,0,1.5707963267948966)},
	{PartName="Right Arm",textureid="135650240593878",C0=angles(0,0,1.5707963267948966)},

	-- white torso
	{PartName="Torso",meshid="126825022897778"},

	-- lay onsale gray torso white arm black leg rig
	{PartName="Torso",meshid="139792224823925"},
	{PartName="Left Leg",meshid="83395427313429",C0=angles(0,0,1.5707963267948966)},
	{PartName="Right Leg",meshid="83395427313429",C0=angles(0,0,1.5707963267948966)},
	{PartName="Left Arm",meshid="105263225400272",C0=angles(0,0,1.5707963267948966)},
	{PartName="Right Arm",meshid="105263225400272",C0=angles(0,0,1.5707963267948966)},

	-- shownape/geecee auto rig
	{PartName="Head",AccessoryName="Accessory (autorig_Head)"},
	{PartName="Torso",AccessoryName="Accessory (autorig_Torso)"},
	{PartName="Left Leg",AccessoryName="Accessory (autorig_LeftLeg)"},
	{PartName="Right Leg",AccessoryName="Accessory (autorig_RightLeg)"},
	{PartName="Left Arm",AccessoryName="Accessory (autorig_LeftArm)"},
	{PartName="Right Arm",AccessoryName="Accessory (autorig_RightArm)"},

	-- free rig
	{PartName="Left Arm",meshid="4324138105",textureid="4324138210",C0=angles(-1.6144295580947547,1.5707963267948966,0)*cf(-0.125,0.3,0)},
	{PartName="Left Arm",meshid="4154474745",textureid="4154474807",C0=angles(1.5271630954950384,-1.5707963267948966,0)*cf(-0.125,-0.3,0)},
	{PartName="Right Arm",meshid="3030546036",textureid="3650191503",C0=angles(1.5271630954950384,1.5707963267948966,0)*cf(0.125,-0.3,0)},
	{PartName="Right Arm",meshid="3030546036",textureid="3443321249",C0=angles(-1.6144295580947547,-1.5707963267948966,0)*cf(0.125,0.3,0)},
	{PartName="Left Leg",meshid="3030546036",textureid="3360974849",C0=angles(1.5271630954950384,1.5707963267948966,0)*cf(-0.125,-0.35,0)},
	{PartName="Left Leg",meshid="3030546036",textureid="3360978739",C0=angles(-1.6144295580947547,-1.5707963267948966,0)*cf(-0.125,0.3,0)},
	{PartName="Right Leg",meshid="3030546036",textureid="3033898741",C0=angles(1.5271630954950384,-1.5707963267948966,0)*cf(0.125,-0.35,0)},
	{PartName="Right Leg",meshid="3030546036",textureid="3409604993",C0=angles(-1.6144295580947547,1.5707963267948966,0)*cf(0.125,0.3,0)},
	{PartName="Torso",meshid="4819720316",textureid="4819722776",C0=angles(0,0,0.2617993877991494)}
}

local makeplaceholder=function(v)
	if not insGet(v,"Archivable") then
		insSet(v,"Archivable",true)
	end
	v=Clone(v)
	local mesh=FindFirstChildOfClass(v,"SpecialMesh")
	if mesh then
		insSet(mesh,"Parent",nil)
		ClearAllChildren(v)
		ClearAllChildren(mesh)
		insSet(mesh,"Name",rs())
		insSet(mesh,"Parent",v)
	else
		ClearAllChildren(v)
	end
	insSet(v,"Name",rs())
	insSet(v,"Anchored",true)
	insSet(v,"CanCollide",false)
	insSet(v,"Transparency",0.25)
	return v
end
local emptyfunction=function() end
local allowshiftlock=nil
local ctrltp=nil
local placeholders=nil
local clickfling=nil
local flingoffset=nil
local flingvel=nil
local flingrotvel=nil
local flingtargetting=nil
local highlightflingtargets=nil
local discharscripts=nil
local flingchangestate=nil
local respawntp=nil
local disguiscripts=nil
local breakjointsmethod=nil
local simrad=false
local hidedeatheffect=nil

local c=nil
local cons={}
local cframes={}
local hrpcon0=nil
local hrpcon1=nil
local flingtable={}
local plrcleanups={}
local onnewcamera=nil

--settings, the old patchma settings list is gone. these are the values its defaults had (ctrl click tp and click fling are on)
local hlparent=nil --where the fling highlights go, set when the gui is built
local restoreAllowSleep=nil
placeholders=true
highlightflingtargets=true
allowshiftlock=true
ctrltp=false --off: left click is used by the weapons
clickfling=false
flingtargetting=(sethiddenproperty and 3) or (setscriptable and 2) or 0
flingoffset=-v3_010
flingvel=v3(0,16000,0)
flingrotvel=v3(16000,0,16000)
flingchangestate=3
respawntp=3
disguiscripts=true
discharscripts=function(v)
	if IsA(v,"Script") then --mind Enum.RunContext.Client
		insSet(v,"Disabled",true)
	end
end
breakjointsmethod=(replicatesignal and 4) or 1
hidedeatheffect=true
simrad=true

local stopreanimate=function() 
	if c then
		c=nil
		for i,v in next,cframes do
			local p=i.v
			if p then
				Destroy(p)
			end
		end
		tclear(cframes)
		if hrpcon0 then
			Disconnect(hrpcon0)
			Disconnect(hrpcon1)
			hrpcon0=nil
		end
		for i,v in next,flingtable do
			if v then --it could be false
				Destroy(v)
			end
		end
		tclear(flingtable)
		for i,v in next,cons do
			Disconnect(v)
		end
		tclear(cons)
		for i,cleanupfunc in next,plrcleanups do
			cleanupfunc()
		end
		tclear(plrcleanups)
		insSet(uis,"MouseBehavior",enumMD)
		if restoreAllowSleep then
			restoreAllowSleep()
			restoreAllowSleep=nil
		end
		onnewcamera()
		return true
	end
	return false
end
local reanimate=function()
	--[[
		FDless reanimate by MyWorld continued by rqz
		optimize the optimized
	]]
	local novoid=true --prevents parts from going under workspace.FallenPartsDestroyHeight if you control them
	local speedlimit=3000 --makes your parts move slower if the magnitude of their velocity is higher than this
	local retVelTime=0.51 --time that claimed parts have velocity to reclaim in case u lose them
	local walkSpeed=16 --your walkspeed (can be changed at runtime)
	local jumpPower=50 --your jump power (can be changed at runtime)
	local gravity=196.2 --how fast the characters velocity decreases while falling (can be changed at runtime)
	local ctrlclicktp=ctrltp --makes you teleport where u point ur mouse cursor at when click and hold ctrl down

	if stopreanimate() then return end

	local cam=nil
	--theres a way to have ws.currentcamera nil on heartbeat and still have the game run normally
	local refcam=function()
		local newcam=insGet(ws,"CurrentCamera")
		while not newcam do
			Wait(GetPropertyChangedSignal(ws,"CurrentCamera"))
			newcam=insGet(ws,"CurrentCamera")
		end
		cam=newcam
	end
	refcam()
	local camcf=insGet(cam,"CFrame")
	local enumCamS=e.CameraType.Scriptable
	local camt=insGet(cam,"CameraType")
	local camcon0=nil
	local camcon1=nil
	local camcon2=nil
	onnewcamera=function()
		refcam()
		if camcon0 then 
			Disconnect(camcon0)
			Disconnect(camcon1)
			camcon0=nil
		end
		if not c then 
			if insGet(cam,"CameraType")==enumCamS then
				insSet(cam,"CameraType",camt)
			end
			return Disconnect(camcon2) 
		end
		camcon0=Connect(GetPropertyChangedSignal(cam,"CFrame"),function()
			if insGet(cam,"CFrame")~=camcf then
				insSet(cam,"CFrame",camcf)
			end
		end)
		camcon1=Connect(GetPropertyChangedSignal(cam,"CameraType"),function()
			if insGet(cam,"CameraType")~=enumCamS then
				insSet(cam,"CameraType",enumCamS)
			end
		end)
		if insGet(cam,"CameraType")~=enumCamS then
			insSet(cam,"CameraType",enumCamS)
		end
		if insGet(cam,"CFrame")~=camcf then
			insSet(cam,"CFrame",camcf)
		end
	end
	camcon2=Connect(GetPropertyChangedSignal(ws,"CurrentCamera"),onnewcamera)

	local wsGravity=insGet(ws,"Gravity")
	tinsert(cons,Connect(GetPropertyChangedSignal(ws,"Gravity"),function()
		wsGravity=insGet(ws,"Gravity")
	end))

	local fpdh=insGet(ws,"FallenPartsDestroyHeight")
	novoid=novoid and (fpdh+1)

	local cfr=nil
	c=insGet(lp,"Character")
	if c and IsDescendantOf(c,ws) then
		cfr=QueryDescendants(c,">BasePart#HumanoidRootPart")[1] or QueryDescendants(c,">BasePart#Torso")[1] or QueryDescendants(c,">BasePart#UpperTorso")[1] or FindFirstChildWhichIsA(c,"BasePart")
		if cfr then
			cfr=insGet(cfr,"CFrame")
		else
			cfr=cfMul(insGet(cam,"Focus"),cf(0,-1.5,0))
		end
	else
		c=true
		cfr=cfMul(insGet(cam,"Focus"),cf(0,-1.5,0))
	end

	onnewcamera()

	local Yvel=0
	local pos=cfGet(cfr,"Position")
	cfr=cfl(pos,pos+cfGet(cfr,"LookVector")*v3_101)
	local primarypart=nil
	local shiftlock=false
	local firstperson=false
	local xzvel=v3_0
	local v3_0150=v3_010*1.5
	local camcfLV=cfGet(camcf,"LookVector")
	local camrot=cfl(v3_0,camcfLV)
	local camrotX,camrotY=cfGet(camrot,"ToEulerAnglesYXZ")(camrot)
	local camcfRV=cfGet(camrot,"RightVector")
	local cammag=-vmagnitude((cfGet(camcf,"Position")-(pos+v3_0150)))
	
	local R6parts={ 
		head={Name="Head"},
		torso={Name="Torso"},
		root={Name="HumanoidRootPart"},
		leftArm={Name="Left Arm"},
		rightArm={Name="Right Arm"},
		leftLeg={Name="Left Leg"},
		rightLeg={Name="Right Leg"}
	}
	local rootpart=R6parts.root
	for i,v in next,R6parts do
		cframes[v]=cfr
	end
	local joints={
		{
			Name="Neck",
			Part0=R6parts.torso,Part1=R6parts.head,
			C0=cf(0,1,0,-1,0,0,0,0,1,0,1,-0),
			C1=cf(0,-0.5,0,-1,0,0,0,0,1,0,1,-0)
		},
		{
			Name="RootJoint",
			Part0=rootpart,Part1=R6parts.torso,
			C0=cf(0,0,0,-1,0,0,0,0,1,0,1,-0),
			C1=cf(0,0,0,-1,0,0,0,0,1,0,1,-0)
		},
		{
			Name="Right Shoulder",
			Part0=R6parts.torso,Part1=R6parts.rightArm,
			C0=cf(1,0.5,0,0,0,1,0,1,-0,-1,0,0),
			C1=cf(-0.5,0.5,0,0,0,1,0,1,-0,-1,0,0)
		},
		{
			Name="Left Shoulder",
			Part0=R6parts.torso,Part1=R6parts.leftArm,
			C0=cf(-1,0.5,0,0,0,-1,0,1,0,1,0,0),
			C1=cf(0.5,0.5,0,0,0,-1,0,1,0,1,0,0)
		},
		{
			Name="Right Hip",
			Part0=R6parts.torso,Part1=R6parts.rightLeg,
			C0=cf(1,-1,0,0,0,1,0,1,-0,-1,0,0),
			C1=cf(0.5,1,0,0,0,1,0,1,-0,-1,0,0)
		},
		{
			Name="Left Hip",
			Part0=R6parts.torso,Part1=R6parts.leftLeg,
			C0=cf(-1,-1,0,0,0,-1,0,1,0,1,0,0),
			C1=cf(-0.5,1,0,0,0,-1,0,1,0,1,0,0)
		}
	}

	local refreshedjoints={}
	local refreshjointsI=nil
	refreshjointsI=function(part)
		refreshedjoints[part]=true
		for i,v in next,joints do
			local part0=v.Part0
			local part1=v.Part1
			if part1 and (part0==part) then
				cframes[part1]=cfMul(cframes[part],cfMul(v.C0,Inverse(v.C1)))
				if not refreshedjoints[part1] then
					refreshjointsI(part1)
				end
			elseif part0 and (part1==part) then
				cframes[part0]=cfMul(cframes[part],cfMul(v.C1,Inverse(v.C0)))
				if not refreshedjoints[part0] then
					refreshjointsI(part0)
				end
			end
		end
	end
	refreshjointsI(rootpart)
	tclear(refreshedjoints)

	local attachments={
		RightShoulderAttachment={R6parts.rightArm,cf(0,1,0,1,0,0,0,1,0,0,0,1)},
		RightGripAttachment={R6parts.rightArm,cf(0,-1,0,1,0,0,0,1,0,0,0,1)},
		LeftFootAttachment={R6parts.leftLeg,cf(0,-1,0,1,0,0,0,1,0,0,0,1)},
		LeftShoulderAttachment={R6parts.leftArm,cf(0,1,0,1,0,0,0,1,0,0,0,1)},
		LeftGripAttachment={R6parts.leftArm,cf(0,-1,0,1,0,0,0,1,0,0,0,1)},
		RootAttachment={rootpart,cf(0,0,0,1,0,0,0,1,0,0,0,1)},
		RightFootAttachment={R6parts.rightLeg,cf(0,-1,0,1,0,0,0,1,0,0,0,1)},
		NeckAttachment={R6parts.torso,cf(0,1,0,1,0,0,0,1,0,0,0,1)},
		BodyFrontAttachment={R6parts.torso,cf(0,0,-0.5,1,0,0,0,1,0,0,0,1)},
		BodyBackAttachment={R6parts.torso,cf(0,0,0.5,1,0,0,0,1,0,0,0,1)},
		LeftCollarAttachment={R6parts.torso,cf(-1,1,0,1,0,0,0,1,0,0,0,1)},
		RightCollarAttachment={R6parts.torso,cf(1,1,0,1,0,0,0,1,0,0,0,1)},
		WaistFrontAttachment={R6parts.torso,cf(0,-1,-0.5,1,0,0,0,1,0,0,0,1)},
		WaistCenterAttachment={R6parts.torso,cf(0,-1,0,1,0,0,0,1,0,0,0,1)},
		WaistBackAttachment={R6parts.torso,cf(0,-1,0.5,1,0,0,0,1,0,0,0,1)},
		HairAttachment={R6parts.head,cf(0,0.6,0,1,0,0,0,1,0,0,0,1)},
		HatAttachment={R6parts.head,cf(0,0.6,0,1,0,0,0,1,0,0,0,1)},
		FaceFrontAttachment={R6parts.head,cf(0,0,-0.6,1,0,0,0,1,0,0,0,1)},
		FaceCenterAttachment={R6parts.head,cf(0,0,0,1,0,0,0,1,0,0,0,1)}
	}

	local getPart=function(name,blacklist)
		if blacklist then
			for i,v in next,cframes do
				if (i.Name==name) and not tfind(blacklist,i) then
					return i
				end
			end
		else
			for i,v in next,cframes do
				if i.Name==name then
					return i
				end
			end
		end
		return nil
	end

	local getJoint=function(name)
		for i,v in next,joints do
			if v.Name==name then
				return v
			end
		end
		return {C0=cf_0,C1=cf_0}
	end

	local getPartFromMesh=function(m,t,blacklist)
		if blacklist then
			for v,_ in next,cframes do
				if v.m and (not tfind(blacklist,v)) and sfind(v.m,m) and sfind(v.t,t) then
					return v
				end
			end
		else
			for v,_ in next,cframes do
				if v.m and sfind(v.m,m) and sfind(v.t,t) then
					return v
				end
			end
		end
		local p={m=m,t=t}
		cframes[p]=cfr
		local j={C0=cf_0,C1=cf_0,Part0=p}
		p.j=j
		return p
	end
	local getPartJoint=function(p)
		if cframes[p] then
			local j=p.j
			if j then
				return j
			end
			for i,v in next,joints do
				if v.Part0==p then
					return v
				end
			end
			for i,v in next,joints do
				if v.Part1==p then
					return v
				end
			end
		end
		return nil
	end

	local getAccWeldFromMesh=function(m,t)
		return getPartJoint(getPartFromMesh(m,t))
	end

	local raycastparams=rp()
	raycastparams.FilterType=e.RaycastFilterType.Exclude
	raycastparams.RespectCanCollide=true
	local rayfilter={}
	local characters={}
	local refreshrayfilter=function()
		tclear(rayfilter)
		for i,v in next,characters do
			tinsert(rayfilter,v)
		end
		raycastparams.FilterDescendantsInstances=rayfilter
	end
	local rootparts={}
	for i,v in next,aligns do
		v.p=getPart(v.PartName)
		if not v.meshid then
			v.meshid=""
		end 
		if not v.textureid then
			v.textureid=""
		end 
	end
	local makePartCons=function(p,t)
		if (t.p==p) and insGet(p,"Anchored") then
			t.p=nil
		end
		local con0=Connect(GetPropertyChangedSignal(p,"Anchored"),function()
			if insGet(p,"Anchored") then
				if t.p==p then
					t.c=nil
					t.p=nil
				end
			elseif not t.p then
				t.p=p
			end
		end)
		local con1=nil
		con1=Connect(insGet(p,"AncestryChanged"),function()
			if not IsDescendantOf(p,ws) then
				Disconnect(con0)
				Disconnect(con1)
				if t.p==p then
					t.p=nil
				end
			end
		end)
	end
	local ondes=function(v)
		if IsA(v,"Attachment") then
			local v1=attachments[insGet(v,"Name")]
			if v1 then
				local p=insGet(v,"Parent")
				if insGet(p,"Parent")~=c then
					local meshid=nil
					local textureid=nil
					if IsA(p,"MeshPart") then
						meshid=insGet(p,"MeshId")
						textureid=insGet(p,"TextureID")
					elseif IsA(p,"BasePart") then
						local sm=FindFirstChildOfClass(p,"SpecialMesh")
						if sm then
							meshid=insGet(sm,"MeshId")
							textureid=insGet(sm,"TextureId")
						else
							meshid=""
							textureid=""
						end
					else
						return
					end
					for i,_ in next,cframes do
						if (meshid==i.m) and (textureid==i.t) then
							local p1=i.p
							if p1 then
								if p1==p then
									return
								end
							else
								i.p=p
								makePartCons(p,i)
								return
							end
						else
							local j=i.j
							if j and sfind(meshid,i.m) and sfind(textureid,i.t) then
								i.m=meshid
								i.t=textureid
								i.l=insGet(p,"Position")
								i.p=p
								makePartCons(p,i)
								i.j=nil
								i.Name=insGet(p,"Name")
								j.C0=insGet(v,"CFrame")
								j.C1=v1[2]
								j.Part1=v1[1]
								tinsert(joints,j)
								return
							end
						end
					end
					local n=insGet(insGet(p,"Parent"),"Name")
					for i,l in next,aligns do
						if l.p and sfind(meshid,l.meshid) and sfind(textureid,l.textureid) and ((not l.AccessoryName) or (l.AccessoryName==n)) then
							local t={Name=insGet(p,"Name"),l=insGet(p,"Position"),m=meshid,t=textureid,p=p}
							makePartCons(p,t)
							if placeholders then
								t.v=makeplaceholder(p)
								t.b=false
							end
							cframes[t]=insGet(p,"CFrame")
							tinsert(joints,{Part0=t,Part1=l.p,C0=l.C0 or cf_0,C1=cf_0})
							l.p=nil
							return
						end
					end
					local t={Name=insGet(p,"Name"),l=insGet(p,"Position"),m=meshid,t=textureid,p=p}
					makePartCons(p,t)
					if placeholders then
						t.v=makeplaceholder(p)
						t.b=false
					end
					cframes[t]=insGet(p,"CFrame")
					tinsert(joints,{Part0=t,Part1=v1[1],C0=insGet(v,"CFrame"),C1=v1[2]})
				end
			end
		end
	end
	
	local simradv=1000
	local enumH=e.CoreGuiType.Health
	local onplayer=function(v)
		simradv=simradv+1000
		local lastc=nil
		local con0=nil
		local con1=nil
		local oncharacter=function()
			local newc=insGet(v,"Character")
			if newc and (newc~=lastc) then
				lastc=newc

				if con0 then
					Disconnect(con0)
					Disconnect(con1)
					con0=nil
				end

				characters[v]=newc
				refreshrayfilter()

				local hrp=QueryDescendants(newc,">BasePart#HumanoidRootPart")[1]
				if hrp then
					rootparts[v]=hrp
				else
					local refresh=true					
					local threshold=false
					tdelay(0.5,function()
						refresh=true
						threshold=true
					end)
					con0=Connect(preanimation,function()
						if refresh then
							if threshold then
								hrp=QueryDescendants(newc,">BasePart#HumanoidRootPart")[1] or QueryDescendants(newc,">BasePart#Torso")[1] or QueryDescendants(newc,">BasePart#UpperTorso")[1] or FindFirstChildWhichIsA(newc,"BasePart")
							else
								hrp=QueryDescendants(newc,">BasePart#HumanoidRootPart")[1]
							end
							if hrp then
								rootparts[v]=hrp
								Disconnect(con0)
								Disconnect(con1)
								con0=nil
								return
							end
							refresh=false
						end
					end)
					con1=Connect(insGet(newc,"ChildAdded"),function()
						refresh=true
					end)
				end
			end
		end

		local charcon=Connect(GetPropertyChangedSignal(v,"Character"),oncharacter)
		oncharacter()
		plrcleanups[v]=function()
			simradv=simradv-1000
			characters[v]=nil
			rootparts[v]=nil
			if con0 then
				Disconnect(con0)
				Disconnect(con1)
				con0=nil
			end
			Disconnect(charcon)
		end
	end
	tinsert(cons,Connect(insGet(plrs,"PlayerRemoving"),function(v)
		local cleanup=plrcleanups[v]
		if cleanup then
			cleanup()
			plrcleanups[v]=nil
		end
	end))
	for i,v in next,GetPlayers(plrs) do simradv=simradv+1000 if v~=lp then tspawn(onplayer,v) end end
	tinsert(cons,Connect(insGet(plrs,"PlayerAdded"),onplayer))
	if disguiscripts then
		tinsert(cons,Connect(insGet(pg,"DescendantAdded"),function(v)
			if IsA(v,"Script") then --mind Enum.RunContext.Client
				insSet(v,"Disabled",true) 
			end
		end))
	end

	local lastc=nil
	local oncharacter=function()
		local newc=insGet(lp,"Character")
		if newc and (newc~=lastc) then
			lastc=newc

			if hrpcon0 then
				Disconnect(hrpcon0)
				Disconnect(hrpcon1)
				hrpcon0=nil
			end

			if discharscripts then
				Connect(insGet(newc,"DescendantAdded"),discharscripts)
				for i,v in next,QueryDescendants(newc,"Script") do
					insSet(v,"Disabled",true)
				end
			end

			characters[lp]=newc
			refreshrayfilter()
			
			local hrp=QueryDescendants(newc,">BasePart#HumanoidRootPart")[1]
			if not hrp then
				local refresh=true
				local threshold=false
				tdelay(0.5,function()
					refresh=true
					threshold=true
				end)
				local thread=crunning()
				hrpcon1=Connect(preanimation,function()
					if refresh then
						if threshold then
							hrp=QueryDescendants(newc,">BasePart#HumanoidRootPart")[1] or QueryDescendants(newc,">BasePart#Torso")[1] or QueryDescendants(newc,">BasePart#UpperTorso")[1] or FindFirstChildWhichIsA(newc,"BasePart")
						else
							hrp=QueryDescendants(newc,">BasePart#HumanoidRootPart")[1]
						end
						if hrp then
							Disconnect(hrpcon0)
							Disconnect(hrpcon1)
							hrpcon0=nil
							cresume(thread)
							return
						end
						refresh=false
					end
				end)
				hrpcon0=Connect(insGet(newc,"ChildAdded"),function()
					refresh=true
				end)
				cyield()
				Wait(stepped)
			end
			
			c=newc
			if next(flingtable) then
				local hum=FindFirstChildOfClass(c,"Humanoid")
				if hum then
					if flingchangestate==3 then
						ChangeState(hum,enumphysics)
						SetStateEnabled(hum,enumseated,false)
					elseif flingchangestate==1 then
						ChangeState(hum,enumphysics)
					else
						if flingchangestate==2 then
							SetStateEnabled(hum,enumseated,false)
						end
						if flingtargetting~=0 then
							ChangeState(hum,enumragdoll)
							SetStateEnabled(hum,enumrunning,false)
						end
					end
				end
				twait(0.25)
				for i1,v in next,tclone(flingtable) do
					if not c then
						return
					end
					if flingtargetting==3 then
						sethiddenproperty(hrp,"PhysicsRepRootPart",i1)
					elseif flingtargetting==2 then
						setscriptable(hrp,"PhysicsRepRootPart",true)
						insSet(hrp,"PhysicsRepRootPart",i1)
						setscriptable(hrp,"PhysicsRepRootPart",false)
					elseif flingtargetting==1 then
						local hrpcpp=insGet(hrp,"CustomPhysicalProperties")
						local tparent=insGet(i1,"Parent")
						local tcfr=insGet(i1,"CFrame")

						local model=i("Model")
						local hum=i("Humanoid",model)
						for i,v in next,humstatesbl do
							SetStateEnabled(hum,v,false)
						end

						local restorejoints={}
						for i,v in next,GetJoints(hrp) do
							restorejoints[v]=insGet(v,"Parent")
							insSet(v,"Parent",nil)
						end
						for i,v in next,GetJoints(i1) do
							restorejoints[v]=insGet(v,"Parent")
							insSet(v,"Parent",nil)
						end

						local tcfr1=cf(cfGet(tcfr,"Position")+v3_010*mrandom(10000,20000))
						insSet(i1,"Parent",ws)
						insSet(i1,"CFrame",tcfr1)
						insSet(hrp,"Parent",model)
						insSet(hrp,"CFrame",tcfr1+(insGet(hrp,"Size")+insGet(i1,"Size"))*sm)
						insSet(i1,"CustomPhysicalProperties",dense)
						insSet(hrp,"CustomPhysicalProperties",light)
						insSet(model,"Parent",ws)
						ChangeState(hum,enumrunning)
						if not insGet(i1,"CanCollide") then
							insSet(i1,"CanCollide",true)
						end
						Wait(stepped)
						for i,v in next,restorejoints do
							insSet(i,"Parent",v)
						end
						insSet(i1,"CFrame",tcfr)
						insSet(i1,"Parent",tparent)
						insSet(hrp,"CustomPhysicalProperties",hrpcpp)
						insSet(hrp,"Parent",newc)
						Destroy(model)
					end
					local startpos=insGet(i1,"Position")
					local stoptime=sine+(((flingtargetting~=0) and 0.1) or 3)
					while true do
						if insGet(i1,"Anchored") or not IsDescendantOf(i1,ws) then
							break
						end
						if vmagnitude(startpos-insGet(i1,"Position"))>200 then
							break
						end
						if flingtargetting~=0 then
							local tcf=cfAdd(insGet(i1,"CFrame"),flingoffset)
							if novoid and (cfGet(tcf,"Y")<novoid) then
								tcf=cfAdd(tcf,v3_010*(novoid-cfGet(tcf,"Y")))
							end
							insSet(hrp,"CFrame",tcf)
							insSet(hrp,"AssemblyLinearVelocity",flingvel)
						else
							local tcf=cfAdd(insGet(i1,"CFrame"),insGet(i1,"AssemblyLinearVelocity")*(sin(sine*15)+1)+flingoffset)
							if novoid and (cfGet(tcf,"Y")<novoid) then
								tcf=cfAdd(tcf,v3_010*(novoid-cfGet(tcf,"Y")))
							end
							insSet(hrp,"CFrame",tcf)
							insSet(hrp,"AssemblyLinearVelocity",insGet(i1,"AssemblyLinearVelocity")*v3_101*75)
						end
						insSet(hrp,"AssemblyAngularVelocity",flingrotvel)
						if sine>stoptime then
							break
						end
						twait()
					end
					if v then
						Destroy(v)
					end
					flingtable[i1]=nil
				end
				if flingtargetting==3 then
					sethiddenproperty(hrp,"PhysicsRepRootPart",nil)
				elseif flingtargetting==2 then
					setscriptable(hrp,"PhysicsRepRootPart",true)
					insSet(hrp,"PhysicsRepRootPart",nil)
					setscriptable(hrp,"PhysicsRepRootPart",false)
				elseif flingtargetting==1 then
					SetStateEnabled(hum,enumrunning,true)
					ChangeState(hum,enumrunning)
				end
				if respawntp==0 then
					insSet(hrp,"AssemblyLinearVelocity",v3_0)
					insSet(hrp,"AssemblyAngularVelocity",v3_0)
					insSet(hrp,"CFrame",cfr)
					twait(0.3)
				end
			end
			if respawntp==0 then
				twait()
			elseif respawntp==1 then
				local startpos=pos+v3(mrandom(-32,32),0,mrandom(-32,32))
				local dir=nil
				local poscheck=true
				while poscheck do
					poscheck=false
					for i,v in next,rootparts do
						local diff=(startpos-insGet(v,"Position"))*v3_101
						if vmagnitude(diff)<10 then
							poscheck=true
							dir=dir or (vnormalize(diff)*3)
							startpos=startpos+dir
						end
					end
					local diff=(startpos-pos)*v3_101
					if vmagnitude(diff)<10 then
						poscheck=true
						dir=dir or (vnormalize(diff)*3)
						startpos=startpos+dir
					end
				end
				startpos=cfAdd(cfGet(cfr,"Rotation"),startpos)
				insSet(hrp,"CFrame",startpos)
				insSet(hrp,"AssemblyLinearVelocity",v3_0)
				insSet(hrp,"AssemblyAngularVelocity",v3_0)
				twait(0.3)
			elseif respawntp==2 then
				insSet(hrp,"CFrame",cfAdd(cfr,cfGet(cfr,"RightVector")*3.5-cfGet(cfr,"LookVector")*3.5))
				insSet(hrp,"AssemblyLinearVelocity",v3_0)
				insSet(hrp,"AssemblyAngularVelocity",v3_0)
				twait(0.3)
			elseif respawntp==3 then
				local t=osclock()+0.3
				local startcf=cfAdd(cfMul(cfGet(cfr,"Rotation"),angles(1.5707963267948966,0,0)),pos*v3_101+v3_010*min(fpdh+30,v3Get(pos,"Y")-5))
				while twait() do
					insSet(hrp,"CFrame",startcf)
					insSet(hrp,"AssemblyLinearVelocity",v3_0)
					insSet(hrp,"AssemblyAngularVelocity",v3_0)
					if osclock()>t then
						break
					end
				end
			end
			if newc~=c then
				return
			end
			primarypart=insGet(newc,"PrimaryPart") or hrp
			if hidedeatheffect and GetCoreGuiEnabled(sg,enumH) then
				SetCoreGuiEnabled(sg,enumH,false)
			end
			--accessories whose attachments the rig doesnt know would be left behind as loose parts once the joints break (thats the hats falling off),
			--so remember where they are now and keep them on the root part afterwards
			local looseacc={}
			local hrpcf=hrp and insGet(hrp,"CFrame")
			for _,acc in next,GetChildren(newc) do
				if hrpcf and IsA(acc,"Accoutrement") then
					local handle=acc:FindFirstChild("Handle")
					if handle and IsA(handle,"BasePart") then
						local known=false
						for _,a in next,GetChildren(handle) do
							if IsA(a,"Attachment") and attachments[insGet(a,"Name")] then
								known=true
								break
							end
						end
						if not known then
							tinsert(looseacc,{handle,cfMul(Inverse(hrpcf),insGet(handle,"CFrame"))})
						end
					end
				end
			end
			if breakjointsmethod==4 then
				local h=FindFirstChildOfClass(newc,"Humanoid")
				if h then
					replicatesignal(insGet(h,"ServerBreakJoints"))
				else
					BreakJoints(newc)
				end
			elseif breakjointsmethod==1 then
				BreakJoints(newc)
				local h=FindFirstChildOfClass(newc,"Humanoid")
				if h then
					insSet(h,"Health",0)
				end
			elseif breakjointsmethod==2 then
				local h=FindFirstChildOfClass(newc,"Humanoid")
				if h then
					insSet(h,"Health",0)
				else
					BreakJoints(newc)
				end
			else
				BreakJoints(newc)
			end
			cons.ondes=Connect(insGet(newc,"DescendantAdded"),ondes)
			for i,v in next,QueryDescendants(newc,"Attachment") do
				ondes(v)
			end
			for _,l in next,looseacc do
				local p=l[1]
				local meshid,textureid="",""
				if IsA(p,"MeshPart") then
					meshid=insGet(p,"MeshId")
					textureid=insGet(p,"TextureID")
				else
					local sm=FindFirstChildOfClass(p,"SpecialMesh")
					if sm then
						meshid=insGet(sm,"MeshId")
						textureid=insGet(sm,"TextureId")
					end
				end
				local t={Name=insGet(p,"Name"),l=insGet(p,"Position"),m=meshid,t=textureid,p=p}
				makePartCons(p,t)
				if placeholders then
					t.v=makeplaceholder(p)
					t.b=false
				end
				cframes[t]=insGet(p,"CFrame")
				tinsert(joints,{Part0=t,Part1=rootpart,C0=cf_0,C1=l[2]})
			end
		end
	end
	tinsert(cons,Connect(GetPropertyChangedSignal(lp,"Character"),oncharacter))
	oncharacter()

	--parts only stay yours while the server thinks they are inside your simulation radius, so make it as big as it goes
	--(the old version only tried a plain assignment, which fails on most executors and then silently did nothing)
	local setsimrad=emptyfunction
	if simrad then
		local simsetters={
			function(n)
				insSet(lp,"SimulationRadius",n)
				insSet(lp,"MaximumSimulationRadius",n)
			end,
			sethiddenproperty and function(n)
				sethiddenproperty(lp,"SimulationRadius",n)
				sethiddenproperty(lp,"MaximumSimulationRadius",n)
			end,
			setscriptable and function(n)
				setscriptable(lp,"SimulationRadius",true)
				setscriptable(lp,"MaximumSimulationRadius",true)
				insSet(lp,"SimulationRadius",n)
				insSet(lp,"MaximumSimulationRadius",n)
			end
		}
		setsimrad=function()
			for k=1,3 do
				local f=simsetters[k]
				if f and pcall(f,simradv) then
					setsimrad=function()
						f(simradv)
					end
					return
				end
			end
			setsimrad=emptyfunction
		end
	end
	pcall(function()
		local physics=settings().Physics
		local oldAllowSleep=physics.AllowSleep
		physics.AllowSleep=false --sleeping parts stop being simulated and then dont follow you anymore
		restoreAllowSleep=function()
			pcall(function()
				settings().Physics.AllowSleep=oldAllowSleep
			end)
		end
	end)

	local mradN05=-0.008726646259971648
	local pi2=math.pi/2-0.0001
	local npi2=-pi2
	local KeyCode=e.KeyCode
	local enumYXZ=e.RotationOrder.YXZ
	local enumMB2=e.UserInputType.MouseButton2
	local enumMLCP=e.MouseBehavior.LockCurrentPosition
	local enumMLC=(insGet(uis,"TouchEnabled") and enumMLCP) or e.MouseBehavior.LockCenter 
	local enumMW=e.UserInputType.MouseWheel
	local enumMM=e.UserInputType.MouseMovement

	local mouseBehavior=insGet(uis,"MouseBehavior")
	tinsert(cons,Connect(GetPropertyChangedSignal(uis,"MouseBehavior"),function()
		if insGet(uis,"MouseBehavior")~=mouseBehavior then
			insSet(uis,"MouseBehavior",mouseBehavior)
		end
	end))

	local mode="default"
	local defaultmode={}
	local modes={default=defaultmode}
	--things the script on top of the engine can hook into: frame (called every frame before the joints get refreshed), noFling, lastroot
	local hooks={}

	local lerpsIdle=emptyfunction
	local lerpsWalk=emptyfunction
	local lerpsJump=emptyfunction
	local lerpsFall=emptyfunction

	local addmode=function(key,mode)
		if (type(key)~="string") or (type(mode)~="table") then
			return
		end
		for i,v in next,mode do
			if type(v)~="function" then
				mode[i]=nil
			end
		end
		if key=="default" then
			defaultmode=mode
			modes.default=mode
			lerpsIdle=mode.idle or emptyfunction
			lerpsWalk=mode.walk or emptyfunction
			lerpsJump=mode.jump or emptyfunction
			lerpsFall=mode.fall or emptyfunction
			if mode.modeEntered then
				mode.modeEntered()
			end
		elseif #key==1 then
			key=KeyCode[supper(ssub(key,1,1))]
			modes[key]=mode
		end
	end

	local keyW=KeyCode.W
	local Wpressed=IsKeyDown(uis,keyW)
	local keyA=KeyCode.A
	local Apressed=IsKeyDown(uis,keyA)
	local keyS=KeyCode.S
	local Spressed=IsKeyDown(uis,keyS)
	local keyD=KeyCode.D
	local Dpressed=IsKeyDown(uis,keyD)
	local keySpace=KeyCode.Space
	local jumpingInput=IsKeyDown(uis,keySpace)

	local FWmovement=0
	local RTmovement=0
	local isWalking=false
	local refreshKeyboardMovement=function()
		if Wpressed then if Spressed then if Dpressed then if Apressed then isWalking=false else FWmovement=0 RTmovement=1 isWalking=true end else if Apressed then FWmovement=0 RTmovement=-1 isWalking=true else isWalking=false end end else FWmovement=1 if Dpressed then if Apressed then RTmovement=0 else RTmovement=1 end else if Apressed then RTmovement=-1 else RTmovement=0 end end isWalking=true end else if Spressed then FWmovement=-1 if Dpressed then if Apressed then RTmovement=0 else RTmovement=1 end else if Apressed then RTmovement=-1 else RTmovement=0 end end isWalking=true else if Dpressed then if Apressed then isWalking=false else FWmovement=0 RTmovement=1 isWalking=true end else if Apressed then FWmovement=0 RTmovement=-1 isWalking=true else isWalking=false end end end end
	end
	refreshKeyboardMovement()

	local keyShift=KeyCode.LeftShift
	tinsert(cons,Connect(insGet(uis,"InputBegan"),function(a)
		if insGet(gs,"MenuIsOpen") or GetFocusedTextBox(uis) then
			return
		end
		a=insGet(a,"KeyCode")
		if a==keyW then
			Wpressed=true
			refreshKeyboardMovement()
		elseif a==keyA then
			Apressed=true
			refreshKeyboardMovement()
		elseif a==keyS then
			Spressed=true
			refreshKeyboardMovement()
		elseif a==keyD then
			Dpressed=true
			refreshKeyboardMovement()
		elseif a==keySpace then
			jumpingInput=true
		elseif a==keyShift then
			shiftlock=allowshiftlock and not shiftlock
		elseif modes[a] then
			local modeLeft=modes[mode].modeLeft
			if modeLeft then
				modeLeft()
			end
			if mode==a then
				mode="default"
			else
				mode=a
			end
			local modet=modes[mode]
			lerpsIdle=modet.idle or defaultmode.idle or emptyfunction
			lerpsWalk=modet.walk or defaultmode.walk or emptyfunction
			lerpsJump=modet.jump or defaultmode.jump or emptyfunction
			lerpsFall=modet.fall or defaultmode.fall or emptyfunction
			if modes[mode].modeEntered then
				modes[mode].modeEntered()
			end
		end
	end))
	tinsert(cons,Connect(insGet(uis,"InputEnded"),function(a)
		a=insGet(a,"KeyCode")
		if a==keyW then
			Wpressed=false
			refreshKeyboardMovement()
		elseif a==keyA then
			Apressed=false
			refreshKeyboardMovement()
		elseif a==keyS then
			Spressed=false
			refreshKeyboardMovement()
		elseif a==keyD then
			Dpressed=false
			refreshKeyboardMovement()
		elseif a==keySpace then
			jumpingInput=false
		end
	end))

	local thumbstickEndX=0
	local thumbstickStartY=0

	local thumbstickSizeMultiplier=0

	local jumpStartX=0
	local jumpStartY=0
	local jumpEndX=0
	local jumpEndY=0

	local thumbstickInputObject=nil
	local jumpInputObject=nil
	local cameraRotateInputObject=nil
	local cameraZoomInputObject=nil

	local thumbstickTouchStart=v3_0
	local cameraZoomInputMagnitude=0

	tinsert(cons,Connect(insGet(uis,"TouchStarted"),function(inputObject)
		if insGet(gs,"MenuIsOpen") or GetFocusedTextBox(uis) then
			return
		end

		local touchPos=insGet(inputObject,"Position")
		local touchX=v3Get(touchPos,"X")
		local touchY=v3Get(touchPos,"Y")

		if (not thumbstickInputObject) and touchX<thumbstickEndX and touchY>thumbstickStartY then
			thumbstickInputObject=inputObject
			thumbstickTouchStart=insGet(inputObject,"Position")
			isWalking=false
		elseif (not jumpInputObject) and touchY>jumpStartY and touchX>jumpStartX and touchX<jumpEndX and touchY<jumpEndY then
			jumpInputObject=inputObject
			jumpingInput=true
		elseif not cameraRotateInputObject then
			cameraRotateInputObject=inputObject
		else
			cameraZoomInputObject=inputObject
			cameraZoomInputMagnitude=vmagnitude(insGet(cameraRotateInputObject,"Position")-insGet(cameraZoomInputObject,"Position"))
		end
	end))
	tinsert(cons,Connect(insGet(uis,"TouchMoved"),function(inputObject)
		local touchPos=insGet(inputObject,"Position")
		local touchX=v3Get(touchPos,"X")
		local touchY=v3Get(touchPos,"Y")
		if inputObject==thumbstickInputObject then
			local direction=insGet(inputObject,"Position")-thumbstickTouchStart
			local directionMag=vmagnitude(direction)/thumbstickSizeMultiplier
			if directionMag>0.05 then
				isWalking=true
				direction=vnormalize(direction)*min(1,(directionMag-0.05)/0.95) 
				FWmovement=-v3Get(direction,"Y")
				RTmovement=v3Get(direction,"X")
			else
				isWalking=false
			end
		elseif inputObject==jumpInputObject then
			jumpingInput=touchY>jumpStartY and touchX>jumpStartX and touchX<jumpEndX and touchY<jumpEndY
		else
			if cameraZoomInputObject then
				local newMagnitude=vmagnitude(insGet(cameraRotateInputObject,"Position")-insGet(cameraZoomInputObject,"Position"))
				cammag=cammag+(newMagnitude-cameraZoomInputMagnitude)*0.04*(0.75-cammag/4)
				cameraZoomInputMagnitude=newMagnitude
				if cammag<0 then
					firstperson=false
				else
					cammag=0
					firstperson=true
				end
			elseif inputObject==cameraRotateInputObject then
				local rotation=GetMouseDelta(uis)
				camrotX=clamp(v2Get(rotation,"Y")*mradN05+camrotX,npi2,pi2)
				camrotY=v2Get(rotation,"X")*mradN05+camrotY
				camrot=angles(camrotX,camrotY,0,enumYXZ)
				camcfLV=cfGet(camrot,"LookVector")
				camcfRV=cfGet(camrot,"RightVector")
			end
		end
	end))
	tinsert(cons,Connect(insGet(uis,"TouchEnded"),function(inputObject)
		if inputObject==thumbstickInputObject then
			thumbstickInputObject=nil
			isWalking=false
		elseif inputObject==jumpInputObject then
			jumpInputObject=nil
			jumpingInput=false
		elseif inputObject==cameraRotateInputObject then
			cameraRotateInputObject=nil
			cameraZoomInputObject=nil
		elseif inputObject==cameraZoomInputObject then
			cameraZoomInputObject=nil
		end
	end))

	local refreshTouchRegions=function()
		local sX=insGet(mouse,"ViewSizeX")
		local sY=insGet(mouse,"ViewSizeY")
		local isSmallScreen=min(sX,sY)<=500

		sY=sY+insGet(gs,"TopbarInset").Height

		thumbstickEndX=sX*0.4
		thumbstickStartY=(sY+0)*0.333

		if isSmallScreen then
			thumbstickSizeMultiplier=35
			jumpStartX=sX-95
			jumpStartY=sY-90
			jumpEndX=jumpStartX+70
			jumpEndY=jumpStartY+70
		else
			thumbstickSizeMultiplier=60
			jumpStartX=sX-170
			jumpStartY=sY-210
			jumpEndX=jumpStartX+120
			jumpEndY=jumpStartY+120
		end
	end
	tinsert(cons,Connect(GetPropertyChangedSignal(mouse,"ViewSizeX"),refreshTouchRegions))
	tinsert(cons,Connect(GetPropertyChangedSignal(mouse,"ViewSizeY"),refreshTouchRegions))
	tinsert(cons,Connect(GetPropertyChangedSignal(gs,"TopbarInset"),refreshTouchRegions))
	refreshTouchRegions()

	local mouseCameraMove=false
	tinsert(cons,Connect(insGet(uis,"InputChanged"),function(a,b)
		if b then return end
		local inputType=insGet(a,"UserInputType")
		if mouseCameraMove and inputType==enumMM then
			local rotation=GetMouseDelta(uis)
			camrotX=clamp(v2Get(rotation,"Y")*mradN05+camrotX,npi2,pi2)
			camrotY=v2Get(rotation,"X")*mradN05+camrotY
			camrot=angles(camrotX,camrotY,0,enumYXZ)
			camcfLV=cfGet(camrot,"LookVector")
			camcfRV=cfGet(camrot,"RightVector")
		elseif inputType==enumMW then
			cammag=cammag+v3Get(insGet(a,"Position"),"Z")*(0.75-cammag/4)
			if cammag<0 then
				firstperson=false
			else
				cammag=0
				firstperson=true
			end
		end
	end))

	local fling=function(target)
		local noFling=hooks.noFling
		if noFling and noFling() then
			return false
		end
		if typeof(target)~="Instance" then
			target=insGet(mouse,"Target")
			if not target then
				return false
			end
		end
		if not IsDescendantOf(target,ws) then
			return false
		end
		if IsA(target,"BasePart") or IsA(target,"Humanoid") then 
			target=insGet(target,"Parent") 
			if IsA(target,"Accoutrement") then
				target=insGet(target,"Parent")
			end
		end
		if (not IsA(target,"Model")) or (target==c) then
			return false
		end
		local targetpart=QueryDescendants(target,">BasePart#Torso")[1] or QueryDescendants(target,">BasePart#UpperTorso")[1]
		if (not targetpart) or (flingtable[targetpart]~=nil) then
			return false
		end
		if highlightflingtargets then
			local h=i("Highlight")
			insSet(h,"Name",rs())
			insSet(h,"Adornee",target)
			insSet(h,"OutlineColor",c3(1,0,0))
			insSet(h,"Parent",hlparent)
			flingtable[targetpart]=h
		else
			flingtable[targetpart]=false
		end
		return true
	end

	if ctrlclicktp then
		ctrlclicktp=KeyCode.LeftControl
		local tpoff=v3_010*3
		if clickfling then
			tinsert(cons,Connect(insGet(mouse,"Button1Down"),function()
				if insGet(mouse,"Target") then
					if IsKeyDown(uis,ctrlclicktp) then
						pos=cfGet(insGet(mouse,"Hit"),"Position")+tpoff
						cfr=cfl(pos,pos+camcfLV*v3_101)
						xzvel=v3_0
						Yvel=0
					else
						fling()
					end
				end
			end))
		else
			tinsert(cons,Connect(insGet(mouse,"Button1Down"),function()
				if insGet(mouse,"Target") and IsKeyDown(uis,ctrlclicktp) then
					pos=cfGet(insGet(mouse,"Hit"),"Position")+tpoff
					cfr=cfl(pos,pos+camcfLV*v3_101)
					xzvel=v3_0
					Yvel=0
				end
			end))
		end
	elseif clickfling then
		tinsert(cons,Connect(insGet(mouse,"Button1Down"),fling))
	end

	local hhOff=3
	local hhOff1=3.01
	local setHipHeight=function(n)
		hhOff=n+3
		hhOff1=n+3.01
	end

	local noYvelTime=1
	hooks.lastroot=pos
	local lastsine=sine
	--extra movement the script on top can add: extvel is a velocity in studs/s that slows down by extdrag per second (elytra boost),
	--pendingLaunch is a y velocity that also works when standing on the ground (mace wind burst)
	local extvel=v3_0
	local extdrag=2.5
	local pendingLaunch=nil
	local lostlog={} --hats that are not ours right now (only used to print why a hat was lost)
	lostlog.name=function(part)
		local ok,n=pcall(function()
			return insGet(insGet(part,"Parent"),"Name")
		end)
		return (ok and n) or "a hat"
	end
	local mainFunction=function()
		sine=osclock()
		local delta=sine-lastsine
		deltaTime=min(delta*10,1)
		lastsine=sine

		if shiftlock then
			if allowshiftlock then
				if mouseBehavior~=enumMLC then
					mouseBehavior=enumMLC
					insSet(uis,"MouseBehavior",mouseBehavior)
				end
				mouseCameraMove=true
			else
				shiftlock=false
			end
		elseif firstperson then
			if mouseBehavior~=enumMLC then
				mouseBehavior=enumMLC
				insSet(uis,"MouseBehavior",mouseBehavior)
			end
			mouseCameraMove=true
		elseif IsMouseButtonPressed(uis,enumMB2) then
			if mouseBehavior~=enumMLCP then
				mouseBehavior=enumMLCP
				insSet(uis,"MouseBehavior",mouseBehavior)
			end
			mouseCameraMove=true
		else
			if mouseBehavior~=enumMD then
				mouseBehavior=enumMD
				insSet(uis,"MouseBehavior",mouseBehavior)
			end
			mouseCameraMove=false
		end

		--the extra velocity moves you like walking does, extnow (only x and z) is added to the walking velocity the hats get below
		local extmoved=false
		local extnow=v3_0
		if extvel~=v3_0 then
			extmoved=true
			extnow=extvel*v3_101
			pos=pos+extvel*delta
			extvel=extvel*math.max(0,1-delta*extdrag)
			if vmagnitude(extvel)<2 then
				extvel=v3_0
			end
		end

		local raycastresult=Raycast(ws,pos,v3_010*(fpdh-v3Get(pos,"Y")),raycastparams)
		local onground=nil
		if raycastresult then
			onground=raycastresult.Distance<hhOff1
			if onground then
				Yvel=0
				pos=pos+v3_010*(v3Get(raycastresult.Position,"Y")+hhOff-v3Get(pos,"Y"))*min(delta*20,1)
				if pendingLaunch then
					Yvel=pendingLaunch
					onground=false
				elseif jumpingInput and (jumpPower>0) then
					Yvel=jumpPower
					onground=false
				end
			else
				Yvel=Yvel-gravity*delta
				raycastresult=v3Get(raycastresult.Position,"Y")
				if v3Get(pos,"Y")+Yvel*delta<raycastresult then
					Yvel=0
					pos=pos+v3_010*(raycastresult+hhOff-v3Get(pos,"Y"))
				end
			end
		else
			Yvel=0
			onground=false
		end
		pendingLaunch=nil
		if extmoved then
			Yvel=0 --no gravity while the extra velocity is pushing
		end

		if firstperson then
			if isWalking then
				if walkSpeed==0 then
					xzvel=v3_0
					if onground then
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsIdle()
						noYvelTime=min(noYvelTime+delta*0.3,1)
						xzvel=xzvel*(1-noYvelTime)
					elseif Yvel>0 then
						pos=pos+v3_010*Yvel*delta
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsJump()
						noYvelTime=0
					else
						pos=pos+v3_010*Yvel*delta
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsFall()
						noYvelTime=0
					end
				else
					xzvel=vnormalize(vnormalize(camcfLV*v3_101)*FWmovement+vnormalize(camcfRV*v3_101)*RTmovement)*walkSpeed
					if onground then
						pos=pos+xzvel*delta
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsWalk()
						noYvelTime=min(noYvelTime+delta*0.3,1)
						xzvel=xzvel*(1-noYvelTime)
					elseif Yvel>0 then
						pos=pos+(xzvel+v3_010*Yvel)*delta
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsJump()
						noYvelTime=0
					else 
						pos=pos+(xzvel+v3_010*Yvel)*delta
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsFall()
						noYvelTime=0
					end
				end
			else
				xzvel=v3_0
				if onground then
					cfr=cfl(pos,pos+camcfLV*v3_101)
					camcf=cfAdd(camrot,pos+v3_0150)
					cframes[rootpart]=cfr
					insSet(cam,"CFrame",camcf)
					lerpsIdle()
					noYvelTime=min(noYvelTime+delta*0.3,1)
					xzvel=xzvel*(1-noYvelTime)
				elseif Yvel>0 then
					pos=pos+v3_010*Yvel*delta
					cfr=cfl(pos,pos+camcfLV*v3_101)
					camcf=cfAdd(camrot,pos+v3_0150)
					cframes[rootpart]=cfr
					insSet(cam,"CFrame",camcf)
					lerpsJump()
					noYvelTime=0
				else
					pos=pos+v3_010*Yvel*delta
					cfr=cfl(pos,pos+camcfLV*v3_101)
					camcf=cfAdd(camrot,pos+v3_0150)
					cframes[rootpart]=cfr
					insSet(cam,"CFrame",camcf)
					lerpsFall()
					noYvelTime=0
				end
			end
		elseif shiftlock then	
			if isWalking then
				if walkSpeed==0 then
					xzvel=v3_0
					if onground then
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150+camcfRV*1.75+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsIdle()
						noYvelTime=min(noYvelTime+delta*0.3,1)
						xzvel=xzvel*(1-noYvelTime)
					elseif Yvel>0 then
						pos=pos+v3_010*Yvel*delta
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150+camcfRV*1.75+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsJump()
						noYvelTime=0
					else
						pos=pos+v3_010*Yvel*delta
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150+camcfRV*1.75+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsFall()
						noYvelTime=0
					end
				else
					xzvel=vnormalize(vnormalize(camcfLV*v3_101)*FWmovement+vnormalize(camcfRV*v3_101)*RTmovement)*walkSpeed
					if onground then
						pos=pos+xzvel*delta
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150+camcfRV*1.75+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsWalk()
						noYvelTime=min(noYvelTime+delta*0.3,1)
						xzvel=xzvel*(1-noYvelTime)
					elseif Yvel>0 then
						pos=pos+(xzvel+v3_010*Yvel)*delta
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150+camcfRV*1.75+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsJump()
						noYvelTime=0
					else
						pos=pos+(xzvel+v3_010*Yvel)*delta
						cfr=cfl(pos,pos+camcfLV*v3_101)
						camcf=cfAdd(camrot,pos+v3_0150+camcfRV*1.75+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsFall()
						noYvelTime=0
					end
				end
			else
				xzvel=v3_0
				if onground then
					cfr=cfl(pos,pos+camcfLV*v3_101)
					camcf=cfAdd(camrot,pos+v3_0150+camcfRV*1.75+camcfLV*cammag)
					cframes[rootpart]=cfr
					insSet(cam,"CFrame",camcf)
					lerpsIdle()
					noYvelTime=min(noYvelTime+delta*0.3,1)
					xzvel=xzvel*(1-noYvelTime)
				elseif Yvel>0 then
					pos=pos+v3_010*Yvel*delta
					cfr=cfl(pos,pos+camcfLV*v3_101)
					camcf=cfAdd(camrot,pos+v3_0150+camcfRV*1.75+camcfLV*cammag)
					cframes[rootpart]=cfr
					insSet(cam,"CFrame",camcf)
					lerpsJump()
					noYvelTime=0
				else
					pos=pos+v3_010*Yvel*delta
					cfr=cfl(pos,pos+camcfLV*v3_101)
					camcf=cfAdd(camrot,pos+v3_0150+camcfRV*1.75+camcfLV*cammag)
					cframes[rootpart]=cfr
					insSet(cam,"CFrame",camcf)
					lerpsFall()
					noYvelTime=0
				end
			end
		else
			if isWalking then
				if walkSpeed==0 then
					xzvel=v3_0
					if onground then
						cfr=cfAdd(cfGet(cfr,"Rotation"),pos)
						camcf=cfAdd(camrot,pos+v3_0150+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsIdle()
						noYvelTime=min(noYvelTime+delta*0.3,1)
						xzvel=xzvel*(1-noYvelTime)
					elseif Yvel>0 then
						pos=pos+v3_010*Yvel*delta
						cfr=cfAdd(cfGet(cfr,"Rotation"),pos)
						camcf=cfAdd(camrot,pos+v3_0150+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsJump()
						noYvelTime=0
					else
						pos=pos+v3_010*Yvel*delta
						cfr=cfAdd(cfGet(cfr,"Rotation"),pos)
						camcf=cfAdd(camrot,pos+v3_0150+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsFall()
						noYvelTime=0
					end
				else
					xzvel=vnormalize(vnormalize(camcfLV*v3_101)*FWmovement+vnormalize(camcfRV*v3_101)*RTmovement)*walkSpeed
					if onground then
						pos=pos+xzvel*delta
						cfr=cfAdd(Lerp(cfGet(cfr,"Rotation"),cfl(v3_0,xzvel),deltaTime),pos)
						camcf=cfAdd(camrot,pos+v3_0150+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsWalk()
						noYvelTime=min(noYvelTime+delta*0.3,1)
						xzvel=xzvel*(1-noYvelTime)
					elseif Yvel>0 then
						pos=pos+(xzvel+(v3_010*Yvel))*delta
						cfr=cfAdd(Lerp(cfGet(cfr,"Rotation"),cfl(v3_0,xzvel),deltaTime),pos)
						camcf=cfAdd(camrot,pos+v3_0150+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsJump()
						noYvelTime=0
					else
						pos=pos+(xzvel+(v3_010*Yvel))*delta
						cfr=cfAdd(Lerp(cfGet(cfr,"Rotation"),cfl(v3_0,xzvel),deltaTime),pos)
						camcf=cfAdd(camrot,pos+v3_0150+camcfLV*cammag)
						cframes[rootpart]=cfr
						insSet(cam,"CFrame",camcf)
						lerpsFall()
						noYvelTime=0
					end
				end
			else
				xzvel=v3_0
				if onground then
					cfr=cfAdd(cfGet(cfr,"Rotation"),pos)
					camcf=cfAdd(camrot,pos+v3_0150+camcfLV*cammag)
					cframes[rootpart]=cfr
					insSet(cam,"CFrame",camcf)
					lerpsIdle()
					noYvelTime=min(noYvelTime+delta*0.3,1)
					xzvel=xzvel*(1-noYvelTime)
				elseif Yvel>0 then
					pos=pos+v3_010*Yvel*delta
					cfr=cfAdd(cfGet(cfr,"Rotation"),pos)
					camcf=cfAdd(camrot,pos+v3_0150+camcfLV*cammag)
					cframes[rootpart]=cfr
					insSet(cam,"CFrame",camcf)
					lerpsJump()
					noYvelTime=0
				else
					pos=pos+v3_010*Yvel*delta
					cfr=cfAdd(cfGet(cfr,"Rotation"),pos)
					camcf=cfAdd(camrot,pos+v3_0150+camcfLV*cammag)
					cframes[rootpart]=cfr
					insSet(cam,"CFrame",camcf)
					lerpsFall()
					noYvelTime=0
				end
			end
		end

		local hookframe=hooks.frame
		if hookframe then
			hookframe()
		end
		refreshjointsI(rootpart)
		tclear(refreshedjoints)

		local sine15=sine*15
		local idlerv=v3(sin(sine15),sin(sine15+1.0471975511965976),sin(sine15+2.0943951023931953))
		local idleoff=idlerv*0.003910064697265625 --0.0156402587890625/4

		local claimpos=insGet(primarypart,"Position")
		--how fast the whole character moves, parts marked .fx (swords/circle that spin around the body) get this instead of their own velocity:
		--their own velocity is the speed of the spinning/flapping which is then multiplied by 10 for the network, that flings them off
		local rootvel=v3_0
		if delta>0 then
			rootvel=(pos-hooks.lastroot)/delta
			if vmagnitude(rootvel)>speedlimit then
				rootvel=vnormalize(rootvel)*speedlimit
			end
		end
		hooks.lastroot=pos
		local alivevel=v3(cos(sine*4)*4,0,sin(sine*4)*4) --4 studs/s sideways, the direction turns around once every 1.6 seconds
		for i,v in next,cframes do
			local part=i.p

			if part then
				if (insGet(part,"ReceiveAge")==0) and not GetJoints(part)[1] then
					local placeholder=i.v
					local vpos=cfGet(v,"Position")
					if novoid and (v3Get(vpos,"Y")<novoid) then
						v=cfAdd(v,v3_010*(novoid-v3Get(vpos,"Y")))
					end
					local lastpos=i.l
					local vel=(vpos-lastpos)/delta
					local mag=vmagnitude(vel)
					if mag<0.11730194091796875 then --0.0156402587890625*15/2
						if placeholder and i.b then
							insSet(placeholder,"Parent",nil)
							i.b=false
						end
						i.l=cfGet(v,"Position")
						v=cfAdd(v,idleoff)
					elseif mag>speedlimit then
						if placeholder then
							insSet(placeholder,"CFrame",v)
							if not i.b then
								insSet(placeholder,"Parent",ws)
								i.b=true
							end
						end
						vel=vnormalize(vel)*speedlimit
						local newpos=lastpos+vel*delta
						v=cfAdd(cfGet(v,"Rotation"),newpos)
						i.l=newpos
					else
						if placeholder and i.b then
							insSet(placeholder,"Parent",nil)
							i.b=false
						end
						i.l=cfGet(v,"Position")
					end
					if i.fx then
						vel=rootvel
					end
					local claimtime=i.c
					if claimtime then
						if (sine-claimtime)<retVelTime then
							local offsetToPrimaryPart=claimpos-cfGet(v,"Position")
							local a=625.5001+wsGravity*-2*v3Get(offsetToPrimaryPart,"Y")
							if a>0 then --part can reach primary part
								insSet(part,"AssemblyLinearVelocity",v3_net+offsetToPrimaryPart*v3_101/((25.01+sqrt(a))/wsGravity))
							else --part cant reach primary part so at least aim for closest point
								insSet(part,"AssemblyLinearVelocity",v3_net+offsetToPrimaryPart*v3_101/(30.010999900019996/wsGravity))
							end
						else
							local vel1=vel*noYvelTime+xzvel+extnow
							if vmagnitude(vel1)>25.01 then
								insSet(part,"AssemblyLinearVelocity",vnormalize(vel1)*v3_xzL+v3_net)
							else
								insSet(part,"AssemblyLinearVelocity",vel1*v3_xz+v3_net)
							end
						end
					else
						i.c=sine
						if lostlog[i] then
							lostlog[i]=nil
							print("Animal FE: got "..lostlog.name(part).." back")
						end
						insSet(part,"CanCollide",false) --collisions between hats (or with the map) push them out of place
						local vel1=vel*noYvelTime+xzvel+extnow
						if vmagnitude(vel1)>25.01 then
							insSet(part,"AssemblyLinearVelocity",vnormalize(vel1)*v3_xzL+v3_net)
						else
							insSet(part,"AssemblyLinearVelocity",vel1*v3_xz+v3_net)
						end
					end
					--the console log showed that only the arms and legs never got lost: their idle sway always gives them some sideways velocity.
					--hats that sit still on you (head, torso, hidden or held items while you stand) reported none and got taken over, so every hat
					--that is not being reclaimed gets a small circling sideways velocity when it has (almost) none of its own
					if not (claimtime and ((sine-claimtime)<retVelTime)) then
						local lv=insGet(part,"AssemblyLinearVelocity")
						if (v3Get(lv,"X")^2+v3Get(lv,"Z")^2)<16 then
							insSet(part,"AssemblyLinearVelocity",lv+alivevel)
						end
					end
					insSet(part,"CFrame",v)
					insSet(part,"AssemblyAngularVelocity",idlerv)
				else
					if i.c and not lostlog[i] then
						--only prints, changes nothing: tells which hat was lost and why
						lostlog[i]=true
						local why=(GetJoints(part)[1] and "something welded it") or ("someone else is simulating it (ReceiveAge "..tostring(insGet(part,"ReceiveAge"))..")")
						local nearest=nil
						local ppos=insGet(part,"Position")
						for _,rp in next,rootparts do
							local d=vmagnitude(insGet(rp,"Position")-ppos)
							if (not nearest) or (d<nearest) then
								nearest=d
							end
						end
						warn("Animal FE: lost "..lostlog.name(part)..": "..why..", nearest other player "..(nearest and (math.floor(nearest*10)/10).." studs" or "none")..", you are "..(math.floor(vmagnitude(pos-ppos)*10)/10).." studs away")
						local onlost=hooks.onLost
						if onlost then
							onlost()
						end
					end
					i.c=nil
					i.l=insGet(part,"Position")
					local placeholder=i.v
					if placeholder then
						insSet(placeholder,"CFrame",v)
						if not i.b then
							insSet(placeholder,"Parent",ws)
							i.b=true
						end
					end
				end
			else
				local placeholder=i.v
				if placeholder then
					insSet(placeholder,"CFrame",v)
					if not i.b then
						insSet(placeholder,"Parent",ws)
						i.b=true
					end
				end
			end
		end

		setsimrad()
	end

	sine=osclock()
	lastsine=sine
	tinsert(cons,Connect(heartbeat,mainFunction))
	mainFunction()

	local refreshjoints=function(v) --use this on the main part if u have parts that
		refreshjointsI(v) --are connected with each other but arent connected to rootpart
		tclear(refreshedjoints)
	end

	local legcfR=cf(1,-1,0)
	local legcfL=cf(-1,-1,0)
	local raydir=v3_010*-2
	local raycastlegs=function() --this returns 2 values: right leg raycast offset, left leg raycast offset
		local rY=Raycast(ws,cfGet(cfMul(cfr,legcfR),"Position"),raydir,raycastparams)
		local lY=Raycast(ws,cfGet(cfMul(cfr,legcfL),"Position"),raydir,raycastparams)
		if rY then
			if lY then
				return v3Get(rY.Position,"Y")-(v3Get(pos,"Y")-3),v3Get(lY.Position,"Y")-(v3Get(pos,"Y")-3)
			else
				return v3Get(rY.Position,"Y")-(v3Get(pos,"Y")-3),0
			end
		elseif lY then
			return 0,v3Get(lY.Position,"Y")-(v3Get(pos,"Y")-3)
		else
			return 0,0
		end
	end

	local velbycfrvec=function() --this returns 2 values: forward/backwards movement (from -1 to 1), right/left movement (from -1 to 1)
		local fw=cfGet(cfr,"LookVector")*xzvel/walkSpeed
		local rt=cfGet(cfr,"RightVector")*xzvel/walkSpeed
		return v3Get(fw,"X")+v3Get(fw,"Z"),v3Get(rt,"X")+v3Get(rt,"Z")
	end

	local lastvel=v3_0
	local velchg1=v3_0
	local velchgbycfrvec=function() --this returns 2 values: forward/backwards velocity change, right/left velocity change
		velchg1=velchg1+(lastvel-xzvel) --i recommend setting velchg1 to v3_0 when u start using this function or it will look worse
		lastvel=xzvel
		velchg1=velchg1-velchg1*(deltaTime/2)
		local fw=cfGet(cfr,"LookVector")*velchg1/32
		local rt=cfGet(cfr,"RightVector")*velchg1/32
		return v3Get(fw,"X")+v3Get(fw,"Z"),v3Get(rt,"X")+v3Get(rt,"Z")
	end

	local lastYvel=0
	local velYchg1=0
	local velYchg=function() --this returns Y axis velocity change
		velYchg1=clamp(velYchg1+(lastYvel-Yvel),-50,50) --i recommend setting velYchg1 to 0 when u start using this function or it will look worse
		lastYvel=Yvel
		velYchg1=velYchg1-velYchg1*(deltaTime/2)
		return velYchg1
	end

	local rotToMouse=function(alpha) --this rotates ur character towards your mouse hit position
		local pos1=pos*v3_010+cfGet(insGet(mouse,"Hit"),"Position")*v3_101
		if pos~=pos1 then --could make nan rotation
			cfr=Lerp(cfr,cfl(pos,pos1),alpha or deltaTime)
		end
	end

	local glitchJoint=function(joint,targetGlitchTime,delayFrom,delayTo,radiansFrom,radiansTo) 
		if sine>targetGlitchTime then --example usage: local glitchtime=0 addMode("x",{idle=function() glitchtime=glitchJoint(joint,glitchtime,0.2,0.4,-0.1,0.1) end})
			radiansFrom=radiansFrom*100
			radiansTo=radiansTo*100
			joint.C0=cfMul(joint.C0,angles(mrandom(radiansFrom,radiansTo)/100,mrandom(radiansFrom,radiansTo)/100,mrandom(radiansFrom,radiansTo)/100)) 
			return sine+mrandom(delayFrom*100,delayTo*100)/100
		end
		return targetGlitchTime
	end

	local setWalkSpeed=function(n)
		if type(n)~="number" then
			n=16
		end
		walkSpeed=n
	end
	local setJumpPower=function(n)
		if type(n)~="number" then
			n=50
		end
		jumpPower=n
	end
	local setGravity=function(n)
		if type(n)~="number" then
			n=196.2
		end
		gravity=n
	end
	local setCfr=function(v) --sets character cframe
		if typeof(v)=="CFrame" then
			local newpos=cfGet(v,"Position")
			camcf=cfAdd(camcf,newpos-pos)
			insSet(cam,"CFrame",camcf)
			cfr=v
			pos=newpos
			hooks.lastroot=pos
		elseif typeof(v)=="Vector3" then
			camcf=cfAdd(camcf,v-pos)
			insSet(cam,"CFrame",camcf)
			cfr=cfAdd(cfGet(cfr,"Rotation"),v)
			pos=v
			hooks.lastroot=pos
		end
	end
	local getVel=function() --returns character velocity
		return xzvel+v3_010*Yvel --important: use only in lerps or it might not work
	end
	local getCamCF=function() --returns camera cframe
		return camcf
	end
	local isFirstPerson=function() --returns true if user is in first person camera mode
		return firstperson
	end
	local getCfr=function() --returns the cframe of the character (yaw only), the position is where the root part is
		return cfr
	end
	local getYvel=function() --returns the y velocity (negative = falling)
		return Yvel
	end
	local launch=function(vy) --sets the y velocity, also works when standing on the ground (like a jump)
		Yvel=vy
		pendingLaunch=vy
	end
	local impulse=function(v,drag) --extra velocity in studs/s that slows down by drag per second, no gravity while it lasts
		extvel=v
		extdrag=drag or 2.5
	end
	local impulseActive=function() --true while the extra velocity of impulse() is still moving you
		return extvel~=v3_0
	end
	local groundDistance=function() --distance from the root part down to the ground (nil if there is none), and the position of the ground
		local res=Raycast(ws,pos,v3_010*(fpdh-v3Get(pos,"Y")),raycastparams)
		if res then
			return res.Distance,res.Position
		end
		return nil,nil
	end
	local mouseHit=function(maxdist) --where the mouse cursor points at (ignores players and things you cant collide with), second value is false if it points at the sky
		maxdist=maxdist or 1000
		local loc=GetMouseLocation(uis)
		local ray=cam:ViewportPointToRay(v2Get(loc,"X"),v2Get(loc,"Y"))
		local dir=ray.Direction*maxdist
		local res=Raycast(ws,ray.Origin,dir,raycastparams)
		if res then
			return res.Position,true
		end
		return ray.Origin+dir,false
	end

	return {
		cframes=cframes,
		joints=joints,
		fling=fling,
		refreshjoints=refreshjoints,
		raycastlegs=raycastlegs,
		velbycfrvec=velbycfrvec,
		velchgbycfrvec=velchgbycfrvec,
		velYchg=velYchg,
		addmode=addmode,
		getPart=getPart,
		getPartFromMesh=getPartFromMesh,
		getAccWeldFromMesh=getAccWeldFromMesh,
		getJoint=getJoint,
		getPartJoint=getPartJoint,
		rotToMouse=rotToMouse,
		glitchJoint=glitchJoint,
		setWalkSpeed=setWalkSpeed,
		setJumpPower=setJumpPower,
		setGravity=setGravity,
		setCfr=setCfr,
		getVel=getVel,
		getCamCF=getCamCF,
		isFirstPerson=isFirstPerson,
		setHipHeight=setHipHeight,
		getCfr=getCfr,
		getYvel=getYvel,
		launch=launch,
		impulse=impulse,
		impulseActive=impulseActive,
		groundDistance=groundDistance,
		mouseHit=mouseHit,
		setHooks=function(h)
			hooks.frame=h.frame
			hooks.noFling=h.noFling
			hooks.onLost=h.onLost
		end,
		resetmode=function() --goes back to the default animation (cancels the emote that is playing)
			if mode~="default" then
				local modeLeft=modes[mode].modeLeft
				if modeLeft then
					modeLeft()
				end
				mode="default"
				lerpsIdle=defaultmode.idle or emptyfunction
				lerpsWalk=defaultmode.walk or emptyfunction
				lerpsJump=defaultmode.jump or emptyfunction
				lerpsFall=defaultmode.fall or emptyfunction
			end
		end
	}
end

--=============================================================================
-- ANIMAL FE
-- everything below the reanimate engine: hat ids, bows, faces, animations and the gui
--=============================================================================

local main=function()
	local VERSION="v1.0.0"
	local genv=(getgenv and getgenv()) or _G
	local JUST_A_BASEPLATE=123974602339071 --the hat loader and the "-re" respawn command only work in this place
	local RESPAWN_ON_STOP=true --pressing 0 to stop also respawns your real character (JustABaseplate only)
	local ARM_OUT=0.3 --studs every animation moves the arms away from the torso (WemmbuFE had 0.2, the arms are 0.1 further out here)
	local armIn=0.35-ARM_OUT
	local HIDE_DEPTH=19 --hidden hats sit this many studs below the root part (same as NoctaliaGlitcher)
	local WALK_SPEED=16
	local RUN_SPEED=30 --R: ninja run

	local pi=math.pi
	local rad=math.rad
	local mmax=math.max

	local HATS_DELAY=6 --seconds between the first /e -gh and the second one

	--the hats this script moves by itself, everything else you wear just follows the body like it normally would
	--asset ids are strings on purpose, 15 digit numbers turn into 1.2345e+14 when you tostring them
	--bows: pos is where the bow sits on the torso (x right, y up, z backwards, the middle of the torso is 0,0,0), ids = the first one that is worn is used,
	--sphere = if the hat cant be told apart by its asset (the lookup can fail) a worn hat that is a perfect sphere is used,
	--side = which side of the body it is on (-1 left, 1 right), rot = extra turn of the bow on the spot where it sits
	--faces: only the one picked with 1 to 4 is shown, the others are hidden under the map
	--modes: 9 loads the animal one, left ctrl + 9 the white one, left alt + 9 the noob one. hats1/hats2 are the two /e -gh commands (10 ids each),
	--torso = a hat that becomes the torso of the rig (aligned to the torso, its mesh is looked up from the asset when the reanimate starts)
	local BOW_DOWN=0.23 --white and noob mode: the bows sit this much lower than in the animal mode (0.35 minus 0.12 moved back up)...
	local BOW_OUT=0.15 --...and this much further away from the middle
	local MODES={
		animal={
			label="Animal",
			hats1="74397898217145 88812665893015 136148501733872 75865279603024 91645491979097 71677300192924 70927849561661 113702227428200 90960046381276 102599402682100",
			hats2="81091457158261 13083313275 17817046226 16085706653 17332700910 94738732644027 102302897591583 87579939943483 140395948277978 82942681251131",
			pieces={
				bow1={ids={"136148501733872"},sphere=true,side=-1,pos=v3(-0.4,0.4,-0.5)}, --left: 0.4 up, 0.4 left, 0.5 forward
				bow2={ids={"88812665893015"},sphere=true,side=1,pos=v3(0.5,0.4,-0.5)}, --right: 0.4 up, 0.5 right, 0.5 forward
				face1={ids={"102302897591583"}},
				face2={ids={"16085706653"}},
				face3={ids={"17817046226"}},
				face4={ids={"94738732644027"}},
				tail={ids={"91645491979097"}} --waves from side to side
			}
		},
		white={
			label="White",
			--the two lists are swapped on purpose: the second list loaded badly when it was sent second
			hats1="140395948277978 13083313275 94738732644027 17817046226 17332700910 121915265126215 102302897591583 113310482615447 16085706653 5645493918",
			hats2="107315290869817 102599402682100 18977739339 82942681251131 90960046381276 18977713210 116778859684063 136751030394620 113102861718340 5645498661",
			pieces={
				--same bow places as the animal mode, both bows turned 180 degrees
				bow1={ids={"5645498661"},side=-1,pos=v3(-0.4,0.4,-0.5),rot=angles(0,pi,0)},
				bow2={ids={"5645493918"},side=1,pos=v3(0.5,0.4,-0.5),rot=angles(0,pi,0)},
				face1={ids={"102302897591583"}},
				face2={ids={"16085706653"}},
				face3={ids={"17817046226"}},
				face4={ids={"94738732644027"}},
				tail={ids={"113102861718340"}}
			}
		},
		noob={
			label="Noob",
			hats1="133538610911377 18367091193 12635697642 77331335218128 108186273151388 72292903231768 18931375074 18367099374 139247981043370 14097681678",
			hats2="139904067056008 84451219120140 115195598167089 119279566022285 80764219442602 17711932823 15741652130 118784199452932 117172206422099 128024322342647",
			torso="133538610911377",
			pieces={
				bow1={ids={"14097681678"},side=-1,pos=v3(-0.4-BOW_OUT,0.4-BOW_DOWN,-0.5),rot=angles(0,pi,0)}, --this bow is turned 180 degrees (around the up axis), it looks wrong otherwise
				bow2={ids={"128024322342647"},side=-1,pos=v3(0.5-BOW_OUT,0.4-BOW_DOWN,-0.5),rot=angles(0,pi,pi)}, --turned 180 degrees on y and also 180 on x
				face1={ids={"17711932823"}},
				face2={ids={"115195598167089"}},
				face3={ids={"119279566022285"}},
				face4={ids={"77331335218128"}},
				tail={ids={"80764219442602"}}
			}
		}
	}
	local PIECE_KEYS={"bow1","bow2","face1","face2","face3","face4","tail"}
	local BOW_BOUNCE=0.06 --how hard a change of the body's up/down speed throws the bows (50 studs/s of speed lost = 3 studs/s of bow speed)
	local TAIL_SWING=rad(20) --how far the tail turns to each side
	local TAIL_SPEED=2.5

	--the mode is remembered when the script is executed again
	local modeName=genv.AnimalFEMode
	if not MODES[modeName] then
		modeName="animal"
	end
	local PIECES=MODES[modeName].pieces
	local setMode=function(name)
		modeName=name
		PIECES=MODES[name].pieces
		genv.AnimalFEMode=name
	end
	--every asset a mode has to look up
	local modeIds=function(name)
		local ids={}
		for _,key in next,PIECE_KEYS do
			for _,id in next,MODES[name].pieces[key].ids do
				tinsert(ids,id)
			end
		end
		if MODES[name].torso then
			tinsert(ids,MODES[name].torso)
		end
		return ids
	end

	local rgb=Color3.fromRGB

	----------------------------------------------------------------------------
	-- small helpers
	----------------------------------------------------------------------------
	local TweenService=game:GetService("TweenService")
	local tween=function(obj,props,time,style,dir)
		local tw=TweenService:Create(obj,TweenInfo.new(time,style or e.EasingStyle.Quad,dir or e.EasingDirection.Out),props)
		tw:Play()
		return tw
	end
	local mk=function(class,props,parent)
		local o=i(class)
		for k,v in next,props do
			o[k]=v
		end
		o.Parent=parent
		return o
	end
	local parentGui=function(gui)
		local ok=pcall(function()
			gui.Parent=(gethui and gethui()) or FindFirstChildOfClass(game,"CoreGui")
		end)
		if (not ok) or (not gui.Parent) then
			gui.Parent=pg
		end
	end
	local guis={} --every gui this script made, they are destroyed on unload
	local newGui=function(order)
		local gui=mk("ScreenGui",{Name=rs(),ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=order,ZIndexBehavior=e.ZIndexBehavior.Sibling},nil)
		parentGui(gui)
		tinsert(guis,gui)
		return gui
	end

	--the unload function of the last time this script was executed
	if genv.AnimalFEUnload then
		pcall(genv.AnimalFEUnload)
	end

	local sendChat=function(message)
		local ok,err=pcall(function()
			local tcs=FindFirstChildOfClass(game,"TextChatService")
			if tcs and (tcs.ChatVersion==e.ChatVersion.TextChatService) then
				local channels=tcs:WaitForChild("TextChannels",5)
				local channel=channels and (channels:FindFirstChild("RBXGeneral") or channels:FindFirstChildWhichIsA("TextChannel"))
				channel:SendAsync(message)
			else
				FindFirstChildOfClass(game,"ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents",5).SayMessageRequest:FireServer(message,"All")
			end
		end)
		if not ok then
			warn("Animal FE: couldnt send chat message: "..tostring(err))
		end
	end

	local hatmeshes={} --asset id -> what the hat looks like (see getHatInfo), false while it is loading or if it couldnt be loaded
	--what a worn hat is compared with: the mesh id, texture id and picture (SurfaceAppearance) of the asset, the name of its accessory and the size of its handle
	--a hat can have no mesh id at all (a sphere made with a special mesh that has none), then m is ""
	local getHatInfo=function(id)
		local ok,info=pcall(function()
			local obj=game:GetObjects("rbxassetid://"..id)[1]
			local handle=obj:FindFirstChild("Handle",true)
			local m,t,size
			if handle:IsA("MeshPart") then
				m,t,size=handle.MeshId,handle.TextureID,handle.Size
			else
				local sm=handle:FindFirstChildOfClass("SpecialMesh")
				if sm then
					m,t=sm.MeshId,sm.TextureId
					local digits=tostring(m):match("%d+")
					if digits then
						--Handle.Size means nothing for a SpecialMesh (often 1,1,1), the real size of the mesh is what tells which way the blade goes
						--CreateMeshPartAsync takes a Content now (a plain string used to work), so try both
						local uri="rbxassetid://"..digits
						local assetService=game:GetService("AssetService")
						local made,meshpart=pcall(function()
							return assetService:CreateMeshPartAsync(Content.fromUri(uri))
						end)
						if not (made and meshpart) then
							made,meshpart=pcall(function()
								return assetService:CreateMeshPartAsync(uri)
							end)
						end
						if made and meshpart then
							size=meshpart.Size*sm.Scale
							meshpart:Destroy()
						else
							size=handle.Size*sm.Scale
						end
					else
						size=handle.Size*sm.Scale
					end
				else
					m,t,size="","",handle.Size
				end
			end
			local sa=handle:FindFirstChildOfClass("SurfaceAppearance")
			local info={
				m=tostring(m):match("%d+") or "",
				t=tostring(t):match("%d+") or "",
				sa=sa and tostring(sa.ColorMap):match("%d+") or nil,
				ext=size,name=obj.Name,hsize=handle.Size
			}
			obj:Destroy()
			return info
		end)
		if ok then
			return info
		end
		return nil,info
	end
	local fetchAll=function(ids,timeout)
		local pending=0
		for _,id in next,ids do
			if hatmeshes[id]==nil then
				hatmeshes[id]=false
				pending=pending+1
				tspawn(function()
					local info,err=getHatInfo(id)
					if info then
						hatmeshes[id]=info
					else
						warn("Animal FE: couldnt look up the hat "..id..": "..tostring(err))
					end
					pending=pending-1
				end)
			end
		end
		local deadline=osclock()+timeout
		while (pending>0) and (osclock()<deadline) do
			twait(0.1)
		end
	end

	----------------------------------------------------------------------------
	-- console
	----------------------------------------------------------------------------
	local printConsole=function()
		print("Hello welcome to Animal fe, by noctalia")
		print(" ")
		warn("[--- How to start---]")
		print("Press 9 to load required hats (Just a baseplate only)")
		print("Left ctrl + 9 loads the White mode hats, left alt + 9 the Noob mode hats")
		print("After loading hats, press 0 to reanimate, again to stop")
		print(" ")
		warn("[--- Keybinds ---]")
		print("1 to 4 - Changes your face")
		print(" ")
		print("R - Ninja run mode (faster, arms behind you when running), press again for normal mode")
		print(" ")
		print("Z - Lay down")
		print("X - Sit")
		print("C - Cute sit")
		print("V - Feet kick")
		print("B - Wave")
		print("N - Silly Dance")
		print("M - Sit hug")
		print("T - Bow fix")
		print("Y - Exhausted")
		print("U - Tired fall")
		print(" ")
		print("Q - Back to normal mode")
	end

	----------------------------------------------------------------------------
	-- loading screen
	----------------------------------------------------------------------------
	local showLoading=function(titleText,subText,seconds)
		local gui=newGui(2147483647)
		local overlay=mk("Frame",{Name=rs(),Size=u2(1,0,1,0),BackgroundColor3=c3(0,0,0),BackgroundTransparency=1,BorderSizePixel=0},gui)
		local common={BackgroundTransparency=1,TextTransparency=1,AnchorPoint=v2(0.5,0.5)}
		local title=mk("TextLabel",{Name=rs(),Position=u2(0.5,0,0.5,-30),Size=u2(0,900,0,120),Text=titleText,Font=e.Font.GothamBold,TextSize=100,TextColor3=c3(1,1,1)},overlay)
		local sub=mk("TextLabel",{Name=rs(),Position=u2(0.5,0,0.5,50),Size=u2(0,900,0,26),Text=subText,Font=e.Font.Gotham,TextSize=20,TextColor3=rgb(150,150,150)},overlay)
		local count=mk("TextLabel",{Name=rs(),Position=u2(0.5,0,0.5,84),Size=u2(0,300,0,26),Text=seconds.."s",Font=e.Font.Gotham,TextSize=20,TextColor3=rgb(150,150,150)},overlay)
		for _,l in next,{title,sub,count} do
			for k,v in next,common do
				l[k]=v
			end
		end
		tspawn(function()
			tween(overlay,{BackgroundTransparency=0.5},0.7)
			twait(0.35)
			for _,l in next,{title,sub,count} do
				tween(l,{TextTransparency=0},0.5)
			end
			for s=seconds,1,-1 do
				count.Text=s.."s"
				twait(1)
			end
			count.Text="0s"
			twait(0.25)
			tween(overlay,{BackgroundTransparency=1},0.7)
			for _,l in next,{title,sub,count} do
				tween(l,{TextTransparency=1},0.5)
			end
			twait(0.9)
			pcall(Destroy,gui)
		end)
	end

	----------------------------------------------------------------------------
	-- preload: everything the first reanimate needs (the mesh and texture ids of the pieces (bows, faces, tail)), so it doesnt lag
	----------------------------------------------------------------------------
	local PRE={pending=0}
	local job=function(f)
		PRE.pending=PRE.pending+1
		tspawn(function()
			local ok,err=pcall(f)
			if not ok then
				warn("Animal FE: preloading failed: "..tostring(err))
			end
			PRE.pending=PRE.pending-1
		end)
	end
	local preloadMode=function(name)
		job(function()
			fetchAll(modeIds(name),30)
		end)
	end

	--the custom torso of the noob rig: its mesh comes from the asset lookup, so the aligns entry is made right before each reanimate
	--(aligns is the engine's list of hats that get fixed to a body part)
	local torsoAlign=nil
	local setTorsoAlign=function()
		if torsoAlign then
			local at=tfind(aligns,torsoAlign)
			if at then
				table.remove(aligns,at)
			end
			torsoAlign=nil
		end
		local id=MODES[modeName].torso
		if not id then
			return
		end
		local info=hatmeshes[id]
		if info and info.m~="" then
			torsoAlign={PartName="Torso",meshid=info.m,textureid=info.t}
			tinsert(aligns,1,torsoAlign)
		else
			warn("Animal FE: couldnt look up the torso hat "..id..", it will not be aligned to the torso")
		end
	end

	----------------------------------------------------------------------------
	-- loading the hats (chat commands of Just A Baseplate)
	----------------------------------------------------------------------------
	--types the message into the real chat bar and presses enter (the only way "/e" commands work with the new chat), plain chat if there is no chat bar
	--fast = very short waits between the steps (used for -net, it is sent while you are already playing)
	local hatsBusy=false
	local typeChat=function(message,fast)
		local wFocus=fast and 0.03 or 0.15
		local wClear=fast and 0.03 or 0.15
		local wText=fast and 0.05 or 0.25
		local wEnter=fast and 0.02 or 0.1
		local wKey=fast and 0.02 or 0.05
		local wSent=fast and 0.12 or 0.25
		local ok=pcall(function()
			local tcs=FindFirstChildOfClass(game,"TextChatService")
			local config=tcs and tcs:FindFirstChild("ChatInputBarConfiguration")
			local box=config and config.TextBox
			if not box then
				local ec=FindFirstChildOfClass(game,"CoreGui"):FindFirstChild("ExperienceChat")
				box=ec and ec:FindFirstChild("TextBox",true)
			end
			assert(box,"no chat bar")
			--tries up to 4 times: if the message is still in the box after enter was pressed it was not sent
			for attempt=1,4 do
				box:CaptureFocus()
				twait(wFocus)
				box.Text=""
				twait(wClear)
				--the chat suggests commands while you type ("/e" turned into "/cleare" at enter), so set the text again until it stays exactly like it should
				for fix=1,4 do
					box.Text=message
					twait(wText)
					if box.Text==message then
						break
					end
				end
				twait(wEnter)
				local pressed=pcall(function()
					local vim=game:GetService("VirtualInputManager")
					vim:SendKeyEvent(true,e.KeyCode.Return,false,game)
					twait(wKey)
					vim:SendKeyEvent(false,e.KeyCode.Return,false,game)
				end)
				if not pressed then
					if keypress and keyrelease then
						keypress(0x0D)
						twait(wKey)
						keyrelease(0x0D)
					elseif firesignal then
						firesignal(box.FocusLost,true)
					end
				end
				twait(wSent)
				if box.Text~=message then
					break
				end
			end
		end)
		if not ok then
			sendChat(message)
		end
	end
	local loadHats=function(name)
		if c then
			warn("Animal FE: stop the reanimate first (press 0), then load the hats")
			return
		end
		if hatsBusy then
			return
		end
		--the mode is picked even outside Just A Baseplate (hats worn some other way)
		setMode(name)
		preloadMode(name)
		if game.PlaceId~=JUST_A_BASEPLATE then
			warn("Animal FE: hats only load in Just A Baseplate ("..MODES[name].label.." mode picked)")
			return
		end
		hatsBusy=true
		print("Animal FE: loading the "..MODES[name].label.." mode hats...")
		showLoading("Wait!","The hats are loading, do not touch anything",14)
		tspawn(function()
			typeChat("/e -ch")
			twait(1)
			typeChat("/e -pd")
			twait(1)
			typeChat("/e -gh "..MODES[name].hats1)
			twait(HATS_DELAY)
			typeChat("/e -gh "..MODES[name].hats2)
			twait(1)
			hatsBusy=false
		end)
	end

	local RT=nil --the state of the current run, nil while not reanimated
	local starting=false
	local stopAll=function()
		local was=(c~=nil) or (RT~=nil)
		local rt=RT
		RT=nil
		if rt and rt.cleanup then
			pcall(rt.cleanup)
		end
		stopreanimate()
		if was and RESPAWN_ON_STOP then
			pcall(function()
				local ch=insGet(lp,"Character")
				local hum=ch and FindFirstChildOfClass(ch,"Humanoid")
				if hum then
					insSet(hum,"Health",0)
				end
			end)
			if game.PlaceId==JUST_A_BASEPLATE then
				tdelay(0.5,function()
					sendChat("-re")
				end)
			end
		end
	end

	----------------------------------------------------------------------------
	-- pose library: every pose is a table of joint C0s {root,neck,rs,ls,rh,lh}. the C0s are built from "delta" rotations
	-- (what the part does compared to the default standing pose, in torso space), so a pose can be read as plain angles.
	-- (the engine's default C0s for the neck and the root joint are turned by angles(-pi/2,0,pi), the hips and shoulders by 90 degrees on y)
	----------------------------------------------------------------------------
	local rx=function(a) return angles(a,0,0) end
	local ry=function(a) return angles(0,a,0) end
	local rz=function(a) return angles(0,0,a) end
	local RYp=angles(0,pi/2,0)
	local RYn=angles(0,-pi/2,0)
	local ROOT_N=angles(-pi/2,0,pi)
	--shoulder/hip C0 that makes the limb point the way ra says (ra is relative to the torso, identity = hanging down)
	--p is the joint position on the torso
	local limbR=function(p,ra) return cfMul(cfMul(cf(p),ra),RYp) end
	local limbL=function(p,ra) return cfMul(cfMul(cf(p),ra),RYn) end
	--turns something around the point p
	local rotAbout=function(p,r) return cfMul(cfMul(cf(p),r),cf(-p)) end
	local pivotR=v3(1-armIn,0.5,0)
	local pivotL=v3(-1+armIn,0.5,0)
	local hipPR=v3(1,-1,0)
	local hipPL=v3(-1,-1,0)
	--the C1 of the engine's joints (where the joint sits on the arm/leg)
	local C1_RH=cfMul(cf(0.5,1,0),RYp)
	local C1_LH=cfMul(cf(-0.5,1,0),RYn)
	local rootC=function(p,d) return cfMul(cf(p),cfMul(d,ROOT_N)) end --p = where the torso is (relative to the root part), d = how it is turned
	local neckC=function(p,d) return cfMul(cf(p),cfMul(d,ROOT_N)) end --p = v3(0,1,0) plus whatever offset
	--arm rotation from pitch (forward, negative = backwards), out (away from the body, negative = towards it) and twist. side is 1 for the right arm and -1 for the left one
	--the arm is first moved out sideways and then lifted forward, so "out" keeps meaning "away from the body" at any pitch
	local armRot=function(side,pitch,out,twist)
		return cfMul(cfMul(rx(pitch),rz(side*out)),ry(twist or 0))
	end
	local armC=function(side,off,pitch,out,twist)
		if side==1 then
			return limbR(pivotR+off,armRot(1,pitch,out,twist))
		end
		return limbL(pivotL+off,armRot(-1,pitch,out,twist))
	end
	--d = rotation of the leg (identity = hanging down, rx(pi/2) = straight forward)
	local legC=function(side,off,d)
		if side==1 then
			return limbR(hipPR+off,d)
		end
		return limbL(hipPL+off,d)
	end
	local v3_waistT=v3(0,-1,0) --the waist in torso space

	local poses={}

	--idle: slight forward lean, head turned 10 degrees (-10 on y), hands behind the back
	--that dip 0.2 studs and come back up slowly
	poses.idle=function(s,Ychg,rY,lY)
		local bob=sin(s*1.3)
		local lean=rad(5)
		local dip=-0.1*(1-cos(s*1.6))
		return {
			root=rootC(v3(0,0.09+0.1*bob+Ychg,0.025*bob),rx(-lean+0.026*bob)),
			neck=neckC(v3(0,1,0),angles(lean+0.035-0.026*sin((s+1)*1.3),rad(-10),0.052*sin((s-0.6)*0.65))),
			rs=armC(1,v3(0,dip,0),rad(-30),rad(-34),0),
			ls=armC(-1,v3(0,dip,0),rad(-30),rad(-34),0),
			rh=legC(1,v3(0,-0.09-0.1*bob+rY-Ychg,-0.5*rY),cfMul(rx(lean-0.026*bob),ry(rad(-10)))),
			lh=legC(-1,v3(0,-0.09-0.1*bob+lY-Ychg,-0.5*lY),cfMul(rx(lean-0.026*bob),ry(rad(10))))
		}
	end

	--cute sit: legs flat on the ground in front, each turned 30 degrees out, hands between the legs (the arms are moved 0.3 down and 0.3 inwards),
	--torso, arms and head sway left and right
	poses.cuteSit=function(s)
		local off=-1.42
		local lean=rad(14)
		local sway=rad(7)*sin(s*0.9)
		local spread=rad(30)
		local fixLeg=rotAbout(v3_waistT,rz(-sway)) --the legs stay on the ground while the torso sways
		local armSway=rad(3)*sin(s*0.9-0.5)
		return {
			root=cfMul(rotAbout(v3(0,off-1,0),rz(sway)),rootC(v3(0,off,0),rx(-lean))),
			neck=neckC(v3(0,1,0),angles(lean+rad(2)*sin(s*1.8),0,rad(6)*sin(s*0.9+0.6))),
			rs=armC(1,v3(-0.3,-0.3,0),rad(50),rad(-34)+armSway,0),
			ls=armC(-1,v3(0.3,-0.3,0),rad(50),rad(-34)-armSway,0),
			rh=cfMul(fixLeg,legC(1,v3_0,cfMul(ry(-spread),rx(pi/2+lean)))),
			lh=cfMul(fixLeg,legC(-1,v3_0,cfMul(ry(spread),rx(pi/2+lean))))
		}
	end

	--sit hug: sits on its legs (folded back), arms around the front, the head moves 0.3 studs forward and back
	--the torso is 0.4 studs lower than it was, the legs stay where they were (legUp is "up" in torso space, it lifts the hips back by the same amount)
	poses.sitHug=function(s)
		local drop=0.4
		local off=-1.5-drop
		local lean=rad(8)
		local legUp=v3(0,drop*cos(lean),drop*sin(lean))
		local f=0.15*(1-cos(s*1.5)) --0 to 0.3 studs
		local nod=rad(3)*(f/0.3)
		local squeeze=rad(3)*sin(s*1.5)
		return {
			root=rootC(v3(0,off+0.02*sin(s*1.5),0),rx(-lean)),
			neck=neckC(v3(0,1,-f),angles(lean-nod+0.03,0,0)),
			rs=armC(1,v3_0,rad(85),rad(-48)+squeeze,0),
			ls=armC(-1,v3_0,rad(85),rad(-48)+squeeze,0),
			rh=legC(1,legUp,cfMul(ry(rad(30)),rx(-pi/2+lean))),
			lh=legC(-1,legUp,cfMul(ry(rad(-30)),rx(-pi/2+lean)))
		}
	end

	--feet kick: on its stomach, head up looking forward and turning, arms folded under the head (moved 0.15 studs back towards the feet and 0.2 studs in), legs up kicking
	poses.kick=function(s)
		local kickA=rad(28)*sin(s*2.5)
		local yaw=rad(10)*sin(s*0.9)
		return {
			root=rootC(v3(0,-2.5+0.02*sin(s*2.5),0),rx(-pi/2)),
			neck=neckC(v3(0,1,0),cfMul(rz(yaw),rx(pi/2-rad(5)))),
			rs=armC(1,v3(-0.2,-0.45,0),rad(180),rad(-30),0),
			ls=armC(-1,v3(0.2,-0.45,0),rad(180),rad(-30),0),
			rh=legC(1,v3_0,cfMul(ry(rad(-5)),rx(rad(-78)+kickA))),
			lh=legC(-1,v3_0,cfMul(ry(rad(5)),rx(rad(-78)-kickA)))
		}
	end

	--ninja run (R): the torso leans far forward, the arms are swept straight back and the legs swing fast. the height is worked out every
	--frame so the lowest foot touches the ground (the ground is 3 studs below the root part). idle and jumping stay the normal ones
	local footY=function(torsoCF,c0,c1,z)
		local part=cfMul(torsoCF,cfMul(c0,Inverse(c1)))
		return v3Get(cfGet(cfMul(part,cf(0,-1,z)),"Position"),"Y")
	end
	poses.ninjaRun=function(s)
		local w=s*13
		local lean=rad(35)
		local swing=rad(38)*sin(w)
		local flutter=rad(1.5)*sin(w*2)
		local rh=legC(1,v3_0,cfMul(ry(rad(-4)),rx(lean+swing)))
		local lh=legC(-1,v3_0,cfMul(ry(rad(4)),rx(lean-swing)))
		--the torso leans around the waist
		local base=cfMul(rotAbout(v3(0,-0.9,0),rx(-lean)),rootC(v3(0,0.09,0),cf_0))
		local torso=cfMul(base,Inverse(ROOT_N))
		local low=min(
			min(footY(torso,rh,C1_RH,0.5),footY(torso,rh,C1_RH,-0.5)),
			min(footY(torso,lh,C1_LH,0.5),footY(torso,lh,C1_LH,-0.5))
		)
		return {
			root=cfMul(cf(0,-3-low,0),base),
			neck=neckC(v3(0,1,0),angles(lean-rad(6),0,0)), --the head stays still
			rs=armC(1,v3_0,rad(-78)+flutter,rad(-3),0),
			ls=armC(-1,v3_0,rad(-78)-flutter,rad(-3),0),
			rh=rh,lh=lh
		}
	end

	--arm that points from its shoulder at a point on the torso (torso space), extraOut = how many more radians it is turned away from the body
	local armAim=function(side,off,tx,ty,tz,extraOut)
		local p=(side==1) and pivotR or pivotL
		local dx=tx-(v3Get(p,"X")+v3Get(off,"X"))
		local dy=ty-(v3Get(p,"Y")+v3Get(off,"Y"))
		local dz=tz-(v3Get(p,"Z")+v3Get(off,"Z"))
		local len=sqrt(dx*dx+dy*dy+dz*dz)
		return armC(side,off,math.atan2(-dz/len,-dy/len),math.asin(side*dx/len)+extraOut,0)
	end

	--bow fix (T): both arms point at the bows, turned 10 degrees outwards, and the hands go around the bows in small circles.
	--the bows follow the circle a little (frame() uses fixBowOffset), bowW fades that in and out
	local FIX_OUT=rad(10)
	local FIX_HAND=0.08 --studs, how far the point the hand aims at moves on its circle (was 0.2, the bow fix is calmer now)
	local FIX_BOW=0.06 --studs, how far the bow moves on its circle (was 0.16)
	--the two sides are not tied together: the right one circles one way at 2.2 rad/s, the left one the other way at a different speed (3 rad/s),
	--so they drift in and out of step and never look like one piece
	local fixPhase=function(side,s)
		if side==1 then
			return s*2.2
		end
		return 1.7-s*3
	end
	local fixBowOffset=function(side,s)
		local a=fixPhase(side,s)
		return v3(FIX_BOW*cos(a),FIX_BOW*sin(a),0)
	end
	--the normal idle body (legs, lean, breathing) with the head looking down at the bows and the arms busy with them. bowL/bowR = where the bows sit
	poses.bowFix=function(s,Ychg,rY,lY,bowL,bowR)
		local p=poses.idle(s,Ychg,rY,lY)
		p.neck=neckC(v3(0,1,0),angles(rad(-12)+0.02*sin(s*1.3),0,0))
		for _,arm in next,{{1,bowR,"rs"},{-1,bowL,"ls"}} do
			local side,bow=arm[1],arm[2]
			local a=fixPhase(side,s)
			p[arm[3]]=armAim(side,v3_0,
				v3Get(bow,"X")+FIX_HAND*cos(a),
				v3Get(bow,"Y")+FIX_HAND*sin(a),
				v3Get(bow,"Z")-0.15,
				FIX_OUT)
		end
		return p
	end

	--exhausted (Y): lying on its back, arms and legs spread out a bit, not moving
	poses.exhausted=function()
		return {
			root=rootC(v3(0,-2.5,0),rx(pi/2)),
			neck=neckC(v3(0,1,0),ry(rad(-20))),
			rs=armC(1,v3_0,0,rad(40),0),
			ls=armC(-1,v3_0,0,rad(40),0),
			rh=legC(1,v3_0,rz(rad(18))),
			lh=legC(-1,v3_0,rz(rad(-18)))
		}
	end

	--tired fall (U): the legs keep standing, the torso is bent forward at the waist until it points 45 degrees below the horizontal (135 degrees from upright),
	--the head lies on the ground on its right cheek looking to the left and the arms lie stretched out forward on the ground next to the head.
	--everything except the torso is worked out in world space and turned into torso space, so the legs, head and arms stay put while the torso breathes
	local TIRED_LEAN=rad(135) --how far the torso is bent forward (90 = horizontal, 135 = 45 degrees towards the ground)
	local TIRED_ARM_OUT=rad(30) --how far the arms are spread apart from the head
	local TIRED_ARM_DOWN=rad(15) --the arms point a bit down so they rest on the ground
	local tiredArm=function(side,lean)
		local wx=side*sin(TIRED_ARM_OUT)*cos(TIRED_ARM_DOWN)
		local wy=-sin(TIRED_ARM_DOWN)
		local wz=-cos(TIRED_ARM_OUT)*cos(TIRED_ARM_DOWN)
		--the same direction in torso space (the torso is turned by rx(-lean))
		local ty=cos(lean)*wy-sin(lean)*wz
		local tz=sin(lean)*wy+cos(lean)*wz
		return armC(side,v3_0,math.atan2(-tz,-ty),math.asin(side*wx),0)
	end
	poses.tiredFall=function(s)
		local lean=TIRED_LEAN+rad(1.2)*sin(s*1.2)
		local rh=legC(1,v3_0,cfMul(rx(lean),ry(rad(-10))))
		local lh=legC(-1,v3_0,cfMul(rx(lean),ry(rad(10))))
		--the torso bends around the waist, the height is worked out so the lowest foot touches the ground (same as the ninja run)
		local base=cfMul(rotAbout(v3(0,-0.9,0),rx(-lean)),rootC(v3(0,0.09,0),cf_0))
		local torso=cfMul(base,Inverse(ROOT_N))
		local low=min(
			min(footY(torso,rh,C1_RH,0.5),footY(torso,rh,C1_RH,-0.5)),
			min(footY(torso,lh,C1_LH,0.5),footY(torso,lh,C1_LH,-0.5))
		)
		return {
			root=cfMul(cf(0,-3-low,0),base),
			--the head: top towards the front, face to the left, right ear on the ground (ry(pi/2)*rz(-pi/2) in world space, rx(lean) takes the torso's turn out)
			neck=neckC(v3(0,1,0),cfMul(rx(lean),cfMul(ry(pi/2),rz(-pi/2)))),
			rs=tiredArm(1,lean),
			ls=tiredArm(-1,lean),
			rh=rh,lh=lh
		}
	end

	----------------------------------------------------------------------------
	-- reanimate
	----------------------------------------------------------------------------
	local startReanimate=function()
		if c or starting or RT then
			return
		end
		starting=true
		local fine,err=pcall(function()
			preloadMode(modeName) --nothing to do if the lookups are done
			if PRE.pending>0 then
				print("Animal FE: still preloading, one moment...")
				local waited=0
				while (PRE.pending>0) and (waited<40) do
					twait(0.1)
					waited=waited+0.1
				end
			end
			setTorsoAlign()

			local t=reanimate()
			if type(t)~="table" then
				warn("Animal FE: couldnt start")
				return
			end

			local cframes=t.cframes
			local getPartJoint=t.getPartJoint
			local addmode=t.addmode
			local raycastlegs=t.raycastlegs
			local velbycfrvec=t.velbycfrvec
			local velYchg=t.velYchg
			local setWalkSpeed=t.setWalkSpeed

			local RootJoint=t.getJoint("RootJoint")
			local RightShoulder=t.getJoint("Right Shoulder")
			local LeftShoulder=t.getJoint("Left Shoulder")
			local RightHip=t.getJoint("Right Hip")
			local LeftHip=t.getJoint("Left Hip")
			local Neck=t.getJoint("Neck")

			--the 6 r6 body parts the engine made up (accessories that got aligned to them have no .m, those are the real hats)
			local virtual=function(name)
				for part in next,cframes do
					if (part.Name==name) and not part.m then
						return part
					end
				end
			end
			local rootP=virtual("HumanoidRootPart")
			local torsoP=virtual("Torso")

			local S={ --everything that changes while you play
				face=1,faceKey="face1",
				bowFix=false,bowW=0, --T: bow fix is playing / how much the bows follow the hands (fades in and out)
				--bouncy bows: each side is a small spring with its own stiffness. o = height offset (studs), v = its speed, k = spring, c = damping
				bounce={[-1]={o=0,v=0,k=230,c=5},[1]={o=0,v=0,k=185,c=4.4}},
				lastYv=0,lastT=0,
				nextResolve=0
			}

			----------------------------------------------------------------
			-- animations. a pose from the pose library is smoothed into the joints
			----------------------------------------------------------------
			local apply=function(p)
				RootJoint.C0=Lerp(RootJoint.C0,p.root,deltaTime)
				Neck.C0=Lerp(Neck.C0,p.neck,deltaTime)
				RightShoulder.C0=Lerp(RightShoulder.C0,p.rs,deltaTime)
				LeftShoulder.C0=Lerp(LeftShoulder.C0,p.ls,deltaTime)
				RightHip.C0=Lerp(RightHip.C0,p.rh,deltaTime)
				LeftHip.C0=Lerp(LeftHip.C0,p.lh,deltaTime)
			end

			--default body animation
			local baseAnim={
				idle = function()
					local rY, lY = raycastlegs()
					apply(poses.idle(sine,velYchg()/20,rY,lY))
				end,
				walk = function()
					local Vfw, Vrt = velbycfrvec()

					local rY, lY = raycastlegs()

					local Ychg=velYchg()/20

					LeftShoulder.C0=Lerp(LeftShoulder.C0,cfMul(cf(-1+armIn,0.5,0),angles(-0.3*sin((sine+0.07)*8)*Vfw,-1.5707963267948966+0.2*sin((sine+0.15)*8),0)),deltaTime) 
					RightShoulder.C0=Lerp(RightShoulder.C0,cfMul(cf(1-armIn,0.5,0),angles(0.3*sin((sine+0.07)*8)*Vfw,1.5707963267948966+0.2*sin((sine+0.15)*8),0)),deltaTime) 
					RightHip.C0=Lerp(RightHip.C0,cfMul(cf(1,-1+0.3*sin((sine - 0.15)*8)+rY-Ychg,rY*-0.5),angles(1.5707963267948966-0.9599310885968813*sin(sine*8)*Vfw,1.5707963267948966-0.7853981633974483*sin(sine*8)*Vrt,-1.5707963267948966)),deltaTime) 
					LeftHip.C0=Lerp(LeftHip.C0,cfMul(cf(-1,-1+0.3*sin((sine + 0.15)*8)+lY-Ychg,lY*-0.5),angles(1.5707963267948966+0.9599310885968813*sin(sine*8)*Vfw,-1.5707963267948966+0.7853981633974483*sin(sine*8)*Vrt,1.5707963267948966)),deltaTime) 
					Neck.C0=Lerp(Neck.C0,cfMul(cf(0,1,0),angles(-1.5707963267948966+0.08726646259971647*sin(sine*16),0,3.141592653589793+0.08726646259971647*sin((sine+0.04)*8)-Vrt)),deltaTime) 
					RootJoint.C0=Lerp(RootJoint.C0,cfMul(cf(0,0.2 * sin((sine+0.1)*16) + Ychg,0),angles(-1.5707963267948966,0,3.141592653589793)),deltaTime) 
				end,
				jump = function()
					velYchg()
					local Vfw, Vrt = velbycfrvec()
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf_0,angles(-1.4835298641951802 + Vfw * 0.1, Vrt * -0.05, -3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1-armIn, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.7453292519943295 + 0.08726646259971647 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.6580627893946132 + 0.06981317007977318 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1+armIn, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.7453292519943295 - 0.08726646259971647 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.3962634015954636, 0, -3.141592653589793 - Vrt)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.6580627893946132 - 0.06981317007977318 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
				end,
				fall = function()
					velYchg()
					local Vfw, Vrt = velbycfrvec()
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf_0,angles(-1.6580627893946132 + Vfw * 0.1, Vrt * -0.05, -3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1-armIn, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.7453292519943295 + 0.08726646259971647 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.6580627893946132 + 0.06981317007977318 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1+armIn, 0.5, 0),angles(4.014257279586958 - 0.08726646259971647 * sin((sine + 0.5) * 4), -1.7453292519943295 - 0.08726646259971647 * sin((sine + 0.25) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.7453292519943295, 0, -3.141592653589793 - Vrt)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.5707963267948966 - 0.08726646259971647 * sin((sine + 0.5) * 4), 1.6580627893946132 - 0.06981317007977318 * sin((sine + 0.25) * 4), -1.5707963267948966)),deltaTime) 
				end
			}
			addmode("default",{
				idle=baseAnim.idle,
				walk=baseAnim.walk,
				jump=baseAnim.jump,
				fall=baseAnim.fall
			})

			----------------------------------------------------------------
			-- emotes. R ninja run, Z lay down, X sit, C cute sit, V feet kick, B wave, N silly dance, M sit hug, T bow fix, Y exhausted, U tired fall
			-- pressing the key again goes back to the normal mode, walking also gets you out of them (only idle is defined)
			----------------------------------------------------------------
			addmode("z", {
				idle = function()
					velYchg()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1+armIn, 0.75, -0.2),angles(2.705260340591211 - 0.08726646259971647 * sin((sine + 0.1) * 2), -2.792526803190927, -0.6981317007977318)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1-armIn, 0.75, -0.2),angles(2.705260340591211 - 0.08726646259971647 * sin((sine + 0.1) * 2), 2.792526803190927, 0.6981317007977318)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.9198621771937625 - 0.10471975511965978 * sin((sine + 0.3) * 2), 0, 3.141592653589793)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -2.45 - 0.05 * sin(sine * 2), 0),angles(0.03490658503988659 * sin(sine * 2), 0, 3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1, 0),angles(1.3962634015954636 - 0.03490658503988659 * sin(sine * 2), 1.3089969389957472, -0.9599310885968813)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1, 0),angles(1.5707963267948966 - 0.03490658503988659 * sin(sine * 2), -1.3089969389957472, 1.5707963267948966)),deltaTime) 
				end
			})
			addmode("x", {
				idle = function()
					velYchg()
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.9+armIn, 0.4 + 0.1 * sin(sine * 2), 0.3 - 0.15 * sin(sine * 2)),angles(-1.0471975511965976 - 0.12217304763960307 * sin(sine * 2), -1.3962634015954636, -0.6981317007977318)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0, -1.85 - 0.1 * sin((sine + 0.2) * 2), 0),angles(-1.3962634015954636 + 0.03490658503988659 * sin(sine * 2), -0.08726646259971647, 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1-armIn, 0.4 + 0.1 * sin(sine * 2), 0.2 - 0.15 * sin(sine * 2)),angles(0.6108652381980153 - 0.12217304763960307 * sin(sine * 2), 1.2217304763960306, -0.7853981633974483)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.6580627893946132 - 0.03490658503988659 * sin((sine + 0.6) * 2), 0.10471975511965978 + 0.06981317007977318 * sin(sine * 0.66), 3.141592653589793 + 0.3490658503988659 * sin(sine * 0.66))),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, 0.2 + 0.15 * sin((sine + 0.2) * 2), -0.7 + 0.1 * sin(sine * 2)),angles(1.4835298641951802 + 0.03490658503988659 * sin(sine * 2), 1.4835298641951802, -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -0.75 + 0.1 * sin((sine + 0.2) * 2), -0.5),angles(1.3962634015954636 - 0.03490658503988659 * sin(sine * 2), -1.6580627893946132, 0)),deltaTime) 
				end
			})
			addmode("b", {
				idle = function()
					local Ychg=velYchg()/20
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-1+armIn, 0.5, 0),angles(1.5707963267948966, -1.6580627893946132 + 0.08726646259971647 * sin((sine - 0.3) * 4), 1.5707963267948966)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(1 + 0.15 * sin((sine - 0.4) * 4)-armIn, 1.42, 0),angles(1.5707963267948966, 1.4835298641951802 - 0.3490658503988659 * sin((sine - 0.4) * 4), 1.5707963267948966)),deltaTime) 
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.4835298641951802, 0.04363323129985824 - 0.08726646259971647 * sin((sine + 0.1) * 4), -3.141592653589793 + 0.04363323129985824 * sin(sine * 4))),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(0.1 * sin(sine * 4), Ychg, 0),angles(-1.5707963267948966, -0.08726646259971647 + 0.08726646259971647 * sin(sine * 4), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1.1 + 0.1 * sin(sine * 4)-Ychg, 0),angles(1.5707963267948966, 1.5707963267948966 + 0.08726646259971647 * sin(sine * 4), -1.5707963267948966)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1 - 0.02 * sin(sine * 4), -0.925 - 0.07 * sin(sine * 4)-Ychg, 0),angles(1.5707963267948966, -1.7453292519943295 + 0.08726646259971647 * sin(sine * 4), 1.5707963267948966)),deltaTime) 
				end
			})
			addmode("n", {
				idle = function()
					local Ychg=velYchg()/20
					Neck.C0 = Lerp(Neck.C0,cfMul(cf(0, 1, 0),angles(-1.5707963267948966, -0.4363323129985824 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					RightHip.C0 = Lerp(RightHip.C0,cfMul(cf(1, -1 + 0.3 * sin(sine * 8)-Ychg, 0),angles(1.5707963267948966, 1.5707963267948966 + 0.5235987755982988 * sin(sine * 8), -1.5707963267948966)),deltaTime) 
					LeftShoulder.C0 = Lerp(LeftShoulder.C0,cfMul(cf(-0.5+armIn, 1, 0),angles(-0.5235987755982988, -1.5707963267948966 - 0.5235987755982988 * sin(sine * 8), 3.141592653589793)),deltaTime) 
					RightShoulder.C0 = Lerp(RightShoulder.C0,cfMul(cf(0.5-armIn, 1, 0),angles(-0.5235987755982988, 1.5707963267948966 - 0.5235987755982988 * sin(sine * 8), 3.141592653589793)),deltaTime) 
					RootJoint.C0 = Lerp(RootJoint.C0,cfMul(cf(-0.1 * sin(sine * 8), 0.2 * sin((sine + 0.1) * 16)+Ychg, 0),angles(-1.5707963267948966, 0.2617993877991494 * sin(sine * 8), -3.141592653589793)),deltaTime) 
					LeftHip.C0 = Lerp(LeftHip.C0,cfMul(cf(-1, -1 - 0.3 * sin(sine * 8)-Ychg, 0),angles(1.5707963267948966, -1.5707963267948966 + 0.5235987755982988 * sin(sine * 8), 1.5707963267948966)),deltaTime) 
				end
			})
			addmode("c", {
				idle = function()
					velYchg()
					apply(poses.cuteSit(sine))
				end
			})
			addmode("v", {
				idle = function()
					velYchg()
					apply(poses.kick(sine))
				end
			})
			addmode("m", {
				idle = function()
					velYchg()
					apply(poses.sitHug(sine))
				end
			})
			--T: bow fix, plays until T is pressed again (or Q, walking also ends it)
			addmode("t", {
				modeEntered = function()
					S.bowFix = true
				end,
				idle = function()
					local rY, lY = raycastlegs()
					apply(poses.bowFix(sine,velYchg()/20,rY,lY,PIECES.bow1.pos,PIECES.bow2.pos))
				end,
				modeLeft = function()
					S.bowFix = false
				end
			})
			--Y: exhausted
			addmode("y", {
				idle = function()
					velYchg()
					apply(poses.exhausted())
				end
			})
			--U: tired fall
			addmode("u", {
				idle = function()
					velYchg()
					apply(poses.tiredFall(sine))
				end
			})
			--R: ninja run. the idle, jump and fall animations are the normal ones (a mode that doesnt define them uses the default ones)
			addmode("r", {
				modeEntered = function()
					setWalkSpeed(RUN_SPEED)
				end,
				walk = function()
					velYchg()
					apply(poses.ninjaRun(sine))
				end,
				modeLeft = function()
					setWalkSpeed(WALK_SPEED)
				end
			})
			----------------------------------------------------------------
			-- hats: find the bows and the faces that are worn and take over their joints
			----------------------------------------------------------------
			local pieces={} --key -> hat
			local resolve=nil
			--the picture of a hat that has a SurfaceAppearance instead of a texture id (faces made like that can share one mesh)
			local wornPicture=function(p)
				local sa=FindFirstChildOfClass(p,"SurfaceAppearance")
				return sa and tostring(insGet(sa,"ColorMap")):match("%d+")
			end
			local accessoryName=function(p)
				local acc=insGet(p,"Parent")
				return acc and insGet(acc,"Name")
			end
			local sizeClose=function(p,hsize)
				return (hsize~=nil) and (vmagnitude(insGet(p,"Size")-hsize)<0.05)
			end
			--is the handle a perfect sphere (as wide as tall and deep)
			local isRound=function(p)
				local s=insGet(p,"Size")
				local sm=FindFirstChildOfClass(p,"SpecialMesh")
				if sm then
					s=s*insGet(sm,"Scale")
				end
				local x,y,z=v3Get(s,"X"),v3Get(s,"Y"),v3Get(s,"Z")
				local lo=min(x,y,z)
				return (lo>0) and ((mmax(x,y,z)/lo)<1.08)
			end
			--pass 1: mesh, texture and picture have to match, pass 2: mesh and texture, pass 3: only the mesh
			--a hat without a mesh id: pass 1: accessory name and size, pass 2: the name, pass 3: the size. pass 4: the shape (only pieces with sphere=true)
			local matches=function(part,p,info,pass)
				if info.m~="" then
					return sfind(part.m,info.m) and ((pass==3) or sfind(part.t,info.t)) and ((pass~=1) or (info.sa~=nil and wornPicture(p)==info.sa))
				end
				if part.m~="" then
					return false
				end
				local named=accessoryName(p)==info.name
				if pass==1 then
					return named and sizeClose(p,info.hsize)
				elseif pass==2 then
					return named
				end
				return sizeClose(p,info.hsize)
			end
			local claim=function(key,part,used,pass)
				local j=getPartJoint(part)
				if j and j.Part1 then
					used[part]=true
					part.fx=true --these get the velocity of the body: the engine gives them the velocity of the root part instead of their own
					return {key=key,part=part,joint=j,Part1=j.Part1,C0=j.C0,C1=j.C1,pass=pass}
				end
				return nil
			end
			local findPiece=function(key,used,pass)
				if pass==4 then
					if PIECES[key].sphere then
						for part in next,cframes do
							local p=part.p
							if p and part.m and (not used[part]) and IsDescendantOf(p,ws) and isRound(p) then
								local h=claim(key,part,used,pass)
								if h then
									return h
								end
							end
						end
					end
					return nil
				end
				for _,id in next,PIECES[key].ids do
					local info=hatmeshes[id]
					if info then
						for part in next,cframes do
							local p=part.p
							if p and part.m and (not used[part]) and IsDescendantOf(p,ws) and matches(part,p,info,pass) then
								local h=claim(key,part,used,pass)
								if h then
									return h
								end
							end
						end
					end
				end
				return nil
			end
			resolve=function()
				--a hat that fell off (or got taken over by someone else) stays in here: the engine keeps its place and the animation keeps going,
				--it snaps back as soon as the hat is ours again
				local used={}
				for _,h in next,pieces do
					used[h.part]=true
				end
				--exact matches of every piece first, so a face that looks like another one can never take its hat
				for pass=1,4 do
					for _,key in next,PIECE_KEYS do
						if not pieces[key] then
							pieces[key]=findPiece(key,used,pass)
						end
					end
				end
			end
			resolve()
			do
				local count=0
				local lost={}
				for _,key in next,PIECE_KEYS do
					local h=pieces[key]
					if h then
						count=count+1
						if h.pass==4 then
							print("Animal FE: "..key.." was found by its shape (the lookup of the asset didnt give a match)")
						end
					else
						local looked=false
						for _,id in next,PIECES[key].ids do
							if hatmeshes[id] then
								looked=true
							end
						end
						tinsert(lost,key..(looked and "" or " (asset lookup failed)"))
					end
				end
				print("Animal FE: reanimated, found "..count.." of "..#PIECE_KEYS.." pieces (bows, faces, tail)")
				if #lost>0 then
					warn("Animal FE: these are not worn (press 9 to load the hats first, a hat can also be missing): "..table.concat(lost,", "))
					--what is worn and not used by a piece, so a hat that doesnt match can be told apart
					local taken={}
					for _,h in next,pieces do
						taken[h.part]=true
					end
					for part in next,cframes do
						if part.m and part.p and (not taken[part]) then
							local s=insGet(part.p,"Size")
							warn(string.format("Animal FE: worn hat %s, mesh %s, size %.2f %.2f %.2f",tostring(accessoryName(part.p)),tostring(part.m):match("%d+") or "none",v3Get(s,"X"),v3Get(s,"Y"),v3Get(s,"Z")))
						end
					end
				end
			end
			local hideCF=cf(0,-HIDE_DEPTH,0)

			----------------------------------------------------------------
			-- per frame: put the bows on the torso, show the face you picked and hide the others
			----------------------------------------------------------------
			local frame=function()
				if sine>=S.nextResolve then
					S.nextResolve=sine+1
					resolve()
				end
				S.bowW=S.bowW+((S.bowFix and 1 or 0)-S.bowW)*deltaTime
				--the bows react to the body's up and down speed like they hang on a spring: when the body suddenly stops (landing) or starts (jump)
				--they get thrown the other way and swing down, up, down (lower), up (lower)... until they settle
				local dt=min(sine-S.lastT,0.05)
				S.lastT=sine
				local yv=t.getYvel()
				local dv=yv-S.lastYv
				S.lastYv=yv
				if dt>0 then
					for _,b in next,S.bounce do
						b.v=b.v-dv*BOW_BOUNCE
						b.v=b.v+(-b.k*b.o-b.c*b.v)*dt
						b.o=clamp(b.o+b.v*dt,-0.6,0.6)
						
					end
				end
				for key,h in next,pieces do
					local j=h.joint
					local piece=PIECES[key]
					if piece.pos then
						--the hat goes to torso * C1 (C0 is nothing), while the bow fix plays the bow follows the hand a little
						local pos=piece.pos+v3(0,S.bounce[piece.side].o,0)
						if S.bowW>0.001 then
							pos=pos+fixBowOffset(piece.side,sine)*S.bowW
						end
						j.Part1=torsoP
						j.C0=cf_0
						j.C1=piece.rot and cfMul(cf(pos),piece.rot) or cf(pos)
					elseif key=="tail" then
						--turns around the point the tail is attached at (the waist), so it waves
						j.Part1=h.Part1
						j.C0=h.C0
						j.C1=cfMul(h.C1,ry(TAIL_SWING*sin(sine*TAIL_SPEED)))
					elseif key==S.faceKey then
						--back to where the accessory normally sits
						j.Part1=h.Part1
						j.C0=h.C0
						j.C1=h.C1
					else
						j.Part1=rootP
						j.C0=cf_0
						j.C1=hideCF --like NoctaliaGlitcher: under the root part, moving with you
					end
				end
			end

			----------------------------------------------------------------
			-- keys
			----------------------------------------------------------------
			local FACE_KEY={One=1,Two=2,Three=3,Four=4}
			tinsert(cons,Connect(insGet(uis,"InputBegan"),function(inp,processed)
				if insGet(gs,"MenuIsOpen") or GetFocusedTextBox(uis) then
					return
				end
				local name=insGet(inp,"KeyCode").Name
				local face=FACE_KEY[name]
				if face then
					S.face=face
					S.faceKey="face"..face
				elseif name=="Q" then
					setWalkSpeed(WALK_SPEED)
					t.resetmode()
				end
			end))

			--Just A Baseplate has a "-net" chat command that helps the hats stay yours (found in game: "/e -net" makes them stay up longer).
			--it is sent right after the joints break, and again whenever a hat gets lost (at most every 5 seconds)
			local netCd=0
			local sendNet=function()
				if (game.PlaceId~=JUST_A_BASEPLATE) or (osclock()<netCd) then
					return
				end
				netCd=osclock()+5
				tspawn(function()
					typeChat("/e -net",true)
				end)
			end
			t.setHooks({frame=frame,onLost=sendNet})
			tdelay(0.3,sendNet)
			setWalkSpeed(WALK_SPEED)

			RT={t=t,S=S,cleanup=function() end}
		end)
		starting=false
		if not fine then
			warn("Animal FE: "..tostring(err))
			stopAll()
		end
	end

	----------------------------------------------------------------------------
	-- start
	----------------------------------------------------------------------------
	--left ctrl / left alt are tracked from the key events, IsKeyDown alone missed the alt that was just pressed (the first alt + 9 loaded the animal hats)
	local held={LeftControl=false,LeftAlt=false}
	local modcon0=Connect(insGet(uis,"InputBegan"),function(inp)
		local name=insGet(inp,"KeyCode").Name
		if held[name]~=nil then
			held[name]=true
		end
	end)
	local modcon1=Connect(insGet(uis,"InputEnded"),function(inp)
		local name=insGet(inp,"KeyCode").Name
		if held[name]~=nil then
			held[name]=false
		end
	end)
	local topcon=Connect(insGet(uis,"InputBegan"),function(inp)
		if insGet(gs,"MenuIsOpen") or GetFocusedTextBox(uis) then
			return
		end
		local name=insGet(inp,"KeyCode").Name
		if name=="Nine" then
			twait(0.05) --gives a modifier pressed at the same moment time to register
			if held.LeftControl or IsKeyDown(uis,e.KeyCode.LeftControl) then
				loadHats("white")
			elseif held.LeftAlt or IsKeyDown(uis,e.KeyCode.LeftAlt) then
				loadHats("noob")
			else
				loadHats("animal")
			end
		elseif name=="Zero" then
			if starting then
				return
			end
			if c or RT then
				stopAll()
			else
				tspawn(startReanimate)
			end
		end
	end)

	genv.AnimalFEUnload=function()
		pcall(Disconnect,topcon)
		pcall(Disconnect,modcon0)
		pcall(Disconnect,modcon1)
		pcall(stopAll)
		for _,gui in next,guis do
			pcall(Destroy,gui)
		end
		if genv.AnimalFEUnload then
			genv.AnimalFEUnload=nil
		end
	end

	showLoading("Noctalia","Open console by pressing F9 or typing /console in chat.",5)
	printConsole()
	preloadMode(modeName)
end
main()
