global dropdownX := 852
global dropdownY := 195
global dropdownListX0 := 911
global dropdownListY0 := 182
global dropdownListDeltaY := 30
global tabList := {"currency": 1 ; the order of your tabs
                , "dump": 2
                , "map": 3
                , "sample" :5
                , "div cards": 7
                , "fragment": 8
                , "oil": 10
                , "prophecy": 9
                , "essence": 11
                , "fossil": 13
                , "veiled": 20
                , "gem" : 2}
global skipScan := [[1,5], [2,5], [12,4], [12,5]] ; coordinates in the inventory
    
Stash(category) {
    GotoNthTabAndMouseBack(tabList[category])
    Send, ^{Click}
    return
}

GotoNthTabAndMouseBack(n) {
    MouseGetPos, x, y
    MouseClick, , dropdownX, dropdownY
    ; Sleep 2000
    MouseMove, dropdownListX0, dropdownListY0 + (n - 1) * dropdownListDeltaY
    Click
    MouseMove, x, y
}

GetCatogory() {
    Clipboard := ""
    Send, ^c
    if (Clipboard = "") {
        return ""
    }
    if (InStr(Clipboard, "sample")) {
        return "sample"
    }
    if (IsCurrency()) {
        return "currency"
    }
    if (InStr(Clipboard, "Divination")) {
        return "div cards"
    }
    if (InStr(Clipboard, "Fragment") or InStr(Clipboard, "Splinter") or InStr(Clipboard, "Scarab") or InStr(Clipboard, "Vessel") or InStr(Clipboard, "Offering") or InStr(Clipboard, "Sacrifice")) {
        return "fragment"
    }
    if (InStr(Clipboard, "Atlas Region")) {
        return "map"
    }
    if (InStr(Clipboard, "oil")) {
        return "oil"
    }
    if (InStr(Clipboard, "veiled")) {
        return "veiled"
    }
    if (InStr(Clipboard, "Rarity: Gem")) {
        return "gem"
    }
    if (InStr(Clipboard, "Fossil") or InStr(Clipboard, "Resonator")) {
        return "fossil"
    }
    if (InStr(Clipboard, "Essence") or InStr(Clipboard, "Remnant")) {
        return "essence"
    }
    If (InStr(Clipboard, "Rarity: Rare")) {
        ; return GetRareCategory(Clipboard)
        return GetRareCategory()
    }
    return "dump"
}

GetRareCategory() {
    return "dump"
}

ShouldSkip(i, j) {
    for index, coord in skipScan
        if (i = coord[1] and j = coord[2]) {
            return True
        }
    return False
}

Scan() {
    dx := 70
    dy := 70
    x0 := 1733
    y0 := 822
    lastCategory := ""
    Loop, 12 {
        i := A_Index
        Loop, 5 {
            j := A_Index
            If (ShouldSkip(i, j)) 
                Continue
            nextX := x0 + dx * (i - 1)
            nextY := y0 + dy * (j - 1)
            MouseMove, nextX, nextY
            category := GetCatogory()
            ; msgbox % category
            if (category = "") 
                Continue
            if (category = lastCategory) {
                Send, ^{Click}
                Continue
            }
            Stash(category)
            lastCategory := category
        }
    }
}

F2::
; stash.GotoNthTabAndMouseBack(7)
Scan()
return

F3::
Reload
Send, ^
return

IsCurrency() {
    lines := StrSplit(Clipboard, "`n", , 3)
    itemName := lines[2]
    StringTrimRight, itemName, itemName, 1
    currencyList := ["Blessed Orb", "Silver Coin", "Chaos Shard", "Chromatic Orb", "Engineer's Shard", "Glassblower's Bauble", "Horizon Shard", "Jeweller's Orb", "Orb of Alteration", "Orb of Chance", "Regal Shard", "Blacksmith's Whetstone", "Alteration Shard", "Armourer's Scrap", "Transmutation Shard", "Binding Shard", "Orb of Augmentation", "Alchemy Shard", "Orb of Transmutation", "Portal Scroll", "Scroll of Wisdom", "Exalted Shard", "Awakened Sextant", "Prime Sextant", "Stacked Deck", "Ancient Shard", "Annulment Shard", "Chaos Orb", "Engineer's Orb", "Gemcutter's Prism", "Harbinger's Shard", "Bestiary Orb", "Cartographer's Chisel", "Orb of Alchemy", "Orb of Binding", "Orb of Fusing", "Orb of Horizons", "Orb of Regret", "Orb of Scouring", "Regal Orb", "Vaal Orb", "Simple Sextant", "Fertile Catalyst", "Prismatic Catalyst", "Turbulent Catalyst", "Imbued Catalyst", "Intrinsic Catalyst", "Abrasive Catalyst", "Tempering Catalyst", "Crusader's Exalted Orb", "Redeemer's Exalted Orb", "Hunter's Exalted Orb", "Warlord's Exalted Orb", "Awakener's Orb", "Albino Rhoa Feather", "Eternal Orb", "Exalted Orb", "Mirror of Kalandra", "Mirror Shard", "Ancient Orb", "Divine Orb", "Harbinger's Orb", "Orb of Annulment", "Perandus Coin"]
    return HasVal(currencyList, itemName)
}

HasVal(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

