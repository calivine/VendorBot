JMUtil = {}

function JMUtil:MakeMovable(frame)
    frame:SetMovable(frame);
    frame:RegisterForDrag("LeftButton");
    frame:SetScript("OnDragStart", frame.StartMoving);
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing);
end

function JMUtil:MakeSettingsFrame(frame)
    
end

function JMUtil:MakeSettingsButton(frame)
    frame:SetHeight(25);
    frame:SetWidth(25);
    frame:SetText("JM");
    frame:ClearAllPoints();
    frame:SetPoint("LEFT", 0, 0);
end