-- ============================================================
-- RetroUI - Early Roblox Style Script UI Library
-- 2010-2015 era Roblox exploit UI aesthetic
-- ============================================================

local RetroUI = {};
RetroUI.__index = RetroUI;

local Players = game:GetService("Players");
local TweenService = game:GetService("TweenService");
local UserInputService = game:GetService("UserInputService");
local LocalPlayer = Players.LocalPlayer;

-- 早期 Roblox 配色 (2010-2015)
local COLORS = {
	-- 经典 Roblox 灰蓝色系
	TopBar = Color3.fromRGB(32, 32, 36);
	TopBarGradient = Color3.fromRGB(45, 45, 50);
	Background = Color3.fromRGB(40, 40, 44);
	BackgroundLight = Color3.fromRGB(55, 55, 60);
	Sidebar = Color3.fromRGB(35, 35, 40);
	SidebarHover = Color3.fromRGB(50, 50, 58);
	SidebarActive = Color3.fromRGB(65, 105, 165);
	Content = Color3.fromRGB(45, 45, 50);
	Text = Color3.fromRGB(220, 220, 220);
	TextDim = Color3.fromRGB(160, 160, 170);
	TextDark = Color3.fromRGB(100, 100, 110);
	Accent = Color3.fromRGB(65, 105, 165);
	AccentLight = Color3.fromRGB(85, 130, 200);
	Green = Color3.fromRGB(50, 160, 50);
	Red = Color3.fromRGB(180, 50, 50);
	Yellow = Color3.fromRGB(200, 180, 50);
	Border = Color3.fromRGB(60, 60, 68);
	BorderLight = Color3.fromRGB(80, 80, 90);
	Shadow = Color3.fromRGB(20, 20, 24);
	InputBg = Color3.fromRGB(30, 30, 34);
	Scrollbar = Color3.fromRGB(70, 70, 80);
	ScrollbarTrack = Color3.fromRGB(35, 35, 40);
	White = Color3.fromRGB(255, 255, 255);
	Black = Color3.fromRGB(0, 0, 0);
};

-- ========== 创建窗口 ==========
function RetroUI.new(config)
	config = config or {};
	local self = setmetatable({}, RetroUI);
	self.Name = config.Name or "Script Hub";
	self.Subtitle = config.Subtitle or "v1.0";
	self.Tabs = {};
	self.ActiveTab = nil;
	self.Connections = {};
	self.TabButtons = {};

	self:_build();
	return self;
end;

function RetroUI:_build()
	-- ScreenGui
	self.Gui = Instance.new("ScreenGui");
	self.Gui.Name = "RetroUI_" .. self.Name;
	self.Gui.Parent = LocalPlayer.PlayerGui;
	self.Gui.ResetOnSpawn = false;
	self.Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;

	-- ===== 主框架 =====
	self.Frame = Instance.new("Frame");
	self.Frame.Name = "MainFrame";
	self.Frame.Size = UDim2.new(0, 500, 0, 350);
	self.Frame.Position = UDim2.new(0.5, -250, 0.5, -175);
	self.Frame.BackgroundColor3 = COLORS.Background;
	self.Frame.BorderSizePixel = 0;
	self.Frame.Parent = self.Gui;

	-- 经典 1px 黑色外边框
	self.FrameBorder = Instance.new("UIStroke");
	self.FrameBorder.Color = COLORS.Black;
	self.FrameBorder.Thickness = 1;
	self.FrameBorder.Parent = self.Frame;

	-- 经典 1px 内凹边框效果（顶部和左侧亮，底部和右侧暗）
	local bevelTop = Instance.new("Frame");
	bevelTop.Size = UDim2.new(1, 0, 0, 1);
	bevelTop.Position = UDim2.new(0, 0, 0, 0);
	bevelTop.BackgroundColor3 = COLORS.BorderLight;
	bevelTop.BorderSizePixel = 0;
	bevelTop.ZIndex = 5;
	bevelTop.Parent = self.Frame;

	local bevelLeft = Instance.new("Frame");
	bevelLeft.Size = UDim2.new(0, 1, 1, 0);
	bevelLeft.Position = UDim2.new(0, 0, 0, 0);
	bevelLeft.BackgroundColor3 = COLORS.BorderLight;
	bevelLeft.BorderSizePixel = 0;
	bevelLeft.ZIndex = 5;
	bevelLeft.Parent = self.Frame;

	local bevelBottom = Instance.new("Frame");
	bevelBottom.Size = UDim2.new(1, 0, 0, 1);
	bevelBottom.Position = UDim2.new(0, 0, 1, -1);
	bevelBottom.BackgroundColor3 = COLORS.Shadow;
	bevelBottom.BorderSizePixel = 0;
	bevelBottom.ZIndex = 5;
	bevelBottom.Parent = self.Frame;

	local bevelRight = Instance.new("Frame");
	bevelRight.Size = UDim2.new(0, 1, 1, 0);
	bevelRight.Position = UDim2.new(1, -1, 0, 0);
	bevelRight.BackgroundColor3 = COLORS.Shadow;
	bevelRight.BorderSizePixel = 0;
	bevelRight.ZIndex = 5;
	bevelRight.Parent = self.Frame;

	-- ===== 标题栏（经典 Roblox 深色渐变） =====
	self.TitleBar = Instance.new("Frame");
	self.TitleBar.Name = "TitleBar";
	self.TitleBar.Size = UDim2.new(1, 0, 0, 28);
	self.TitleBar.BackgroundColor3 = COLORS.TopBar;
	self.TitleBar.BorderSizePixel = 0;
	self.TitleBar.ZIndex = 10;
	self.TitleBar.Parent = self.Frame;

	-- 标题栏底部线
	local titleLine = Instance.new("Frame");
	titleLine.Size = UDim2.new(1, 0, 0, 1);
	titleLine.Position = UDim2.new(0, 0, 1, -1);
	titleLine.BackgroundColor3 = COLORS.Border;
	titleLine.BorderSizePixel = 0;
	titleLine.ZIndex = 10;
	titleLine.Parent = self.TitleBar;

	-- 标题栏渐变覆盖（模拟早期 Roblox 渐变）
	local titleGradient = Instance.new("Frame");
	titleGradient.Size = UDim2.new(1, 0, 0, 14);
	titleGradient.Position = UDim2.new(0, 0, 0, 0);
	titleGradient.BackgroundColor3 = COLORS.TopBarGradient;
	titleGradient.BackgroundTransparency = 0.5;
	titleGradient.BorderSizePixel = 0;
	titleGradient.ZIndex = 11;
	titleGradient.Parent = self.TitleBar;

	-- 标题文字（经典粗体）
	local titleLabel = Instance.new("TextLabel");
	titleLabel.Size = UDim2.new(0, 200, 1, 0);
	titleLabel.Position = UDim2.new(0, 8, 0, 0);
	titleLabel.BackgroundTransparency = 1;
	titleLabel.Text = self.Name;
	titleLabel.Font = Enum.Font.SourceSansBold;
	titleLabel.TextSize = 14;
	titleLabel.TextColor3 = COLORS.White;
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left;
	titleLabel.ZIndex = 12;
	titleLabel.Parent = self.TitleBar;

	-- 版本号
	local verLabel = Instance.new("TextLabel");
	verLabel.Size = UDim2.new(0, 60, 1, 0);
	verLabel.Position = UDim2.new(0, 8 + titleLabel.TextBounds.X + 4, 0, 0);
	verLabel.BackgroundTransparency = 1;
	verLabel.Text = self.Subtitle;
	verLabel.Font = Enum.Font.SourceSans;
	verLabel.TextSize = 11;
	verLabel.TextColor3 = COLORS.TextDim;
	verLabel.TextXAlignment = Enum.TextXAlignment.Left;
	verLabel.ZIndex = 12;
	verLabel.Parent = self.TitleBar;

	-- 关闭按钮（经典 X）
	local closeBtn = Instance.new("TextButton");
	closeBtn.Size = UDim2.new(0, 28, 0, 20);
	closeBtn.Position = UDim2.new(1, -32, 0, 4);
	closeBtn.BackgroundColor3 = COLORS.Red;
	closeBtn.BorderSizePixel = 0;
	closeBtn.Text = "X";
	closeBtn.Font = Enum.Font.SourceSansBold;
	closeBtn.TextSize = 11;
	closeBtn.TextColor3 = COLORS.White;
	closeBtn.ZIndex = 12;
	closeBtn.Parent = self.TitleBar;

	-- 关闭按钮内凹效果
	local closeBevel = Instance.new("Frame");
	closeBevel.Size = UDim2.new(1, 0, 0, 1);
	closeBevel.Position = UDim2.new(0, 0, 0, 0);
	closeBevel.BackgroundColor3 = Color3.fromRGB(220, 80, 80);
	closeBevel.BorderSizePixel = 0;
	closeBevel.ZIndex = 13;
	closeBevel.Parent = closeBtn;

	closeBtn.MouseButton1Click:Connect(function()
		self:Destroy();
	end);

	-- ===== 侧边栏 =====
	self.Sidebar = Instance.new("Frame");
	self.Sidebar.Name = "Sidebar";
	self.Sidebar.Size = UDim2.new(0, 110, 1, -28);
	self.Sidebar.Position = UDim2.new(0, 0, 0, 28);
	self.Sidebar.BackgroundColor3 = COLORS.Sidebar;
	self.Sidebar.BorderSizePixel = 0;
	self.Sidebar.ZIndex = 5;
	self.Sidebar.Parent = self.Frame;

	-- 侧边栏右边线
	local sideLine = Instance.new("Frame");
	sideLine.Size = UDim2.new(0, 1, 1, 0);
	sideLine.Position = UDim2.new(1, -1, 0, 0);
	sideLine.BackgroundColor3 = COLORS.Border;
	sideLine.BorderSizePixel = 0;
	sideLine.ZIndex = 6;
	sideLine.Parent = self.Sidebar;

	-- ===== 内容区域 =====
	self.Content = Instance.new("Frame");
	self.Content.Name = "Content";
	self.Content.Size = UDim2.new(1, -110, 1, -28);
	self.Content.Position = UDim2.new(0, 110, 0, 28);
	self.Content.BackgroundColor3 = COLORS.Content;
	self.Content.BorderSizePixel = 0;
	self.Content.ClipsDescendants = true;
	self.Content.ZIndex = 5;
	self.Content.Parent = self.Frame;

	-- 内容区域内边框
	local contentBorder = Instance.new("UIStroke");
	contentBorder.Color = COLORS.Border;
	contentBorder.Thickness = 1;
	contentBorder.Transparency = 0.5;
	contentBorder.Parent = self.Content;

	-- 欢迎文字
	local welcome = Instance.new("TextLabel");
	welcome.Size = UDim2.new(1, -16, 0, 20);
	welcome.Position = UDim2.new(0, 8, 0, 8);
	welcome.BackgroundTransparency = 1;
	welcome.Text = "-- Welcome to " .. self.Name .. " --";
	welcome.Font = Enum.Font.SourceSansBold;
	welcome.TextSize = 13;
	welcome.TextColor3 = COLORS.Text;
	welcome.TextXAlignment = Enum.TextXAlignment.Left;
	welcome.ZIndex = 6;
	welcome.Parent = self.Content;

	local sub = Instance.new("TextLabel");
	sub.Size = UDim2.new(1, -16, 0, 14);
	sub.Position = UDim2.new(0, 8, 0, 28);
	sub.BackgroundTransparency = 1;
	sub.Text = "Select a tab from the sidebar."
	sub.Font = Enum.Font.SourceSans;
	sub.TextSize = 11;
	sub.TextColor3 = COLORS.TextDim;
	sub.TextXAlignment = Enum.TextXAlignment.Left;
	sub.ZIndex = 6;
	sub.Parent = self.Content;

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
	local yPos = 4 + (#self.Tabs * 26);

	-- 标签按钮
	local btn = Instance.new("TextButton");
	btn.Name = "Tab_" .. name;
	btn.Size = UDim2.new(1, -4, 0, 24);
	btn.Position = UDim2.new(0, 2, 0, yPos);
	btn.BackgroundColor3 = COLORS.Sidebar;
	btn.BorderSizePixel = 0;
	btn.Text = "  " .. name;
	btn.Font = Enum.Font.SourceSansBold;
	btn.TextSize = 12;
	btn.TextColor3 = COLORS.TextDim;
	btn.TextXAlignment = Enum.TextXAlignment.Left;
	btn.ZIndex = 7;
	btn.Parent = self.Sidebar;

	-- 左侧激活指示条
	local indicator = Instance.new("Frame");
	indicator.Name = "Indicator";
	indicator.Size = UDim2.new(0, 2, 1, 0);
	indicator.Position = UDim2.new(0, 0, 0, 0);
	indicator.BackgroundColor3 = COLORS.Accent;
	indicator.BorderSizePixel = 0;
	indicator.Visible = false;
	indicator.ZIndex = 8;
	indicator.Parent = btn;

	-- 标签内容
	local content = Instance.new("Frame");
	content.Name = "TabContent_" .. name;
	content.Size = UDim2.new(1, 0, 1, 0);
	content.BackgroundTransparency = 1;
	content.Visible = false;
	content.ZIndex = 6;
	content.Parent = self.Content;

	-- 内部滚动框架
	local scrollFrame = Instance.new("ScrollingFrame");
	scrollFrame.Size = UDim2.new(1, -8, 1, -8);
	scrollFrame.Position = UDim2.new(0, 4, 0, 4);
	scrollFrame.BackgroundTransparency = 1;
	scrollFrame.BorderSizePixel = 0;
	scrollFrame.ScrollBarThickness = 6;
	scrollFrame.ScrollBarImageColor3 = COLORS.Scrollbar;
	scrollFrame.ZIndex = 7;
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0);
	scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y;
	scrollFrame.Parent = content;

	local listLayout = Instance.new("UIListLayout");
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder;
	listLayout.Padding = UDim.new(0, 4);
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

	-- Hover 效果
	btn.MouseEnter:Connect(function()
		if self.ActiveTab ~= tab then
			btn.BackgroundColor3 = COLORS.SidebarHover;
		end;
	end);

	btn.MouseLeave:Connect(function()
		if self.ActiveTab ~= tab then
			btn.BackgroundColor3 = COLORS.Sidebar;
		end;
	end);

	btn.MouseButton1Click:Connect(function()
		self:SelectTab(tab);
	end);

	table.insert(self.Tabs, tab);
	table.insert(self.TabButtons, btn);

	if #self.Tabs == 1 then
		self:SelectTab(tab);
	end;

	return tab;
end;

function RetroUI:SelectTab(tab)
	for _, t in ipairs(self.Tabs) do
		t.Content.Visible = false;
		t.Button.BackgroundColor3 = COLORS.Sidebar;
		t.Button.TextColor3 = COLORS.TextDim;
		t.Indicator.Visible = false;
	end;

	tab.Content.Visible = true;
	tab.Button.BackgroundColor3 = COLORS.SidebarActive;
	tab.Button.TextColor3 = COLORS.White;
	tab.Indicator.Visible = true;
	self.ActiveTab = tab;
end;

-- ========== UI 控件工厂 ==========

-- 标签
function RetroUI:AddLabel(tab, text)
	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(1, 0, 0, 18);
	label.BackgroundColor3 = COLORS.BackgroundLight;
	label.BorderSizePixel = 0;
	label.Text = "  " .. text;
	label.Font = Enum.Font.SourceSansBold;
	label.TextSize = 12;
	label.TextColor3 = COLORS.Text;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 8;
	label.Parent = tab.ScrollFrame;
	label.LayoutOrder = #tab.Elements;

	-- 内凹效果
	local bevel = Instance.new("Frame");
	bevel.Size = UDim2.new(1, 0, 0, 1);
	bevel.Position = UDim2.new(0, 0, 0, 0);
	bevel.BackgroundColor3 = COLORS.BorderLight;
	bevel.BackgroundTransparency = 0.5;
	bevel.BorderSizePixel = 0;
	bevel.ZIndex = 9;
	bevel.Parent = label;

	table.insert(tab.Elements, label);
	return label;
end;

-- 按钮
function RetroUI:AddButton(tab, text, callback)
	local btn = Instance.new("TextButton");
	btn.Size = UDim2.new(1, 0, 0, 26);
	btn.BackgroundColor3 = COLORS.Accent;
	btn.BorderSizePixel = 0;
	btn.Text = text;
	btn.Font = Enum.Font.SourceSansBold;
	btn.TextSize = 12;
	btn.TextColor3 = COLORS.White;
	btn.ZIndex = 8;
	btn.Parent = tab.ScrollFrame;
	btn.LayoutOrder = #tab.Elements;

	-- 经典按钮高光
	local highlight = Instance.new("Frame");
	highlight.Size = UDim2.new(1, -2, 0, 1);
	highlight.Position = UDim2.new(0, 1, 0, 1);
	highlight.BackgroundColor3 = COLORS.AccentLight;
	highlight.BackgroundTransparency = 0.5;
	highlight.BorderSizePixel = 0;
	highlight.ZIndex = 9;
	highlight.Parent = btn;

	-- 按钮边框
	local border = Instance.new("UIStroke");
	border.Color = COLORS.Black;
	border.Thickness = 1;
	border.Parent = btn;

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = COLORS.AccentLight;
	end);
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = COLORS.Accent;
	end);

	if callback then
		btn.MouseButton1Click:Connect(callback);
	end;

	table.insert(tab.Elements, btn);
	return btn;
end;

-- 开关
function RetroUI:AddToggle(tab, text, default, callback)
	default = default or false;
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 26);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(1, -40, 1, 0);
	label.Position = UDim2.new(0, 4, 0, 0);
	label.BackgroundTransparency = 1;
	label.Text = text;
	label.Font = Enum.Font.SourceSans;
	label.TextSize = 12;
	label.TextColor3 = COLORS.Text;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 9;
	label.Parent = container;

	local toggle = Instance.new("TextButton");
	toggle.Size = UDim2.new(0, 32, 0, 18);
	toggle.Position = UDim2.new(1, -36, 0.5, -9);
	toggle.BackgroundColor3 = default and COLORS.Green or COLORS.BackgroundLight;
	toggle.BorderSizePixel = 0;
	toggle.Text = default and "ON" or "OFF";
	toggle.Font = Enum.Font.SourceSansBold;
	toggle.TextSize = 9;
	toggle.TextColor3 = COLORS.White;
	toggle.ZIndex = 10;
	toggle.Parent = container;

	-- 开关边框
	local toggleBorder = Instance.new("UIStroke");
	toggleBorder.Color = COLORS.Black;
	toggleBorder.Thickness = 1;
	toggleBorder.Parent = toggle;

	local state = default;
	toggle.MouseButton1Click:Connect(function()
		state = not state;
		toggle.BackgroundColor3 = state and COLORS.Green or COLORS.BackgroundLight;
		toggle.Text = state and "ON" or "OFF";
		if callback then callback(state); end;
	end);

	table.insert(tab.Elements, container);
	return toggle;
end;

-- 文本输入框
function RetroUI:AddTextBox(tab, placeholder, callback)
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 26);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(0, 80, 1, 0);
	label.Position = UDim2.new(0, 0, 0, 0);
	label.BackgroundTransparency = 1;
	label.Text = placeholder .. ":";
	label.Font = Enum.Font.SourceSans;
	label.TextSize = 12;
	label.TextColor3 = COLORS.Text;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 9;
	label.Parent = container;

	local input = Instance.new("TextBox");
	input.Size = UDim2.new(1, -88, 0, 20);
	input.Position = UDim2.new(0, 84, 0, 3);
	input.BackgroundColor3 = COLORS.InputBg;
	input.BorderSizePixel = 0;
	input.Text = "";
	input.PlaceholderText = placeholder;
	input.PlaceholderColor3 = COLORS.TextDark;
	input.Font = Enum.Font.SourceSans;
	input.TextSize = 12;
	input.TextColor3 = COLORS.Text;
	input.ZIndex = 10;
	input.Parent = container;

	-- 输入框内凹边框
	local inputBorder = Instance.new("UIStroke");
	inputBorder.Color = COLORS.Border;
	inputBorder.Thickness = 1;
	inputBorder.Parent = input;

	-- 内部高光
	local inputHighlight = Instance.new("Frame");
	inputHighlight.Size = UDim2.new(1, -2, 0, 1);
	inputHighlight.Position = UDim2.new(0, 1, 0, 1);
	inputHighlight.BackgroundColor3 = COLORS.BorderLight;
	inputHighlight.BackgroundTransparency = 0.7;
	inputHighlight.BorderSizePixel = 0;
	inputHighlight.ZIndex = 11;
	inputHighlight.Parent = input;

	if callback then
		input.FocusLost:Connect(function()
			callback(input.Text);
		end);
	end;

	table.insert(tab.Elements, container);
	return input;
end;

-- 分隔线
function RetroUI:AddSeparator(tab)
	local sep = Instance.new("Frame");
	sep.Size = UDim2.new(1, 0, 0, 1);
	sep.BackgroundColor3 = COLORS.Border;
	sep.BorderSizePixel = 0;
	sep.ZIndex = 8;
	sep.Parent = tab.ScrollFrame;
	sep.LayoutOrder = #tab.Elements;

	table.insert(tab.Elements, sep);
	return sep;
end;

-- 滑块
function RetroUI:AddSlider(tab, text, min, max, default, callback)
	default = default or min;
	local container = Instance.new("Frame");
	container.Size = UDim2.new(1, 0, 0, 36);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	local label = Instance.new("TextLabel");
	label.Size = UDim2.new(1, 0, 0, 16);
	label.BackgroundTransparency = 1;
	label.Text = text .. ": " .. tostring(default);
	label.Font = Enum.Font.SourceSans;
	label.TextSize = 12;
	label.TextColor3 = COLORS.Text;
	label.TextXAlignment = Enum.TextXAlignment.Left;
	label.ZIndex = 9;
	label.Parent = container;

	-- 滑轨背景
	local track = Instance.new("Frame");
	track.Size = UDim2.new(1, -4, 0, 8);
	track.Position = UDim2.new(0, 2, 0, 22);
	track.BackgroundColor3 = COLORS.InputBg;
	track.BorderSizePixel = 0;
	track.ZIndex = 9;
	track.Parent = container;

	local trackBorder = Instance.new("UIStroke");
	trackBorder.Color = COLORS.Border;
	trackBorder.Thickness = 1;
	trackBorder.Parent = track;

	-- 滑块填充
	local fill = Instance.new("Frame");
	fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0);
	fill.BackgroundColor3 = COLORS.Accent;
	fill.BorderSizePixel = 0;
	fill.ZIndex = 10;
	fill.Parent = track;

	-- 滑块按钮
	local sliderBtn = Instance.new("TextButton");
	sliderBtn.Size = UDim2.new(0, 12, 0, 16);
	sliderBtn.Position = UDim2.new((default - min) / (max - min), -6, 0.5, -8);
	sliderBtn.BackgroundColor3 = COLORS.White;
	sliderBtn.BorderSizePixel = 0;
	sliderBtn.Text = "";
	sliderBtn.ZIndex = 11;
	sliderBtn.Parent = track;

	local sliderBorder = Instance.new("UIStroke");
	sliderBorder.Color = COLORS.Border;
	sliderBorder.Thickness = 1;
	sliderBorder.Parent = sliderBtn;

	local sliding = false;

	sliderBtn.InputBegan:Connect(function(input)
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

			fill.Size = UDim2.new(relX, 0, 1, 0);
			sliderBtn.Position = UDim2.new(relX, -6, 0.5, -8);
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
	container.Size = UDim2.new(1, 0, 0, 26);
	container.BackgroundTransparency = 1;
	container.ZIndex = 8;
	container.Parent = tab.ScrollFrame;
	container.LayoutOrder = #tab.Elements;

	local btn = Instance.new("TextButton");
	btn.Size = UDim2.new(1, 0, 0, 22);
	btn.Position = UDim2.new(0, 0, 0, 2);
	btn.BackgroundColor3 = COLORS.InputBg;
	btn.BorderSizePixel = 0;
	btn.Text = "  " .. text .. ": " .. (options[1] or "None");
	btn.Font = Enum.Font.SourceSans;
	btn.TextSize = 12;
	btn.TextColor3 = COLORS.Text;
	btn.TextXAlignment = Enum.TextXAlignment.Left;
	btn.ZIndex = 10;
	btn.Parent = container;

	local btnBorder = Instance.new("UIStroke");
	btnBorder.Color = COLORS.Border;
	btnBorder.Thickness = 1;
	btnBorder.Parent = btn;

	local isOpen = false;
	local dropFrame = Instance.new("Frame");
	dropFrame.Size = UDim2.new(1, 0, 0, #options * 22);
	dropFrame.Position = UDim2.new(0, 0, 0, 24);
	dropFrame.BackgroundColor3 = COLORS.Background;
	dropFrame.BorderSizePixel = 0;
	dropFrame.Visible = false;
	dropFrame.ZIndex = 20;
	dropFrame.ClipsDescendants = true;
	dropFrame.Parent = container;

	local dropBorder = Instance.new("UIStroke");
	dropBorder.Color = COLORS.Border;
	dropBorder.Thickness = 1;
	dropBorder.Parent = dropFrame;

	for i, opt in ipairs(options) do
		local optBtn = Instance.new("TextButton");
		optBtn.Size = UDim2.new(1, 0, 0, 22);
		optBtn.Position = UDim2.new(0, 0, 0, (i-1) * 22);
		optBtn.BackgroundColor3 = COLORS.Sidebar;
		optBtn.BorderSizePixel = 0;
		optBtn.Text = "  " .. opt;
		optBtn.Font = Enum.Font.SourceSans;
		optBtn.TextSize = 12;
		optBtn.TextColor3 = COLORS.Text;
		optBtn.TextXAlignment = Enum.TextXAlignment.Left;
		optBtn.ZIndex = 21;
		optBtn.Parent = dropFrame;

		optBtn.MouseEnter:Connect(function()
			optBtn.BackgroundColor3 = COLORS.SidebarHover;
		end);
		optBtn.MouseLeave:Connect(function()
			optBtn.BackgroundColor3 = COLORS.Sidebar;
		end);

		optBtn.MouseButton1Click:Connect(function()
			btn.Text = "  " .. text .. ": " .. opt;
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

-- ========== 销毁 ==========
function RetroUI:Destroy()
	for _, conn in ipairs(self.Connections) do
		conn:Disconnect();
	end;
	if self.Gui then self.Gui:Destroy(); end;
end;

return RetroUI;
