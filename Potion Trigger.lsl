#include "ban-updater/ban.h"

default
{
	touch_end(integer total_number)
	{
		llWhisper(PUBLIC_CHANNEL, "Renewing warding spells.");
		 llRegionSay(REGION_CHANNEL, "update");
	}
}
