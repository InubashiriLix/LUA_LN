Student = require("src.student")
Member = require("src.deathlist")

local lix = Student:new("lix", 18)
-- lix:printHello()
lix:greeting("sht")
print(lix:getName())

local aya = Student:new("aya", 21)
aya:greeting(lix:getName())

local DiWu = Member:new(
	"DiWu",
	18,
	"2024-12-25",
	"killed by me with a knife at Kristimas, with his arms and legs seperated painfully, and his organs are cutted when he is still alive",
	100
)

local YawenWu = Member:new("YawenWu", 18, "2019-12-12", "Stub to death by me at 1.am, when he was in his dream.", 100)

local KaiZhang = Member:new(
	"KaiZhang",
	18,
	"2024-12-25",
	"Killed by me when we are eating out, I cut down his neck and let him die in the pain of blood",
	100
)

local ZitaoQing = Member:new(
	"ZitaoQing",
	18,
	"2024-12-25",
	"Killed by me when he is looking at his phone, gigering, I stub at his stomach first, then cut down his dick and arms, then I slice his face, with his tonch cutted, he died in pain.",
	100
)

local members = { DiWu, YawenWu, KaiZhang, ZitaoQing }
for index, obj in pairs(members) do
	obj:goHell()
end
