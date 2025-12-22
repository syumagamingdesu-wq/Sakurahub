local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Orion UIライブラリの読み込み - 茶色の背景色を適用
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/jadpy/suki/refs/heads/main/orion"))()

-- Orion UIの色設定をカスタマイズ
local Theme = {
    BackgroundColor = Color3.fromRGB(139, 69, 19),  -- 茶色 (Brown)
    SliderColor = Color3.fromRGB(255, 105, 180),     -- ホットピンク (Hot Pink)
    TextColor = Color3.fromRGB(255, 255, 255),       -- 白 (White)
    SectionColor = Color3.fromRGB(210, 180, 140),    -- 薄茶色 (Light Brown)
}

-- ====================================================================
-- 横一列の配置設定（羽） - 独立した設定
-- ====================================================================
local FeatherConfig = {
    Enabled = false,  -- 羽の機能はデフォルトでオフ
    spacing = 3,
    heightOffset = 2,
    backwardOffset = 3,  -- 前方オフセットから背中オフセットに変更
    maxSparklers = 20,
    tiltAngle = 45,
    waveSpeed = 2,
    baseAmplitude = 1,
}

-- 羽の専用変数
local FeatherToys = {}
local FeatherRowPoints = {}
local FeatherAssignedToys = {}
local FeatherLoopConn = nil
local FeatherTime = 0

-- ====================================================================
-- 魔法陣［RingX2］機能 - 独立した設定
-- ====================================================================
local RingConfig = {
    Enabled = false,
    RingHeight = 5.0,
    RingDiameter = 5.0,
    ObjectCount = 10,
    RotationSpeed = 20.0
}

local RingList = {}
local RingLoopConn = nil
local RingTAccum = 0

-- ====================================================================
-- ハート形配置機能
-- ====================================================================
local HeartConfig = {
    Enabled = false,
    Height = 5.0,           -- 高さ
    Size = 5.0,             -- ハートのサイズ
    ObjectCount = 12,       -- 花火の数
    RotationSpeed = 1.0,    -- 回転速度
    PulseSpeed = 2.0,       -- 脈動速度
    PulseAmplitude = 0.5,   -- 脈動振幅
    FollowPlayer = true,    -- プレイヤーを追従
}

local HeartToys = {}
local HeartPoints = {}
local HeartAssignedToys = {}
local HeartLoopConn = nil
local HeartTime = 0

-- ====================================================================
-- おっきぃ♡配置機能（大きいハート）- 速度設定を拡張
-- ====================================================================
local BigHeartConfig = {
    Enabled = false,
    Height = 8.0,           -- 高さ（デフォルトより高い）
    Size = 10.0,            -- ハートのサイズ（大きい）
    ObjectCount = 20,       -- 花火の数（多い）
    RotationSpeed = 0.5,    -- 回転速度（ゆっくり）
    RotationSpeedMax = 10.0, -- 最大回転速度（追加）
    PulseSpeed = 1.0,       -- 脈動速度（ゆっくり）
    PulseSpeedMax = 10.0,   -- 最大脈動速度（追加）
    PulseAmplitude = 1.0,   -- 脈動振幅（大きい）
    FollowPlayer = true,    -- プレイヤーを追従
    HeartScale = 2.0,       -- スケール係数
    VerticalStretch = 1.2,  -- 垂直方向の伸び
}

local BigHeartToys = {}
local BigHeartPoints = {}
local BigHeartAssignedToys = {}
local BigHeartLoopConn = nil
local BigHeartTime = 0

-- ====================================================================
-- ダビデ星配置機能
-- ====================================================================
local StarOfDavidConfig = {
    Enabled = false,
    Height = 5.0,           -- 高さ
    Size = 5.0,             -- サイズ
    ObjectCount = 12,       -- 花火の数（6の倍数推奨）
    RotationSpeed = 1.0,    -- 回転速度
    PulseSpeed = 1.5,       -- 脈動速度
    FollowPlayer = true,    -- プレイヤーを追従
    TriangleHeight = 0.5,   -- 三角形の高さ
}

local StarOfDavidToys = {}
local StarOfDavidPoints = {}
local StarOfDavidAssignedToys = {}
local StarOfDavidLoopConn = nil
local StarOfDavidTime = 0

-- ====================================================================
-- スター配置機能（⭐️の形）
-- ====================================================================
local StarConfig = {
    Enabled = false,
    Height = 5.0,           -- 高さ
    Size = 5.0,             -- サイズ
    ObjectCount = 10,       -- 花火の数
    RotationSpeed = 1.0,    -- 回転速度
    TwinkleSpeed = 2.0,     -- きらめき速度
    FollowPlayer = true,    -- プレイヤーを追従
    StarPoints = 5,         -- 星の頂点数（5角星）
    OuterRadius = 5.0,      -- 外側の半径
    InnerRadius = 2.0,      -- 内側の半径
}

local StarToys = {}
local StarPoints = {}
local StarAssignedToys = {}
local StarLoopConn = nil
local StarTime = 0

-- ====================================================================
-- スーパーリング（竜巻）配置機能
-- ====================================================================
local SuperRingConfig = {
    Enabled = false,
    BaseHeight = 2.0,       -- 基本高さ
    Height = 10.0,          -- 全体の高さ
    Radius = 3.0,           -- 半径
    ObjectCount = 16,       -- 花火の数
    RotationSpeed = 2.0,    -- 回転速度
    SpiralSpeed = 1.0,      -- らせん速度
    WaveSpeed = 1.5,        -- 波の速度
    WaveAmplitude = 0.5,    -- 波の振幅
    FollowPlayer = true,    -- プレイヤーを追従
    TornadoEffect = true,   -- 竜巻効果
}

local SuperRingToys = {}
local SuperRingPoints = {}
local SuperRingAssignedToys = {}
local SuperRingLoopConn = nil
local SuperRingTime = 0

-- ====================================================================
-- 卍マンジ配置機能（追加）
-- ====================================================================
local ManjiConfig = {
    Enabled = false,
    Height = 6.0,           -- 高さ
    Size = 8.0,             -- サイズ
    ObjectCount = 16,       -- 花火の数
    RotationSpeed = 1.0,    -- 回転速度
    RotationSpeedMax = 15.0, -- 最大回転速度
    PulseSpeed = 2.0,       -- 脈動速度
    PulseSpeedMax = 15.0,   -- 最大脈動速度
    PulseAmplitude = 0.8,   -- 脈動振幅
    FollowPlayer = true,    -- プレイヤーを追従
    ArmLength = 1.5,        -- 卍の腕の長さ
    ArmThickness = 0.3,     -- 腕の太さ
}

local ManjiToys = {}
local ManjiPoints = {}
local ManjiAssignedToys = {}
local ManjiLoopConn = nil
local ManjiTime = 0

-- ====================================================================
-- スター2✫配置機能（追加 - 太陽のようなギザギザ模様）
-- ====================================================================
local Star2Config = {
    Enabled = false,
    Height = 10.0,          -- 高さ
    Size = 15.0,            -- 基本サイズ
    ObjectCount = 24,       -- 花火の数（多い）
    RotationSpeed = 5.0,    -- 回転速度（高速）
    RotationSpeedMax = 30.0, -- 最大回転速度
    PulseSpeed = 8.0,       -- 脈動速度（高速）
    PulseSpeedMax = 20.0,   -- 最大脈動速度
    PulseAmplitude = 2.0,   -- 脈動振幅（大きい）
    FollowPlayer = true,    -- プレイヤーを追従
    RayCount = 12,          -- 光線の数
    RayLength = 3.0,        -- 光線の長さ
    RayLengthMax = 10.0,    -- 最大光線長
    JitterSpeed = 5.0,      -- ギザギザの揺れ速度
    JitterAmount = 1.0,     -- ギザギザの揺れ量
    SizeMax = 30.0,         -- 最大サイズ
}

local Star2Toys = {}
local Star2Points = {}
local Star2AssignedToys = {}
local Star2LoopConn = nil
local Star2Time = 0

-- ====================================================================
-- 便利機能 (Mi(=^・^=))
-- ====================================================================
local UtilityConfig = {
    InfiniteJump = false,
    Noclip = false,
}

local NoclipConnection = nil
local OriginalCollision = {}

-- ====================================================================
-- 共通ユーティリティ関数
-- ====================================================================
local function findFireworkSparklers()
    local toys = {}
    
    for _, item in ipairs(workspace:GetDescendants()) do
        if item:IsA("Model") and item.Name == "FireworkSparkler" then
            local alreadyAdded = false
            for _, existingToy in ipairs(toys) do
                if existingToy == item then
                    alreadyAdded = true
                    break
                end
            end
            if not alreadyAdded then
                table.insert(toys, item)
            end
        end
    end
    
    table.sort(toys, function(a, b)
        return a.Name < b.Name
    end)
    
    return toys
end

local function getPrimaryPart(model)
    if model.PrimaryPart then
        return model.PrimaryPart
    end
    
    local potentialParts = {"Handle", "Main", "Part", "Base", "Sparkler", "Firework"}
    for _, partName in ipairs(potentialParts) do
        local part = model:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            return part
        end
    end
    
    for _, child in ipairs(model:GetChildren()) do
        if child:IsA("BasePart") then
            return child
        end
    end
    
    return nil
end

-- ====================================================================
-- Noclip修正関数
-- ====================================================================
local function enableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    -- 元の衝突判定を保存
    OriginalCollision = {}
    if LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                OriginalCollision[part] = part.CanCollide
            end
        end
    end
    
    -- Noclipを有効化
    NoclipConnection = RunService.Stepped:Connect(function()
        if UtilityConfig.Noclip and LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)
end

local function disableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    -- 元の衝突判定を復元
    if LocalPlayer.Character then
        for part, canCollide in pairs(OriginalCollision) do
            if part and part.Parent then
                part.CanCollide = canCollide
            end
        end
        OriginalCollision = {}
    end
end

-- ====================================================================
-- 羽（Feather）機能専用関数
-- ====================================================================
local function createFeatherRowPoints(count)
    local points = {}
    
    if count == 0 then return points end
    
    local totalWidth = (count - 1) * FeatherConfig.spacing
    local startX = -totalWidth / 2
    
    for i = 1, count do
        local x = startX + (i - 1) * FeatherConfig.spacing
        local part = Instance.new("Part")
        part.CanCollide = false
        part.Anchored = true
        part.Transparency = 1
        part.Size = Vector3.new(4, 1, 4)
        part.Parent = workspace
        
        points[i] = {
            offsetX = x,
            part = part,
            assignedToy = nil,
        }
    end
    
    return points
end

local function attachFeatherPhysics(part)
    if not part then return nil, nil end
    
    local existingBG = part:FindFirstChildOfClass("BodyGyro")
    local existingBP = part:FindFirstChildOfClass("BodyPosition")
    
    if existingBG and existingBP then 
        return existingBG, existingBP
    end
    
    if existingBG then existingBG:Destroy() end
    if existingBP then existingBP:Destroy() end
    
    local BP = Instance.new("BodyPosition")  
    local BG = Instance.new("BodyGyro")  
    
    BP.P = 15000  
    BP.D = 200  
    BP.MaxForce = Vector3.new(1, 1, 1) * 1e10  
    BP.Parent = part  
    
    BG.P = 15000  
    BG.D = 200  
    BG.MaxTorque = Vector3.new(1, 1, 1) * 1e10  
    BG.Parent = part  
    
    return BG, BP
end

local function assignFeatherToysToPoints()
    FeatherAssignedToys = {}
    local distanceGroups = {}
    
    for i, point in ipairs(FeatherRowPoints) do
        local absDistance = math.abs(point.offsetX)
        
        if not distanceGroups[absDistance] then
            distanceGroups[absDistance] = {}
        end
        table.insert(distanceGroups[absDistance], i)
    end
    
    local sortedDistances = {}
    for distance, _ in pairs(distanceGroups) do
        table.insert(sortedDistances, distance)
    end
    table.sort(sortedDistances)
    
    for rank, distance in ipairs(sortedDistances) do
        for _, pointIndex in ipairs(distanceGroups[distance]) do
            FeatherRowPoints[pointIndex].distanceRank = rank
        end
    end
    
    for i = 1, math.min(#FeatherToys, #FeatherRowPoints) do
        local toy = FeatherToys[i]
        if toy and toy:IsA("Model") and toy.Name == "FireworkSparkler" then
            local primaryPart = getPrimaryPart(toy)
            
            if primaryPart then  
                for _, child in ipairs(toy:GetChildren()) do  
                    if child:IsA("BasePart") then  
                        child.CanCollide = false
                        child.CanTouch = false
                        child.Anchored = false
                    end  
                end
                
                local BG, BP = attachFeatherPhysics(primaryPart)  
                local toyTable = {  
                    BG = BG,  
                    BP = BP,  
                    Pallet = primaryPart,
                    Model = toy,
                    RowIndex = i,
                    offsetX = FeatherRowPoints[i].offsetX,
                    distanceRank = FeatherRowPoints[i].distanceRank
                }  
                
                FeatherRowPoints[i].assignedToy = toyTable
                table.insert(FeatherAssignedToys, toyTable)
            end  
        end
    end
    
    return FeatherAssignedToys
end

local function startFeatherLoop()
    if FeatherLoopConn then
        FeatherLoopConn:Disconnect()
        FeatherLoopConn = nil
    end
    
    FeatherTime = 0
    
    FeatherLoopConn = RunService.RenderStepped:Connect(function(dt)
        if not FeatherConfig.Enabled or not LocalPlayer.Character then
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local torso = LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
        
        if not humanoidRootPart or not torso then
            return
        end
        
        FeatherTime += dt * FeatherConfig.waveSpeed
        
        local charCFrame = humanoidRootPart.CFrame
        local rightVector = charCFrame.RightVector
        local lookVector = charCFrame.LookVector
        
        -- 背中側に配置するために、前方ではなく後方にオフセット
        local backVector = -lookVector
        
        local basePosition = torso.Position + 
                             Vector3.new(0, FeatherConfig.heightOffset, 0) + 
                             (backVector * FeatherConfig.backwardOffset)
        
        for i, point in ipairs(FeatherRowPoints) do
            if point.assignedToy and point.assignedToy.BP and point.assignedToy.BG then
                local toy = point.assignedToy
                
                local targetPosition = basePosition + (rightVector * toy.offsetX)
                
                local amplitude = FeatherConfig.baseAmplitude * toy.distanceRank
                local waveMovement = math.sin(FeatherTime) * amplitude
                local finalPosition = targetPosition + Vector3.new(0, waveMovement, 0)
                
                if point.part then
                    point.part.Position = finalPosition
                end
                
                toy.BP.Position = finalPosition
                
                -- プレイヤーの背中側を向くように修正
                local backYRotation = math.atan2(-lookVector.X, -lookVector.Z)
                local baseCFrame = CFrame.new(finalPosition) * CFrame.Angles(0, backYRotation, 0)
                local tiltedCFrame = baseCFrame * CFrame.Angles(math.rad(-FeatherConfig.tiltAngle), 0, 0)
                
                local currentCFrame = toy.BG.CFrame
                local interpolatedCFrame = currentCFrame:Lerp(tiltedCFrame, 0.3)
                
                toy.BG.CFrame = interpolatedCFrame
            end
        end
    end)
end

local function stopFeatherLoop()
    if FeatherLoopConn then
        FeatherLoopConn:Disconnect()
        FeatherLoopConn = nil
    end
    
    -- 物理演算をクリーンアップ
    for _, point in ipairs(FeatherRowPoints) do
        if point.part then
            point.part:Destroy()
        end
        if point.assignedToy then
            if point.assignedToy.BG then
                point.assignedToy.BG:Destroy()
            end
            if point.assignedToy.BP then
                point.assignedToy.BP:Destroy()
            end
        end
    end
    
    FeatherRowPoints = {}
    FeatherAssignedToys = {}
end

local function toggleFeather(state)
    FeatherConfig.Enabled = state
    if state then
        -- 他の機能を停止（同時に両方は動作しない）
        if RingConfig.Enabled then
            toggleRingAura(false)
        end
        if HeartConfig.Enabled then
            toggleHeart(false)
        end
        if BigHeartConfig.Enabled then
            toggleBigHeart(false)
        end
        if StarOfDavidConfig.Enabled then
            toggleStarOfDavid(false)
        end
        if StarConfig.Enabled then
            toggleStar(false)
        end
        if SuperRingConfig.Enabled then
            toggleSuperRing(false)
        end
        if ManjiConfig.Enabled then
            toggleManji(false)
        end
        if Star2Config.Enabled then
            toggleStar2(false)
        end
        
        FeatherToys = findFireworkSparklers()
        FeatherRowPoints = createFeatherRowPoints(math.min(#FeatherToys, FeatherConfig.maxSparklers))
        FeatherAssignedToys = assignFeatherToysToPoints()
        startFeatherLoop()
        
        OrionLib:MakeNotification({
            Name = "羽[Feather]起動",
            Content = "花火数: " .. #FeatherAssignedToys .. "本 (背中側)",
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    else
        stopFeatherLoop()
        OrionLib:MakeNotification({
            Name = "羽[Feather]停止",
            Content = "羽の配置を解除しました",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

-- ====================================================================
-- 魔法陣［RingX2］機能専用関数
-- ====================================================================
local function HRP()
    local c = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return c:FindFirstChild("HumanoidRootPart")
end

local function attachRingPhysics(rec)
    local model = rec.model
    local part = rec.part
    if not model or not part or not part.Parent then return end
    
    -- ネットワークオーナー設定
    for _, p in ipairs(model:GetDescendants()) do
        if p:IsA("BasePart") then
            pcall(function() p:SetNetworkOwner(LocalPlayer) end)
            p.CanCollide = false
            p.CanTouch = false
        end
    end
    
    -- BodyVelocity追加
    if not part:FindFirstChild("RingBodyVelocity") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "RingBodyVelocity"
        bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        bv.Velocity = Vector3.new()
        bv.P = 1e6
        bv.Parent = part
    end
    
    -- BodyGyro追加
    if not part:FindFirstChild("RingBodyGyro") then
        local bg = Instance.new("BodyGyro")
        bg.Name = "RingBodyGyro"
        bg.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
        bg.CFrame = part.CFrame
        bg.P = 1e6
        bg.Parent = part
    end
end

local function detachRingPhysics(rec)
    local model = rec.model
    local part = rec.part
    if not model or not part then return end
    
    local bv = part:FindFirstChild("RingBodyVelocity")
    if bv then bv:Destroy() end
    
    local bg = part:FindFirstChild("RingBodyGyro")
    if bg then bg:Destroy() end
    
    for _, p in ipairs(model:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = true
            p.CanTouch = true
            pcall(function() p:SetNetworkOwner(nil) end)
        end
    end
end

local function rescanRing()
    for _, r in ipairs(RingList) do
        detachRingPhysics(r)
    end
    RingList = {}
    
    local foundCount = 0
    
    for _, d in ipairs(workspace:GetDescendants()) do
        if foundCount >= RingConfig.ObjectCount then break end
        
        if d:IsA("Model") and d.Name == "FireworkSparkler" then
            local part = getPrimaryPart(d)
            if part and not part.Anchored then
                local rec = { model = d, part = part }
                table.insert(RingList, rec)
                foundCount = foundCount + 1
            end
        end
    end
    
    for i = 1, #RingList do
        attachRingPhysics(RingList[i])
    end
end

local function startRingLoop()
    if RingLoopConn then
        RingLoopConn:Disconnect()
        RingLoopConn = nil
    end
    RingTAccum = 0
    
    RingLoopConn = RunService.Heartbeat:Connect(function(dt)
        if not RingConfig.Enabled then return end
        
        local root = HRP()
        if not root or #RingList == 0 then return end
        
        RingTAccum = RingTAccum + dt * (RingConfig.RotationSpeed / 10)
        
        local radius = RingConfig.RingDiameter / 2
        local angleIncrement = 360 / #RingList
        
        -- HRPの速度を取得 (飛行中も追従させるため)
        local rootVelocity = root.AssemblyLinearVelocity or root.Velocity or Vector3.new()
        
        for i, rec in ipairs(RingList) do
            local part = rec.part
            if not part or not part.Parent then continue end
            
            -- 回転角度計算
            local angle = math.rad(i * angleIncrement + RingTAccum * 50)
            
            -- リング上の位置計算 (HRPの向きに関係なく水平リングを維持)
            local localPos = Vector3.new(
                radius * math.cos(angle),
                RingConfig.RingHeight,
                radius * math.sin(angle)
            )
            
            -- ワールド座標での目標位置 (HRPの回転を無視して水平を維持)
            local targetPos = root.Position + localPos
            
            -- BodyVelocityで移動 (飛行中の速度も加算)
            local dir = targetPos - part.Position
            local distance = dir.Magnitude
            local bv = part:FindFirstChild("RingBodyVelocity")
            
            if bv then
                if distance > 0.1 then
                    -- HRPの速度を加算して飛行中も追従
                    local moveVelocity = dir.Unit * math.min(3000, distance * 50)
                    bv.Velocity = moveVelocity + rootVelocity
                else
                    bv.Velocity = rootVelocity
                end
            end
            
            -- BodyGyroで回転 (外側を向く)
            local bg = part:FindFirstChild("RingBodyGyro")
            if bg then
                local lookAtCFrame = CFrame.lookAt(targetPos, root.Position) * CFrame.Angles(0, math.pi, 0)
                bg.CFrame = lookAtCFrame
            end
        end
    end)
end

local function stopRingLoop()
    if RingLoopConn then
        RingLoopConn:Disconnect()
        RingLoopConn = nil
    end
    for _, rec in ipairs(RingList) do
        detachRingPhysics(rec)
    end
    RingList = {}
end

local function toggleRingAura(state)
    RingConfig.Enabled = state
    if state then
        -- 他の機能を停止（同時に両方は動作しない）
        if FeatherConfig.Enabled then
            toggleFeather(false)
        end
        if HeartConfig.Enabled then
            toggleHeart(false)
        end
        if BigHeartConfig.Enabled then
            toggleBigHeart(false)
        end
        if StarOfDavidConfig.Enabled then
            toggleStarOfDavid(false)
        end
        if StarConfig.Enabled then
            toggleStar(false)
        end
        if SuperRingConfig.Enabled then
            toggleSuperRing(false)
        end
        if ManjiConfig.Enabled then
            toggleManji(false)
        end
        if Star2Config.Enabled then
            toggleStar2(false)
        end
        
        rescanRing()
        startRingLoop()
        OrionLib:MakeNotification({
            Name = "魔法陣［RingX2］起動",
            Content = "高さ: " .. RingConfig.RingHeight .. ", 直径: " .. RingConfig.RingDiameter .. ", 数: " .. RingConfig.ObjectCount,
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    else
        stopRingLoop()
        OrionLib:MakeNotification({
            Name = "魔法陣［RingX2］停止",
            Content = "リングオーラを解除しました",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

-- ====================================================================
-- ハート形配置機能専用関数
-- ====================================================================
local function createHeartPoints(count)
    local points = {}
    
    if count == 0 then return points end
    
    for i = 1, count do
        -- ハート曲線に沿った角度を計算
        local t = (i - 1) * (2 * math.pi / count)
        
        -- 参考点用パート
        local part = Instance.new("Part")
        part.CanCollide = false
        part.Anchored = true
        part.Transparency = 1
        part.Size = Vector3.new(4, 1, 4)
        part.Parent = workspace
        
        points[i] = {
            angle = t,
            part = part,
            assignedToy = nil,
        }
    end
    
    return points
end

local function getHeartPosition(t, size, pulse, scale, verticalStretch)
    -- ハート曲線のパラメトリック方程式
    -- x = 16 * sin^3(t)
    -- y = 13 * cos(t) - 5 * cos(2t) - 2 * cos(3t) - cos(4t)
    
    local baseScale = size / 20  -- スケーリング係数
    local currentScale = baseScale * (scale or 1)
    
    -- ハートのX座標
    local x = 16 * (math.sin(t) ^ 3) * currentScale
    
    -- ハートのY座標
    local y = (13 * math.cos(t) - 5 * math.cos(2*t) - 2 * math.cos(3*t) - math.cos(4*t)) * currentScale
    
    -- 垂直方向の伸びを適用
    if verticalStretch and verticalStretch > 1 then
        y = y * verticalStretch
    end
    
    -- 脈動効果を加える
    if pulse > 0 then
        local pulseFactor = 1 + (pulse * 0.1)
        x = x * pulseFactor
        y = y * pulseFactor
    end
    
    return x, y
end

local function attachHeartPhysics(part)
    if not part then return nil, nil end
    
    local existingBG = part:FindFirstChildOfClass("BodyGyro")
    local existingBP = part:FindFirstChildOfClass("BodyPosition")
    
    if existingBG and existingBP then 
        return existingBG, existingBP
    end
    
    if existingBG then existingBG:Destroy() end
    if existingBP then existingBP:Destroy() end
    
    local BP = Instance.new("BodyPosition")  
    local BG = Instance.new("BodyGyro")  
    
    BP.P = 15000  
    BP.D = 200  
    BP.MaxForce = Vector3.new(1, 1, 1) * 1e10  
    BP.Parent = part  
    
    BG.P = 15000  
    BG.D = 200  
    BG.MaxTorque = Vector3.new(1, 1, 1) * 1e10  
    BG.Parent = part  
    
    return BG, BP
end

local function assignHeartToysToPoints()
    HeartAssignedToys = {}
    
    for i = 1, math.min(#HeartToys, #HeartPoints) do
        local toy = HeartToys[i]
        if toy and toy:IsA("Model") and toy.Name == "FireworkSparkler" then
            local primaryPart = getPrimaryPart(toy)
            
            if primaryPart then  
                for _, child in ipairs(toy:GetChildren()) do  
                    if child:IsA("BasePart") then  
                        child.CanCollide = false
                        child.CanTouch = false
                        child.Anchored = false
                    end  
                end
                
                local BG, BP = attachHeartPhysics(primaryPart)  
                local toyTable = {  
                    BG = BG,  
                    BP = BP,  
                    Pallet = primaryPart,
                    Model = toy,
                    PointIndex = i,
                    baseAngle = HeartPoints[i].angle,
                }  
                
                HeartPoints[i].assignedToy = toyTable
                table.insert(HeartAssignedToys, toyTable)
            end  
        end
    end
    
    return HeartAssignedToys
end

local function startHeartLoop()
    if HeartLoopConn then
        HeartLoopConn:Disconnect()
        HeartLoopConn = nil
    end
    
    HeartTime = 0
    
    HeartLoopConn = RunService.RenderStepped:Connect(function(dt)
        if not HeartConfig.Enabled or not LocalPlayer.Character then
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local torso = LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
        
        if not humanoidRootPart or not torso then
            return
        end
        
        HeartTime += dt
        
        local basePosition
        if HeartConfig.FollowPlayer then
            basePosition = torso.Position
        else
            -- プレイヤーの現在位置を基準にするが追従しない
            basePosition = torso.Position
        end
        
        -- 脈動効果の計算
        local pulseEffect = 0
        if HeartConfig.PulseSpeed > 0 then
            pulseEffect = math.sin(HeartTime * HeartConfig.PulseSpeed) * HeartConfig.PulseAmplitude
        end
        
        for i, point in ipairs(HeartPoints) do
            if point.assignedToy and point.assignedToy.BP and point.assignedToy.BG then
                local toy = point.assignedToy
                
                -- 回転角度を計算（時間経過で回転）
                local currentAngle = toy.baseAngle + (HeartTime * HeartConfig.RotationSpeed)
                
                -- ハート曲線上の位置を計算
                local x, y = getHeartPosition(currentAngle, HeartConfig.Size, pulseEffect, 1, 1)
                
                -- 高さ調整（少しランダムな高さで立体的に）
                local heightOffset = HeartConfig.Height + (math.sin(currentAngle * 2) * 0.5)
                
                -- 最終的な位置（上から見た時にハート形になるようXZ平面で配置）
                local localPos = Vector3.new(x, heightOffset, y)
                
                local targetPosition = basePosition + localPos
                
                if point.part then
                    point.part.Position = targetPosition
                end
                
                toy.BP.Position = targetPosition
                
                -- 上を向くように設定
                toy.BG.CFrame = CFrame.new(targetPosition) * CFrame.Angles(-math.rad(90), 0, 0)
            end
        end
    end)
end

local function stopHeartLoop()
    if HeartLoopConn then
        HeartLoopConn:Disconnect()
        HeartLoopConn = nil
    end
    
    -- 物理演算をクリーンアップ
    for _, point in ipairs(HeartPoints) do
        if point.part then
            point.part:Destroy()
        end
        if point.assignedToy then
            if point.assignedToy.BG then
                point.assignedToy.BG:Destroy()
            end
            if point.assignedToy.BP then
                point.assignedToy.BP:Destroy()
            end
        end
    end
    
    HeartPoints = {}
    HeartAssignedToys = {}
end

local function toggleHeart(state)
    HeartConfig.Enabled = state
    if state then
        -- 他の機能を停止（同時に両方は動作しない）
        if FeatherConfig.Enabled then
            toggleFeather(false)
        end
        if RingConfig.Enabled then
            toggleRingAura(false)
        end
        if BigHeartConfig.Enabled then
            toggleBigHeart(false)
        end
        if StarOfDavidConfig.Enabled then
            toggleStarOfDavid(false)
        end
        if StarConfig.Enabled then
            toggleStar(false)
        end
        if SuperRingConfig.Enabled then
            toggleSuperRing(false)
        end
        if ManjiConfig.Enabled then
            toggleManji(false)
        end
        if Star2Config.Enabled then
            toggleStar2(false)
        end
        
        HeartToys = findFireworkSparklers()
        HeartPoints = createHeartPoints(math.min(#HeartToys, HeartConfig.ObjectCount))
        HeartAssignedToys = assignHeartToysToPoints()
        startHeartLoop()
        
        OrionLib:MakeNotification({
            Name = "♡ハート♡起動",
            Content = "サイズ: " .. HeartConfig.Size .. ", 高さ: " .. HeartConfig.Height .. ", 数: " .. HeartConfig.ObjectCount,
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    else
        stopHeartLoop()
        OrionLib:MakeNotification({
            Name = "♡ハート♡停止",
            Content = "ハート形配置を解除しました",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

-- ====================================================================
-- おっきぃ♡配置機能専用関数（大きいハート）- 速度拡張版
-- ====================================================================
local function createBigHeartPoints(count)
    local points = {}
    
    if count == 0 then return points end
    
    for i = 1, count do
        -- ハート曲線に沿った角度を計算
        local t = (i - 1) * (2 * math.pi / count)
        
        -- 参考点用パート
        local part = Instance.new("Part")
        part.CanCollide = false
        part.Anchored = true
        part.Transparency = 1
        part.Size = Vector3.new(4, 1, 4)
        part.Parent = workspace
        
        points[i] = {
            angle = t,
            part = part,
            assignedToy = nil,
        }
    end
    
    return points
end

local function assignBigHeartToysToPoints()
    BigHeartAssignedToys = {}
    
    for i = 1, math.min(#BigHeartToys, #BigHeartPoints) do
        local toy = BigHeartToys[i]
        if toy and toy:IsA("Model") and toy.Name == "FireworkSparkler" then
            local primaryPart = getPrimaryPart(toy)
            
            if primaryPart then  
                for _, child in ipairs(toy:GetChildren()) do  
                    if child:IsA("BasePart") then  
                        child.CanCollide = false
                        child.CanTouch = false
                        child.Anchored = false
                    end  
                end
                
                local BG, BP = attachHeartPhysics(primaryPart)  
                local toyTable = {  
                    BG = BG,  
                    BP = BP,  
                    Pallet = primaryPart,
                    Model = toy,
                    PointIndex = i,
                    baseAngle = BigHeartPoints[i].angle,
                }  
                
                BigHeartPoints[i].assignedToy = toyTable
                table.insert(BigHeartAssignedToys, toyTable)
            end  
        end
    end
    
    return BigHeartAssignedToys
end

local function startBigHeartLoop()
    if BigHeartLoopConn then
        BigHeartLoopConn:Disconnect()
        BigHeartLoopConn = nil
    end
    
    BigHeartTime = 0
    
    BigHeartLoopConn = RunService.RenderStepped:Connect(function(dt)
        if not BigHeartConfig.Enabled or not LocalPlayer.Character then
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local torso = LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
        
        if not humanoidRootPart or not torso then
            return
        end
        
        BigHeartTime += dt
        
        local basePosition
        if BigHeartConfig.FollowPlayer then
            basePosition = torso.Position
        else
            -- プレイヤーの現在位置を基準にするが追従しない
            basePosition = torso.Position
        end
        
        -- 脈動効果の計算（拡張された速度範囲）
        local pulseEffect = 0
        if BigHeartConfig.PulseSpeed > 0 then
            pulseEffect = math.sin(BigHeartTime * BigHeartConfig.PulseSpeed) * BigHeartConfig.PulseAmplitude
        end
        
        for i, point in ipairs(BigHeartPoints) do
            if point.assignedToy and point.assignedToy.BP and point.assignedToy.BG then
                local toy = point.assignedToy
                
                -- 回転角度を計算（拡張された速度範囲）
                local currentAngle = toy.baseAngle + (BigHeartTime * BigHeartConfig.RotationSpeed)
                
                -- 大きなハート曲線上の位置を計算
                local x, y = getHeartPosition(
                    currentAngle, 
                    BigHeartConfig.Size, 
                    pulseEffect, 
                    BigHeartConfig.HeartScale,
                    BigHeartConfig.VerticalStretch
                )
                
                -- 高さ調整（大きいハートなので高さも大きめ）
                local heightOffset = BigHeartConfig.Height + (math.sin(currentAngle * 2) * 1.0)
                
                -- 最終的な位置（上から見た時にハート形になるようXZ平面で配置）
                local localPos = Vector3.new(x, heightOffset, y)
                
                local targetPosition = basePosition + localPos
                
                if point.part then
                    point.part.Position = targetPosition
                end
                
                toy.BP.Position = targetPosition
                
                -- 上を向くように設定
                toy.BG.CFrame = CFrame.new(targetPosition) * CFrame.Angles(-math.rad(90), 0, 0)
            end
        end
    end)
end

local function stopBigHeartLoop()
    if BigHeartLoopConn then
        BigHeartLoopConn:Disconnect()
        BigHeartLoopConn = nil
    end
    
    -- 物理演算をクリーンアップ
    for _, point in ipairs(BigHeartPoints) do
        if point.part then
            point.part:Destroy()
        end
        if point.assignedToy then
            if point.assignedToy.BG then
                point.assignedToy.BG:Destroy()
            end
            if point.assignedToy.BP then
                point.assignedToy.BP:Destroy()
            end
        end
    end
    
    BigHeartPoints = {}
    BigHeartAssignedToys = {}
end

local function toggleBigHeart(state)
    BigHeartConfig.Enabled = state
    if state then
        -- 他の機能を停止（同時に両方は動作しない）
        if FeatherConfig.Enabled then
            toggleFeather(false)
        end
        if RingConfig.Enabled then
            toggleRingAura(false)
        end
        if HeartConfig.Enabled then
            toggleHeart(false)
        end
        if StarOfDavidConfig.Enabled then
            toggleStarOfDavid(false)
        end
        if StarConfig.Enabled then
            toggleStar(false)
        end
        if SuperRingConfig.Enabled then
            toggleSuperRing(false)
        end
        if ManjiConfig.Enabled then
            toggleManji(false)
        end
        if Star2Config.Enabled then
            toggleStar2(false)
        end
        
        BigHeartToys = findFireworkSparklers()
        BigHeartPoints = createBigHeartPoints(math.min(#BigHeartToys, BigHeartConfig.ObjectCount))
        BigHeartAssignedToys = assignBigHeartToysToPoints()
        startBigHeartLoop()
        
        OrionLib:MakeNotification({
            Name = "おっきぃ♡起動",
            Content = "サイズ: " .. BigHeartConfig.Size .. "×" .. BigHeartConfig.HeartScale .. ", 高さ: " .. BigHeartConfig.Height .. ", 数: " .. BigHeartConfig.ObjectCount,
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    else
        stopBigHeartLoop()
        OrionLib:MakeNotification({
            Name = "おっきぃ♡停止",
            Content = "大きなハート形配置を解除しました",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

-- ====================================================================
-- ダビデ星配置機能専用関数
-- ====================================================================
local function createStarOfDavidPoints(count)
    local points = {}
    
    if count == 0 then return points end
    
    for i = 1, count do
        -- 6角形の頂点に配置（2つの正三角形を重ねた形）
        local angle = (i - 1) * (2 * math.pi / 6)
        
        -- 参考点用パート
        local part = Instance.new("Part")
        part.CanCollide = false
        part.Anchored = true
        part.Transparency = 1
        part.Size = Vector3.new(4, 1, 4)
        part.Parent = workspace
        
        points[i] = {
            angle = angle,
            part = part,
            assignedToy = nil,
            triangleIndex = math.floor((i - 1) / 2) + 1,  -- 三角形のインデックス
        }
    end
    
    return points
end

local function getStarOfDavidPosition(i, angle, size, triangleHeight, time, pulseSpeed)
    local scale = size / 10
    
    -- 基本的な六角形の位置
    local baseX = math.cos(angle) * scale
    local baseZ = math.sin(angle) * scale
    
    -- 三角形の高さを考慮（上下の三角形）
    local heightOffset = 0
    if i % 2 == 0 then
        -- 上の三角形の頂点
        heightOffset = triangleHeight
    else
        -- 下の三角形の頂点
        heightOffset = -triangleHeight
    end
    
    -- 脈動効果
    local pulse = math.sin(time * pulseSpeed) * 0.1
    
    return baseX, baseZ, heightOffset + pulse
end

local function attachStarOfDavidPhysics(part)
    if not part then return nil, nil end
    
    local existingBG = part:FindFirstChildOfClass("BodyGyro")
    local existingBP = part:FindFirstChildOfClass("BodyPosition")
    
    if existingBG and existingBP then 
        return existingBG, existingBP
    end
    
    if existingBG then existingBG:Destroy() end
    if existingBP then existingBP:Destroy() end
    
    local BP = Instance.new("BodyPosition")  
    local BG = Instance.new("BodyGyro")  
    
    BP.P = 15000  
    BP.D = 200  
    BP.MaxForce = Vector3.new(1, 1, 1) * 1e10  
    BP.Parent = part  
    
    BG.P = 15000  
    BG.D = 200  
    BG.MaxTorque = Vector3.new(1, 1, 1) * 1e10  
    BG.Parent = part  
    
    return BG, BP
end

local function assignStarOfDavidToysToPoints()
    StarOfDavidAssignedToys = {}
    
    for i = 1, math.min(#StarOfDavidToys, #StarOfDavidPoints) do
        local toy = StarOfDavidToys[i]
        if toy and toy:IsA("Model") and toy.Name == "FireworkSparkler" then
            local primaryPart = getPrimaryPart(toy)
            
            if primaryPart then  
                for _, child in ipairs(toy:GetChildren()) do  
                    if child:IsA("BasePart") then  
                        child.CanCollide = false
                        child.CanTouch = false
                        child.Anchored = false
                    end  
                end
                
                local BG, BP = attachStarOfDavidPhysics(primaryPart)  
                local toyTable = {  
                    BG = BG,  
                    BP = BP,  
                    Pallet = primaryPart,
                    Model = toy,
                    PointIndex = i,
                    baseAngle = StarOfDavidPoints[i].angle,
                    triangleIndex = StarOfDavidPoints[i].triangleIndex,
                }  
                
                StarOfDavidPoints[i].assignedToy = toyTable
                table.insert(StarOfDavidAssignedToys, toyTable)
            end  
        end
    end
    
    return StarOfDavidAssignedToys
end

local function startStarOfDavidLoop()
    if StarOfDavidLoopConn then
        StarOfDavidLoopConn:Disconnect()
        StarOfDavidLoopConn = nil
    end
    
    StarOfDavidTime = 0
    
    StarOfDavidLoopConn = RunService.RenderStepped:Connect(function(dt)
        if not StarOfDavidConfig.Enabled or not LocalPlayer.Character then
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local torso = LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
        
        if not humanoidRootPart or not torso then
            return
        end
        
        StarOfDavidTime += dt
        
        local basePosition
        if StarOfDavidConfig.FollowPlayer then
            basePosition = torso.Position
        else
            basePosition = torso.Position
        end
        
        for i, point in ipairs(StarOfDavidPoints) do
            if point.assignedToy and point.assignedToy.BP and point.assignedToy.BG then
                local toy = point.assignedToy
                
                -- 回転角度を計算
                local currentAngle = toy.baseAngle + (StarOfDavidTime * StarOfDavidConfig.RotationSpeed)
                
                -- ダビデ星の位置を計算
                local x, z, heightOffset = getStarOfDavidPosition(
                    i, currentAngle, StarOfDavidConfig.Size, 
                    StarOfDavidConfig.TriangleHeight, StarOfDavidTime, StarOfDavidConfig.PulseSpeed
                )
                
                -- 最終的な高さ
                local finalHeight = StarOfDavidConfig.Height + heightOffset
                
                -- 最終的な位置
                local localPos = Vector3.new(x, finalHeight, z)
                local targetPosition = basePosition + localPos
                
                if point.part then
                    point.part.Position = targetPosition
                end
                
                toy.BP.Position = targetPosition
                
                -- 外側を向く
                local direction = (targetPosition - basePosition).Unit
                if direction.Magnitude > 0 then
                    local lookCFrame = CFrame.lookAt(targetPosition, targetPosition + direction)
                    toy.BG.CFrame = lookCFrame
                end
            end
        end
    end)
end

local function stopStarOfDavidLoop()
    if StarOfDavidLoopConn then
        StarOfDavidLoopConn:Disconnect()
        StarOfDavidLoopConn = nil
    end
    
    -- 物理演算をクリーンアップ
    for _, point in ipairs(StarOfDavidPoints) do
        if point.part then
            point.part:Destroy()
        end
        if point.assignedToy then
            if point.assignedToy.BG then
                point.assignedToy.BG:Destroy()
            end
            if point.assignedToy.BP then
                point.assignedToy.BP:Destroy()
            end
        end
    end
    
    StarOfDavidPoints = {}
    StarOfDavidAssignedToys = {}
end

local function toggleStarOfDavid(state)
    StarOfDavidConfig.Enabled = state
    if state then
        -- 他の機能を停止（同時に両方は動作しない）
        if FeatherConfig.Enabled then
            toggleFeather(false)
        end
        if RingConfig.Enabled then
            toggleRingAura(false)
        end
        if HeartConfig.Enabled then
            toggleHeart(false)
        end
        if BigHeartConfig.Enabled then
            toggleBigHeart(false)
        end
        if StarConfig.Enabled then
            toggleStar(false)
        end
        if SuperRingConfig.Enabled then
            toggleSuperRing(false)
        end
        if ManjiConfig.Enabled then
            toggleManji(false)
        end
        if Star2Config.Enabled then
            toggleStar2(false)
        end
        
        StarOfDavidToys = findFireworkSparklers()
        StarOfDavidPoints = createStarOfDavidPoints(math.min(#StarOfDavidToys, StarOfDavidConfig.ObjectCount))
        StarOfDavidAssignedToys = assignStarOfDavidToysToPoints()
        startStarOfDavidLoop()
        
        OrionLib:MakeNotification({
            Name = "ダビデ✡起動",
            Content = "サイズ: " .. StarOfDavidConfig.Size .. ", 高さ: " .. StarOfDavidConfig.Height .. ", 数: " .. StarOfDavidConfig.ObjectCount,
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    else
        stopStarOfDavidLoop()
        OrionLib:MakeNotification({
            Name = "ダビデ✡停止",
            Content = "ダビデ星配置を解除しました",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

-- ====================================================================
-- スター配置機能専用関数（⭐️の形）
-- ====================================================================
local function createStarPoints(count)
    local points = {}
    
    if count == 0 then return points end
    
    for i = 1, count do
        -- 星の頂点に沿って配置（10個の頂点：5つの外側頂点と5つの内側頂点）
        local starIndex = (i - 1) % 10  -- 0-9
        local isOuter = starIndex % 2 == 0  -- 外側頂点（0,2,4,6,8）
        
        -- 参考点用パート
        local part = Instance.new("Part")
        part.CanCollide = false
        part.Anchored = true
        part.Transparency = 1
        part.Size = Vector3.new(4, 1, 4)
        part.Parent = workspace
        
        points[i] = {
            starIndex = starIndex,
            isOuter = isOuter,
            part = part,
            assignedToy = nil,
        }
    end
    
    return points
end

local function getStarPosition(starIndex, isOuter, outerRadius, innerRadius, time, rotationSpeed, twinkleSpeed)
    -- 星の角度（5角星なので72度間隔）
    local anglePerPoint = 2 * math.pi / 5
    local pointAngle = starIndex * (anglePerPoint / 2)  -- 内側と外側が交互になる
    
    -- 星の頂点の半径を決定
    local radius = isOuter and outerRadius or innerRadius
    
    -- 回転効果
    local rotationAngle = pointAngle + (time * rotationSpeed)
    
    -- 星の位置を計算
    local x = math.cos(rotationAngle) * radius
    local z = math.sin(rotationAngle) * radius
    
    -- きらめき効果
    local twinkle = math.sin(time * twinkleSpeed + starIndex) * 0.2
    local finalRadius = radius * (1 + twinkle)
    x = math.cos(rotationAngle) * finalRadius
    z = math.sin(rotationAngle) * finalRadius
    
    return x, z, pointAngle
end

local function attachStarPhysics(part)
    if not part then return nil, nil end
    
    local existingBG = part:FindFirstChildOfClass("BodyGyro")
    local existingBP = part:FindFirstChildOfClass("BodyPosition")
    
    if existingBG and existingBP then 
        return existingBG, existingBP
    end
    
    if existingBG then existingBG:Destroy() end
    if existingBP then existingBP:Destroy() end
    
    local BP = Instance.new("BodyPosition")  
    local BG = Instance.new("BodyGyro")  
    
    BP.P = 15000  
    BP.D = 200  
    BP.MaxForce = Vector3.new(1, 1, 1) * 1e10  
    BP.Parent = part  
    
    BG.P = 15000  
    BG.D = 200  
    BG.MaxTorque = Vector3.new(1, 1, 1) * 1e10  
    BG.Parent = part  
    
    return BG, BP
end

local function assignStarToysToPoints()
    StarAssignedToys = {}
    
    for i = 1, math.min(#StarToys, #StarPoints) do
        local toy = StarToys[i]
        if toy and toy:IsA("Model") and toy.Name == "FireworkSparkler" then
            local primaryPart = getPrimaryPart(toy)
            
            if primaryPart then  
                for _, child in ipairs(toy:GetChildren()) do  
                    if child:IsA("BasePart") then  
                        child.CanCollide = false
                        child.CanTouch = false
                        child.Anchored = false
                    end  
                end
                
                local BG, BP = attachStarPhysics(primaryPart)  
                local toyTable = {  
                    BG = BG,  
                    BP = BP,  
                    Pallet = primaryPart,
                    Model = toy,
                    PointIndex = i,
                    starIndex = StarPoints[i].starIndex,
                    isOuter = StarPoints[i].isOuter,
                }  
                
                StarPoints[i].assignedToy = toyTable
                table.insert(StarAssignedToys, toyTable)
            end  
        end
    end
    
    return StarAssignedToys
end

local function startStarLoop()
    if StarLoopConn then
        StarLoopConn:Disconnect()
        StarLoopConn = nil
    end
    
    StarTime = 0
    
    StarLoopConn = RunService.RenderStepped:Connect(function(dt)
        if not StarConfig.Enabled or not LocalPlayer.Character then
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local torso = LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
        
        if not humanoidRootPart or not torso then
            return
        end
        
        StarTime += dt
        
        local basePosition
        if StarConfig.FollowPlayer then
            basePosition = torso.Position
        else
            basePosition = torso.Position
        end
        
        for i, point in ipairs(StarPoints) do
            if point.assignedToy and point.assignedToy.BP and point.assignedToy.BG then
                local toy = point.assignedToy
                
                -- 星の位置を計算
                local x, z, pointAngle = getStarPosition(
                    toy.starIndex, toy.isOuter, 
                    StarConfig.OuterRadius, StarConfig.InnerRadius,
                    StarTime, StarConfig.RotationSpeed, StarConfig.TwinkleSpeed
                )
                
                -- 高さ調整（星の頂点によって少し変化）
                local heightVariation = math.sin(pointAngle * 3) * 0.5
                local finalHeight = StarConfig.Height + heightVariation
                
                -- 最終的な位置
                local localPos = Vector3.new(x, finalHeight, z)
                local targetPosition = basePosition + localPos
                
                if point.part then
                    point.part.Position = targetPosition
                end
                
                toy.BP.Position = targetPosition
                
                -- 星の中心から外側を向く
                local direction = (targetPosition - basePosition).Unit
                if direction.Magnitude > 0 then
                    local lookCFrame = CFrame.lookAt(targetPosition, targetPosition + direction)
                    toy.BG.CFrame = lookCFrame
                end
            end
        end
    end)
end

local function stopStarLoop()
    if StarLoopConn then
        StarLoopConn:Disconnect()
        StarLoopConn = nil
    end
    
    -- 物理演算をクリーンアップ
    for _, point in ipairs(StarPoints) do
        if point.part then
            point.part:Destroy()
        end
        if point.assignedToy then
            if point.assignedToy.BG then
                point.assignedToy.BG:Destroy()
            end
            if point.assignedToy.BP then
                point.assignedToy.BP:Destroy()
            end
        end
    end
    
    StarPoints = {}
    StarAssignedToys = {}
end

local function toggleStar(state)
    StarConfig.Enabled = state
    if state then
        -- 他の機能を停止（同時に両方は動作しない）
        if FeatherConfig.Enabled then
            toggleFeather(false)
        end
        if RingConfig.Enabled then
            toggleRingAura(false)
        end
        if HeartConfig.Enabled then
            toggleHeart(false)
        end
        if BigHeartConfig.Enabled then
            toggleBigHeart(false)
        end
        if StarOfDavidConfig.Enabled then
            toggleStarOfDavid(false)
        end
        if SuperRingConfig.Enabled then
            toggleSuperRing(false)
        end
        if ManjiConfig.Enabled then
            toggleManji(false)
        end
        if Star2Config.Enabled then
            toggleStar2(false)
        end
        
        StarToys = findFireworkSparklers()
        StarPoints = createStarPoints(math.min(#StarToys, StarConfig.ObjectCount))
        StarAssignedToys = assignStarToysToPoints()
        startStarLoop()
        
        OrionLib:MakeNotification({
            Name = "スター★起動",
            Content = "外径: " .. StarConfig.OuterRadius .. ", 内径: " .. StarConfig.InnerRadius .. ", 数: " .. StarConfig.ObjectCount,
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    else
        stopStarLoop()
        OrionLib:MakeNotification({
            Name = "スター★停止",
            Content = "星形配置を解除しました",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

-- ====================================================================
-- スーパーリング（竜巻）配置機能専用関数
-- ====================================================================
local function createSuperRingPoints(count)
    local points = {}
    
    if count == 0 then return points end
    
    for i = 1, count do
        -- らせんに沿った角度を計算
        local angle = (i - 1) * (2 * math.pi / count)
        
        -- 参考点用パート
        local part = Instance.new("Part")
        part.CanCollide = false
        part.Anchored = true
        part.Transparency = 1
        part.Size = Vector3.new(4, 1, 4)
        part.Parent = workspace
        
        points[i] = {
            angle = angle,
            part = part,
            assignedToy = nil,
            heightOffset = (i - 1) * (SuperRingConfig.Height / count),  -- 高さオフセット
        }
    end
    
    return points
end

local function getSuperRingPosition(angle, radius, heightOffset, time, rotationSpeed, spiralSpeed, waveSpeed, waveAmplitude, tornadoEffect)
    -- 基本の円周上の位置
    local x = math.cos(angle) * radius
    local z = math.sin(angle) * radius
    
    -- 回転効果
    local rotationAngle = angle + (time * rotationSpeed)
    x = math.cos(rotationAngle) * radius
    z = math.sin(rotationAngle) * radius
    
    -- らせん効果
    local spiralOffset = 0
    if spiralSpeed > 0 then
        spiralOffset = math.sin(time * spiralSpeed + angle) * 0.5
    end
    
    -- 波の効果
    local waveOffset = 0
    if waveSpeed > 0 then
        waveOffset = math.sin(time * waveSpeed + angle * 2) * waveAmplitude
    end
    
    -- 竜巻効果（半径が高さによって変わる）
    local currentRadius = radius
    if tornadoEffect then
        -- 高くなるほど半径が小さくなる
        local heightFactor = 1 - (heightOffset / SuperRingConfig.Height) * 0.5
        currentRadius = radius * heightFactor
        x = math.cos(rotationAngle) * currentRadius
        z = math.sin(rotationAngle) * currentRadius
    end
    
    -- 最終的な高さ
    local finalHeight = SuperRingConfig.BaseHeight + heightOffset + spiralOffset + waveOffset
    
    return x, z, finalHeight, currentRadius
end

local function attachSuperRingPhysics(part)
    if not part then return nil, nil end
    
    local existingBG = part:FindFirstChildOfClass("BodyGyro")
    local existingBP = part:FindFirstChildOfClass("BodyPosition")
    
    if existingBG and existingBP then 
        return existingBG, existingBP
    end
    
    if existingBG then existingBG:Destroy() end
    if existingBP then existingBP:Destroy() end
    
    local BP = Instance.new("BodyPosition")  
    local BG = Instance.new("BodyGyro")  
    
    BP.P = 15000  
    BP.D = 200  
    BP.MaxForce = Vector3.new(1, 1, 1) * 1e10  
    BP.Parent = part  
    
    BG.P = 15000  
    BG.D = 200  
    BG.MaxTorque = Vector3.new(1, 1, 1) * 1e10  
    BG.Parent = part  
    
    return BG, BP
end

local function assignSuperRingToysToPoints()
    SuperRingAssignedToys = {}
    
    for i = 1, math.min(#SuperRingToys, #SuperRingPoints) do
        local toy = SuperRingToys[i]
        if toy and toy:IsA("Model") and toy.Name == "FireworkSparkler" then
            local primaryPart = getPrimaryPart(toy)
            
            if primaryPart then  
                for _, child in ipairs(toy:GetChildren()) do  
                    if child:IsA("BasePart") then  
                        child.CanCollide = false
                        child.CanTouch = false
                        child.Anchored = false
                    end  
                end
                
                local BG, BP = attachSuperRingPhysics(primaryPart)  
                local toyTable = {  
                    BG = BG,  
                    BP = BP,  
                    Pallet = primaryPart,
                    Model = toy,
                    PointIndex = i,
                    baseAngle = SuperRingPoints[i].angle,
                    baseHeightOffset = SuperRingPoints[i].heightOffset,
                }  
                
                SuperRingPoints[i].assignedToy = toyTable
                table.insert(SuperRingAssignedToys, toyTable)
            end  
        end
    end
    
    return SuperRingAssignedToys
end

local function startSuperRingLoop()
    if SuperRingLoopConn then
        SuperRingLoopConn:Disconnect()
        SuperRingLoopConn = nil
    end
    
    SuperRingTime = 0
    
    SuperRingLoopConn = RunService.RenderStepped:Connect(function(dt)
        if not SuperRingConfig.Enabled or not LocalPlayer.Character then
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local torso = LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
        
        if not humanoidRootPart or not torso then
            return
        end
        
        SuperRingTime += dt
        
        local basePosition
        if SuperRingConfig.FollowPlayer then
            basePosition = torso.Position
        else
            basePosition = torso.Position
        end
        
        for i, point in ipairs(SuperRingPoints) do
            if point.assignedToy and point.assignedToy.BP and point.assignedToy.BG then
                local toy = point.assignedToy
                
                -- 角度を計算
                local currentAngle = toy.baseAngle + (SuperRingTime * SuperRingConfig.RotationSpeed * 0.5)
                
                -- スーパーリングの位置を計算
                local x, z, height, radius = getSuperRingPosition(
                    currentAngle, SuperRingConfig.Radius, toy.baseHeightOffset,
                    SuperRingTime, SuperRingConfig.RotationSpeed, SuperRingConfig.SpiralSpeed,
                    SuperRingConfig.WaveSpeed, SuperRingConfig.WaveAmplitude, SuperRingConfig.TornadoEffect
                )
                
                -- 最終的な位置
                local localPos = Vector3.new(x, height, z)
                local targetPosition = basePosition + localPos
                
                if point.part then
                    point.part.Position = targetPosition
                end
                
                toy.BP.Position = targetPosition
                
                -- 竜巻効果がある場合、外側を向く
                if SuperRingConfig.TornadoEffect then
                    local direction = (targetPosition - basePosition).Unit
                    if direction.Magnitude > 0 then
                        local lookCFrame = CFrame.lookAt(targetPosition, targetPosition + direction)
                        toy.BG.CFrame = lookCFrame
                    end
                else
                    -- 上を向く
                    toy.BG.CFrame = CFrame.new(targetPosition) * CFrame.Angles(-math.rad(90), 0, 0)
                end
            end
        end
    end)
end

local function stopSuperRingLoop()
    if SuperRingLoopConn then
        SuperRingLoopConn:Disconnect()
        SuperRingLoopConn = nil
    end
    
    -- 物理演算をクリーンアップ
    for _, point in ipairs(SuperRingPoints) do
        if point.part then
            point.part:Destroy()
        end
        if point.assignedToy then
            if point.assignedToy.BG then
                point.assignedToy.BG:Destroy()
            end
            if point.assignedToy.BP then
                point.assignedToy.BP:Destroy()
            end
        end
    end
    
    SuperRingPoints = {}
    SuperRingAssignedToys = {}
end

local function toggleSuperRing(state)
    SuperRingConfig.Enabled = state
    if state then
        -- 他の機能を停止（同時に両方は動作しない）
        if FeatherConfig.Enabled then
            toggleFeather(false)
        end
        if RingConfig.Enabled then
            toggleRingAura(false)
        end
        if HeartConfig.Enabled then
            toggleHeart(false)
        end
        if BigHeartConfig.Enabled then
            toggleBigHeart(false)
        end
        if StarOfDavidConfig.Enabled then
            toggleStarOfDavid(false)
        end
        if StarConfig.Enabled then
            toggleStar(false)
        end
        if ManjiConfig.Enabled then
            toggleManji(false)
        end
        if Star2Config.Enabled then
            toggleStar2(false)
        end
        
        SuperRingToys = findFireworkSparklers()
        SuperRingPoints = createSuperRingPoints(math.min(#SuperRingToys, SuperRingConfig.ObjectCount))
        SuperRingAssignedToys = assignSuperRingToysToPoints()
        startSuperRingLoop()
        
        OrionLib:MakeNotification({
            Name = "SuperRing起動",
            Content = "半径: " .. SuperRingConfig.Radius .. ", 高さ: " .. SuperRingConfig.Height .. ", 数: " .. SuperRingConfig.ObjectCount,
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    else
        stopSuperRingLoop()
        OrionLib:MakeNotification({
            Name = "SuperRing停止",
            Content = "スーパーリング配置を解除しました",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

-- ====================================================================
-- 卍マンジ配置機能専用関数（追加）
-- ====================================================================
local function createManjiPoints(count)
    local points = {}
    
    if count == 0 then return points end
    
    for i = 1, count do
        -- 卍の形に沿った角度を計算
        local t = (i - 1) * (2 * math.pi / count)
        
        -- 参考点用パート
        local part = Instance.new("Part")
        part.CanCollide = false
        part.Anchored = true
        part.Transparency = 1
        part.Size = Vector3.new(4, 1, 4)
        part.Parent = workspace
        
        points[i] = {
            angle = t,
            part = part,
            assignedToy = nil,
        }
    end
    
    return points
end

local function getManjiPosition(t, size, pulse, armLength, armThickness)
    -- 卍の形を計算する関数
    -- 基本的な円形に、4つの腕を追加
    
    local scale = size / 10
    
    -- 基本の円形位置
    local baseX = math.cos(t) * scale
    local baseZ = math.sin(t) * scale
    
    -- 卍の腕の位置を計算
    -- 4つの角度に腕を追加
    local armAngle1 = 0  -- 右
    local armAngle2 = math.pi / 2  -- 上
    local armAngle3 = math.pi  -- 左
    local armAngle4 = 3 * math.pi / 2  -- 下
    
    -- 現在の角度に最も近い腕を探す
    local closestArm = armAngle1
    local minDiff = math.abs(t - armAngle1)
    
    for _, arm in ipairs({armAngle2, armAngle3, armAngle4}) do
        local diff = math.abs(t - arm)
        if diff < minDiff then
            minDiff = diff
            closestArm = arm
        end
    end
    
    -- 腕の位置を計算
    local armFactor = 0
    if minDiff < (math.pi / 8) then  -- 腕の角度付近
        armFactor = (1 - (minDiff / (math.pi / 8))) * armLength
        
        -- 腕の幅方向の調整
        local perpendicularAngle = closestArm + math.pi / 2
        local perpX = math.cos(perpendicularAngle) * armThickness
        local perpZ = math.sin(perpendicularAngle) * armThickness
        
        -- 基本位置に腕の位置を追加
        baseX = baseX + math.cos(closestArm) * armFactor + perpX
        baseZ = baseZ + math.sin(closestArm) * armFactor + perpZ
    end
    
    -- 脈動効果
    if pulse > 0 then
        local pulseFactor = 1 + (pulse * 0.05)
        baseX = baseX * pulseFactor
        baseZ = baseZ * pulseFactor
    end
    
    return baseX, baseZ
end

local function attachManjiPhysics(part)
    if not part then return nil, nil end
    
    local existingBG = part:FindFirstChildOfClass("BodyGyro")
    local existingBP = part:FindFirstChildOfClass("BodyPosition")
    
    if existingBG and existingBP then 
        return existingBG, existingBP
    end
    
    if existingBG then existingBG:Destroy() end
    if existingBP then existingBP:Destroy() end
    
    local BP = Instance.new("BodyPosition")  
    local BG = Instance.new("BodyGyro")  
    
    BP.P = 15000  
    BP.D = 200  
    BP.MaxForce = Vector3.new(1, 1, 1) * 1e10  
    BP.Parent = part  
    
    BG.P = 15000  
    BG.D = 200  
    BG.MaxTorque = Vector3.new(1, 1, 1) * 1e10  
    BG.Parent = part  
    
    return BG, BP
end

local function assignManjiToysToPoints()
    ManjiAssignedToys = {}
    
    for i = 1, math.min(#ManjiToys, #ManjiPoints) do
        local toy = ManjiToys[i]
        if toy and toy:IsA("Model") and toy.Name == "FireworkSparkler" then
            local primaryPart = getPrimaryPart(toy)
            
            if primaryPart then  
                for _, child in ipairs(toy:GetChildren()) do  
                    if child:IsA("BasePart") then  
                        child.CanCollide = false
                        child.CanTouch = false
                        child.Anchored = false
                    end  
                end
                
                local BG, BP = attachManjiPhysics(primaryPart)  
                local toyTable = {  
                    BG = BG,  
                    BP = BP,  
                    Pallet = primaryPart,
                    Model = toy,
                    PointIndex = i,
                    baseAngle = ManjiPoints[i].angle,
                }  
                
                ManjiPoints[i].assignedToy = toyTable
                table.insert(ManjiAssignedToys, toyTable)
            end  
        end
    end
    
    return ManjiAssignedToys
end

local function startManjiLoop()
    if ManjiLoopConn then
        ManjiLoopConn:Disconnect()
        ManjiLoopConn = nil
    end
    
    ManjiTime = 0
    
    ManjiLoopConn = RunService.RenderStepped:Connect(function(dt)
        if not ManjiConfig.Enabled or not LocalPlayer.Character then
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local torso = LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
        
        if not humanoidRootPart or not torso then
            return
        end
        
        ManjiTime += dt
        
        local basePosition
        if ManjiConfig.FollowPlayer then
            basePosition = torso.Position
        else
            basePosition = torso.Position
        end
        
        -- 脈動効果の計算
        local pulseEffect = 0
        if ManjiConfig.PulseSpeed > 0 then
            pulseEffect = math.sin(ManjiTime * ManjiConfig.PulseSpeed) * ManjiConfig.PulseAmplitude
        end
        
        for i, point in ipairs(ManjiPoints) do
            if point.assignedToy and point.assignedToy.BP and point.assignedToy.BG then
                local toy = point.assignedToy
                
                -- 回転角度を計算（時間経過で回転）
                local currentAngle = toy.baseAngle + (ManjiTime * ManjiConfig.RotationSpeed)
                
                -- 卍の形の位置を計算
                local x, z = getManjiPosition(
                    currentAngle, 
                    ManjiConfig.Size, 
                    pulseEffect,
                    ManjiConfig.ArmLength,
                    ManjiConfig.ArmThickness
                )
                
                -- 高さ調整
                local heightOffset = ManjiConfig.Height + (math.sin(currentAngle * 2) * 0.3)
                
                -- 最終的な位置
                local localPos = Vector3.new(x, heightOffset, z)
                local targetPosition = basePosition + localPos
                
                if point.part then
                    point.part.Position = targetPosition
                end
                
                toy.BP.Position = targetPosition
                
                -- 外側を向く
                local direction = (targetPosition - basePosition).Unit
                if direction.Magnitude > 0 then
                    local lookCFrame = CFrame.lookAt(targetPosition, targetPosition + direction)
                    toy.BG.CFrame = lookCFrame
                end
            end
        end
    end)
end

local function stopManjiLoop()
    if ManjiLoopConn then
        ManjiLoopConn:Disconnect()
        ManjiLoopConn = nil
    end
    
    -- 物理演算をクリーンアップ
    for _, point in ipairs(ManjiPoints) do
        if point.part then
            point.part:Destroy()
        end
        if point.assignedToy then
            if point.assignedToy.BG then
                point.assignedToy.BG:Destroy()
            end
            if point.assignedToy.BP then
                point.assignedToy.BP:Destroy()
            end
        end
    end
    
    ManjiPoints = {}
    ManjiAssignedToys = {}
end

local function toggleManji(state)
    ManjiConfig.Enabled = state
    if state then
        -- 他の機能を停止（同時に両方は動作しない）
        if FeatherConfig.Enabled then
            toggleFeather(false)
        end
        if RingConfig.Enabled then
            toggleRingAura(false)
        end
        if HeartConfig.Enabled then
            toggleHeart(false)
        end
        if BigHeartConfig.Enabled then
            toggleBigHeart(false)
        end
        if StarOfDavidConfig.Enabled then
            toggleStarOfDavid(false)
        end
        if StarConfig.Enabled then
            toggleStar(false)
        end
        if SuperRingConfig.Enabled then
            toggleSuperRing(false)
        end
        if Star2Config.Enabled then
            toggleStar2(false)
        end
        
        ManjiToys = findFireworkSparklers()
        ManjiPoints = createManjiPoints(math.min(#ManjiToys, ManjiConfig.ObjectCount))
        ManjiAssignedToys = assignManjiToysToPoints()
        startManjiLoop()
        
        OrionLib:MakeNotification({
            Name = "卍マンジ起動",
            Content = "サイズ: " .. ManjiConfig.Size .. ", 高さ: " .. ManjiConfig.Height .. ", 数: " .. ManjiConfig.ObjectCount,
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    else
        stopManjiLoop()
        OrionLib:MakeNotification({
            Name = "卍マンジ停止",
            Content = "卍形配置を解除しました",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

-- ====================================================================
-- スター2✫配置機能専用関数（追加 - 太陽のようなギザギザ模様）
-- ====================================================================
local function createStar2Points(count)
    local points = {}
    
    if count == 0 then return points end
    
    for i = 1, count do
        -- 光線に沿った角度を計算
        local t = (i - 1) * (2 * math.pi / count)
        
        -- 参考点用パート
        local part = Instance.new("Part")
        part.CanCollide = false
        part.Anchored = true
        part.Transparency = 1
        part.Size = Vector3.new(4, 1, 4)
        part.Parent = workspace
        
        points[i] = {
            angle = t,
            part = part,
            assignedToy = nil,
            rayIndex = (i - 1) % Star2Config.RayCount,
        }
    end
    
    return points
end

local function getStar2Position(t, size, pulse, rayLength, rayIndex, time, jitterSpeed, jitterAmount)
    -- 太陽のようなギザギザ模様を計算
    local scale = size / 10
    
    -- 基本の円形位置
    local baseRadius = scale
    
    -- 光線の効果（ギザギザ）
    local rayFactor = 0
    local anglePerRay = 2 * math.pi / Star2Config.RayCount
    local rayAngle = rayIndex * anglePerRay
    
    -- 現在の角度と最も近い光線の角度の差を計算
    local angleDiff = math.abs(t - rayAngle)
    if angleDiff > math.pi then
        angleDiff = 2 * math.pi - angleDiff
    end
    
    -- 光線の位置を計算
    if angleDiff < (anglePerRay / 4) then
        -- 光線の先端に近い場合
        rayFactor = (1 - (angleDiff / (anglePerRay / 4))) * rayLength
        
        -- ギザギザ効果（揺れ）
        local jitter = math.sin(time * jitterSpeed + rayIndex) * jitterAmount
        rayFactor = rayFactor * (1 + jitter * 0.1)
    end
    
    -- 脈動効果
    local pulseFactor = 1
    if pulse > 0 then
        pulseFactor = 1 + (pulse * 0.1)
    end
    
    -- 最終的な半径
    local finalRadius = (baseRadius + rayFactor) * pulseFactor
    
    -- 位置を計算
    local x = math.cos(t) * finalRadius
    local z = math.sin(t) * finalRadius
    
    return x, z, finalRadius
end

local function attachStar2Physics(part)
    if not part then return nil, nil end
    
    local existingBG = part:FindFirstChildOfClass("BodyGyro")
    local existingBP = part:FindFirstChildOfClass("BodyPosition")
    
    if existingBG and existingBP then 
        return existingBG, existingBP
    end
    
    if existingBG then existingBG:Destroy() end
    if existingBP then existingBP:Destroy() end
    
    local BP = Instance.new("BodyPosition")  
    local BG = Instance.new("BodyGyro")  
    
    BP.P = 20000  -- より高い値で高速移動に対応
    BP.D = 300
    BP.MaxForce = Vector3.new(1, 1, 1) * 1.5e10  -- より大きな力
    BP.Parent = part  
    
    BG.P = 20000
    BG.D = 300
    BG.MaxTorque = Vector3.new(1, 1, 1) * 1.5e10
    BG.Parent = part  
    
    return BG, BP
end

local function assignStar2ToysToPoints()
    Star2AssignedToys = {}
    
    for i = 1, math.min(#Star2Toys, #Star2Points) do
        local toy = Star2Toys[i]
        if toy and toy:IsA("Model") and toy.Name == "FireworkSparkler" then
            local primaryPart = getPrimaryPart(toy)
            
            if primaryPart then  
                for _, child in ipairs(toy:GetChildren()) do  
                    if child:IsA("BasePart") then  
                        child.CanCollide = false
                        child.CanTouch = false
                        child.Anchored = false
                    end  
                end
                
                local BG, BP = attachStar2Physics(primaryPart)  
                local toyTable = {  
                    BG = BG,  
                    BP = BP,  
                    Pallet = primaryPart,
                    Model = toy,
                    PointIndex = i,
                    baseAngle = Star2Points[i].angle,
                    rayIndex = Star2Points[i].rayIndex,
                }  
                
                Star2Points[i].assignedToy = toyTable
                table.insert(Star2AssignedToys, toyTable)
            end  
        end
    end
    
    return Star2AssignedToys
end

local function startStar2Loop()
    if Star2LoopConn then
        Star2LoopConn:Disconnect()
        Star2LoopConn = nil
    end
    
    Star2Time = 0
    
    Star2LoopConn = RunService.RenderStepped:Connect(function(dt)
        if not Star2Config.Enabled or not LocalPlayer.Character then
            return
        end
        
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local torso = LocalPlayer.Character:FindFirstChild("Torso") or LocalPlayer.Character:FindFirstChild("UpperTorso")
        
        if not humanoidRootPart or not torso then
            return
        end
        
        Star2Time += dt
        
        local basePosition
        if Star2Config.FollowPlayer then
            basePosition = torso.Position
        else
            basePosition = torso.Position
        end
        
        -- 高速脈動効果の計算
        local pulseEffect = 0
        if Star2Config.PulseSpeed > 0 then
            pulseEffect = math.sin(Star2Time * Star2Config.PulseSpeed) * Star2Config.PulseAmplitude
        end
        
        for i, point in ipairs(Star2Points) do
            if point.assignedToy and point.assignedToy.BP and point.assignedToy.BG then
                local toy = point.assignedToy
                
                -- 高速回転角度を計算
                local currentAngle = toy.baseAngle + (Star2Time * Star2Config.RotationSpeed)
                
                -- スター2（太陽）の位置を計算
                local x, z, radius = getStar2Position(
                    currentAngle, 
                    Star2Config.Size, 
                    pulseEffect,
                    Star2Config.RayLength,
                    toy.rayIndex,
                    Star2Time,
                    Star2Config.JitterSpeed,
                    Star2Config.JitterAmount
                )
                
                -- 高さ調整（揺れ効果）
                local heightVariation = math.sin(Star2Time * 3 + toy.rayIndex) * 0.5
                local heightOffset = Star2Config.Height + heightVariation
                
                -- 最終的な位置
                local localPos = Vector3.new(x, heightOffset, z)
                local targetPosition = basePosition + localPos
                
                if point.part then
                    point.part.Position = targetPosition
                end
                
                -- 高速移動用の調整
                toy.BP.Position = targetPosition
                
                -- 外側を向く（高速回転用に滑らかに）
                local direction = (targetPosition - basePosition).Unit
                if direction.Magnitude > 0 then
                    local currentCFrame = toy.BG.CFrame
                    local targetCFrame = CFrame.lookAt(targetPosition, targetPosition + direction)
                    local interpolatedCFrame = currentCFrame:Lerp(targetCFrame, 0.5)  -- 高速用に補間率を上げる
                    toy.BG.CFrame = interpolatedCFrame
                end
            end
        end
    end)
end

local function stopStar2Loop()
    if Star2LoopConn then
        Star2LoopConn:Disconnect()
        Star2LoopConn = nil
    end
    
    -- 物理演算をクリーンアップ
    for _, point in ipairs(Star2Points) do
        if point.part then
            point.part:Destroy()
        end
        if point.assignedToy then
            if point.assignedToy.BG then
                point.assignedToy.BG:Destroy()
            end
            if point.assignedToy.BP then
                point.assignedToy.BP:Destroy()
            end
        end
    end
    
    Star2Points = {}
    Star2AssignedToys = {}
end

local function toggleStar2(state)
    Star2Config.Enabled = state
    if state then
        -- 他の機能を停止（同時に両方は動作しない）
        if FeatherConfig.Enabled then
            toggleFeather(false)
        end
        if RingConfig.Enabled then
            toggleRingAura(false)
        end
        if HeartConfig.Enabled then
            toggleHeart(false)
        end
        if BigHeartConfig.Enabled then
            toggleBigHeart(false)
        end
        if StarOfDavidConfig.Enabled then
            toggleStarOfDavid(false)
        end
        if StarConfig.Enabled then
            toggleStar(false)
        end
        if SuperRingConfig.Enabled then
            toggleSuperRing(false)
        end
        if ManjiConfig.Enabled then
            toggleManji(false)
        end
        
        Star2Toys = findFireworkSparklers()
        Star2Points = createStar2Points(math.min(#Star2Toys, Star2Config.ObjectCount))
        Star2AssignedToys = assignStar2ToysToPoints()
        startStar2Loop()
        
        OrionLib:MakeNotification({
            Name = "スター2✫起動",
            Content = "サイズ: " .. Star2Config.Size .. ", 高さ: " .. Star2Config.Height .. ", 光線: " .. Star2Config.RayCount,
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    else
        stopStar2Loop()
        OrionLib:MakeNotification({
            Name = "スター2✫停止",
            Content = "太陽形配置を解除しました",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

-- ====================================================================
-- 便利機能 (Mi(=^・^=))
-- ====================================================================
local function toggleInfiniteJump(state)
    UtilityConfig.InfiniteJump = state
    
    if state then
        -- 無限ジャンプを有効化
        local connection
        connection = game:GetService("UserInputService").JumpRequest:Connect(function()
            if UtilityConfig.InfiniteJump and LocalPlayer.Character then
                local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState("Jumping")
                end
            end
        end)
        
        OrionLib:MakeNotification({
            Name = "無限ジャンプ",
            Content = "無限ジャンプを有効化しました",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    else
        OrionLib:MakeNotification({
            Name = "無限ジャンプ",
            Content = "無限ジャンプを無効化しました",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

local function toggleNoclip(state)
    UtilityConfig.Noclip = state
    
    if state then
        -- Noclipを有効化
        enableNoclip()
        OrionLib:MakeNotification({
            Name = "Noclip",
            Content = "Noclipを有効化しました（壁抜け可能）",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    else
        -- Noclipを無効化
        disableNoclip()
        OrionLib:MakeNotification({
            Name = "Noclip",
            Content = "Noclipを無効化しました（通常の当たり判定）",
            Image = "rbxassetid://4483362458",
            Time = 2
        })
    end
end

-- ====================================================================
-- Orion UI作成
-- ====================================================================
local Window = OrionLib:MakeWindow({
    Name = "🌸さくらhub🌸",
    HidePremium = true,
    SaveConfig = false,
    IntroEnabled = false,
    ThemeColor = Theme.BackgroundColor,
    BackgroundColor = Theme.BackgroundColor,
    TextColor = Theme.TextColor
})

-- ====================================================================
-- タブ1: 羽[Feather]
-- ====================================================================
local MainTab = Window:MakeTab({
    Name = "羽[Feather]",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

-- 羽のON/OFFトグル
MainTab:AddToggle({
    Name = "羽を起動 (背中側)",
    Default = false,
    Callback = function(Value)
        toggleFeather(Value)
    end
})

local FeatherSection1 = MainTab:AddSection({
    Name = "配置設定"
})

MainTab:AddSlider({
    Name = "最大花火数",
    Min = 2,
    Max = 40,
    Default = FeatherConfig.maxSparklers,
    Color = Theme.SliderColor,
    Increment = 2,
    ValueName = "本",
    Callback = function(Value)
        FeatherConfig.maxSparklers = Value
        if FeatherConfig.Enabled then
            toggleFeather(false)
            task.wait(0.1)
            toggleFeather(true)
        end
    end
})

MainTab:AddSlider({
    Name = "花火の間隔",
    Min = 1,
    Max = 10,
    Default = FeatherConfig.spacing,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        FeatherConfig.spacing = Value
        if FeatherConfig.Enabled then
            toggleFeather(false)
            task.wait(0.1)
            toggleFeather(true)
        end
    end
})

MainTab:AddSlider({
    Name = "高さオフセット",
    Min = -5,
    Max = 10,
    Default = FeatherConfig.heightOffset,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        FeatherConfig.heightOffset = Value
    end
})

MainTab:AddSlider({
    Name = "背中オフセット",
    Min = 0,
    Max = 10,
    Default = FeatherConfig.backwardOffset,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        FeatherConfig.backwardOffset = Value
    end
})

local FeatherSection2 = MainTab:AddSection({
    Name = "角度設定"
})

MainTab:AddSlider({
    Name = "花火の傾き角度",
    Min = 0,
    Max = 90,
    Default = FeatherConfig.tiltAngle,
    Color = Theme.SliderColor,
    Increment = 5,
    ValueName = "度",
    Callback = function(Value)
        FeatherConfig.tiltAngle = Value
    end
})

local FeatherSection3 = MainTab:AddSection({
    Name = "上下動設定"
})

MainTab:AddSlider({
    Name = "上下動の速度",
    Min = 0,
    Max = 10,
    Default = FeatherConfig.waveSpeed,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "速度",
    Callback = function(Value)
        FeatherConfig.waveSpeed = Value
    end
})

MainTab:AddSlider({
    Name = "基本振幅（最も近い花火）",
    Min = 0,
    Max = 5,
    Default = FeatherConfig.baseAmplitude,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        FeatherConfig.baseAmplitude = Value
    end
})

local FeatherSection4 = MainTab:AddSection({
    Name = "その他"
})

MainTab:AddButton({
    Name = "花火を再検出",
    Callback = function()
        if FeatherConfig.Enabled then
            toggleFeather(false)
            task.wait(0.1)
            toggleFeather(true)
            OrionLib:MakeNotification({
                Name = "再検出完了",
                Content = "花火を再検出しました",
                Image = "rbxassetid://4483362458",
                Time = 3
            })
        end
    end
})

-- ====================================================================
-- タブ2: 魔法陣［RingX2］
-- ====================================================================
local RingTab = Window:MakeTab({
    Name = "魔法陣［RingX2］",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local RingSection1 = RingTab:AddSection({
    Name = "魔法陣基本設定"
})

RingTab:AddToggle({
    Name = "魔法陣を起動",
    Default = false,
    Callback = function(Value)
        toggleRingAura(Value)
    end
})

RingTab:AddSlider({
    Name = "魔法陣の高さ",
    Min = 0,
    Max = 20,
    Default = RingConfig.RingHeight,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        RingConfig.RingHeight = Value
    end
})

RingTab:AddSlider({
    Name = "魔法陣の直径",
    Min = 2,
    Max = 20,
    Default = RingConfig.RingDiameter,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        RingConfig.RingDiameter = Value
    end
})

RingTab:AddSlider({
    Name = "花火の数",
    Min = 3,
    Max = 20,
    Default = RingConfig.ObjectCount,
    Color = Theme.SliderColor,
    Increment = 1,
    ValueName = "個",
    Callback = function(Value)
        RingConfig.ObjectCount = Value
        if RingConfig.Enabled then
            rescanRing()
        end
    end
})

local RingSection2 = RingTab:AddSection({
    Name = "魔法陣回転設定"
})

RingTab:AddSlider({
    Name = "回転速度",
    Min = 1,
    Max = 50,
    Default = RingConfig.RotationSpeed,
    Color = Theme.SliderColor,
    Increment = 1,
    ValueName = "速度",
    Callback = function(Value)
        RingConfig.RotationSpeed = Value
    end
})

-- ====================================================================
-- タブ3: ♡ハート♡
-- ====================================================================
local HeartTab = Window:MakeTab({
    Name = "♡ハート♡",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local HeartSection1 = HeartTab:AddSection({
    Name = "基本設定"
})

HeartTab:AddToggle({
    Name = "ハート形を起動",
    Default = false,
    Callback = function(Value)
        toggleHeart(Value)
    end
})

HeartTab:AddToggle({
    Name = "プレイヤー追従",
    Default = HeartConfig.FollowPlayer,
    Callback = function(Value)
        HeartConfig.FollowPlayer = Value
    end
})

local HeartSection2 = HeartTab:AddSection({
    Name = "サイズ設定"
})

HeartTab:AddSlider({
    Name = "ハートのサイズ",
    Min = 2,
    Max = 15,
    Default = HeartConfig.Size,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        HeartConfig.Size = Value
    end
})

HeartTab:AddSlider({
    Name = "基本高さ",
    Min = 0,
    Max = 20,
    Default = HeartConfig.Height,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        HeartConfig.Height = Value
    end
})

HeartTab:AddSlider({
    Name = "花火の数",
    Min = 6,
    Max = 24,
    Default = HeartConfig.ObjectCount,
    Color = Theme.SliderColor,
    Increment = 2,
    ValueName = "個",
    Callback = function(Value)
        HeartConfig.ObjectCount = Value
        if HeartConfig.Enabled then
            toggleHeart(false)
            task.wait(0.1)
            toggleHeart(true)
        end
    end
})

local HeartSection3 = HeartTab:AddSection({
    Name = "動き設定"
})

HeartTab:AddSlider({
    Name = "回転速度",
    Min = 0,
    Max = 3,
    Default = HeartConfig.RotationSpeed,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "速度",
    Callback = function(Value)
        HeartConfig.RotationSpeed = Value
    end
})

HeartTab:AddSlider({
    Name = "脈動速度",
    Min = 0,
    Max = 5,
    Default = HeartConfig.PulseSpeed,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "速度",
    Callback = function(Value)
        HeartConfig.PulseSpeed = Value
    end
})

HeartTab:AddSlider({
    Name = "脈動振幅",
    Min = 0,
    Max = 2,
    Default = HeartConfig.PulseAmplitude,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "studs",
    Callback = function(Value)
        HeartConfig.PulseAmplitude = Value
    end
})

local HeartSection4 = HeartTab:AddSection({
    Name = "制御"
})

HeartTab:AddButton({
    Name = "花火を再検出",
    Callback = function()
        if HeartConfig.Enabled then
            toggleHeart(false)
            task.wait(0.1)
            toggleHeart(true)
            OrionLib:MakeNotification({
                Name = "再検出完了",
                Content = "花火を再検出しました",
                Image = "rbxassetid://4483362458",
                Time = 3
            })
        end
    end
})

-- ====================================================================
-- タブ4: おっきぃ♡（大きいハート）- 速度拡張版
-- ====================================================================
local BigHeartTab = Window:MakeTab({
    Name = "おっきぃ♡",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local BigHeartSection1 = BigHeartTab:AddSection({
    Name = "基本設定"
})

BigHeartTab:AddToggle({
    Name = "おっきぃ♡を起動",
    Default = false,
    Callback = function(Value)
        toggleBigHeart(Value)
    end
})

BigHeartTab:AddToggle({
    Name = "プレイヤー追従",
    Default = BigHeartConfig.FollowPlayer,
    Callback = function(Value)
        BigHeartConfig.FollowPlayer = Value
    end
})

local BigHeartSection2 = BigHeartTab:AddSection({
    Name = "サイズ設定（大きい）"
})

BigHeartTab:AddSlider({
    Name = "ハートの基本サイズ",
    Min = 5,
    Max = 25,
    Default = BigHeartConfig.Size,
    Color = Theme.SliderColor,
    Increment = 1,
    ValueName = "studs",
    Callback = function(Value)
        BigHeartConfig.Size = Value
    end
})

BigHeartTab:AddSlider({
    Name = "拡大スケール",
    Min = 1.0,
    Max = 4.0,
    Default = BigHeartConfig.HeartScale,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "倍",
    Callback = function(Value)
        BigHeartConfig.HeartScale = Value
    end
})

BigHeartTab:AddSlider({
    Name = "垂直方向の伸び",
    Min = 1.0,
    Max = 2.0,
    Default = BigHeartConfig.VerticalStretch,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "倍",
    Callback = function(Value)
        BigHeartConfig.VerticalStretch = Value
    end
})

BigHeartTab:AddSlider({
    Name = "基本高さ",
    Min = 5,
    Max = 30,
    Default = BigHeartConfig.Height,
    Color = Theme.SliderColor,
    Increment = 1,
    ValueName = "studs",
    Callback = function(Value)
        BigHeartConfig.Height = Value
    end
})

BigHeartTab:AddSlider({
    Name = "花火の数（多い）",
    Min = 12,
    Max = 40,
    Default = BigHeartConfig.ObjectCount,
    Color = Theme.SliderColor,
    Increment = 2,
    ValueName = "個",
    Callback = function(Value)
        BigHeartConfig.ObjectCount = Value
        if BigHeartConfig.Enabled then
            toggleBigHeart(false)
            task.wait(0.1)
            toggleBigHeart(true)
        end
    end
})

local BigHeartSection3 = BigHeartTab:AddSection({
    Name = "動き設定（高速対応）"
})

BigHeartTab:AddSlider({
    Name = "回転速度（高速対応）",
    Min = 0,
    Max = BigHeartConfig.RotationSpeedMax,
    Default = BigHeartConfig.RotationSpeed,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "速度",
    Callback = function(Value)
        BigHeartConfig.RotationSpeed = Value
    end
})

BigHeartTab:AddSlider({
    Name = "脈動速度（高速対応）",
    Min = 0,
    Max = BigHeartConfig.PulseSpeedMax,
    Default = BigHeartConfig.PulseSpeed,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "速度",
    Callback = function(Value)
        BigHeartConfig.PulseSpeed = Value
    end
})

BigHeartTab:AddSlider({
    Name = "脈動振幅（大きく）",
    Min = 0,
    Max = 3,
    Default = BigHeartConfig.PulseAmplitude,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "studs",
    Callback = function(Value)
        BigHeartConfig.PulseAmplitude = Value
    end
})

local BigHeartSection4 = BigHeartTab:AddSection({
    Name = "制御"
})

BigHeartTab:AddButton({
    Name = "花火を再検出",
    Callback = function()
        if BigHeartConfig.Enabled then
            toggleBigHeart(false)
            task.wait(0.1)
            toggleBigHeart(true)
            OrionLib:MakeNotification({
                Name = "再検出完了",
                Content = "花火を再検出しました",
                Image = "rbxassetid://4483362458",
                Time = 3
            })
        end
    end
})

-- ====================================================================
-- タブ5: ダビデ✡
-- ====================================================================
local StarOfDavidTab = Window:MakeTab({
    Name = "ダビデ✡",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local StarOfDavidSection1 = StarOfDavidTab:AddSection({
    Name = "基本設定"
})

StarOfDavidTab:AddToggle({
    Name = "ダビデ星を起動",
    Default = false,
    Callback = function(Value)
        toggleStarOfDavid(Value)
    end
})

StarOfDavidTab:AddToggle({
    Name = "プレイヤー追従",
    Default = StarOfDavidConfig.FollowPlayer,
    Callback = function(Value)
        StarOfDavidConfig.FollowPlayer = Value
    end
})

local StarOfDavidSection2 = StarOfDavidTab:AddSection({
    Name = "サイズ設定"
})

StarOfDavidTab:AddSlider({
    Name = "星のサイズ",
    Min = 2,
    Max = 15,
    Default = StarOfDavidConfig.Size,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        StarOfDavidConfig.Size = Value
    end
})

StarOfDavidTab:AddSlider({
    Name = "基本高さ",
    Min = 0,
    Max = 20,
    Default = StarOfDavidConfig.Height,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        StarOfDavidConfig.Height = Value
    end
})

StarOfDavidTab:AddSlider({
    Name = "三角形の高さ",
    Min = 0,
    Max = 5,
    Default = StarOfDavidConfig.TriangleHeight,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "studs",
    Callback = function(Value)
        StarOfDavidConfig.TriangleHeight = Value
    end
})

StarOfDavidTab:AddSlider({
    Name = "花火の数",
    Min = 6,
    Max = 24,
    Default = StarOfDavidConfig.ObjectCount,
    Color = Theme.SliderColor,
    Increment = 2,
    ValueName = "個",
    Callback = function(Value)
        StarOfDavidConfig.ObjectCount = Value
        if StarOfDavidConfig.Enabled then
            toggleStarOfDavid(false)
            task.wait(0.1)
            toggleStarOfDavid(true)
        end
    end
})

local StarOfDavidSection3 = StarOfDavidTab:AddSection({
    Name = "動き設定"
})

StarOfDavidTab:AddSlider({
    Name = "回転速度",
    Min = 0,
    Max = 3,
    Default = StarOfDavidConfig.RotationSpeed,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "速度",
    Callback = function(Value)
        StarOfDavidConfig.RotationSpeed = Value
    end
})

StarOfDavidTab:AddSlider({
    Name = "脈動速度",
    Min = 0,
    Max = 5,
    Default = StarOfDavidConfig.PulseSpeed,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "速度",
    Callback = function(Value)
        StarOfDavidConfig.PulseSpeed = Value
    end
})

local StarOfDavidSection4 = StarOfDavidTab:AddSection({
    Name = "制御"
})

StarOfDavidTab:AddButton({
    Name = "花火を再検出",
    Callback = function()
        if StarOfDavidConfig.Enabled then
            toggleStarOfDavid(false)
            task.wait(0.1)
            toggleStarOfDavid(true)
            OrionLib:MakeNotification({
                Name = "再検出完了",
                Content = "花火を再検出しました",
                Image = "rbxassetid://4483362458",
                Time = 3
            })
        end
    end
})

-- ====================================================================
-- タブ6: スター★（⭐️の形）
-- ====================================================================
local StarTab = Window:MakeTab({
    Name = "スター★",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local StarSection1 = StarTab:AddSection({
    Name = "基本設定"
})

StarTab:AddToggle({
    Name = "星形を起動",
    Default = false,
    Callback = function(Value)
        toggleStar(Value)
    end
})

StarTab:AddToggle({
    Name = "プレイヤー追従",
    Default = StarConfig.FollowPlayer,
    Callback = function(Value)
        StarConfig.FollowPlayer = Value
    end
})

local StarSection2 = StarTab:AddSection({
    Name = "サイズ設定"
})

StarTab:AddSlider({
    Name = "外側の半径",
    Min = 2,
    Max = 10,
    Default = StarConfig.OuterRadius,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        StarConfig.OuterRadius = Value
    end
})

StarTab:AddSlider({
    Name = "内側の半径",
    Min = 1,
    Max = 5,
    Default = StarConfig.InnerRadius,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        StarConfig.InnerRadius = Value
    end
})

StarTab:AddSlider({
    Name = "基本高さ",
    Min = 0,
    Max = 20,
    Default = StarConfig.Height,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        StarConfig.Height = Value
    end
})

StarTab:AddSlider({
    Name = "花火の数",
    Min = 5,
    Max = 20,
    Default = StarConfig.ObjectCount,
    Color = Theme.SliderColor,
    Increment = 1,
    ValueName = "個",
    Callback = function(Value)
        StarConfig.ObjectCount = Value
        if StarConfig.Enabled then
            toggleStar(false)
            task.wait(0.1)
            toggleStar(true)
        end
    end
})

local StarSection3 = StarTab:AddSection({
    Name = "動き設定"
})

StarTab:AddSlider({
    Name = "回転速度",
    Min = 0,
    Max = 3,
    Default = StarConfig.RotationSpeed,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "速度",
    Callback = function(Value)
        StarConfig.RotationSpeed = Value
    end
})

StarTab:AddSlider({
    Name = "きらめき速度",
    Min = 0,
    Max = 5,
    Default = StarConfig.TwinkleSpeed,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "速度",
    Callback = function(Value)
        StarConfig.TwinkleSpeed = Value
    end
})

local StarSection4 = StarTab:AddSection({
    Name = "制御"
})

StarTab:AddButton({
    Name = "花火を再検出",
    Callback = function()
        if StarConfig.Enabled then
            toggleStar(false)
            task.wait(0.1)
            toggleStar(true)
            OrionLib:MakeNotification({
                Name = "再検出完了",
                Content = "花火を再検出しました",
                Image = "rbxassetid://4483362458",
                Time = 3
            })
        end
    end
})

-- ====================================================================
-- タブ7: SuperRing
-- ====================================================================
local SuperRingTab = Window:MakeTab({
    Name = "SuperRing",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local SuperRingSection1 = SuperRingTab:AddSection({
    Name = "基本設定"
})

SuperRingTab:AddToggle({
    Name = "SuperRingを起動",
    Default = false,
    Callback = function(Value)
        toggleSuperRing(Value)
    end
})

SuperRingTab:AddToggle({
    Name = "プレイヤー追従",
    Default = SuperRingConfig.FollowPlayer,
    Callback = function(Value)
        SuperRingConfig.FollowPlayer = Value
    end
})

SuperRingTab:AddToggle({
    Name = "竜巻効果",
    Default = SuperRingConfig.TornadoEffect,
    Callback = function(Value)
        SuperRingConfig.TornadoEffect = Value
    end
})

local SuperRingSection2 = SuperRingTab:AddSection({
    Name = "サイズ設定"
})

SuperRingTab:AddSlider({
    Name = "基本半径",
    Min = 1,
    Max = 10,
    Default = SuperRingConfig.Radius,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        SuperRingConfig.Radius = Value
    end
})

SuperRingTab:AddSlider({
    Name = "基本高さ",
    Min = 0,
    Max = 10,
    Default = SuperRingConfig.BaseHeight,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        SuperRingConfig.BaseHeight = Value
    end
})

SuperRingTab:AddSlider({
    Name = "全体の高さ",
    Min = 5,
    Max = 30,
    Default = SuperRingConfig.Height,
    Color = Theme.SliderColor,
    Increment = 1,
    ValueName = "studs",
    Callback = function(Value)
        SuperRingConfig.Height = Value
        if SuperRingConfig.Enabled then
            toggleSuperRing(false)
            task.wait(0.1)
            toggleSuperRing(true)
        end
    end
})

SuperRingTab:AddSlider({
    Name = "花火の数",
    Min = 8,
    Max = 32,
    Default = SuperRingConfig.ObjectCount,
    Color = Theme.SliderColor,
    Increment = 2,
    ValueName = "個",
    Callback = function(Value)
        SuperRingConfig.ObjectCount = Value
        if SuperRingConfig.Enabled then
            toggleSuperRing(false)
            task.wait(0.1)
            toggleSuperRing(true)
        end
    end
})

local SuperRingSection3 = SuperRingTab:AddSection({
    Name = "動き設定"
})

SuperRingTab:AddSlider({
    Name = "回転速度",
    Min = 0,
    Max = 5,
    Default = SuperRingConfig.RotationSpeed,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "速度",
    Callback = function(Value)
        SuperRingConfig.RotationSpeed = Value
    end
})

SuperRingTab:AddSlider({
    Name = "らせん速度",
    Min = 0,
    Max = 3,
    Default = SuperRingConfig.SpiralSpeed,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "速度",
    Callback = function(Value)
        SuperRingConfig.SpiralSpeed = Value
    end
})

SuperRingTab:AddSlider({
    Name = "波の速度",
    Min = 0,
    Max = 3,
    Default = SuperRingConfig.WaveSpeed,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "速度",
    Callback = function(Value)
        SuperRingConfig.WaveSpeed = Value
    end
})

SuperRingTab:AddSlider({
    Name = "波の振幅",
    Min = 0,
    Max = 2,
    Default = SuperRingConfig.WaveAmplitude,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "studs",
    Callback = function(Value)
        SuperRingConfig.WaveAmplitude = Value
    end
})

local SuperRingSection4 = SuperRingTab:AddSection({
    Name = "制御"
})

SuperRingTab:AddButton({
    Name = "花火を再検出",
    Callback = function()
        if SuperRingConfig.Enabled then
            toggleSuperRing(false)
            task.wait(0.1)
            toggleSuperRing(true)
            OrionLib:MakeNotification({
                Name = "再検出完了",
                Content = "花火を再検出しました",
                Image = "rbxassetid://4483362458",
                Time = 3
            })
        end
    end
})

-- ====================================================================
-- タブ8: 卍マンジ（追加）
-- ====================================================================
local ManjiTab = Window:MakeTab({
    Name = "卍マンジ",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local ManjiSection1 = ManjiTab:AddSection({
    Name = "基本設定"
})

ManjiTab:AddToggle({
    Name = "卍形を起動",
    Default = false,
    Callback = function(Value)
        toggleManji(Value)
    end
})

ManjiTab:AddToggle({
    Name = "プレイヤー追従",
    Default = ManjiConfig.FollowPlayer,
    Callback = function(Value)
        ManjiConfig.FollowPlayer = Value
    end
})

local ManjiSection2 = ManjiTab:AddSection({
    Name = "サイズ設定"
})

ManjiTab:AddSlider({
    Name = "卍のサイズ",
    Min = 3,
    Max = 20,
    Default = ManjiConfig.Size,
    Color = Theme.SliderColor,
    Increment = 1,
    ValueName = "studs",
    Callback = function(Value)
        ManjiConfig.Size = Value
    end
})

ManjiTab:AddSlider({
    Name = "基本高さ",
    Min = 0,
    Max = 20,
    Default = ManjiConfig.Height,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        ManjiConfig.Height = Value
    end
})

ManjiTab:AddSlider({
    Name = "腕の長さ",
    Min = 0.5,
    Max = 4.0,
    Default = ManjiConfig.ArmLength,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "studs",
    Callback = function(Value)
        ManjiConfig.ArmLength = Value
    end
})

ManjiTab:AddSlider({
    Name = "腕の太さ",
    Min = 0.1,
    Max = 1.0,
    Default = ManjiConfig.ArmThickness,
    Color = Theme.SliderColor,
    Increment = 0.05,
    ValueName = "studs",
    Callback = function(Value)
        ManjiConfig.ArmThickness = Value
    end
})

ManjiTab:AddSlider({
    Name = "花火の数",
    Min = 8,
    Max = 32,
    Default = ManjiConfig.ObjectCount,
    Color = Theme.SliderColor,
    Increment = 2,
    ValueName = "個",
    Callback = function(Value)
        ManjiConfig.ObjectCount = Value
        if ManjiConfig.Enabled then
            toggleManji(false)
            task.wait(0.1)
            toggleManji(true)
        end
    end
})

local ManjiSection3 = ManjiTab:AddSection({
    Name = "動き設定（高速対応）"
})

ManjiTab:AddSlider({
    Name = "回転速度（高速）",
    Min = 0,
    Max = ManjiConfig.RotationSpeedMax,
    Default = ManjiConfig.RotationSpeed,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "速度",
    Callback = function(Value)
        ManjiConfig.RotationSpeed = Value
    end
})

ManjiTab:AddSlider({
    Name = "脈動速度（高速）",
    Min = 0,
    Max = ManjiConfig.PulseSpeedMax,
    Default = ManjiConfig.PulseSpeed,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "速度",
    Callback = function(Value)
        ManjiConfig.PulseSpeed = Value
    end
})

ManjiTab:AddSlider({
    Name = "脈動振幅",
    Min = 0,
    Max = 2,
    Default = ManjiConfig.PulseAmplitude,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "studs",
    Callback = function(Value)
        ManjiConfig.PulseAmplitude = Value
    end
})

local ManjiSection4 = ManjiTab:AddSection({
    Name = "制御"
})

ManjiTab:AddButton({
    Name = "花火を再検出",
    Callback = function()
        if ManjiConfig.Enabled then
            toggleManji(false)
            task.wait(0.1)
            toggleManji(true)
            OrionLib:MakeNotification({
                Name = "再検出完了",
                Content = "花火を再検出しました",
                Image = "rbxassetid://4483362458",
                Time = 3
            })
        end
    end
})

-- ====================================================================
-- タブ9: スター2✫（追加 - 太陽のようなギザギザ模様）
-- ====================================================================
local Star2Tab = Window:MakeTab({
    Name = "スター2✫",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local Star2Section1 = Star2Tab:AddSection({
    Name = "基本設定（高速・巨大）"
})

Star2Tab:AddToggle({
    Name = "太陽形を起動",
    Default = false,
    Callback = function(Value)
        toggleStar2(Value)
    end
})

Star2Tab:AddToggle({
    Name = "プレイヤー追従",
    Default = Star2Config.FollowPlayer,
    Callback = function(Value)
        Star2Config.FollowPlayer = Value
    end
})

local Star2Section2 = Star2Tab:AddSection({
    Name = "サイズ設定（巨大）"
})

Star2Tab:AddSlider({
    Name = "基本サイズ（巨大）",
    Min = 5,
    Max = Star2Config.SizeMax,
    Default = Star2Config.Size,
    Color = Theme.SliderColor,
    Increment = 1,
    ValueName = "studs",
    Callback = function(Value)
        Star2Config.Size = Value
    end
})

Star2Tab:AddSlider({
    Name = "光線の長さ",
    Min = 1.0,
    Max = Star2Config.RayLengthMax,
    Default = Star2Config.RayLength,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "studs",
    Callback = function(Value)
        Star2Config.RayLength = Value
    end
})

Star2Tab:AddSlider({
    Name = "基本高さ（高い）",
    Min = 5,
    Max = 30,
    Default = Star2Config.Height,
    Color = Theme.SliderColor,
    Increment = 1,
    ValueName = "studs",
    Callback = function(Value)
        Star2Config.Height = Value
    end
})

Star2Tab:AddSlider({
    Name = "光線の数",
    Min = 6,
    Max = 24,
    Default = Star2Config.RayCount,
    Color = Theme.SliderColor,
    Increment = 2,
    ValueName = "本",
    Callback = function(Value)
        Star2Config.RayCount = Value
        if Star2Config.Enabled then
            toggleStar2(false)
            task.wait(0.1)
            toggleStar2(true)
        end
    end
})

Star2Tab:AddSlider({
    Name = "花火の数（多い）",
    Min = 12,
    Max = 48,
    Default = Star2Config.ObjectCount,
    Color = Theme.SliderColor,
    Increment = 4,
    ValueName = "個",
    Callback = function(Value)
        Star2Config.ObjectCount = Value
        if Star2Config.Enabled then
            toggleStar2(false)
            task.wait(0.1)
            toggleStar2(true)
        end
    end
})

local Star2Section3 = Star2Tab:AddSection({
    Name = "動き設定（超高速）"
})

Star2Tab:AddSlider({
    Name = "回転速度（超高速）",
    Min = 0,
    Max = Star2Config.RotationSpeedMax,
    Default = Star2Config.RotationSpeed,
    Color = Theme.SliderColor,
    Increment = 1,
    ValueName = "速度",
    Callback = function(Value)
        Star2Config.RotationSpeed = Value
    end
})

Star2Tab:AddSlider({
    Name = "脈動速度（超高速）",
    Min = 0,
    Max = Star2Config.PulseSpeedMax,
    Default = Star2Config.PulseSpeed,
    Color = Theme.SliderColor,
    Increment = 1,
    ValueName = "速度",
    Callback = function(Value)
        Star2Config.PulseSpeed = Value
    end
})

Star2Tab:AddSlider({
    Name = "脈動振幅（大きく）",
    Min = 0,
    Max = 5,
    Default = Star2Config.PulseAmplitude,
    Color = Theme.SliderColor,
    Increment = 0.2,
    ValueName = "studs",
    Callback = function(Value)
        Star2Config.PulseAmplitude = Value
    end
})

local Star2Section4 = Star2Tab:AddSection({
    Name = "ギザギザ効果"
})

Star2Tab:AddSlider({
    Name = "ギザギザ速度",
    Min = 0,
    Max = 10,
    Default = Star2Config.JitterSpeed,
    Color = Theme.SliderColor,
    Increment = 0.5,
    ValueName = "速度",
    Callback = function(Value)
        Star2Config.JitterSpeed = Value
    end
})

Star2Tab:AddSlider({
    Name = "ギザギザ量",
    Min = 0,
    Max = 3,
    Default = Star2Config.JitterAmount,
    Color = Theme.SliderColor,
    Increment = 0.1,
    ValueName = "studs",
    Callback = function(Value)
        Star2Config.JitterAmount = Value
    end
})

local Star2Section5 = Star2Tab:AddSection({
    Name = "制御"
})

Star2Tab:AddButton({
    Name = "花火を再検出",
    Callback = function()
        if Star2Config.Enabled then
            toggleStar2(false)
            task.wait(0.1)
            toggleStar2(true)
            OrionLib:MakeNotification({
                Name = "再検出完了",
                Content = "花火を再検出しました",
                Image = "rbxassetid://4483362458",
                Time = 3
            })
        end
    end
})

-- ====================================================================
-- タブ10: Mi(=^・^=)
-- ====================================================================
local UtilityTab = Window:MakeTab({
    Name = "Mi(=^・^=)",
    Icon = "rbxassetid://4483362458",
    PremiumOnly = false
})

local UtilitySection1 = UtilityTab:AddSection({
    Name = "便利機能"
})

UtilityTab:AddToggle({
    Name = "無限ジャンプ",
    Default = false,
    Callback = function(Value)
        toggleInfiniteJump(Value)
    end
})

UtilityTab:AddToggle({
    Name = "Noclip (壁抜け)",
    Default = false,
    Callback = function(Value)
        toggleNoclip(Value)
    end
})

local UtilitySection2 = UtilityTab:AddSection({
    Name = "情報"
})

UtilityTab:AddLabel("現在のプレイヤー: " .. LocalPlayer.Name)
UtilityTab:AddLabel("ゲーム: " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)

UtilityTab:AddButton({
    Name = "スクリプトを再読み込み",
    Callback = function()
        OrionLib:MakeNotification({
            Name = "再読み込み",
            Content = "ゲームを再起動してスクリプトを再実行してください",
            Image = "rbxassetid://4483362458",
            Time = 3
        })
    end
})

-- ====================================================================
-- 初期化
-- ====================================================================
OrionLib:MakeNotification({
    Name = "さくらhub起動",
    Content = "全10タブの機能が使用可能です",
    Image = "rbxassetid://4483362458",
    Time = 5
})

-- OrionLibのカスタマイズを追加
local OrionLibFunctions = {
    Init = function(self)
        -- 既存のUI要素の色を変更
        for _, element in pairs(self.elements) do
            if element.Type == "Section" then
                -- セクションの色を変更
                if element.Section then
                    element.Section.Title.BackgroundColor3 = Theme.SectionColor
                end
            elseif element.Type == "Slider" then
                -- スライダーの色を変更
                if element.Slider then
                    element.Slider.Fill.BackgroundColor3 = Theme.SliderColor
                    element.Slider.Circle.BackgroundColor3 = Theme.SliderColor
                end
            end
        end
        
        -- 元のInit関数を呼び出し
        self:Init()
    end
}

-- テーマを適用
setmetatable(OrionLibFunctions, {__index = OrionLib})
OrionLib = OrionLibFunctions

OrionLib:Init()

print("さくらhubが起動しました")
print("羽[Feather]機能: 背中側に横一列配置")
print("魔法陣［RingX2］機能: 独立した魔法陣")
print("♡ハート♡機能: ハート形配置")
print("おっきぃ♡機能: 大きいハート形配置（速度拡張版）")
print("ダビデ✡機能: ダビデ星形配置")
print("スター★機能: ⭐️形配置")
print("SuperRing機能: 竜巻効果付きリング")
print("卍マンジ機能: 卍形配置（新規追加）")
print("スター2✫機能: 太陽形配置・超高速・巨大（新規追加）")
print("Mi(=^・^=)機能: 便利機能")
print("UIテーマ: 茶色背景, ピンクスライダー")
