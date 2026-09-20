local ADDON_NAME = ...

-- Which game this is.
--
-- World of Warcraft: Forever answers WOW_PROJECT_ID as if it were Retail, and
-- every flavour test in this addon is written against that constant, so on this
-- client every one of them is wrong: the Vanilla paths -- warlock grimoires,
-- the old auction house, no guild bank -- would all be skipped, and the
-- collections paths they would be skipped in favour of need journals this
-- client does not have.
--
-- The one answer Forever gives that Retail does not is its version: 1.60.x,
-- where Classic Era is 1.15.x. So the major and minor are what decide it, the
-- same rule the QuestWordHunter addons use.
--
-- Loaded before AlreadyKnownClassic.lua, which reads the flag as it loads.

local version = GetBuildInfo()
local major, minor = tostring(version or ""):match("^(%d+)%.(%d+)")
major, minor = tonumber(major), tonumber(minor)

AlreadyKnownForever = {
	isForever = (major == 1 and minor ~= nil and minor >= 60) or false,
	version = version,
}

SLASH_AKFOREVER1 = "/akforever"
SLASH_AKFOREVER2 = "/akf"
SlashCmdList = SlashCmdList or {}
SlashCmdList["AKFOREVER"] = function()
	local function say(text)
		print("|cffffcc00" .. ADDON_NAME .. ":|r " .. text)
	end
	local v, build, _, iface = GetBuildInfo()
	say(string.format("client %s (%s), interface %s, WOW_PROJECT_ID=%s",
		tostring(v), tostring(build), tostring(iface), tostring(WOW_PROJECT_ID)))
	say(string.format("recognised as Forever: %s -- so the Classic reading of this game is on",
		tostring(AlreadyKnownForever.isForever)))
	say(string.format("collections on this client: PetJournal=%s MountJournal=%s Transmog=%s TooltipInfo=%s",
		tostring(_G.C_PetJournal ~= nil), tostring(_G.C_MountJournal ~= nil),
		tostring(_G.C_TransmogCollection ~= nil), tostring(_G.C_TooltipInfo ~= nil)))
	say(string.format("merchant hook in place: %s -- open a vendor and known items turn colour",
		tostring(type(_G.MerchantFrame_UpdateMerchantInfo) == "function")))
	say("colours and the rest: /ak")
end
