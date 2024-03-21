local stackable = {}

local function GetLower(item)
  item.itemNameLower = item.itemNameLower or (string.match(item.itemLink, "h%[(.*)%]|h")):lower()
  return item.itemNameLower
end

function Syndicator.Search.GetGroupingKey(item, callback)
  local function Result()
    local lower = GetLower(item)
    if item.itemID == Syndicator.Constants.BattlePetCageID then
      callback(lower .. "_" .. strjoin("-", BattlePetToolTip_UnpackBattlePetLink(item.itemLink)) .. "_" .. tostring(item.isBound))
    elseif stackable[item.itemID] then
      callback(lower .. "_" .. tostring(item.itemID) .. "_" .. tostring(item.isBound))
    else
      local linkParts = {strsplit(":", item.itemLink)}
      -- Remove uniqueID, linkLevel, specializationID, modifiersMask, itemContext
      for i = 9, 13 do
        linkParts[i] = ""
      end
      local itemLink = table.concat(linkParts, ":")
      callback(lower .. "_" .. tostring(itemLink) .. "_" .. tostring(item.isBound))
    end
  end
  if stackable[item.itemID] ~= nil then
    Result()
  else
    Item:CreateFromItemID(item.itemID):ContinueOnItemLoad(function()
      stackable[item.itemID] = C_Item.GetItemMaxStackSizeByID(item.itemID) > 1
      Result()
    end)
  end
end
