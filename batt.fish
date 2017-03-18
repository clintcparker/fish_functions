function batt
	set -l bat (mac battery)
set -l per (echo $bat | grep -oE '\d+%')
echo "$per charged"
set -l rem (echo $bat | grep -oE '\d+:\d+')
echo "$rem remaining"
end
