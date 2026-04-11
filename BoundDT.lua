
repeat
	wait(0.1)
until game:IsLoaded() and game.Players and game.Players.LocalPlayer

if getgenv().SomtankIsRun then
	return
end
getgenv().SomtankIsRun = true

pcall(function()
	queue_on_teleport([[
	 repeat wait(0.1) until game:IsLoaded() and game.Players and game.Players.LocalPlayer
     loadstring(game:HttpGet("https://raw.githubusercontent.com/M4VOWJ8IAKSR5WFRCCJ7AW5IW/ScrFr/refs/heads/main/BoundDT.lua"))()
    ]])
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local lobbyId = 116495829188952
local isLobby = (game.PlaceId == lobbyId)

-- === 1. การจัดการ UI (CoreGui) ===
local parentUI = gethui and gethui() or game:GetService("CoreGui")
if parentUI:FindFirstChild("SomtankFarmUI") then
	parentUI.SomtankFarmUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SomtankFarmUI"
screenGui.IgnoreGuiInset = true
screenGui.Parent = parentUI

-- ระบบ Blur ใน Lobby
local blurEffect = Lighting:FindFirstChild("SomtankBlur")
if not blurEffect then
	blurEffect = Instance.new("BlurEffect")
	blurEffect.Name = "SomtankBlur"
	blurEffect.Size = 0
	blurEffect.Parent = Lighting
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 25)
mainFrame.BackgroundTransparency = isLobby and 0.4 or 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

local function setUIState(visible)
	mainFrame.Visible = visible
	if isLobby then
		TweenService:Create(blurEffect, TweenInfo.new(0.5), { Size = visible and 20 or 0 }):Play()
	end
end

-- เปิด Blur ทันทีถ้าอยู่ใน Lobby
if isLobby then
	blurEffect.Size = 20
end

-- ใส่ Gradient ม่วง-ดำ
local uiGradient = Instance.new("UIGradient")
uiGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 0, 80)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 20)),
})
uiGradient.Rotation = 45
uiGradient.Parent = mainFrame

-- ฟังก์ชันสร้าง Text พร้อม Stroke
local function createText(text, size, pos, parent)
	local lbl = Instance.new("TextLabel")
	lbl.Text = text
	lbl.Size = UDim2.new(0, 400, 0, 50)
	lbl.Position = pos
	lbl.AnchorPoint = Vector2.new(0.5, 0.5)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	lbl.TextSize = size
	lbl.Font = Enum.Font.GothamBold
	lbl.Parent = parent

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Parent = lbl
	return lbl
end

-- === 2. องค์ประกอบ UI ===
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 160, 0, 160)
logo.Position = UDim2.new(0.5, 0, 0.4, 0)
logo.AnchorPoint = Vector2.new(0.5, 0.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://108281745434228"
logo.Parent = mainFrame

local title = createText("Somtank ฟาร์มเงินแดง", 28, UDim2.new(0.5, 0, 0.53, 0), mainFrame)
title.TextColor3 = Color3.fromRGB(200, 100, 255)

local currencyLabel = createText("กำลังโหลด..", 20, UDim2.new(0.5, 0, 0.59, 0), mainFrame)

-- === 3. Loading Bar (เฉพาะตอนฟาร์ม/ในเกม) ===
local loadingBg = Instance.new("Frame")
loadingBg.Size = UDim2.new(0, 300, 0, 10)
loadingBg.Position = UDim2.new(0.5, 0, 0.65, 0)
loadingBg.AnchorPoint = Vector2.new(0.5, 0.5)
loadingBg.BackgroundColor3 = Color3.fromRGB(40, 0, 60)
loadingBg.Parent = mainFrame

local loadingFill = Instance.new("Frame")
loadingFill.Size = UDim2.new(0, 0, 1, 0)
loadingFill.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
loadingFill.BorderSizePixel = 0
loadingFill.Parent = loadingBg

Instance.new("UICorner", loadingBg).CornerRadius = UDim.new(1, 0)
Instance.new("UICorner", loadingFill).CornerRadius = UDim.new(1, 0)

local loadingText =
	createText("เตรียมกลับ Lobby ใน: 60s", 14, UDim2.new(0.5, 0, 0.68, 0), mainFrame)

-- === 4. ปุ่มเปิด/ปิด UI (ย้ายมาไว้ตรงกลางขอบบน) ===
if isLobby then
	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Name = "SomtankToggle"
	toggleBtn.Size = UDim2.new(0, 120, 0, 30) -- ปรับขนาดให้เล็กลงหน่อย
	toggleBtn.Position = UDim2.new(0.5, 0, 0, 10) -- ไว้ตรงกลาง (0.5) ขอบบน (10)
	toggleBtn.AnchorPoint = Vector2.new(0.5, 0) -- ให้จุดหมุนอยู่ตรงกลางปุ่ม
	toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
	toggleBtn.Text = "ปิดหน้าจอ"
	toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleBtn.Font = Enum.Font.GothamBold
	toggleBtn.TextSize = 14
	toggleBtn.Parent = screenGui

	-- ใส่ขอบและเงาให้ปุ่มดูดีขึ้น
	Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 6)
	local stroke = Instance.new("UIStroke", toggleBtn)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.5

	toggleBtn.MouseButton1Click:Connect(function()
		local newState = not mainFrame.Visible
		setUIState(newState)
		toggleBtn.Text = newState and "ปิดหน้าจอ" or "เปิดหน้าจอ"

		-- เปลี่ยนสีปุ่มตอนปิด/เปิด ให้สังเกตง่าย
		toggleBtn.BackgroundColor3 = newState and Color3.fromRGB(80, 0, 150) or Color3.fromRGB(40, 40, 40)
	end)
end

-- === 5. ระบบนับถอยหลัง & Teleport ===
task.spawn(function()
	local timeLeft = 60
	while timeLeft > 0 do
		loadingText.Text = "เตรียมกลับ Lobby ใน: " .. timeLeft .. "s"
		loadingFill.Size = UDim2.new(1 - (timeLeft / 60), 0, 1, 0)
		task.wait(1)
		timeLeft = timeLeft - 1
	end
	TeleportService:Teleport(lobbyId, player)
end)

-- === 6. Marquee & Buttons (Source เดิม) ===
local announcementFrame = Instance.new("Frame")
announcementFrame.Size = UDim2.new(1, 0, 0, 40)
announcementFrame.Position = UDim2.new(0, 0, 0.95, 0)
announcementFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 50)
announcementFrame.BackgroundTransparency = 0.5
announcementFrame.ClipsDescendants = true
announcementFrame.Parent = mainFrame

local newsText = Instance.new("TextLabel")
newsText.Size = UDim2.new(1, 0, 1, 0)
newsText.Position = UDim2.new(1, 0, 0, 0)
newsText.BackgroundTransparency = 1
newsText.TextColor3 = Color3.fromRGB(255, 255, 255)
newsText.TextSize = 18
newsText.Font = Enum.Font.GothamMedium
newsText.Parent = announcementFrame

local messages = {
	"อย่าลืมกดติดตามช่องผมนะครับ @somtank",
	"ขอบคุณที่เล่นสคริปคนไทยนะครับ",
	"สุขสันต์วันสงกรานต์ครับ!",
}
task.spawn(function()
	while true do
		for _, msg in pairs(messages) do
			newsText.Text = msg
			newsText.Position = UDim2.new(1, 0, 0, 0)
			local t = TweenService:Create(
				newsText,
				TweenInfo.new(8, Enum.EasingStyle.Linear),
				{ Position = UDim2.new(0, -newsText.TextBounds.X - 500, 0, 0) }
			)
			t:Play()
			t.Completed:Wait()
		end
	end
end)

-- [ปุ่มคัดลอก - Source เดิม]
local frameButtons = Instance.new("Frame")
frameButtons.Size = UDim2.new(0, 400, 0, 50)
frameButtons.Position = UDim2.new(0.5, 0, 0.75, 0)
frameButtons.AnchorPoint = Vector2.new(0.5, 0.5)
frameButtons.BackgroundTransparency = 1
frameButtons.Parent = mainFrame
local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Padding = UDim.new(0, 15)
layout.Parent = frameButtons

local function createBtn(name, link)
	local btn = Instance.new("TextButton")
	btn.Text = name
	btn.Size = UDim2.new(0, 110, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(80, 0, 150)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Parent = frameButtons
	Instance.new("UICorner", btn)
	btn.MouseButton1Click:Connect(function()
		setclipboard(link)
		btn.Text = "Copied!"
		task.wait(1)
		btn.Text = name
	end)
end
createBtn("YouTube", "https://www.youtube.com/@somtank")
createBtn("Website", "https://somtank.vhous.xyz/")
createBtn("Discord", "https://discord.gg/uamwRU9ETU")

-- === 7. ระบบเช็คเงิน & Logic การฟาร์ม (ห้ามแก้) ===
task.spawn(function()
	while task.wait(1) do
		local path = isLobby and player.PlayerGui:FindFirstChild("BondDisplay")
			or player.PlayerGui:FindFirstChild("BondGui")
		local val = path and path.BondInfo.BondCount.Text
		currencyLabel.Text = (val and val ~= "0") and "เงินแดงที่มี: " .. val
			or "กำลังโหลด.."
	end
end)

if not isLobby then
	RunService:Set3dRenderingEnabled(false)
end

-- [ระบบสร้างห้อง & Actionable เหมือนเดิม]
if isLobby then
	task.spawn(function()
		local character = player.Character or player.CharacterAdded:Wait()
		local zones = workspace:WaitForChild("PartyZones")
		local createPartyRemote = ReplicatedStorage:WaitForChild("Shared")
			:WaitForChild("Universe")
			:WaitForChild("Network")
			:WaitForChild("RemoteEvent")
			:WaitForChild("CreateParty")
		for _, z in pairs(zones:GetChildren()) do
			local h = z:FindFirstChild("Hitbox")
			if h then
				local occ = false
				for _, p in pairs(workspace:GetPartsInPart(h)) do
					if p.Parent:FindFirstChild("Humanoid") and p.Parent ~= character then
						occ = true
						break
					end
				end
				if not occ then
					character:PivotTo(h.CFrame * CFrame.new(0, 2, 0))
					task.wait(1)
					if firetouchinterest then
						firetouchinterest(character.HumanoidRootPart, h, 0)
						task.wait(0.1)
						firetouchinterest(character.HumanoidRootPart, h, 1)
					end
					task.wait(1)
					local args = {
						[1] = {
							isPrivate = true,
							maxMembers = 1,
							trainId = "default",
							gameMode = "Normal",
						},
					}
					createPartyRemote:FireServer(unpack(args))
					break
				end
			end
		end
	end)
else
	task.spawn(function()
		local remote = ReplicatedStorage.Shared.Universe.Network.RemoteEvent.Actionable
		for i = 1, 3000 do
			remote:FireServer(i)
			task.wait(0.001)
		end
		TeleportService:Teleport(lobbyId, player)
	end)
end
