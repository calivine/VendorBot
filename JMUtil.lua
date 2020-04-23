JMUtil = {}

function JMUtil:MakeMovable(frame)
    frame:SetMovable(frame);
    frame:RegisterForDrag("LeftButton");
    frame:SetScript("OnDragStart", frame.StartMoving);
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing);
end

function JMUtil:MakeSettingsFrame(frame)
    frame:SetFrameStrata("HIGH");
    frame:SetPoint("CENTER");
    frame:SetHeight(275);
    frame:SetWidth(275);
end

function JMUtil:MakeSettingsButton(frame)
    frame:SetHeight(25);
    frame:SetWidth(25);
    frame:SetText("JM");
    frame:ClearAllPoints();
    frame:SetPoint("LEFT", 0, 0);
end