-- Vigenere.lua
-- Raymas
--
-- decryptor for vigenere method

-- LANGUAGE FREQUENCIES
english = "eariotnslcudpmhgbfywkvxzjq"
french = "eaisnrtoludcmpégbvhfqyxjèàkwzêçôâîûùï üëö"
spanish = string.lower("")

-- 1. Cracking key length
function keylengthguess(text, language, maxkeylength, verbose)

  if (maxkeylength == nil) then maxkeylength = 20 end
  if (verbose == nil) then verbose = false end

  local results = {}
  local minMax = 0

  for keylength = 1, maxkeylength, 1 do
    -- count every character in text
    local charmap = {}
    local keyindex = 0
    for i = 1, #text do
      local c = text:lower():sub(i,i)
      if language:find(c) then
        if keyindex % keylength == 0 then
          if (charmap[c]) then charmap[c] = charmap[c] + 1 else charmap[c] = 1 end
        end
        keyindex = keyindex + 1
      end
    end
    -- end of key search
    local sortedOccurences = getKeysSortedByValue(charmap, function(a, b) return a < b end)
    local occurencesOfMinLetter = charmap[sortedOccurences[1]]
    local occurencesOfMaxLetter = charmap[sortedOccurences[#sortedOccurences]]
    local minProb = occurencesOfMinLetter / keyindex * keylength * 100
    local maxProb = occurencesOfMaxLetter / keyindex * keylength * 100
    -- the probability of key length is greater than previuously : outputing results
    if (maxProb - minProb) > minMax then
      minMax = maxProb - minProb
      results["prob"] = minMax
      results["keylength"] = keylength
      results["keyindex"] = keyindex
      results["charmap"] = charmap
    end
  end
  return results
end


-- 2. Cracking key length
function guessingKey(text, language, keylength, verbose)

  if (verbose == nil) then verbose = false end
  local charmap = {}
  local keyindex = 0

  for index = 1, keylength, 1 do
    for i = 1, #text do
      local c = text:lower():sub(i,i)
      if language:find(c) then
        if (keyindex % keylength == index) then
          if (charmap[c]) then charmap[c] = charmap[c] + 1 else charmap[c] = 1 end
        end
        keyindex = keyindex + 1
      end
    end



-- N/A usefull functions
function compare(a, b)
  return a[1] < b[1]
end

function printDict(d)
  for k,v in pairs(d) do print(k,v) end
end

function getKeysSortedByValue(tbl, sortFunction)
  local keys = {}
  for key in pairs(tbl) do table.insert(keys, key) end
  table.sort(keys, function(a, b) return sortFunction(tbl[a], tbl[b]) end)
  return keys
end


ret = keylengthguess([===[uayslumk jfx hew ibqg. afuayslumk jfx hew ioqg. afuayslumk jfx hew ibqg. af
ig ydfj, pmyuwt dnx ldynaig ydfj, piyuwt dnx ldynaig ydfj, piyuwt dnx ldyna
taljqse mvnil mupngj, gxataljqse mvnil mupngj, gxataljqsl mvnil mupngj, gxa
yfjka pqjuqc hznjw pos wuyfjka pqjuqc hztjw pos wuyfjka pqjuqc hznjw pos wu
n qjvnpmsv yut, qjnd. krsn qjvnpmsv yut, qjnd. krsn qjsnpmsv yut, qjnd. krs
mvjov cezjbxcfezat uqgcmsmvjov cezjbxcfezat uqgcmsmvjov cezjbxcfgzat uqgcms
vbik ulpo. vyahsavfx ngc vbik ulpo. vyahsavfx ngc vbik ulpo. vyahsavfx egc
ucua fvy bmg, kfrkjv lucmucua fvy bmg, kfrkjv lucmccua fvy bmg, kfrkjv lucm
iux kwjrlnetyox, ev neioqiux kwjrln tyox, ev neioqiux kwjrlnetyox, ev neioq
dwa .vetdadjck fardbq hnxdwa .vetdadjck fardbq hnxdwa .vetdadjck fardbqwhnx
tur, einbagx phhvz. abnwytur, einbagx phhvz. abnwytur, einbegx phhvz. abnwy
oc ghbta dac, wvrzt. vqtfoc ghbtaodac, wvrzt. vqtfoc ghbta dac, wvrzt. vqtf
qa, xkrzm, yiyaj cnq  lvpqa, xkrzm, yiyaj cnq  lvpqa, xkrzm, yiyaj cnq  avp
ocfv edcnozbdjmm, wjzy fhocfv edcnozbdjmm, wjzyefhocfv edcnozbdjmm, wjzyefh
qlejrt gefk dlljvnh. nip qlejst gefk dlljvnh. nip qlejst gefk dlljvnh. nip
jvktil. qsat bncjlota. nejvktil. qsat bncjlota. nejvkhil. qsat bncjlota. ne
dulxyskfnm. zaj ntl ftugidulxyskfnm. zaj ntl ftugidulxyskfnm. zwj ntl ftugi
tqo crqtswzj xrje jfwar, tqo orqtswzj xrje jfwar, tqo crqtswzj xrje jfwar,
qhknaz gsxqyrc aelxiv, qaqhknaz gsxqyrc aelxiv, qaqhknaz gsxqyrc aelxiv, qt
]===], french)

printDict(ret)
