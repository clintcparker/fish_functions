function mute
	if test count(mac volume:ismute  | grep -Eo 'true') >0

        mac volume:unmute
    else
        mac volume:mute
    end
end
