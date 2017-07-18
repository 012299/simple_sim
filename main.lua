--
-- Created by IntelliJ IDEA.
-- User: brontosaurus
-- Date: 16/07/2017
-- Time: 12:36
-- To change this template use File | Settings | File Templates.
--
local spec = select(2, GetSpecializationInfo(GetSpecialization(), nil, nil, nil, UnitSex("player")));
if spec ~= "Brewmaster" then
    return false;
end
