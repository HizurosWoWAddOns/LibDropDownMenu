
-- Replacement of LibDropDownMenu.xml
local lib = LibStub("LibDropDownMenu");

local function buttonOnEnable(self)
	self.invisibleButton:Hide();
end

local function buttonOnDisable(self)
	self.invisibleButton:Show();
end

local function buttonColorSwatchOnClick(self)
	CloseMenus();
	lib.UIDropDownMenuButton_OpenColorPicker(self:GetParent());
end

local function buttonColorSwatchOnEnter(self)
	lib.CloseDropDownMenus(self:GetParent():GetParent():GetID() + 1);
	_G[self:GetName().."SwatchBg"]:SetVertexColor(NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b);
	lib.UIDropDownMenu_StopCounting(self:GetParent():GetParent());
end

local function buttonColorSwatchOnLeave(self)
	_G[self:GetName().."SwatchBg"]:SetVertexColor(HIGHLIGHT_FONT_COLOR.r, HIGHLIGHT_FONT_COLOR.g, HIGHLIGHT_FONT_COLOR.b);
	lib.UIDropDownMenu_StartCounting(self:GetParent():GetParent());
end

local function buttonExpandArrowOnClick(self, button, down)
	lib.ToggleDropDownMenu(self:GetParent():GetParent():GetID() + 1, self:GetParent().value, nil, nil, nil, nil, self:GetParent().menuList, self);
end

local function buttonExpandArrowOnEnter(self)
	lib.UIDropDownMenuButton_OnEnter(self:GetParent());
end

local function buttonExpandArrowOnLeave(self)
	lib.UIDropDownMenuButton_OnLeave(self:GetParent());
end

local function listOnClick(self)
	self:Hide();
end

local function listOnShow(self)
	for i=1, lib.UIDROPDOWNMENU_MAXBUTTONS do
		if (not self.noResize) then
			_G[self:GetName().."Button"..i]:SetWidth(self.maxWidth);
		end
	end
	if (not self.noResize) then
		self:SetWidth(self.maxWidth+25);
	end
	self.showTimer = nil;
	if ( self:GetID() > 1 ) then
		self.parent = _G["LibDropDownMenu_List"..(self:GetID() - 1)];
	end
	lib.UIDropDownMenu_OnShow(self);
end

local function menuOnHide(self)
	lib.CloseDropDownMenus();
end

local function menuButtonOnEnter(self)
	local parent = self:GetParent();
	local myscript = parent:GetScript("OnEnter");
	if(myscript ~= nil) then
		myscript(parent);
	end
end

local function menuButtonOnLeave(self)
	local parent = self:GetParent();
	local myscript = parent:GetScript("OnLeave");
	if(myscript ~= nil) then
		myscript(parent);
	end
end

local function menuButtonOnClick(self,button)
	local parent = self:GetParent();
	lib.ToggleDropDownMenu(nil, nil, parent);
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);
end

local UIDropDownCustomMenuEntryMixin = {};

function UIDropDownCustomMenuEntryMixin:GetPreferredEntryWidth()
	-- NOTE: Only width is currently supported, dropdown menus size vertically based on how many buttons are present.
	return self:GetWidth();
end

function UIDropDownCustomMenuEntryMixin:OnSetOwningButton()
	-- for derived objects to implement
end

function UIDropDownCustomMenuEntryMixin:SetOwningButton(button)
	self:SetParent(button:GetParent());
	self.owningButton = button;
	self:OnSetOwningButton();
end

function UIDropDownCustomMenuEntryMixin:GetOwningDropdown()
	return self.owningButton:GetParent();
end

function UIDropDownCustomMenuEntryMixin:SetContextData(contextData)
	self.contextData = contextData;
end

function UIDropDownCustomMenuEntryMixin:GetContextData()
	return self.contextData;
end

local function customMenuEntryOnEnter(self)
	lib.UIDropDownMenu_StopCounting(self:GetOwningDropdown());
end

local function customMenuEntryOnLeave(self)
	lib.UIDropDownMenu_StartCounting(self:GetOwningDropdown());
end

function lib.Create_DropDownCustomMenuEntry(name,parent,opts)
	local frame = CreateFrame("frame");
	frame:EnableMouse(true);
	frame:Hide();
	frame:SetScript("OnEnter",customMenuEntryOnEnter);
	frame:SetScript("OnLeave",customMenuEntryOnLeave);
	Mixin(frame,UIDropDownCustomMenuEntryMixin);
end

function lib.Create_DropDownMenuButton(name,parent,opts)
	local button = CreateFrame("Button",name,parent);
	button:SetSize(100,16);
	button:SetFrameLevel(parent:GetFrameLevel()+2); -- OnLoad
	button:SetScript("OnClick",lib.UIDropDownMenuButton_OnClick);
	button:SetScript("OnEnter",lib.UIDropDownMenuButton_OnEnter);
	button:SetScript("OnLeave",lib.UIDropDownMenuButton_OnLeave);
	button:SetScript("OnEnable",buttonOnEnable);
	button:SetScript("OnDisable",buttonOnDisable);

	if opts then
		if opts.id then
			button:SetID(opts.id);
		end
	end

	local text = button:CreateFontString(name.."NormalText","ARTWORK");
	text:SetPoint("LEFT",-5,0);
	button:SetFontString(text);
	button:SetNormalFontObject("GameFontHighlightSmallLeft")
	button:SetHighlightFontObject("GameFontHighlightSmallLeft");
	button:SetDisabledFontObject("GameFontDisableSmallLeft");
	button.NormalText = text;

	local highlight = button:CreateTexture(name.."Highlight","BACKGROUND");
	highlight:SetTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]]);
	highlight:SetBlendMode("ADD");
	highlight:SetAllPoints();
	highlight:Hide();
	button.Highlight = highlight;

	local check = button:CreateTexture(name.."Check","ARTWORK");
	check:SetTexture([[Interface\Common\UI-DropDownRadioChecks]]);
	check:SetSize(16,16);
	check:SetPoint("LEFT",0,0);
	check:SetTexCoord(0,0.5,0.5,1);
	--button.Check = check;

	local uncheck = button:CreateTexture(name.."UnCheck","ARTWORK");
	uncheck:SetTexture([[Interface\Common\UI-DropDownRadioChecks]]);
	uncheck:SetSize(16,16);
	uncheck:SetPoint("LEFT",0,0);
	uncheck:SetTexCoord(0.5,1,0.5,1);
	--button.UnCheck = uncheck;

	local icon = button:CreateTexture(name.."Icon","ARTWORK");
	icon:Hide();
	icon:SetSize(16,16);
	icon:SetPoint("RIGHT",0,0);
	button.Icon = icon;

	local color = CreateFrame("Button",name.."ColorSwatch",button);
	color:Hide();
	color:SetSize(16,16);
	color:SetPoint("RIGHT",-6,0);
	color:SetScript("OnClick",buttonColorSwatchOnClick);
	color:SetScript("OnEnter",buttonColorSwatchOnEnter);
	color:SetScript("OnLeave",buttonColorSwatchOnLeave);
	color:SetNormalTexture([[Interface\ChatFrame\ChatFrameColorSwatch]]);
	--button.ColorSwatch = color;

	local swatchBg = color:CreateTexture(name.."ColorSwatchSwatchBg","BACKGROUND");
	swatchBg:SetSize(14,14);
	swatchBg:SetPoint("CENTER",0,0);
	swatchBg:SetVertexColor(1,1,1);
	button.ColorSwatchSwatchBg = swatchBg;

	local expandArrow = CreateFrame("Button",name.."ExpandArrow",button);
	expandArrow:SetMotionScriptsWhileDisabled(true);
	expandArrow:SetSize(16,16);
	expandArrow:SetPoint("RIGHT",0,0);
	expandArrow:SetScript("OnClick",buttonExpandArrowOnClick);
	expandArrow:SetScript("OnEnter",buttonExpandArrowOnEnter);
	expandArrow:SetScript("OnLeave",buttonExpandArrowOnLeave);
	button.ExpandArrow = expandArrow;

	local arrow = expandArrow:CreateTexture(nil,"ARTWORK");
	arrow:SetTexture([[Interface\ChatFrame\ChatFrameExpandArrow]]);
	arrow:SetAllPoints();

	button.invisibleButton = CreateFrame("Frame",name.."InvisibleButton",button);
	button.invisibleButton:Hide();
	button.invisibleButton:SetPoint("TOPLEFT");
	button.invisibleButton:SetPoint("BOTTOMLEFT");
	button.invisibleButton:SetPoint("RIGHT",color,"LEFT",0,0);
	button.invisibleButton:SetScript("OnEnter",lib.UIDropDownMenuButtonInvisibleButton_OnEnter);
	button.invisibleButton:SetScript("OnLeave",lib.UIDropDownMenuButtonInvisibleButton_OnLeave);

	return button;
end

function lib.Create_DropDownMenuList(name,parent,opts)
	local list = CreateFrame("Button",name,parent);
	list:Hide();
	list:SetToplevel(true);
	list:SetFrameStrata("FULLSCREEN_DIALOG");
	list:EnableMouse(true);
	list:SetClampedToScreen(true);
	list:SetScript("OnClick",listOnClick);
	list:SetScript("OnEnter",lib.UIDropDownMenu_StopCounting);
	list:SetScript("OnLeave",lib.UIDropDownMenu_StartCounting);
	list:SetScript("OnUpdate",lib.UIDropDownMenu_OnUpdate);
	list:SetScript("OnShow",listOnShow);
	list:SetScript("OnHide",lib.UIDropDownMenu_OnHide);

	if opts then
		if opts.id then
			list:SetID(opts.id);
		end
	end

	local backdrop = CreateFrame("Frame",name.."Backdrop",list);
	backdrop:SetAllPoints();
	backdrop:SetBackdrop({
		bgFile=[[Interface\DialogFrame\UI-DialogBox-Background-Dark]],
		edgeFile=[[Interface\DialogFrame\UI-DialogBox-Border]],
		tile=true, tileSize=32, edgeSize=32,
		insets = {left=11, right=12, top=12, bottom=9}
	});

	local menuBackdrop = CreateFrame("Frame",name.."MenuBackdrop",list);
	menuBackdrop:SetAllPoints();
	menuBackdrop:SetBackdrop({
		bgFile=[[Interface\Tooltips\UI-Tooltip-Background]],
		edgeFile=[[Interface\Tooltips\UI-Tooltip-Border]],
		tile=true, edgeSize=16, tileSize=16,
		insets={left=5, right=5, top=5, bottom=4}
	});
	menuBackdrop:SetBackdropBorderColor(TOOLTIP_DEFAULT_COLOR.r, TOOLTIP_DEFAULT_COLOR.g, TOOLTIP_DEFAULT_COLOR.b);
	menuBackdrop:SetBackdropColor(TOOLTIP_DEFAULT_BACKGROUND_COLOR.r, TOOLTIP_DEFAULT_BACKGROUND_COLOR.g, TOOLTIP_DEFAULT_BACKGROUND_COLOR.b);

	for i=1, lib.UIDROPDOWNMENU_MAXBUTTONS do
		lib.Create_DropDownMenuButton(name.."Button"..i,list,{id=i});
	end

	if not lib.UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT then
		local fontName, fontHeight, fontFlags = _G["DropDownList1Button1NormalText"]:GetFont();
		lib.UIDROPDOWNMENU_DEFAULT_TEXT_HEIGHT = fontHeight;
	end

	return list;
end

function lib.Create_DropDownMenu(name,parent,opts)
	local menu = CreateFrame("Frame",name);
	menu:SetSize(40,32);
	menu:SetScript("OnHide",menuOnHide);

	if opts then
		if opts.id then
			menu:SetID(opts.id);
		end
	end

	menu.Left = menu:CreateTexture(name.."Left","ARTWORK");
	menu.Left:SetSize(25,64);
	menu.Left:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]);
	menu.Left:SetTexCoord(0,0.1953125,0,1);
	menu.Left:SetPoint("TOPLEFT",0,17);

	menu.Middle = menu:CreateTexture(name.."Middle","ARTWORK");
	menu.Middle:SetSize(115,64);
	menu.Middle:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]);
	menu.Middle:SetTexCoord(0.1953125,0.8046875,0,1);
	menu.Middle:SetPoint("LEFT",menu.Left,"RIGHT",0,0);

	menu.Right = menu:CreateTexture(name.."Right","ARTWORK");
	menu.Right:SetSize(25,64);
	menu.Right:SetTexture([[Interface\Glues\CharacterCreate\CharacterCreate-LabelFrame]]);
	menu.Right:SetTexCoord(0.8046875,1,0,1);
	menu.Right:SetPoint("LEFT",menu.Middle,"RIGHT",0,0);

	menu.Text = menu:CreateFontString(name.."Text","ARTWORK","GameFontHighlightSmall");
	menu.Text:SetNonSpaceWrap(false);
	menu.Text:SetJustifyH("RIGHT");
	menu.Text:SetSize(0,10);
	menu.Text:SetPoint("RIGHT",menu.Right,"RIGHT",-43,2);

	menu.Icon = menu:CreateTexture(name.."Icon","OVERLAY");
	menu.Icon:Hide();
	menu.Icon:SetSize(16,16);
	menu.Icon:SetPoint("LEFT",30,2);

	local buttonName = name.."Button";
	menu.Button = CreateFrame("Button",buttonName,menu);
	menu.Button:SetMotionScriptsWhileDisabled(true);
	menu.Button:SetSize(24,24);
	menu.Button:SetPoint("TOPRIGHT",menu.Right,"TOPRIGHT",-16,-18);
	menu.Button:SetScript("OnEnter",menuButtonOnEnter);
	menu.Button:SetScript("OnLeave",menuButtonOnLeave);
	menu.Button:SetScript("OnClick",menuButtonOnClick);

	menu.Button.NormalTexture = menu.Button:CreateTexture(buttonName.."NormalTexture","ARTWORK");
	menu.Button.NormalTexture:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Up]]);
	menu.Button.NormalTexture:SetAllPoints();
	menu.Button:SetNormalTexture(menu.Button.NormalTexture);

	menu.Button.PushedTexture = menu.Button:CreateTexture(buttonName.."PushedTexture","ARTWORK");
	menu.Button.PushedTexture:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Down]]);
	menu.Button.PushedTexture:SetAllPoints();
	menu.Button:SetPushedTexture(menu.Button.PushedTexture);

	menu.Button.DisabledTexture = menu.Button:CreateTexture(buttonName.."DisabledTexture","ARTWORK");
	menu.Button.DisabledTexture:SetTexture([[Interface\ChatFrame\UI-ChatIcon-ScrollDown-Disabled]]);
	menu.Button.DisabledTexture:SetAllPoints();
	menu.Button:SetDisabledTexture(menu.Button.DisabledTexture);

	menu.Button.HighlightTexture = menu.Button:CreateTexture(buttonName.."HighlightTexture","ARTWORK");
	menu.Button.HighlightTexture:SetTexture([[Interface\ChatFrame\UI-Common-MouseHilight]],"ADD");
	menu.Button.HighlightTexture:SetAllPoints();
	menu.Button:SetHighlightTexture(menu.Button.HighlightTexture,"ADD");

	return menu;
end

if not _G.LibDropDownMenu_List1 then
	lib.Create_DropDownMenuList("LibDropDownMenu_List1",nil,{id=1});
	lib.Create_DropDownMenuList("LibDropDownMenu_List2",nil,{id=2});
end

