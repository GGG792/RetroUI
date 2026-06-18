-- ============================================================
-- RetroUI - Early Roblox Style Script UI Library
-- 100% Authentic 2010-2015 Roblox Exploit Hub Aesthetic
-- Sharp corners, 3D bevels, WinXP-style controls
-- ============================================================

local RetroUI = {};
RetroUI.__index = RetroUI;

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;

-- 经典 Roblox/WinXP 配色
local C = {
	-- 窗口
	WinBg = Color3.fromRGB(212, 208, 200);       -- WinXP 窗口背景
	WinTitle = Color3.fromRGB(0, 16, 128);          -- 经典蓝色标题栏
	WinTitleInactive = Color3.fromRGB(128, 128, 128);
	WinTitleText = Color3.fromRGB(255, 255, 255);
	
	-- 3D 凹凸效果
	BevelLight = Color3.fromRGB(255, 255, 255);    -- 高光（左上）
	BevelDark = Color3.fromRGB(128, 128, 128);     -- 阴影（右下）
	BevelDarker = Color3.fromRGB(64, 64, 64);      -- 最深阴影
	BevelMid = Color3.fromRGB(192, 192, 192);     -- 中间色
	
	-- 控件
	BtnFace = Color3.fromRGB(212, 208, 200);       -- 按钮面
	BtnHighlight = Color3.fromRGB(240, 240, 240);  -- 按钮高光
	BtnShadow = Color3.fromRGB(128, 128, 128);      -- 按钮阴影
	BtnPressed = Color3.fromRGB(192, 192, 192);     -- 按下状态
	
	-- 侧边栏
	SidebarBg = Color3.fromRGB(245, 243, 240);      -- 浅灰侧边栏
	SidebarActive = Color3.fromRGB(49, 106, 197);   -- 经典蓝色选中
	SidebarHover = Color3.fromRGB(220, 218, 214);   -- 悬停
	SidebarText = Color3.fromRGB(0, 0, 0);
	SidebarTextActive = Color3.fromRGB(255, 255, 255);
	
	-- 内容区
	ContentBg = Color3.fromRGB(255, 255, 255);      -- 白色内容区
	ContentText = Color3.fromRGB(0, 0, 0);
	ContentTextDim = Color3.fromRGB(100, 100, 100);
	ContentBorder = Color3.fromRGB(128, 128, 128);
	
	-- 输入框
	InputBg = Color3.fromRGB(255, 255, 255);
	InputBorder = Color3.fromRGB(128, 128, 128);
	InputText = Color3.fromRGB(0, 0, 0);
	
	-- 滚动条
	ScrollThumb = Color3.fromRGB(160, 160, 160);
	ScrollTrack = Color3.fromRGB(212, 208, 200);
	
	-- 状态栏
	StatusBg = Color3.fromRGB(176, 176, 176);
	StatusText = Color3.fromRGB(0, 0, 0);
	
	-- 开关
	ToggleOn = Color3.fromRGB(49, 106, 197);
	ToggleOff = Color3.fromRGB(192, 192, 192);
	
	-- 关闭按钮
	CloseBtn = Color3.fromRGB(108, 108, 108);
	CloseHover = Color3.fromRGB(200, 60, 60);
	
	-- 分隔线
	Separator = Color3.fromRGB(128, 128, 128);
	
	-- 标签头
	TabHeader = Color3.fromRGB(245, 243, 240);
	TabHeaderActive = Color3.fromRGB(255, 255, 255);
	TabHeaderBorder = Color3.fromRGB(128, 128, 128);
	
	-- 下拉框
	DropdownBg = Color3.fromRGB(255, 255, 255);
	DropdownHover = Color3.fromRGB(49, 106, 197);
	DropdownHoverText = Color3.fromRGB(255, 255, 255);
	DropdownArrow = Color3.fromRGB(0, 0, 0);
	
	-- 滑块
	SliderTrack = Color3.fromRGB(192, 192, 192);
	SliderFill = Color3.fromRGB(49, 106, 197);
	SliderThumb = Color3.fromRGB(212, 208, 200);
	
	-- 标签
	LabelBg = Color3.fromRGB(245, 243, 240);
};

-- ========== 辅助：3D 凹凸边框 ==========
local function addBevel(parent, style, thickness)
	-- style: "raised" (凸起) / "sunken" (凹陷)
	thickness = thickness or 2;
	local lightColor = style == "raised" and C.BevelLight or C.BevelDark;
	local darkColor = style == "raised" and C.BevelDark or C.BevelLight;
	local midColor = style == "raised" and C.BevelMid or C.BevelMid;
	
	-- 外层高光/阴影
	local edges = {
		-- 左边
		{Size=UDim2.new(0, thickness, 1, 0), Position=UDim2.new(0, 0, 0, 0), Color=lightColor},
		-- 上边
		{Size=UDim2.new(1, 0, 0, thickness), Position=UDim2.new(0, 0, 0, 0), Color=lightColor},
		-- 右边
		{Size=UDim2.new(0, thickness, 1, 0), Position=UDim2.new(1, -thickness, 0, 0), Color=darkColor},
		-- 下边
		{Size=UDim2.new(1, 0, 0, thickness), Position=UDim2.new(0, 0, 1, -thickness), Color=darkColor},
	};
	
	for _, e in ipairs(edges) do
		local f = Instance.new("Frame");
		f.Size = e.Size;
		f.Position = e.Position;
		f.BackgroundColor3 = e.Color;
		f.BorderSizePixel = 0;
		f.ZIndex = parent.ZIndex + 1;
		f.Parent = parent;
	end;
	
	-- 内层（更细的高光/阴影）
	if thickness >= 2 then
		local inner = {
			{Size=UDim2.new(0, 1, 1, -2), Position=UDim2.new(0, thickness, 0, 1), Color=midColor},
			{Size=UDim2.new(1, -2, 0, 1), Position=UDim2.new(0, 1, 0, thickness), Color=midColor},
		};
		for _, e in ipairs(inner) do
			local f = Instance.new("Frame");
			f.Size = e.Size;
			f.Position = e.Position;
			f.BackgroundColor3 = e.Color;
			f.BorderSizePixel = 0;
			f.ZIndex = parent.ZIndex + 1;
			f.Parent = parent;
		end;
	end;
end;

-- ========== 创建窗口 ==========
function RetroUI.new(config)
	config = config or {};
	local self = setmetatable({}, RetroUI);
	self.Name = config.Name or "Script Hub";
	self.Subtitle = config.Subtitle or "v1.0";
	self.Tabs = {};
	self.ActiveTab = nil;
	self.Connections = {};
	self.StatusText = "Ready";

	self:_build();
	return self;
end;

function RetroUI:_build()
	self.Gui = Instance.new("ScreenGui");
	self.Gui.Name = "RetroUI_" .. self.Name;
	self.Gui.Parent = LocalPlayer.PlayerGui;
	self.Gui.ResetOnSpawn = false;
	self.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

	-- ===== 主窗口 =====
	self.Frame = Instance.new("Frame");
	self.Frame.Name = "MainFrame";
	self.Frame.Size = UDim2.new(0, 520, 0, 380);
	self.Frame.Position = UDim2.new(0.5, -260, 0.5, -190);
	self.Frame.BackgroundColor3 = C.WinBg;
	self.Frame.BorderSizePixel = 0;
	self.Frame.Parent = self.Gui;
	addBevel(self.Frame, "raised", 2);

	-- ===== 标题栏（经典蓝色渐变） =====
	self.TitleBar = Instance.new("Frame");
	self.TitleBar.Size = UDim2.new(1, -4, 0, 24);
	self.TitleBar.Position = UDim2.new(0, 2, 0, 2);
	self.TitleBar.BackgroundColor3 = C.WinTitle;
	self.TitleBar.BorderSizePixel = 0;
	self.TitleBar.ZIndex = 10;
	self.TitleBar.Parent = self.Frame;

	-- 标题栏渐变（上亮下暗）
	local titleGradTop = Instance.new("Frame");
	titleGradTop.Size = UDim2.new(1, 0, 0, 12);
	titleGradTop.Position = UDim2.new(0, 0, 0, 0);
	titleGradTop.BackgroundColor3 = Color3.fromRGB(50, 80, 200);
	titleGradTop.BackgroundTransparency = 0.3;
	titleGradTop.BorderSizePixel = 0;
	titleGradTop.ZIndex = 11;
	titleGradTop.Parent = self.TitleBar;

	-- 标题栏底部线
	local titleLine = Instance.new("Frame");
	titleLine.Size = UDim2.new(1, 0, 0, 1);
	titleLine.Position = UDim2.new(0, 0, 1, -1);
	titleLine.BackgroundColor3 = C.BevelDark;
	titleLine.BorderSizePixel = 0;
	titleLine.ZIndex = 11;
	titleLine.Parent = self.TitleBar;

	-- 标题图标（经典 Roblox 风格小方块）
	local icon = Instance.new("Frame");
	icon.Size = UDim2.new(0, 14, 0, 14);
	icon.Position = UDim2.new(0, 4, 0, 5);
	icon.BackgroundColor3 = Color3.fromRGB(100, 160, 255);
	icon.BorderSizePixel = 0;
	icon.ZIndex = 12;
	icon.Parent = self.TitleBar;
	addBevel(icon, "raised", 1);

	-- 标题文字
	local titleLabel = Instance.new("TextLabel");
	titleLabel.Size = UDim2.new(0, 200, 1, 0);
	titleLabel.Position = UDim2.new(0, 22, 0, 0);
	titleLabel.BackgroundTransparency = 1;
	titleLabel.Text = self.Name;
	titleLabel.Font = Enum.Font.SourceSansBold;
	titleLabel.TextSize = 12;
	titleLabel.TextColor3 = C.WinTitleText;
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left;
	titleLabel.ZIndex = 12;
	titleLabel.Parent = self.TitleBar;

	-- 副标题
	local verLabel = Instance.new("TextLabel");
	verLabel.Size = UDim2.new(0, 50, 1, 0);
	verLabel.Position = UDim2.new(0, 24 + titleLabel.TextBounds.X, 0, 0);
	verLabel.BackgroundTransparency = 1;
	verLabel.Text = self.Subtitle;
	verLabel.Font = Enum.Font.SourceSans;
	verLabel.TextSize = 10;
	verLabel.TextColor3 = Color3.fromRGB(180, 200, 255);
	verLabel.TextXAlignment = Enum.TextXAlignment.Left;
	verLabel.ZIndex = 12;
	verLabel.Parent = self.TitleBar;

	-- 关闭按钮（经典 WinXP 风格）
	local closeBtn = Instance.new("TextButton");
	closeBtn.Size = UDim2.new(0, 21, 0, 21);
	closeBtn.Position = UDim2.new(1, -23, 0, 2);
	closeBtn.BackgroundColor3 = C.CloseBtn;
	closeBtn.BorderSizePixel = 0;
	closeBtn.Text = "X";
	closeBtn.Font = Enum.Font.SourceSansBold;
	closeBtn.TextSize = 10;
	closeBtn.TextColor3 = C.WinTitleText;
	closeBtn.ZIndex = 12;
	closeBtn.Parent = self.TitleBar;
	addBevel(closeBtn, "raised", 1);

	closeBtn.MouseEnter:Connect(function()
		closeBtn.BackgroundColor3 = C.CloseHover;
	end);
	closeBtn.MouseLeave:Connect(function()
		closeBtn.BackgroundColor3 = C.CloseBtn;
	end);
	closeBtn.MouseButton1Click:Connect(function()
		self:Destroy();
	end);

	-- ===== 菜单栏（经典 File/Edit/Help） =====
	local menuBar = Instance.new("Frame");
	menuBar.Size = UDim2.new(1, -4, 0, 20);
	menuBar.Position = UDim2.new(0, 2, 0, 26);
	menuBar.BackgroundColor3 = C.WinBg;
	menuBar.BorderSizePixel = 0;
	menuBar.ZIndex = 10;
	menuBar.Parent = self.Frame;
	addBevel(menuBar, "raised", 1);

	local menuItems = {"File", "Edit", "View", "Help"};
	for i, item in ipairs(menuItems) do
		local menuBtn = Instance.new("TextButton");
		menuBtn.Size = UDim2.new(0, 36, 0, 18);
		menuBtn.Position = UDim2.new(0, 2 + (i-1) * 38, 0, 1);
		menuBtn.BackgroundColor3 = C.WinBg;
		menuBtn.BorderSizePixel = 0;
		menuBtn.Text = item;
		menuBtn.Font = Enum.Font.SourceSans;
		menuBtn.TextSize = 11;
		menuBtn.TextColor3 = C.ContentText;
		menuBtn.ZIndex = 11;
		menuBtn.Parent = menuBar;

		menuBtn.MouseEnter:Connect(function()
			menuBtn.BackgroundColor3 = C.SidebarActive;
			menuBtn.TextColor3 = C.SidebarTextActive;
		end);
		menuBtn.MouseLeave:Connect(function()
			menuBtn.BackgroundColor3 = C.WinBg;
			menuBtn.TextColor3 = C.ContentText;
		end);
	end;

	-- ===== 工具栏（经典图标按钮栏） =====
	local toolBar = Instance.new("Frame");
	toolBar.Size = UDim2.new(1, -4, 0, 26);
	toolBar.Position = UDim2.new(0, 2, 0, 46);
	toolBar.BackgroundColor3 = C.WinBg;
	toolBar.BorderSizePixel = 0;
	toolBar.ZIndex = 10;
	toolBar.Parent = self.Frame;
	addBevel(toolBar, "raised", 1);

	-- 工具栏分隔线
	local toolSep = Instance.new("Frame");
	toolSep.Size = UDim2.new(1, 0, 0, 1);
	toolSep.Position = UDim2.new(0, 0, 1, -1);
	toolSep.BackgroundColor3 = C.BevelDark;
	toolSep.BorderSizePixel = 0;
	toolSep.ZIndex = 11;
	toolSep.Parent = toolBar;

	-- 工具栏按钮
	local toolIcons = {"||", ">>", "[]", "##", "@@"};
	for i, icon in ipairs(toolIcons) do
		local toolBtn = Instance.new("TextButton");
		toolBtn.Size = UDim2.new(0, 24, 0, 22);
		toolBtn.Position = UDim2.new(0, 2 + (i-1) * 26, 0, 2);
		toolBtn.BackgroundColor3 = C.WinBg;
		toolBtn.BorderSizePixel = 0;
		toolBtn.Text = icon;
		toolBtn.Font = Enum.Font.SourceSans;
		toolBtn.TextSize = 10;
		toolBtn.TextColor3 = C.ContentText;
		toolBtn.ZIndex = 11;
		toolBtn.Parent = toolBar;

		toolBtn.MouseEnter:Connect(function()
			toolBtn.BackgroundColor3 = C.BtnHighlight;
		end);
		toolBtn.MouseLeave:Connect(function()
			toolBtn.BackgroundColor3 = C.WinBg;
		end);
	end;

	-- ===== 主体区域 =====
	local bodyFrame = Instance.new("Frame");
	bodyFrame.Size = UDim2.new(1, -4, 1, -100);
	bodyFrame.Position = UDim2.new(0, 2, 0, 72);
	bodyFrame.BackgroundColor3 = C.WinBg;
	bodyFrame.BorderSizePixel = 0;
	bodyFrame.ZIndex = 5;
	bodyFrame.Parent = self.Frame;

	-- ===== 侧边栏（经典树形视图风格） =====
	self.Sidebar = Instance.new("Frame");
	self.Sidebar.Size = UDim2.new(0, 120, 1, 0);
	self.Sidebar.BackgroundColor3 = C.SidebarBg;
	self.Sidebar.BorderSizePixel = 0;
	self.Sidebar.ZIndex = 6;
	self.Sidebar.Parent = bodyFrame;
	addBevel(self.Sidebar, "sunken", 1);

	-- 侧边栏标题
	local sideTitle = Instance.new("Frame");
	sideTitle.Size = UDim2.new(1, 0, 0, 20);
	sideTitle.BackgroundColor3 = C.WinBg;
	sideTitle.BorderSizePixel = 0;
	sideTitle.ZIndex = 7;
	sideTitle.Parent = self.Sidebar;

	local sideTitleLabel = Instance.new("TextLabel");
	sideTitleLabel.Size = UDim2.new(1, -4, 1, 0);
	sideTitleLabel.Position = UDim2.new(0, 4, 0, 0);
	sideTitleLabel.BackgroundTransparency = 1;
	sideTitleLabel.Text = "Navigation";
	sideTitleLabel.Font = Enum.Font.SourceSansBold;
	sideTitleLabel.TextSize = 10;
	sideTitleLabel.TextColor3 = C.ContentText;
	sideTitleLabel.TextXAlignment = Enum.TextXAlignment.Left;
	sideTitleLabel.ZIndex = 8;
	sideTitleLabel.Parent = sideTitle;

	-- ===== 内容区域（经典凹陷面板） =====
	self.Content = Instance.new("Frame");
	self.Content.Size = UDim2.new(1, -120, 1, 0);
	self.Content.Position = UDim2.new(0, 120, 0, 0);
	self.Content.BackgroundColor3 = C.ContentBg;
	self.Content.BorderSizePixel = 0;
	self.Content.ClipsDescendants = true;
	self.Content.ZIndex = 6;
	self.Content.Parent = bodyFrame;
	addBevel(self.Content, "sunken", 2);

	-- 欢迎文字
	local welcome = Instance.new("TextLabel");
	welcome.Size = UDim2.new(1, -12, 0, 18);
	welcome.Position = UDim2.new(0, 6, 0, 6);
	welcome.BackgroundTransparency = 1;
	welcome.Text = "Welcome to " .. self.Name;
	welcome.Font = Enum.Font.SourceSansBold;
	welcome.TextSize = 12;
	welcome.TextColor3 = C.ContentText;
	welcome.TextXAlignment = Enum.TextXAlignment.Left;
	welcome.ZIndex = 7;
	welcome.Parent = self.Content;

	local sub = Instance.new("TextLabel");
	sub.Size = UDim2.new(1, -12, 0, 14);
	sub.Position = UDim2.new(0, 6, 0, 24);
	sub.BackgroundTransparency = 1;
	sub.Text = "Select a tab from the sidebar to begin."
	sub.Font = Enum.Font.SourceSans;
	sub.TextSize = 10;
	sub.TextColor3 = C.ContentTextDim;
	sub.TextXAlignment = Enum.TextXAlignment.Left;
	sub.ZIndex = 7;
	sub.Parent = self.Content;

	-- ===== 状态栏（经典 Windows 状态栏） =====
	self.StatusBar = Instance.new("Frame");
	self.StatusBar.Size = UDim2.new(1, -4, 0, 20);
	self.StatusBar.Position = UDim2.new(0, 2, 1, -22);
	self.StatusBar.BackgroundColor3 = C.StatusBg;
	self.StatusBar.BorderSizePixel = 0;
	self.StatusBar.ZIndex = 10;
	self.StatusBar.Parent = self.Frame;
	addBevel(self.StatusBar, "sunken", 1);

	-- 状态栏分隔
	local statusSep = Instance.new("Frame");
	statusSep.Size = UDim2.new(0, 1, 1, -4);
	statusSep.Position = UDim2.new(0.7, 0, 0, 2);
	statusSep.BackgroundColor3 = C.BevelDark;
	statusSep.BorderSizePixel = 0;
	statusSep.ZIndex = 11;
	statusSep.Parent = self.StatusBar;

	-- 状态栏文字
	local statusLabel = Instance.new("TextLabel");
	statusLabel.Name = "StatusLabel";
	statusLabel.Size = UDim2.new(0.7, -8, 1, 0);
	statusLabel.Position = UDim2.new(0, 4, 0, 0);
	statusLabel.BackgroundTransparency = 1;
	statusLabel.Text = self.StatusText;
	statusLabel.Font = Enum.Font.SourceSans;
	statusLabel.TextSize = 10;
	statusLabel.TextColor3 = C.StatusText;
	statusLabel.TextXAlignment = Enum.TextXAlignment.Left;
	statusLabel.ZIndex = 12;
	statusLabel.Parent = self.StatusBar;
	self.StatusLabel = statusLabel;

	-- 状态栏右侧
	local statusRight = Instance.new("TextLabel");
	statusRight.Size = UDim2.new(0.3, -8, 1, 0);
	statusRight.Position = UDim2.new(0.7, 4, 0, 0);
	statusRight.BackgroundTransparency = 1;
	statusRight.Text = os.date("%H:%M:%S");
	statusRight.Font = Enum.Font.SourceSans;
	statusRight.TextSize = 10;
	statusRight.TextColor3 = C.StatusText;
	statusRight.TextXAlignment = Enum.TextXAlignment.Right;
	statusRight.ZIndex = 12;
	statusRight.Parent = self.StatusBar;

	-- 时钟更新
	task.spawn(function()
		while self.Gui and self.Gui.Parent do
			task.wait(1);
			pcall(function()
				statusRight.Text = os.date("%H:%M:%S");
			end);
		end;
	end);

	-- ===== 拖拽 =====
	self:_makeDraggable();
end;

function RetroUI:_makeDraggable()
	local dragging = false;
	local dragStart, startPos;

	self.TitleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true;
			dragStart = input.Position;
			startPos = self.Frame.Position;
		end;
	end);

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart;
			self.Frame.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			);
		end;
	end);

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false;
		end;
	end);
end;

-- ========== 标签页 ==========
function RetroUI:AddTab(name)
	local yPos = 22 + (#self.Tabs * 24);

	local btn = Instance.new("TextButton");
	btn.Name = "Tab_" .. name;
	btn.Size = UDim2.new(1, -4, 0, 22);
	btn.Position = UDim2.new(0, 2, 0, yPos);
	btn.BackgroundColor3 = C.SidebarBg;
	btn.BorderSizePixel = 0;
	btn.Text = "  " .. name;
	btn.Font = Enum.Font.SourceSans;
	btn.TextSize = 11;
	btn.TextColor3 = C.SidebarText;
	btn.TextXAlignment = Enum.TextXAlignment.Left;
	btn.ZIndex = 8;
	btn.Parent = self.Sidebar;

	-- 左侧激活指示条（经典蓝色条）
	local indicator = Instance.new("Frame");
	indicator.Size = UDim2.new(0, 3, 1, -2);
	indicator.Position = UDim2.new(0, 0, 0, 1);
	indicator.BackgroundColor3 = C.SidebarActive;
	indicator.BorderSizePixel = 0;
	indicator.Visible = false;
	indicator.ZIndex = 9;
	indicator.Parent = btn;

	-- 内容
	local content = Instance.new("Frame");
	content.Name = "TabContent_" .. name;
	content.Size = UDim2.new(1, 0, 1, 0);
	content.BackgroundTransparency = 1;
	content.Visible = false;
	content.ZIndex = 7;
	content.Parent = self.Content;

	-- 滚动框架
	local scrollFrame = Instance.new("ScrollingFrame");
	scrollFrame.Size = UDim2.new(1, -8, 1, -8);
	scrollFrame.Position = UDim2.new(0, 4, 0, 4);
	scrollFrame.BackgroundTransparency = 1;
	scrollFrame.BorderSizePixel = 0;
	scrollFrame.ScrollBarThickness = 8;
	scrollFrame.ScrollBarImageColor3 = C.ScrollThumb;
	scrollFrame.ScrollBarBackgroundColor3 = C.ScrollTrack;
	scrollFrame.ZIndex = 8;
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
	scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
	scrollFrame.Parent = content;

	local listLayout = Instance.new("UIListLayout");
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder;
	listLayout.Padding = UDim.new(0, 3);
	listLayout.Parent = scrollFrame;

	local tab = {
		Name = name;
		Button = btn;
		Content = content;
		ScrollFrame = scrollFrame;
		ListLayout = listLayout;
		Indicator = indicator;
		Elements = {};
	};

	btn.MouseEnter:Connect(function()
		if self.ActiveTab ~= tab then
			btn.BackgroundColor3 = C.SidebarHover;
		end;
	end);

	btn.MouseLeave:Connect(function()
		if self.ActiveTab ~= tab then
			btn.BackgroundColor3 = C.SidebarBg;
		end;
	end);

	btn.MouseButton1Click:Connect(function()
		self:SelectTab(tab);
	end);

	table.insert(self.Tabs, tab);

	if #self.Tabs == 1 then
		self:SelectTab(tab);
	end;

	return tab;
end;

function RetroUI:SelectTab(tab)
	for _, t in ipairs(self.Tabs) do
		t.Content.Visible = false;
		t.Button.BackgroundColor3 = C.SidebarBg;
		t.Button.TextColor3 = C.SidebarText;
		t.Button.Font = Enum.Font.SourceSans;
		t.Indicator.Visible = false;
	end;

	tab.Content.Visible = true;
	tab.Button.BackgroundColor3 = C.SidebarActive;
	tab.Button.TextColor3 = C.SidebarTextActive;
	tab.Button.Font = Enum.Font.SourceSansBold;
	tab.Indicator.Visible = true;
	self.ActiveTab = tab;

	-- 更新状态栏
	self:SetStatus("Tab: " .. tab.Name);
end;

-- ========== 状态栏 ==========
function RetroUI:SetStatus(text)
	self.StatusText = text;
	if self.StatusLabel then
		self.StatusLabel.Text = text;
	end;
end;

-- ========== 控件工厂 ==========

-- 标签（经典 GroupBox 风格）
function RetroUI:AddLabel(tab, text)
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 22);
	container.BackgroundColor3 = C.LabelBg;
	container.BorderSizePixel = 0;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;
	addBevel(container, "sunken", 1);

	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(1, -6, 1, 0);
	label.Position = UDim2.new(0, 4, 0, 0);
	label.BackgroundTransparency = 1;
	label.Text = text;
	label.Font = Enum.Font.SourceSansBold;
	label.TextSize = 11;
	label.TextColor3 = C.ContentText;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 9;
	label.Parent = container;

	table.insert(tab.Elements, container);
	return label;
end;

-- 按钮（经典 3D 凸起按钮）
function RetroUI:AddButton(tab, text, callback)
	local btn = Instance.new("TextButton");
	btn.Size = UDim2.new(1, 0, 0, 26);
	btn.BackgroundColor3 = C.BtnFace;
	btn.BorderSizePixel = 0;
	btn.Text = text;
	btn.Font = Enum.Font.SourceSansBold;
	btn.TextSize = 11;
	btn.TextColor3 = C.ContentText;
	btn.ZIndex = 8;
	btn.Parent = tab.ScrollFrame;
	btn.LayoutOrder = #tab.Elements;
	addBevel(btn, "raised", 2);

	-- 按钮文字阴影效果
	local shadow = Instance.new("TextLabel");
	shadow.Size = UDim2.new(1, 0, 1, 0);
	shadow.Position = UDim2.new(0, 1, 0, 1);
	shadow.BackgroundTransparency = 1;
	shadow.Text = text;
	shadow.Font = Enum.Font.SourceSansBold;
	shadow.TextSize = 11;
	shadow.TextColor3 = C.BevelDark;
	shadow.TextTransparency = 0.6;
	shadow.ZIndex = 9;
	shadow.Parent = btn;

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = C.BtnHighlight;
	end);
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = C.BtnFace;
	end);

	btn.MouseButton1Click:Connect(function()
		-- 按下效果
		btn.BackgroundColor3 = C.BtnPressed;
		shadow.TextTransparency = 1;
		task.delay(0.15, function()
			btn.BackgroundColor3 = C.BtnFace;
			shadow.TextTransparency = 0.6;
		end);
		if callback then callback(); end;
	end);

	table.insert(tab.Elements, btn);
	return btn;
end;

-- 开关（经典复选框风格）
function RetroUI:AddToggle(tab, text, default, callback)
	default = default or false;

	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 22);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	-- 经典复选框
	local checkbox = Instance.new("TextButton");
	checkbox.Size = UDim2.new(0, 16, 0, 16);
	checkbox.Position = UDim2.new(0, 2, 0, 3);
	checkbox.BackgroundColor3 = C.ContentBg;
	checkbox.BorderSizePixel = 0;
	checkbox.Text = default and "v" or "";
	checkbox.Font = Enum.Font.SourceSansBold;
	checkbox.TextSize = 11;
	checkbox.TextColor3 = C.ContentText;
	checkbox.ZIndex = 10;
	checkbox.Parent = container;
	addBevel(checkbox, "sunken", 1);

	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(1, -28, 1, 0);
	label.Position = UDim2.new(0, 24, 0, 0);
	label.BackgroundTransparency = 1;
	label.Text = text;
	label.Font = Enum.Font.SourceSans;
	label.TextSize = 11;
	label.TextColor3 = C.ContentText;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 9;
	label.Parent = container;

	local state = default;
	checkbox.MouseButton1Click:Connect(function()
		state = not state;
		checkbox.Text = state and "v" or "";
		checkbox.BackgroundColor3 = state and C.ToggleOn or C.ContentBg;
		if callback then callback(state); end;
	end);

	table.insert(tab.Elements, container);
	return checkbox;
end;

-- 文本输入框（经典凹陷输入框）
function RetroUI:AddTextBox(tab, placeholder, callback)
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 24);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(0, 70, 1, 0);
	label.Position = UDim2.new(0, 0, 0, 0);
	label.BackgroundTransparency = 1;
	label.Text = placeholder .. ":";
	label.Font = Enum.Font.SourceSans;
	label.TextSize = 11;
	label.TextColor3 = C.ContentText;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 9;
	label.Parent = container;

	local input = Instance.new("TextBox");
	input.Size = UDim2.new(1, -78, 0, 20);
	input.Position = UDim2.new(0, 74, 0, 2);
	input.BackgroundColor3 = C.InputBg;
	input.BorderSizePixel = 0;
	input.Text = "";
	input.PlaceholderText = placeholder;
	input.PlaceholderColor3 = C.ContentTextDim;
	input.Font = Enum.Font.SourceSans;
	input.TextSize = 11;
	input.TextColor3 = C.InputText;
	input.ZIndex = 10;
	input.Parent = container;
	addBevel(input, "sunken", 1);

	if callback then
		input.FocusLost:Connect(function()
			callback(input.Text);
		end);
	end;

	table.insert(tab.Elements, container);
	return input;
end;

-- 滑块
function RetroUI:AddSlider(tab, text, min, max, default, callback)
	default = default or min;
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 32);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(1, 0, 0, 14);
	label.BackgroundTransparency = 1;
	label.Text = text .. ": " .. tostring(default);
	label.Font = Enum.Font.SourceSans;
	label.TextSize = 11;
	label.TextColor3 = C.ContentText;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 9;
	label.Parent = container;

	-- 滑轨（凹陷）
	local track = Instance.new("Frame");
	track.Size = UDim2.new(1, -4, 0, 10);
	track.Position = UDim2.new(0, 2, 0, 18);
	track.BackgroundColor3 = C.SliderTrack;
	track.BorderSizePixel = 0;
	track.ZIndex = 9;
	track.Parent = container;
	addBevel(track, "sunken", 1);

	-- 填充
	local fill = Instance.new("Frame");
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, -4);
	fill.Position = UDim2.new(0, 2, 0, 2);
	fill.BackgroundColor3 = C.SliderFill;
	fill.BorderSizePixel = 0;
	fill.ZIndex = 10;
	fill.Parent = track;

	-- 滑块手柄（凸起）
	local thumb = Instance.new("TextButton");
	thumb.Size = UDim2.new(0, 10, 0, 18);
	thumb.Position = UDim2.new((default - min) / (max - min), -5, 0.5, -9);
	thumb.BackgroundColor3 = C.SliderThumb;
	thumb.BorderSizePixel = 0;
	thumb.Text = "";
	thumb.ZIndex = 11;
	thumb.Parent = track;
	addBevel(thumb, "raised", 1);

	local sliding = false;
	thumb.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = true;
		end;
	end);

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			sliding = false;
		end;
	end);

	UserInputService.InputChanged:Connect(function(input)
		if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local relX = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1);
			local value = min + (max - min) * relX;
			value = math.floor(value * 100 + 0.5) / 100;
			fill.Size = UDim2.new(relX, 0, 1, -4);
			thumb.Position = UDim2.new(relX, -5, 0.5, -9);
			label.Text = text .. ": " .. tostring(value);
			if callback then callback(value); end;
		end;
	end);

	table.insert(tab.Elements, container);
	return container;
end;

-- 下拉框
function RetroUI:AddDropdown(tab, text, options, callback)
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 22);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	local btn = Instance.new("TextButton");
	btn.Size = UDim2.new(1, 0, 0, 20);
	btn.Position = UDim2.new(0, 0, 0, 1);
	btn.BackgroundColor3 = C.InputBg;
	btn.BorderSizePixel = 0;
	btn.Text = "  " .. text .. ": " .. (options[1] or "None") .. "  v";
	btn.Font = Enum.Font.SourceSans;
	btn.TextSize = 11;
	btn.TextColor3 = C.InputText;
	btn.TextXAlignment = Enum.TextXAlignment.Left;
	btn.ZIndex = 10;
	btn.Parent = container;
	addBevel(btn, "sunken", 1);

	local isOpen = false;
	local dropFrame = Instance.new("Frame");
	dropFrame.Size = UDim2.new(1, 0, 0, #options * 20);
	dropFrame.Position = UDim2.new(0, 0, 0, 22);
	dropFrame.BackgroundColor3 = C.DropdownBg;
	dropFrame.BorderSizePixel = 0;
	dropFrame.Visible = false;
	dropFrame.ZIndex = 20;
	dropFrame.ClipsDescendants = true;
	dropFrame.Parent = container;
	addBevel(dropFrame, "raised", 2);

	for i, opt in ipairs(options) do
		local optBtn = Instance.new("TextButton");
		optBtn.Size = UDim2.new(1, -4, 0, 20);
		optBtn.Position = UDim2.new(0, 2, 0, (i-1) * 20);
		optBtn.BackgroundColor3 = C.DropdownBg;
		optBtn.BorderSizePixel = 0;
		optBtn.Text = "  " .. opt;
		optBtn.Font = Enum.Font.SourceSans;
		optBtn.TextSize = 11;
		optBtn.TextColor3 = C.ContentText;
		optBtn.TextXAlignment = Enum.TextXAlignment.Left;
		optBtn.ZIndex = 21;
		optBtn.Parent = dropFrame;

		optBtn.MouseEnter:Connect(function()
			optBtn.BackgroundColor3 = C.DropdownHover;
			optBtn.TextColor3 = C.DropdownHoverText;
		end);
		optBtn.MouseLeave:Connect(function()
			optBtn.BackgroundColor3 = C.DropdownBg;
			optBtn.TextColor3 = C.ContentText;
		end);

		optBtn.MouseButton1Click:Connect(function()
			btn.Text = "  " .. text .. ": " .. opt .. "  v";
			dropFrame.Visible = false;
			isOpen = false;
			if callback then callback(opt); end;
		end);
	end;

	btn.MouseButton1Click:Connect(function()
		isOpen = not isOpen;
		dropFrame.Visible = isOpen;
	end);

	table.insert(tab.Elements, container);
	return container;
end;

-- 分隔线
function RetroUI:AddSeparator(tab)
	local sep = Instance.new("Frame");
	sep.Size = UDim2.new(1, 0, 0, 2);
	sep.BackgroundColor3 = C.Separator;
	sep.BorderSizePixel = 0;
	sep.ZIndex = 8;
	sep.Parent = tab.ScrollFrame;
	sep.LayoutOrder = #tab.Elements;

	-- 3D 分隔线效果
	local sepLight = Instance.new("Frame");
	sepLight.Size = UDim2.new(1, 0, 0, 1);
	sepLight.BackgroundColor3 = C.BevelLight;
	sepLight.BorderSizePixel = 0;
	sepLight.ZIndex = 9;
	sepLight.Parent = sep;

	table.insert(tab.Elements, sep);
	return sep;
end;

-- ========== 销毁 ==========
function RetroUI:Destroy()
	for _, conn in ipairs(self.Connections) do
		conn:Disconnect();
	end;
	if self.Gui then self.Gui:Destroy(); end;
end;

return RetroUI;
