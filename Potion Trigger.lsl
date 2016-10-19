#include "ban-updater/ban.h"

	default
	{
		touch_end(integer total_number)
		{
			llSay(PUBLIC_CHANNEL, "Renewing warding spells.");
			llRegionSay(REGION_CHANNEL, "update");
		}
	}
