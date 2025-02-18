---@class RSA
local M = {}

---Generate a pair of keys.
---@return string Public key
---@return string Private key
function M.generate_keys()
    local keys = GameAPI.generate_rsa_keys()
    local public_key = keys[0]
    local private_key = keys[1]
    return public_key, private_key
end

---encipher
---@param public_key string # Public key
---@param data string # Content to encrypt
---@return string # Encrypted content
function M.encrypt(public_key, data)
    return GameAPI.rsa_encrypt_message(public_key, data)
end

---decrypt
---@param private_key string # Private key
---@param data string # The content to be decrypted
---@return string # The contents after decryption
function M.decrypt(private_key, data)
    return GameAPI.rsa_decrypt_message(private_key, data)
end

return M
