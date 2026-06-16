local type         = type
local error        = error
local tostring     = tostring
local mathType     = math.type
local stringPack   = string.pack
local stringUnpack = string.unpack
local stringSub    = string.sub
local tableConcat  = table.concat
local tableSort    = table.sort

local Number  = 'N' --Locally encoded numbers
local Double  = 'D' --Double-precision floating-point numbers
local NumZero = 'o'
local UInt8   = 'I'
local UInt16  = 'J'
local UInt24  = 'O'
local UInt32  = 'K'
local Int64   = 'L'
local I0      = '0'
local I1      = '1'
local I2      = '2'
local I3      = '3'
local I4      = '4'
local I5      = '5'
local I6      = '6'
local I7      = '7'
local I8      = '8'
local I9      = '9'
local Char1   = 'V'
local Char2   = 'W'
local Str8    = 'X'
local Str16   = 'Y'
local Str32   = 'Z'
local True    = 'T'
local False   = 'F'
local Nil     = '!'
local ArrayB  = '[' --Start an array definition
local ArrayE  = ']' --Ends the definition of an array
local TableB  = 'B' --Start defining a table (deprecated, for compatibility only)
local TableE  = 'E' --End the definition of a table (deprecated, only for compatibility)
local MixB    = '{' --Start defining a mixed table
local MixE    = '}' --End the definition of a mixed table
local STableB = '<' --Start the definition of a simple table in the format of [k1, k2,..., /, v1, v2,...] Among them, the key part will attempt to be reused
local Sep     = '|' --The key-value separator of a simple table
local RTableB = '>' --Start reusing a simple table, and the number following it indicates the ID of the reused table. When reusing, the length is known, so an ending character is not needed.
local Array   = '.' --This field is the integer part
local Ref     = 'R' --Reuse a previously defined string or table
local Custom  = 'C' --Custom data

local RefStrLen = 4 --Save a reference if the string length is greater than this value

local EndSymbol   = { '<END>' }
local ArraySymbol = { '<ARRAY>' }
local SepSymbol   = { '<SEP>' }

---@alias Serialization.SupportTypes
---| number
---| string
---| boolean
---| table
---| nil

local encode

---@param t table
---@return any[] keys
---@return boolean allSimpleKey
---@return integer? arrayLen
local function peekTable(t)
    ---@type integer?
    local maxInteger = 0
    local arrayLen
    local keys = {}
    local allSimpleKey = true
    for k in next, t do
        keys[#keys+1] = k
        local tp = type(k)
        if tp == 'number' then
            if mathType(k) == 'integer' and k > 0 then
                if maxInteger and k > maxInteger then
                    maxInteger = k --[[@as integer]]
                end
            else
                --Negative integer / 0 / floating-point keys cannot enter array form
                maxInteger = nil
            end
        elseif tp == 'string' then
            maxInteger = nil
        else
            maxInteger = nil
            allSimpleKey = false
        end
    end
    --A certain degree of sparsity is allowed, after all, the sparse part only occupies one byte
    if maxInteger and #keys * 4 >= maxInteger then
        arrayLen = maxInteger
    end
    return keys, allSimpleKey, arrayLen
end

local encodeMethods;encodeMethods = {
    ['number'] = function (value, buf)
        if mathType(value) == 'integer' then
            if value >= 0 then
                if value < 10 then
                    if value == 0 then
                        buf[#buf+1] = I0
                        return
                    end
                    if value < 5 then
                        if value < 3 then
                            if value == 1 then
                                buf[#buf+1] = I1
                                return
                            end
                            if value == 2 then
                                buf[#buf+1] = I2
                                return
                            end
                        else
                            if value == 3 then
                                buf[#buf+1] = I3
                                return
                            end
                            if value == 4 then
                                buf[#buf+1] = I4
                                return
                            end
                        end
                    elseif value < 8 then
                        if value == 5 then
                            buf[#buf+1] = I5
                            return
                        end
                        if value == 6 then
                            buf[#buf+1] = I6
                            return
                        end
                        if value == 7 then
                            buf[#buf+1] = I7
                            return
                        end
                    else
                        if value == 8 then
                            buf[#buf+1] = I8
                            return
                        end
                        if value == 9 then
                            buf[#buf+1] = I9
                            return
                        end
                    end
                end
                if value < (1 << 8) then
                    buf[#buf+1] = UInt8 .. stringPack('<I1', value)
                    return
                elseif value < (1 << 16) then
                    buf[#buf+1] = UInt16 .. stringPack('<I2', value)
                    return
                elseif value < (1 << 24) then
                    buf[#buf+1] = UInt24 .. stringPack('<I3', value)
                    return
                elseif value < (1 << 32) then
                    buf[#buf+1] = UInt32 .. stringPack('<I4', value)
                    return
                end
            end
            buf[#buf+1] = Int64 .. stringPack('<i8', value)
        else
            if value == 0.0 then
                buf[#buf+1] = NumZero
                return
            end
            buf[#buf+1] = Double .. stringPack('<d', value)
        end
    end,
    ['string'] = function (value, buf, ex)
        local len = #value
        if len > RefStrLen then
            local ref = ex.refMap[value]
            if ref then
                buf[#buf+1] = Ref
                encodeMethods['number'](ref, buf)
                return
            end
        end
        if len == 1 then
            buf[#buf+1] = Char1 .. value
        elseif len == 2 then
            buf[#buf+1] = Char2 .. value
        elseif len < (1 << 8) then
            buf[#buf+1] = Str8 .. stringPack('<s1', value)
        elseif len < (1 << 16) then
            buf[#buf+1] = Str16 .. stringPack('<s2', value)
        elseif len < (1 << 32) then
            buf[#buf+1] = Str32 .. stringPack('<s4', value)
        else
            error('This long string is not supported!')
        end
        if len > RefStrLen then
            ex.refid = ex.refid + 1
            ex.refMap[value] = ex.refid
        end
    end,
    ['boolean'] = function (value, buf)
        if value then
            buf[#buf+1] = True
        else
            buf[#buf+1] = False
        end
    end,
    ['nil'] = function (value, buf)
        buf[#buf+1] = Nil
    end,
    ['table'] = function (value, buf, ex, disableHook)
        local ref = ex.refMap[value]
        if ref then
            buf[#buf+1] = Ref
            encodeMethods['number'](ref, buf)
            return
        end

        if ex.hook and not disableHook then
            local newValue, tag = ex.hook(value)
            if newValue ~= nil then
                buf[#buf+1] = Custom
                encode(newValue, buf, ex, true)
                encode(tag or false, buf, ex, true)
                return
            end
        end

        ex.refid = ex.refid + 1
        ex.refMap[value] = ex.refid

        local myRef = ex.refid

        local keys, allSimpleKey, arrayLen = peekTable(value)
        if arrayLen then
            buf[#buf+1] = ArrayB

            for i = 1, arrayLen do
                encode(value[i], buf, ex)
            end

            buf[#buf+1] = ArrayE
        elseif allSimpleKey then
            tableSort(keys, function (a, b)
                local ta, tb = type(a), type(b)
                if ta == tb then
                    return a < b
                end
                return ta == 'number'
            end)

            local keyBuf = {}
            local i = 1
            for n = 1, #keys do
                local k = keys[n]

                if k == i then
                    --Array part
                    i = i + 1
                    keyBuf[#keyBuf+1] = Array
                else
                    --Mixed table section
                    encode(k, keyBuf, ex)
                end
            end
            local keyContent = tableConcat(keyBuf)
            local refid = ex.simpleMap[keyContent]
            if refid then
                buf[#buf+1] = RTableB
                encode(refid, buf, ex)
            else
                buf[#buf+1] = STableB
                ex.simpleMap[keyContent] = myRef
                buf[#buf+1] = keyContent
                buf[#buf+1] = Sep
            end

            for n = 1, #keys do
                local k = keys[n]
                local v = value[k]
                encode(v, buf, ex)
            end
        else
            buf[#buf+1] = MixB

            local i = 1
            for n = 1, #keys do
                local k = keys[n]
                local v = value[k]
                if k == i then
                    --Array part
                    i = i + 1
                    buf[#buf+1] = Array
                    encode(v, buf, ex)
                else
                    --Mixed table section
                    if ex.ignoreUnknownType and not encodeMethods[type(k)] then
                        --The key type is not supported. Skip the entire pair to avoid the error of value[nil] at the decoding end
                    else
                        encode(k, buf, ex)
                        encode(v, buf, ex)
                    end
                end
            end

            buf[#buf+1] = MixE
        end
    end,
}

function encode(value, buf, ex, disableHook)
    local tp = type(value)
    local f = encodeMethods[tp]
    if f then
        f(value, buf, ex, disableHook)
        return
    end
    if ex.ignoreUnknownType then
        --Write Nil placeholders to avoid disrupting the outer structure (array length, hash k/v pairing, etc.)
        buf[#buf+1] = Nil
        return
    end
    error('Unsupported types:' .. tp)
end

local decode

local decodeMethods;decodeMethods = {
    [Number] = function (ex)
        local value, newIndex = stringUnpack('<n', ex.str, ex.index)
        ex.index = newIndex
        return value
    end,
    [Double] = function (ex)
        local value, newIndex = stringUnpack('<d', ex.str, ex.index)
        ex.index = newIndex
        return value
    end,
    [UInt8] = function (ex)
        local value, newIndex = stringUnpack('<I1', ex.str, ex.index)
        ex.index = newIndex
        return value
    end,
    [UInt16] = function (ex)
        local value, newIndex = stringUnpack('<I2', ex.str, ex.index)
        ex.index = newIndex
        return value
    end,
    [UInt24] = function (ex)
        local value, newIndex = stringUnpack('<I3', ex.str, ex.index)
        ex.index = newIndex
        return value
    end,
    [UInt32] = function (ex)
        local value, newIndex = stringUnpack('<I4', ex.str, ex.index)
        ex.index = newIndex
        return value
    end,
    [Int64] = function (ex)
        local value, newIndex = stringUnpack('<i8', ex.str, ex.index)
        ex.index = newIndex
        return value
    end,
    [NumZero] = function ()
        return 0.0
    end,
    [I0] = function ()
        return 0
    end,
    [I1] = function ()
        return 1
    end,
    [I2] = function ()
        return 2
    end,
    [I3] = function ()
        return 3
    end,
    [I4] = function ()
        return 4
    end,
    [I5] = function ()
        return 5
    end,
    [I6] = function ()
        return 6
    end,
    [I7] = function ()
        return 7
    end,
    [I8] = function ()
        return 8
    end,
    [I9] = function ()
        return 9
    end,
    [Char1] = function (ex)
        local value = stringSub(ex.str, ex.index, ex.index)
        ex.index = ex.index + 1
        if #value > RefStrLen then
            ex.ref = ex.ref + 1
            ex.refMap[ex.ref] = value
        end
        return value
    end,
    [Char2] = function (ex)
        local value = stringSub(ex.str, ex.index, ex.index + 1)
        ex.index = ex.index + 2
        if #value > RefStrLen then
            ex.ref = ex.ref + 1
            ex.refMap[ex.ref] = value
        end
        return value
    end,
    [Str8] = function (ex)
        local value, newIndex = stringUnpack('<s1', ex.str, ex.index)
        ex.index = newIndex
        if #value > RefStrLen then
            ex.ref = ex.ref + 1
            ex.refMap[ex.ref] = value
        end
        return value
    end,
    [Str16] = function (ex)
        local value, newIndex = stringUnpack('<s2', ex.str, ex.index)
        ex.index = newIndex
        if #value > RefStrLen then
            ex.ref = ex.ref + 1
            ex.refMap[ex.ref] = value
        end
        return value
    end,
    [Str32] = function (ex)
        local value, newIndex = stringUnpack('<s4', ex.str, ex.index)
        ex.index = newIndex
        if #value > RefStrLen then
            ex.ref = ex.ref + 1
            ex.refMap[ex.ref] = value
        end
        return value
    end,
    [True] = function ()
        return true
    end,
    [False] = function ()
        return false
    end,
    [Nil] = function ()
        return nil
    end,
    [TableB] = function (ex)
        local value = {}
        ex.ref = ex.ref + 1
        ex.refMap[ex.ref] = value
        while true do
            local k = decode(ex)
            if k == EndSymbol then
                break
            end
            local v = decode(ex)
            ---@diagnostic disable-next-line: need-check-nil
            value[k] = v
        end
        return value
    end,
    [TableE] = function ()
        return EndSymbol
    end,
    [ArrayB] = function (ex)
        local value = {}
        ex.ref = ex.ref + 1
        ex.refMap[ex.ref] = value
        local i = 0
        while true do
            local v = decode(ex)
            if v == EndSymbol then
                break
            end
            i = i + 1
            value[i] = v
        end
        return value
    end,
    [ArrayE] = function ()
        return EndSymbol
    end,
    [Array] = function ()
        return ArraySymbol
    end,
    [MixE] = function ()
        return EndSymbol
    end,
    [MixB] = function (ex)
        local value = {}
        ex.ref = ex.ref + 1
        ex.refMap[ex.ref] = value
        local i = 1
        while true do
            local k = decode(ex)
            if k == EndSymbol then
                break
            end
            if k == ArraySymbol then
                --Array part
                local v = decode(ex)
                value[i] = v
                i = i + 1
            else
                --"Hash part
                local v = decode(ex)
                ---@diagnostic disable-next-line: need-check-nil
                value[k] = v
            end
        end
        return value
    end,
    [STableB] = function (ex)
        local value = {}
        ex.ref = ex.ref + 1
        ex.refMap[ex.ref] = value

        local myRef = ex.ref

        local i = 1
        local keys = {}
        while true do
            local v = decode(ex)
            if v == SepSymbol then
                break
            end
            if v == ArraySymbol then
                keys[#keys+1] = i
                i = i + 1
            else
                keys[#keys+1] = v
            end
        end

        ex.simpleMap[myRef] = keys

        for n = 1, #keys do
            local k = keys[n]
            local v = decode(ex)
            value[k] = v
        end

        return value
    end,
    [RTableB] = function (ex)
        local value = {}
        ex.ref = ex.ref + 1
        ex.refMap[ex.ref] = value

        local refid = decode(ex)
        local keys = ex.simpleMap[refid]

        for n = 1, #keys do
            local k = keys[n]
            local v = decode(ex)
            value[k] = v
        end

        return value
    end,
    [Ref] = function (ex)
        local value = decode(ex)
        value = ex.refMap[value]
        return value
    end,
    [Sep] = function ()
        return SepSymbol
    end,
    [Custom] = function (ex)
        local value = decode(ex)
        ---@cast value -?
        local tag = decode(ex)
        ---@cast tag string | false
        if not ex.hook then
            error('When deserializing custom data but no hook is provided, tag=' .. tostring(tag or nil))
        end
        value = ex.hook(value, tag or nil)
        return value
    end,
}

---@param ex table
---@return any
function decode(ex)
    local tp = stringSub(ex.str, ex.index, ex.index)
    ex.index = ex.index + 1
    return decodeMethods[tp](ex)
end

---@class Serialization
local M = {}

M.version = '1.2.0'

--Serialize a Lua value to binary data. Do not use as a long-term storage solution, as binary data may become incompatible due to version updates.
---@param data Serialization.SupportTypes | nil
---@param hook? fun(value: table): Serialization.SupportTypes | nil, string?
---@param ignoreUnknownType? boolean
---@return string
function M.encode(data, hook, ignoreUnknownType)
    if data == nil then
        return ''
    end
    local buf = {}

    encode(data, buf, {
        refid = 0,
        refMap = {},
        simpleMap = {},
        hook = hook,
        ignoreUnknownType = ignoreUnknownType,
    })

    return tableConcat(buf)
end

--Deserialize binary data to Lua values
---@param str string
---@param hook? fun(value: Serialization.SupportTypes, tag? : string): Serialization.SupportTypes | nil
---@return Serialization.SupportTypes | nil
function M.decode(str, hook)
    if str == '' then
        return nil
    end

    local ex = {
        str = str,
        index = 1,
        ref = 0,
        refMap = {},
        simpleMap = {},
        hook = hook,
    }

    local value = decode(ex)
    assert(ex.index == #str + 1)
    return value
end

return M
