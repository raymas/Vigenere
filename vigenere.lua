-- Vigenere.lua
-- Raymas
--
-- decryptor for vigenere method

-- paramters
local params = {...}

-- LANGUAGE FREQUENCIES
alphabet = "abcdefghijklmnopqrstuvwxyz"
english = "eariotnslcudpmhgbfywkvxzjq"
french = "eaisnrtoludcmpégbvhfqyxjèàkwzêçôâîûùïüëö"
spanish = "eaosnrildtucmpbhqyvgÓÍfjzÁÉÑxÚkwÜ"

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
    -- the probability of key length is greater than previuously : updating results
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
    local keyindex = 1
    for i = 1, #text do
      local c = text:lower():sub(i,i)
      if language:find(c) then
        if (keyindex == index) then
          if (charmap[c]) then charmap[c] = charmap[c] + 1 else charmap[c] = 1 end
        end
        keyindex = onePadding((keyindex + 1) % (keylength + 1))
      end
    end
    -- guessing statistically the key
    local sortedOccurences = getKeysSortedByValue(charmap, function(a, b) return a < b end)
    if (#sortedOccurences ~= 0) then
      local k = language:sub(1, 1)
      local maxLetter = string.char(((letterValue(sortedOccurences[#sortedOccurences]) - letterValue(k)) % 26) + string.byte('a'))
      key = key .. maxLetter
    end
  end
  return key
end


-- 3. Decrypt
function decrypt(text, key, language)
  local decrypted = ""
  local keyindex = 1
  key = key:lower()
  for i = 1, #text, 1 do
    local c = text:lower():sub(i,i)
    if language:find(c) then
      local k = key:sub(keyindex,keyindex)
      decrypted = decrypted .. string.char(((26 + letterValue(c) - letterValue(k)) % 26) + string.byte('a'))
      keyindex = onePadding((keyindex + 1) % (#key + 1))
    else
      decrypted = decrypted .. c
    end
  end
  return decrypted
end


-- 4. Encrypt
function encrypt(text, key, language)
  local crypted = ""
  local keyindex = 1
  key = key:lower()
  for i = 1, #text, 1 do
    local c = text:lower():sub(i,i)
    if language:find(c) then
      local k = key:sub(keyindex,keyindex)
      crypted = crypted .. string.char(((26 + letterValue(c) + letterValue(k)) % 26) + string.byte('a'))
      keyindex = onePadding((keyindex + 1) % (#key + 1))
    else
      crypted = crypted .. c
    end
  end
  return crypted
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

function letterValue(letter)
  return (letter:byte() - ("a"):byte())
end

function onePadding(int)
  return (int > 0) and int or 1
end

function isInList(key, list)
  for _,v in pairs(list) do
    if v == key then
      return true
    end
  end
  return false
end

function getIndex(key, list)
  for t,v in pairs(list) do
    if v == key then
      return t
    end
  end
  return nil
end

function split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end



-- Help
function printHelp()
  print("Usage : lua vigenere.lua [MODE] [OPTIONS]")
  print("")
  print("# MODES: #")
  print("\te\tencrypt by entering a key, and a text")
  print("\td\tdecrypt by entering a key, and a text")
  print("\tc\tcrack")
  print("#-------------------------------------------#")
  print("\te parameter : lua vigenere.lua e [OPTIONS --raw | OPTIONS --file] key")
  print("")
  print("\t\t--raw 'text in console'")
  print("\t\t--file [path to file]")
  print("#-------------------------------------------#")
  print("\td parameter : lua vigenere.lua [OPTIONS --raw | OPTIONS --file] key")
  print("")
  print("\t\t--raw 'text in console'")
  print("\t\t--file [path to file]")
  print("#-------------------------------------------#")
  print("\tc parameter : lua vigenere.lua [(OPTIONS --raw | OPTIONS --file) && --maxkeylength keylength]")
  print("\t\t--raw 'text in console'")
  print("\t\t--file [path to file]")
  print("\t\t--maxkeylength [integer keylength] : this parameter is mandatory")
  print("\t\t--trylength [lower:upper] : this parameter is mandatory and should not be used with maxkeylength")
  print("#-------------------------------------------#")
end

-- TEST FUNCTION
function TEST()
  longText = [===[
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc sed ipsum sit amet metus suscipit pharetra. Pellentesque imperdiet a enim ut cursus. Nullam euismod blandit urna, sit amet faucibus lectus tristique ac. Nulla congue ac lacus nec tempus. Suspendisse dapibus metus vel diam porta interdum. Donec pulvinar a magna id dignissim. Nulla eleifend laoreet urna. Aliquam sit amet risus vitae neque ornare sodales nec vel odio. Vivamus eu est id lacus faucibus eleifend. Nulla nec pharetra massa. Duis quis iaculis elit. Cras et hendrerit elit. Sed at neque et orci semper eleifend vitae eget nisl. Morbi malesuada pellentesque urna, sit amet efficitur purus eleifend accumsan. Etiam lectus nisl, consectetur eget lacus vitae, cursus facilisis libero. Nullam vitae vehicula eros. Vestibulum vitae commodo velit. Integer elementum pellentesque venenatis. Duis eget urna ac lectus ullamcorper ullamcorper et vel risus. In ante est, consequat eget lacinia vel, tincidunt nec erat. Integer lobortis mi ante, ut condimentum purus commodo vel. In hac habitasse platea dictumst. Suspendisse vulputate hendrerit nisi elementum vulputate.
  Nulla posuere vestibulum sem, id pulvinar quam malesuada dapibus. Integer porttitor ac velit quis malesuada. Cras eu ligula quis arcu dictum ultrices ac at odio. Nulla sit amet nulla sed odio vehicula aliquam sed nec tortor. Sed viverra enim sit amet odio elementum, ut vehicula erat convallis. Ut leo mauris, blandit ut pulvinar sit amet, tristique at quam. Integer est eros, ornare non erat at, vulputate tempus neque. Sed ornare felis sit amet lectus pellentesque, ac suscipit ex venenatis. In finibus vel lorem ac dignissim.
  Aenean rutrum sodales urna, non venenatis diam scelerisque et. Aliquam porttitor augue sed dapibus auctor. Nulla tempus leo nec leo tristique interdum. Maecenas vehicula, enim ac efficitur ullamcorper, ligula ante elementum ligula, vitae semper enim sapien sit amet felis. Nullam lobortis accumsan est, accumsan lobortis neque sollicitudin eget. Morbi lacus arcu, vulputate sed dictum sed, auctor id elit. Proin nisl dui, pellentesque et diam et, mattis convallis sapien. Aliquam semper imperdiet ante, non suscipit risus molestie sed. Morbi gravida sem metus, sed varius augue eleifend sed. Donec pulvinar ipsum nunc, at mattis ex sodales at. In dignissim libero nisl, sit amet pharetra diam aliquet non. Aliquam consectetur lacinia ex ac sollicitudin.

  In non auctor leo. Praesent maximus luctus tortor. Donec luctus, dolor vel mattis porttitor, orci felis vestibulum eros, sit amet tempus lorem felis ut nulla. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nunc non consequat neque. Donec mollis gravida urna, sed iaculis augue pellentesque non. Suspendisse ac porta urna. Sed congue finibus felis viverra varius. In nisl justo, iaculis sed fringilla nec, semper non dui. Vivamus cursus ante eu interdum ultricies. Nunc volutpat consectetur volutpat. Nam ut massa nec massa eleifend mollis non sed ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae;]===]
  print("#----------------------------#")
  r = encrypt(longText, "lua", english)
  print(r)
  print("#----------------------------#")
  print("        DECRYPTION            ")
  print("#----------------------------#")
  len = keylengthguess(r, english, 5)
  print("Length guess is : " .. len.keylength)
  pseudoKey = guessingKey(r, english, len.keylength)
  print("Psuedo key guess is : ".. pseudoKey)
  print("#----------------------------#")
  print("         TESTING              ")
  print("#----------------------------#")
  d = decrypt(r, pseudoKey, english)
  print(d)
  print("#----------------------------#")
end


-- Main Function
function main(args)
  if #args > 0 then
    if isInList("e", args) then
      cmdEncode(args)
    elseif isInList("d", args) then
      cmdDecode(args)
    elseif isInList("c", args) then
      cmdCrack(args)
    elseif isInList("-h", args) or isInList("--help", args) then
      printHelp()
    else
      print("No command found. Use --help for list and usages")
    end
  else
    printHelp()
  end
end

function cmdEncode(cli)
  local string = nil
  local key = nil
  local language = english

  if isInList("--file", cli) then
    local path = getIndex("--file", cli) + 1
    if cli[path] ~= nil then
      file = io.open(cli[path], "r")
      string = file:read("*a")
    else
      print("Error argument : incorrect path")
      os.exit()
    end
  elseif isInList("--raw", cli) then
    local text = getIndex("--raw", cli) + 1
    if cli[text] ~= nil then
      string = cli[text]
    else
      print("Error argument : incorrect text")
      os.exit()
    end
  end
  key = cli[#cli]
  print(encrypt(string, key, english))
end

function cmdDecode(cli)
  local string = nil
  local key = nil
  local language = english

  if isInList("--file", cli) then
    local path = getIndex("--file", cli) + 1
    if cli[path] ~= nil then
      file = io.open(cli[path], "r")
      string = file:read("*a")
    else
      print("Error argument : incorrect path")
      os.exit()
    end
  elseif isInList("--raw", cli) then
    local text = getIndex("--raw", cli) + 1
    if cli[text] ~= nil then
      string = cli[text]
    else
      print("Error argument : incorrect text")
      os.exit()
    end
  end
  key = cli[#cli]
  print(decrypt(string, key, language))
end


function cmdCrack(cli)
  local string = nil
  local keylength = nil
  local lower = nil
  local upper = nil
  local language = english

  if isInList("--file", cli) then
    local path = getIndex("--file", cli) + 1
    if cli[path] ~= nil then
      file = io.open(cli[path], "r")
      string = file:read("*a")
    else
      print("Error argument : incorrect path")
      os.exit()
    end
  elseif isInList("--raw", cli) then
    local text = getIndex("--raw", cli) + 1
    if cli[text] ~= nil then
      string = cli[text]
    else
      print("Error argument : incorrect text")
      os.exit()
    end
  end

  if isInList("--maxkeylength", cli) then
    local mkl = getIndex("--maxkeylength", cli) + 1
    if cli[mkl] ~= nil then
      keylength = cli[mkl]
    end
  elseif isInList("--trylength", cli) then
    local tl = getIndex("--trylength", cli) + 1
    if cli[tl] ~= nil then
      lower, upper = cli[tl]:match("([^,]+):([^,]+)")
    end
  end

  if keylength then
    local keyguess = guessingKey(string, language, keylength)
    print("Key guess is : " .. keyguess)
    print(decrypt(string, keyguess, language))
  elseif lower and upper then
    for try = tonumber(lower), tonumber(upper), 1 do
      local keyguess = guessingKey(string, language, try)
      print("[" .. try .. "] Key guess is : " .. keyguess)
    end
  else
    local len = keylengthguess(string, english)
    print("Length guess is : " .. len.keylength)
    local pseudoKey = guessingKey(string, english, len.keylength)
    print("Key guess is : ".. pseudoKey)
    print(decrypt(string, pseudoKey, language))
  end
end

main(params)
