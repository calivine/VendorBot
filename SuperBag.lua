
local TEXT_DISPLAY_X_OFFSET = -245;
local TEXT_DISPLAY_Y_OFFSET = -7;
local TEXT_DISPAY_HEIGHT = 50;
local TEXT_DISPLAY_WIDTH = 50;
local TEXT_DISPLAY_SIZE = 14;
local TEXT_DISPLAY_FONT_FLAG = "THICKOUTLINE";
local TEXT_DISPLAY_FONT = "NumberFont_OutlineThick_Mono_Small";
local TEXT_DISPLAY_FONT_SOURCE = "Fonts\\FRIZQT__.TTF";
local AUTO_SELL_X_OFFSET = 91;
local AUTO_SELL_Y_OFFSET = -417;

local JM = CreateFrame("Frame", "JM", UIParent);
JM:SetFrameStrata("HIGH");
JM:SetPoint("BOTTOMRIGHT");
JM:SetHeight(TEXT_DISPAY_HEIGHT);
JM:SetWidth(TEXT_DISPLAY_WIDTH);

local JM_Texture = JM:CreateTexture("JM_Texture", "OVERLAY");
JM_Texture:SetPoint("BOTTOMRIGHT", JM, "BOTTOMRIGHT", TEXT_DISPLAY_X_OFFSET, TEXT_DISPLAY_Y_OFFSET);
JM_Texture:SetColorTexture(0.22, 0.22, 0.22, 0);
JM_Texture:SetAlpha(1);
JM_Texture:SetHeight(TEXT_DISPAY_HEIGHT);
JM_Texture:SetWidth(TEXT_DISPLAY_WIDTH);

local AS = CreateFrame("Button", "AS", UIParent, "UIPanelButtonTemplate");
AS:SetHeight(20);
AS:SetWidth(75);
AS:SetFrameStrata("HIGH");
AS:SetFrameLevel(2);
AS:SetToplevel(true);
AS:SetText("$$$");
AS:ClearAllPoints();
AS:SetPoint("TOPLEFT", MerchantFrame, AUTO_SELL_X_OFFSET, AUTO_SELL_Y_OFFSET);
AS:RegisterForClicks("LeftButtonDown");

function AutoSellButton_OnEnter(self, motion)
    GameTooltip:SetOwner(self, "ANCHOR_TOPRIGHT");
    GameTooltip:SetText("Sell All Junk");
    GameTooltip:Show();
end

function AutoSellButton_OnLeave(self, motion)
    GameTooltip:Hide();
end

AS:SetScript("OnEnter", AutoSellButton_OnEnter);
AS:SetScript("OnLeave", AutoSellButton_OnLeave);

AS:Hide();

local origTab2Click = MerchantFrameTab2:GetScript("OnClick");
local function newTab2Click(...)
    AS:Hide();
    if ( origTab2Click ) then
        return origTab2Click(...);
    end
end

local origTab1Click = MerchantFrameTab1:GetScript("OnClick");
local function newTab1Click(...)
    AS:SetPoint("TOPLEFT", MerchantFrame, AUTO_SELL_X_OFFSET, AUTO_SELL_Y_OFFSET);
    AS:SetFrameStrata("HIGH");
    AS:Show();
    if ( origTab1Click ) then
        return origTab1Click(...);
    end
end

local repairItemButton = MerchantRepairItemButton:GetScript("OnClick");
local function newMerchantRepairItem(...)
    AS:SetPoint("TOPLEFT", MerchantFrame, AUTO_SELL_X_OFFSET, AUTO_SELL_Y_OFFSET);
    AS:SetFrameStrata("HIGH");
    AS:Show();
    if ( repairItemButton ) then
        return repairItemButton(...);
    end
end

local repairAllItemsButton = MerchantRepairAllButton:GetScript("OnClick");
local function newMerchantRepairAll(...)
    AS:SetPoint("TOPLEFT", MerchantFrame, AUTO_SELL_X_OFFSET, AUTO_SELL_Y_OFFSET);
    AS:SetFrameStrata("HIGH");
    AS:Show();
    if ( repairAllItemsButton ) then
        return repairAllItemsButton(...);
    end
end

local nextPageButton = MerchantNextPageButton:GetScript("OnClick");
local function newNextPageButton(...)
    AS:SetPoint("TOPLEFT", MerchantFrame, AUTO_SELL_X_OFFSET, AUTO_SELL_Y_OFFSET);
    AS:SetFrameStrata("HIGH");
    AS:Show();
    if ( nextPageButton ) then
        return nextPageButton(...);
    end
end

local prevPageButton = MerchantPrevPageButton:GetScript("OnClick");
local function newPrevPageButton(...)
    AS:SetPoint("TOPLEFT", MerchantFrame, AUTO_SELL_X_OFFSET, AUTO_SELL_Y_OFFSET);
    AS:SetFrameStrata("HIGH");
    AS:Show();
    if ( prevPageButton ) then
        return prevPageButton(...);
    end
end

function JM:OnEvent(event, ...)
    if ( event == "BAG_UPDATE" ) then
        local remaining = self:SlotsRemaining();
        remainingSlotsText:SetFormattedText("%d", remaining);    
    elseif ( event == "MERCHANT_SHOW" ) then
        AS:SetPoint("TOPLEFT", MerchantFrame, AUTO_SELL_X_OFFSET, AUTO_SELL_Y_OFFSET);
        AS:Show();
    elseif ( event == "MERCHANT_CLOSED" ) then
        AS:Hide();
    elseif ( event == "PLAYER_LOGIN" ) then
        self:Initialize();
    end
end

JM:SetScript("OnEvent", JM.OnEvent);

AS:SetScript("OnClick", function(self, button, down) 
    JM:SellJunk();
end);

MerchantFrameTab1:SetScript("OnClick", newTab1Click);
MerchantFrameTab2:SetScript("OnClick", newTab2Click);

if ( IsLoggedIn() ) then
    JM:Initialize();
else
    JM:RegisterEvent("PLAYER_LOGIN");
end

function JM:Initialize()
    self:RegisterEvent("MERCHANT_SHOW");
    self:RegisterEvent("MERCHANT_CLOSED");
    self:RegisterEvent("BAG_UPDATE");
    self:CreateFrame();
    print('SuperBag! v1.0.0');
end

function JM:CreateFrame()
    local remaining = self:SlotsRemaining();
    remainingSlotsText = self:CreateFontString(nil, "OVERLAY", TEXT_DISPLAY_FONT);
    remainingSlotsText:SetFont(TEXT_DISPLAY_FONT_SOURCE, TEXT_DISPLAY_SIZE, TEXT_DISPLAY_FONT_FLAG);
    remainingSlotsText:SetTextColor(1,1,1,1);
    remainingSlotsText:SetFormattedText("%d", remaining);
    remainingSlotsText:SetPoint("CENTER", TEXT_DISPLAY_X_OFFSET, TEXT_DISPLAY_Y_OFFSET);
end

-- Cycle through all bags and slots and sells poor quality items
-- Happens when players interacts with Merchant.
function JM:SellJunk()
    local foundJunk = false;
    for i=0,4 do
        local bagSlots = GetContainerNumSlots(i);
        for j=1,bagSlots do
            local icon, itemCount, locked, quality, readable, lootable, itemLink, isFiltered, noValue, itemID = GetContainerItemInfo(i, j);
            if ( itemLink ~= nil and quality == 0 ) then
                if ( not foundJunk ) then
                    foundJunk = true;
                    print("Selling Junk...");
                end
                UseContainerItem(i, j);
            end
        end
    end
end

function JM:SlotsRemaining()
    local slotsRemaining = 0;
    for bag=0,4 do
        local numFreeSlots = GetContainerNumFreeSlots(bag);
        if ( numFreeSlots ~= nil ) then
            slotsRemaining = slotsRemaining + numFreeSlots;
        end
    end
    return slotsRemaining;
end