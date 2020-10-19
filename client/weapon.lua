function GetIntFromBlob(b, s, o)
	r = 0
	for i=1,s,1 do
		r = r | (string.byte(b,o+i)<<(i-1)*8)
	end
	return r
end

function GetWeaponHudStats(weaponHash, none)
	blob = '\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0'
	retval = Citizen.InvokeNative(0xD92C739EE34C9EBA, weaponHash, blob, Citizen.ReturnResultAnyway())
	hudDamage = GetIntFromBlob(blob,8,0)
	hudSpeed = GetIntFromBlob(blob,8,8)
	hudCapacity = GetIntFromBlob(blob,8,16)
	hudAccuracy = GetIntFromBlob(blob,8,24)
	hudRange = GetIntFromBlob(blob,8,32)
	return retval, hudDamage, hudSpeed, hudCapacity, hudAccuracy, hudRange
end