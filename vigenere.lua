-- Vigenere.lua
-- Raymas
--
-- decryptor for vigenere method

-- LANGUAGE FREQUENCIES
english = "eariotnslcudpmhgbfywkvxzjq"
french = "eaisnrtoludcmpégbvhfqyxjèàkwzêçôâîûùïüëö"
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


-- 2. Cracking key
function guessingKey(text, language, keylength, verbose)

  if (verbose == nil) then verbose = false end
  local key = "";

  for index = 1, keylength, 1 do
    local charmap = {}
    local keyindex = 0
    for i = 1, #text do
      local c = text:lower():sub(i,i)
      if language:find(c) then
        if (keyindex % keylength == index) then
          if (charmap[c]) then charmap[c] = charmap[c] + 1 else charmap[c] = 1 end
        end
        keyindex = keyindex + 1
      end
    end
    -- guessing statistically the key
    -- printDict(charmap)
    local sortedOccurences = getKeysSortedByValue(charmap, function(a, b) return a < b end)
    printDict(sortedOccurences)
    print("--END--")
    local maxLetter = string.char(((string.byte(sortedOccurences[#sortedOccurences]) - string.byte(language:sub(1, 1))) % 26) + string.byte('a'))
    key = key .. maxLetter
  end
  return key
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

ret = guessingKey("nGmni Tskcxipo esdskkxgmejvc !", french, 3)
print(ret)
