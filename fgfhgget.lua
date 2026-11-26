-- ============================================
-- BurmaldaHook Loader
-- ============================================

local CONFIG = {
    Name = "BurmaldaHook",
    WorkerURL = "https://divine-dawn-ba86.n80060917.workers.dev",
    DiscordURL = "https://discord.gg/JwmJ7fcQE",
    GetKeyURL = "https://discord.gg/JwmJ7fcQE",
}

-- ============================================
-- СЕРВИСЫ
-- ============================================
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local UserId = tostring(LocalPlayer.UserId)

-- Защита от двойного запуска
if CoreGui:FindFirstChild("BurmaldaHook") then
    CoreGui:FindFirstChild("BurmaldaHook"):Destroy()
end

-- ============================================
-- УТИЛИТЫ
-- ============================================
local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    return obj
end

local function corner(radius)
    return create("UICorner", { CornerRadius = UDim.new(0, radius) })
end

local function stroke(color, thickness)
    return create("UIStroke", {
        Color = color or Color3.fromRGB(255, 255, 255),
        Thickness = thickness or 1,
        Transparency = 0.7,
    })
end

-- ============================================
-- ГЛАВНЫЙ GUI
-- ============================================
local ScreenGui = create("ScreenGui", {
    Name = "BurmaldaHook",
    Parent = CoreGui,
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 999,
})

-- Затемнение фона
local Backdrop = create("Frame", {
    Name = "Backdrop",
    Parent = ScreenGui,
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
})
TweenService:Create(Backdrop, TweenInfo.new(0.4), { BackgroundTransparency = 0.5 }):Play()

-- ============================================
-- ГЛАВНОЕ ОКНО
-- ============================================
local Main = create("Frame", {
    Name = "Main",
    Parent = ScreenGui,
    Size = UDim2.new(0, 420, 0, 340),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.15,
    BorderSizePixel = 0,
    ClipsDescendants = true,
})

corner(18)(Main)

local MainStroke = stroke(Color3.fromRGB(255, 255, 255), 1)
MainStroke.Transparency = 0.5
MainStroke.Parent = Main

-- Анимация появления
Main.Position = UDim2.new(0.5, 0, 0.55, 0)
TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0)
}):Play()

-- ============================================
-- ЗАГОЛОВОК
-- ============================================
local Header = create("Frame", {
    Parent = Main,
    Size = UDim2.new(1, 0, 0, 56),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
})

local Title = create("TextLabel", {
    Parent = Header,
    Size = UDim2.new(1, -120, 0, 56),
    Position = UDim2.new(0, 24, 0, 0),
    BackgroundTransparency = 1,
    Text = CONFIG.Name,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    TextColor3 = Color3.fromRGB(30, 30, 40),
    TextXAlignment = Enum.TextXAlignment.Left,
})

local Accent = create("Frame", {
    Parent = Main,
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 0, 56),
    BackgroundColor3 = Color3.fromRGB(200, 200, 210),
    BackgroundTransparency = 0.6,
    BorderSizePixel = 0,
})

-- Кнопка закрытия
local CloseBtn = create("TextButton", {
    Parent = Header,
    Size = UDim2.new(0, 36, 0, 36),
    Position = UDim2.new(1, -46, 0.5, -18),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.7,
    Text = "✕",
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.fromRGB(30, 30, 40),
    AutoButtonColor = false,
})
corner(10)(CloseBtn)
stroke(Color3.fromRGB(200, 200, 210), 1).Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.25), {
        Size = UDim2.new(0, 420, 0, 0),
        BackgroundTransparency = 1,
    }):Play()
    TweenService:Create(Backdrop, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
    task.wait(0.26)
    ScreenGui:Destroy()
end)

-- Перетаскивание
local dragging = false
local dragStart, startPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ============================================
-- ПОДЗАГОЛОВОК
-- ============================================
local Subtitle = create("TextLabel", {
    Parent = Main,
    Size = UDim2.new(1, -48, 0, 20),
    Position = UDim2.new(0, 24, 0, 66),
    BackgroundTransparency = 1,
    Text = "Введите ключ для активации",
    Font = Enum.Font.Gotham,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(90, 90, 105),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- ============================================
-- ПОЛЕ ВВОДА КЛЮЧА
-- ============================================
local KeyBox = create("Frame", {
    Parent = Main,
    Size = UDim2.new(1, -48, 0, 46),
    Position = UDim2.new(0, 24, 0, 98),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.35,
    BorderSizePixel = 0,
})
corner(12)(KeyBox)
local keyStroke = stroke(Color3.fromRGB(180, 180, 200), 1)
keyStroke.Transparency = 0.4
keyStroke.Parent = KeyBox

local KeyInput = create("TextBox", {
    Parent = KeyBox,
    Size = UDim2.new(1, -24, 1, 0),
    Position = UDim2.new(0, 12, 0, 0),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "xxxxx-xxxx-xxxx",
    Font = Enum.Font.Gotham,
    TextSize = 15,
    TextColor3 = Color3.fromRGB(30, 30, 40),
    PlaceholderColor3 = Color3.fromRGB(160, 160, 175),
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
})

KeyInput.Focused:Connect(function()
    keyStroke.Color = Color3.fromRGB(120, 100, 255)
    keyStroke.Transparency = 0.1
end)
KeyInput.FocusLost:Connect(function()
    keyStroke.Color = Color3.fromRGB(180, 180, 200)
    keyStroke.Transparency = 0.4
end)

-- ============================================
-- КНОПКА ВХОДА
-- ============================================
local LoginBtn = create("TextButton", {
    Parent = Main,
    Size = UDim2.new(1, -48, 0, 46),
    Position = UDim2.new(0, 24, 0, 158),
    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
    Text = "Войти",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    AutoButtonColor = false,
    BorderSizePixel = 0,
})
corner(12)(LoginBtn)

LoginBtn.MouseEnter:Connect(function()
    TweenService:Create(LoginBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(50, 50, 65) }):Play()
end)
LoginBtn.MouseLeave:Connect(function()
    TweenService:Create(LoginBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(30, 30, 40) }):Play()
end)

-- ============================================
-- СТАТУС
-- ============================================
local Status = create("TextLabel", {
    Parent = Main,
    Size = UDim2.new(1, -48, 0, 18),
    Position = UDim2.new(0, 24, 0, 212),
    BackgroundTransparency = 1,
    Text = "",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = Color3.fromRGB(120, 120, 135),
    TextXAlignment = Enum.TextXAlignment.Left,
})

-- ============================================
-- КНОПКИ ССЫЛОК
-- ============================================
local BtnRow = create("Frame", {
    Parent = Main,
    Size = UDim2.new(1, -48, 0, 42),
    Position = UDim2.new(0, 24, 0, 250),
    BackgroundTransparency = 1,
})

local GetKeyBtn = create("TextButton", {
    Parent = BtnRow,
    Size = UDim2.new(0.5, -6, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 0.55,
    Text = "🔑 Get Key",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(30, 30, 40),
    AutoButtonColor = false,
    BorderSizePixel = 0,
})
corner(10)(GetKeyBtn)
stroke(Color3.fromRGB(180, 180, 200), 1).Parent = GetKeyBtn

local DiscordBtn = create("TextButton", {
    Parent = BtnRow,
    Size = UDim2.new(0.5, -6, 1, 0),
    Position = UDim2.new(0.5, 6, 0, 0),
    BackgroundColor3 = Color3.fromRGB(88, 101, 242),
    BackgroundTransparency = 0.1,
    Text = "💬 Discord",
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = Color3.fromRGB(255, 255, 255),
    AutoButtonColor = false,
    BorderSizePixel = 0,
})
corner(10)(DiscordBtn)

GetKeyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(CONFIG.GetKeyURL) end
    end)
    Status.Text = "Ссылка скопирована. Открой Discord."
    Status.TextColor3 = Color3.fromRGB(80, 80, 100)
end)

DiscordBtn.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard(CONFIG.DiscordURL) end
    end)
    Status.Text = "Ссылка на Discord скопирована."
    Status.TextColor3 = Color3.fromRGB(80, 80, 100)
end)

GetKeyBtn.MouseEnter:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(245, 245, 250) }):Play()
end)
GetKeyBtn.MouseLeave:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), { BackgroundColor3 = Color3.fromRGB(255, 255, 255) }):Play()
end)

-- ============================================
-- ЛОГИКА ВАЛИДАЦИИ
-- ============================================
local valid = false

local function setStatus(text, color)
    Status.Text = text
    Status.TextColor3 = color or Color3.fromRGB(120, 120, 135)
end

local function setLoading(on)
    LoginBtn.Text = on and "Проверка..." or "Войти"
    LoginBtn.Active = not on
end

local function validate(key)
    local url = CONFIG.WorkerURL .. "/validate?key=" .. HttpService:UrlEncode(key) .. "&userid=" .. UserId
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not res then return nil end
    local decoded
    local ok2 = pcall(function()
        decoded = HttpService:JSONDecode(res)
    end)
    if not ok2 or not decoded then return nil end
    return decoded
end

local function loadPayload(key)
    local url = CONFIG.WorkerURL .. "/payload?key=" .. HttpService:UrlEncode(key) .. "&userid=" .. UserId
    local ok, res = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or not res then return nil end
    if res == "invalid_key" or res == "expired" or res == "banned" or res == "bound_to_other" or res == "no_payload" or res == "no_key" then
        return nil
    end
    return res
end

LoginBtn.MouseButton1Click:Connect(function()
    if valid then return end
    local key = KeyInput.Text:gsub("%s+", "")
    if key == "" then
        setStatus("Введи ключ", Color3.fromRGB(200, 60, 80))
        return
    end

    setLoading(true)
    setStatus("Проверяю ключ...", Color3.fromRGB(120, 120, 135))

    task.spawn(function()
        local data = validate(key)
        if not data then
            setLoading(false)
            setStatus("Ошибка соединения с сервером", Color3.fromRGB(200, 60, 80))
            return
        end
        if not data.ok then
            setLoading(false)
            local msg = "Неверный ключ"
            if data.error == "expired" then msg = "Ключ истёк"
            elseif data.error == "banned" then msg = "Ключ отключён"
            elseif data.error == "bound_to_other" then msg = "Ключ привязан к другому аккаунту"
            end
            setStatus(msg, Color3.fromRGB(200, 60, 80))
            return
        end

        setStatus("Загружаю скрипт...", Color3.fromRGB(80, 80, 100))
        local payload = loadPayload(key)
        if not payload then
            setLoading(false)
            setStatus("Не удалось получить скрипт", Color3.fromRGB(200, 60, 80))
            return
        end

        setLoading(false)
        setStatus("Успех! Запуск...", Color3.fromRGB(60, 180, 120))
        valid = true
        TweenService:Create(Main, TweenInfo.new(0.3), {
            BackgroundTransparency = 1,
        }):Play()
        task.delay(0.6, function()
            ScreenGui:Destroy()
        end)

        local fn, err = loadstring(payload)
        if fn then
            pcall(fn)
        else
            warn("[BurmaldaHook] Ошибка компиляции: " .. tostring(err))
        end
    end)
end)

-- Enter тоже запускает
KeyInput.FocusLost:Connect(function(enter)
    if enter then
        LoginBtn:GetPropertyChangedSignal("Text"):Connect(function() end)
        LoginBtn.MouseButton1Click:Fire()
    end
end)
