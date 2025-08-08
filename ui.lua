local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
UserInputService.MouseIconEnabled = false
RunService:BindToRenderStep("ForceMouseCenter", Enum.RenderPriority.Last.Value + 1, function()
    if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end)
--[[
  LoadingScreenScript.lua
  Author: Zeel
  Purpose: Simulates an 8-minute loading screen for Roblox
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoadingScreen"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Background Frame
local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.Parent = screenGui

-- Loading Text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0.1, 0)
loadingText.Position = UDim2.new(0, 0, 0.4, 0)
loadingText.Text = "Hang on the script is loading should take 2-5 minutes"
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.BackgroundTransparency = 1
loadingText.Font = Enum.Font.SourceSansBold
loadingText.TextSize = 28
loadingText.Parent = bg

-- Progress Bar Background
local progressBarBG = Instance.new("Frame")
progressBarBG.Size = UDim2.new(0.5, 0, 0.05, 0)
progressBarBG.Position = UDim2.new(0.25, 0, 0.5, 0)
progressBarBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
progressBarBG.BorderSizePixel = 0
progressBarBG.Parent = bg

-- Progress Bar Fill
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBG

-- Progress Text
local progressText = Instance.new("TextLabel")
progressText.Size = UDim2.new(1, 0, 0.1, 0)
progressText.Position = UDim2.new(0, 0, 0.55, 0)
progressText.Text = "Loading... 0%"
progressText.TextColor3 = Color3.fromRGB(255, 255, 255)
progressText.BackgroundTransparency = 1
progressText.Font = Enum.Font.SourceSans
progressText.TextSize = 20
progressText.Parent = bg

-- Loading Logic
local totalTime = 480 -- 8 minutes in seconds
local currentTime = 0

while currentTime <= totalTime do
    local progress = currentTime / totalTime
    progressBar.Size = UDim2.new(progress, 0, 1, 0)
    progressText.Text = string.format("Loading... %d%%", math.floor(progress * 100))

    wait(1)
    currentTime = currentTime + 1
end

-- Remove the loading screen
screenGui:Destroy()
