-- without obfuscation

repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

TaskHubScriptIdentity = "TaskHub - Nico's Nextbot"
TaskHubScriptVersion = "v1.0"
TaskHubScriptPlaceId = {
	[12629753855] = true,
	[10118559731] = true,
	[12135007762] = true
}
PlaceId = game.PlaceId

local Notify = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/not-taskkill/Librarys/refs/heads/main/scr/Notify.luau"))()
local LemonSignal = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Data-Oriented-House/LemonSignal/refs/heads/main/src/LemonSignal.lua"))()

local function YieldForChild(inst, name)
	local First = inst:FindFirstChild(name)

	if First then
		return First
	end

	local running = coroutine.running()

	local connection
	connection = inst.ChildAdded:Connect(function(child)
		if child.Name == name then
			connection:Disconnect()
			coroutine.resume(running, child)
		end
	end)

	return coroutine.yield()
end

local function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end

cloneref = missing("function", cloneref, function(...) return ... end)
sethidden = missing("function", sethiddenproperty or set_hidden_property or set_hidden_prop)
gethidden = missing("function", gethiddenproperty or get_hidden_property or get_hidden_prop)
deletepropertyexistence = missing("function", setscriptable or set_scriptable)
base64dec = missing("function", base64decode or base64_decode or crypt.base64decode)
waxwritefile, waxreadfile = writefile, readfile
writefile = missing("function", waxwritefile) and function(file, data, safe)
	if safe == true then return pcall(waxwritefile, file, data) end
	waxwritefile(file, data)
end
readfile = missing("function", waxreadfile) and function(file, safe)
	if safe == true then return pcall(waxreadfile, file) end
	return waxreadfile(file)
end
isfile = missing("function", isfile, readfile and function(file)
	local success, result = pcall(function()
		return readfile(file)
	end)
	return success and result ~= nil and result ~= ""
end)
makefolder = missing("function", makefolder)
isfolder = missing("function", isfolder)
waxgetcustomasset = missing("function", getcustomasset or getsynasset)
IsOnMobile = nil
PARENT = nil
rnd = Random.new(os.clock())
gdestroy = game.Destroy
IsA = game.IsA
inew = function(InstanceIdentity, Propertys)
	local InstanceCreatedSuccess, InstanceCreated = pcall(function()
		return Instance.new(InstanceIdentity)
	end)

	if not InstanceCreatedSuccess then
		return
	end

	for PropertyIdentity, PropertyValue in pairs(Propertys) do
		InstanceCreated[PropertyIdentity] = PropertyValue
	end

	return InstanceCreated
end

local function randomString(len)
	return ("."):rep(len or rnd:NextInteger(75, 100)):gsub(".", function()
		return string.char(rnd:NextInteger(32, 126))
	end)
end

Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		else
			warn("Invalid Service: " .. tostring(name))
		end
	end,
	__metatable = "meow!"
})

if not TaskHubScriptPlaceId[PlaceId] then
	Notify({
		Title = TaskHubScriptIdentity,
		Subtitle = "Wrong Place to use the script.",
		Icon = "rbxassetid://7315883219",
		Duration = 10.5,
		SoundId = "rbxassetid://8551372796"
	})
	return
elseif TaskHubNicoNextbotLoaded then
	Notify({
		Title = TaskHubScriptIdentity,
		Subtitle = "Already loaded.",
		Icon = "rbxassetid://7315883219",
		Duration = 10.5,
		SoundId = "rbxassetid://8551372796"
	})
	return
end

pcall(function() getgenv().TaskHubNicoNextbotLoaded = true end)

Notify({
	Title = TaskHubScriptIdentity,
	Subtitle = "thanks for using the script ;>",
	Icon = "rbxassetid://6724406109",
	Duration = 5,
	SoundId = "rbxassetid://8551372796"
})

local CoreGui = Services.CoreGui
local Players = Services.Players
local RunService = Services.RunService
local HttpService = Services.HttpService
local TweenService = Services.TweenService
local UserInputService = Services.UserInputService
xpcall(function()
	IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
end, function()
	IsOnMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end)

if get_hidden_gui or gethui then
	local hiddenUI = get_hidden_gui or gethui
	local Main = inew("ScreenGui", {
		Name = randomString(),
		ScreenInsets = Enum.ScreenInsets.None,
		Parent = hiddenUI()
	})
	PARENT = Main
elseif (not is_sirhurt_closure) and (syn and syn.protect_gui) then
	local Main = inew("ScreenGui", {
		Name = randomString(),
		ScreenInsets = Enum.ScreenInsets.None,
		Parent = CoreGui
	})
	syn.protect_gui(Main)
	PARENT = Main
elseif CoreGui:FindFirstChild("RobloxGui") then
	PARENT = CoreGui.RobloxGui
else
	local Main = inew("ScreenGui", {
		Name = randomString(),
		ScreenInsets = Enum.ScreenInsets.None,
		Parent = CoreGui
	})
	PARENT = Main
end

local LocalUser = Players.LocalPlayer
local BasePlayerScripts = YieldForChild(LocalUser, "PlayerScripts")
local BasePlayerGui = YieldForChild(LocalUser, "PlayerGui")

local GameSettings = YieldForChild(BasePlayerScripts, "game")
local BotsSpritesManager = YieldForChild(GameSettings, "boteffects")
local BotManagerEnabled = LemonSignal.wrap(BotsSpritesManager:GetPropertyChangedSignal("Enabled"))

pcall(function()
	if sethidden then
		sethidden(BotsSpritesManager, "Enabled", false)
	else
		BotsSpritesManager.Enabled = false
	end
end)

BotManagerEnabled:Connect(function()
	if BotsSpritesManager.Disabled == false then
		if sethidden then
			sethidden(BotsSpritesManager, "Enabled", false)
		else
			BotsSpritesManager.Enabled = false
		end
	end
end)

local Menu = YieldForChild(BasePlayerGui, "menu")
local Assets = YieldForChild(Menu, "assets")
local SFX = YieldForChild(Assets, "sfx")
local BGM = YieldForChild(SFX, "bgm")
local Equalizer = BGM:FindFirstChildWhichIsA("EqualizerSoundEffect")
local Reverb = BGM:FindFirstChildWhichIsA("ReverbSoundEffect")

local ChamStorage = inew("Folder", {
	Name = "TaskHub | ChamStorage",
	Parent = PARENT
})

for _, folder in {"TaskHub", "TaskHub/NicoNextbot", "TaskHub/NicoNextbot/assets"} do
	if not isfolder(folder) then
		makefolder(folder)
	end
	if not isfile("TaskHub/NicoNextbot/assets/NicoNextbot-LucidLobby.mp3") then
		local bytecode = game:HttpGetAsync("https://raw.githubusercontent.com/not-taskkill/op-rep/refs/heads/main/Musics/nico's%20nextbots%20ost%20-%20lucid%20lobby.txt")
		writefile("TaskHub/NicoNextbot/assets/NicoNextbot-LucidLobby.mp3", base64dec(bytecode))
	end
	if IsOnMobile then writefile("TaskHub/NicoNextbot/assets/.nomedia") end
end

local asset_id = waxgetcustomasset("TaskHub/NicoNextbot/assets/NicoNextbot-LucidLobby.mp3")
local function FixBGMSoundEffect()
	if BGM and typeof(BGM) == "Instance" then
		if sethidden then
			sethidden(BGM, "SoundId", asset_id)
			sethidden(BGM, "Volume", 0.9)
			sethidden(BGM, "PlaybackSpeed", 1)
			sethidden(Equalizer, "Enabled", false)
			sethidden(Reverb, "Enabled", false)
		else
			BGM.SoundId = asset_id
			BGM.Volume = 0.9
			BGM.PlaybackSpeed = 1
			Equalizer.Enabled = false
			Reverb.Enabled = false
		end
		BGM:SetAttribute("original", asset_id)
	end
end

local function TransitionUI(AwaitTime)
	local Info = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
	local BlackFrame = inew("Frame", {
		Name = randomString(),
		ZIndex = 9e99,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Parent = PARENT
	})
	local FadeIn = TweenService:Create(BlackFrame, Info, {
		BackgroundTransparency = 0
	}):Play()
	task.wait(AwaitTime or 5)
	local FadeOut = TweenService:Create(BlackFrame, Info, {
		BackgroundTransparency = 1
	})
	FadeOut:Play()
	FadeOut.Completed:Once(function()
		pcall(gdestroy, BlackFrame)
		pcall(gdestroy, FadeIn)
		pcall(gdestroy, FadeOut)
	end)
end

TransitionUI(10)

RunService:BindToRenderStep(HttpService:GenerateGUID(false), Enum.RenderPriority.Camera.Value, FixBGMSoundEffect)

local function ApplyCham(Object, Ancestry)
	if not Object or not Ancestry then return end
	
	local AncestryChanged = LemonSignal.wrap(Object.AncestryChanged)
	local Cham = inew("Highlight", {
		Enabled = true,
		Name = randomString(),
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
		FillColor = Color3.fromRGB(138, 99, 255),
		OutlineColor = Color3.fromRGB(138, 99, 255),
		OutlineTransparency = 0.25,
		FillTransparency = 0.85,
		Adornee = Object,
		Parent = ChamStorage
	})
	
	AncestryChanged:Connect(function(_, newAncestry)
		if newAncestry ~= Ancestry then
			pcall(gdestroy, Cham)
			AncestryChanged:Destroy()
			return
		end
	end)
end

local function ApplyBotEsp(Bot)
	if Bot and typeof(Bot) == "Instance" then
		if IsA(Bot, "BillboardGui") then
			local BotImage = Bot:FindFirstChildWhichIsA("ImageLabel") or Bot:WaitForChild("ImageLabel", 5)
			if sethidden then
				sethidden(Bot, "Enabled", true)
				sethidden(Bot, "AlwaysOnTop", true)
				sethidden(BotImage, "ImageTransparency", 0.2)
			else
				Bot.AlwaysOnTop = true
				Bot.Enabled = true
				BotImage.ImageTransparency = 0.2
			end
		elseif IsA(Bot, "Model") then
			ApplyCham(Bot, Bot.Parent)
		end
	end
end

local Bots = YieldForChild(workspace, "bots")

local PlayerAdded = LemonSignal.wrap(Players.PlayerAdded)
local BotAdded = LemonSignal.wrap(Bots.DescendantAdded)

for _, Kid in pairs(Bots:GetDescendants()) do
	if Kid and typeof(Kid) == "Instance" then
		ApplyBotEsp(Kid)
	end
end

BotAdded:Connect(function(Kid)
	if Kid and typeof(Kid) == "Instance" then
		ApplyBotEsp(Kid)
	end
end)

for _, User in pairs(Players:GetPlayers()) do
	if User and typeof(User) == "Instance" then
		if User.Character then
			for _, Kid in ipairs(User.Character:GetDescendants()) do
				if IsA(Kid, "BillboardGui") and Kid.Name == "icon" then
					ApplyBotEsp(Kid)
				end
			end
			User.Character.DescendantAdded:Connect(function(Kid)
				if IsA(Kid, "BillboardGui") and Kid.Name == "icon" then
					ApplyBotEsp(Kid)
				end
			end)
		end

		local CharacterAdded = LemonSignal.wrap(User.CharacterAdded)
		CharacterAdded:Connect(function()
			for _, Kid in ipairs(User.Character:GetDescendants()) do
				if IsA(Kid, "BillboardGui") and Kid.Name == "icon" then
					ApplyBotEsp(Kid)
				end
			end
			User.Character.DescendantAdded:Connect(function(Kid)
				if IsA(Kid, "BillboardGui") and Kid.Name == "icon" then
					ApplyBotEsp(Kid)
				end
			end)
		end)
	end
end

PlayerAdded:Connect(function(User)
	if User and typeof(User) == "Instance" then
		if User.Character then
			for _, Kid in ipairs(User.Character:GetDescendants()) do
				if IsA(Kid, "BillboardGui") and Kid.Name == "icon" then
					ApplyBotEsp(Kid)
				end
			end
			User.Character.DescendantAdded:Connect(function(Kid)
				if IsA(Kid, "BillboardGui") and Kid.Name == "icon" then
					ApplyBotEsp(Kid)
				end
			end)
		end
		
		local CharacterAdded = LemonSignal.wrap(User.CharacterAdded)
		CharacterAdded:Connect(function()
			for _, Kid in ipairs(User.Character:GetDescendants()) do
				if IsA(Kid, "BillboardGui") and Kid.Name == "icon" then
					ApplyBotEsp(Kid)
				end
			end
			User.Character.DescendantAdded:Connect(function(Kid)
				if IsA(Kid, "BillboardGui") and Kid.Name == "icon" then
					ApplyBotEsp(Kid)
				end
			end)
		end)
	end
end)