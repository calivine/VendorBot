
local TEXT_DISPLAY_X_OFFSET = -245;
local TEXT_DISPLAY_Y_OFFSET = -7;
local TEXT_DISPAY_HEIGHT = 50;
local TEXT_DISPLAY_WIDTH = 50;
local TEXT_DISPLAY_SIZE = 14;
local TEXT_DISPLAY_FONT_FLAG = "THICKOUTLINE";
local TEXT_DISPLAY_FONT = "NumberFont_OutlineThick_Mono_Small";
local TEXT_DISPLAY_FONT_SOURCE = "Fonts\\FRIZQT__.TTF";

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
AS:SetHeight(35);
AS:SetWidth(75);
AS:SetFrameStrata("HIGH");
AS:SetText("Sell Junk");
AS:ClearAllPoints();
AS:SetPoint("LEFT", 75, -75);
AS:RegisterForClicks("LeftButtonDown");
AS:Hide();


function JM:OnEvent(event, ...)
    if ( event == "BAG_UPDATE" ) then
        local remaining = self:SlotsRemaining();
        remainingSlotsText:SetFormattedText("%d", remaining);    
    elseif ( event == "MERCHANT_SHOW" ) then
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
    print('JunkMaster v1.0.3');
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