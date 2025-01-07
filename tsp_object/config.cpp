class CfgPatches {
	class tsp_object {
		requiredAddons[] = {"A3_Structures_F"};
		units[] = {"tsp_zone", "tsp_platform", "tsp_platform_ramp", "tsp_platform_thin", "tsp_platform_weird", "tsp_logo"};		
	};
};

class CfgVehicles {	
	class House_F;
	class tsp_zone: House_F	{scope = 2; displayName = "Zone Wall"; model = "tsp_object\zone.p3d"; vehicleClass = "Structures"; mapSize = 20;};
	class tsp_zone_empty: tsp_zone {displayName = "Zone Wall (Transparent)"; model = "tsp_object\zone_empty.p3d";};
	class tsp_platform: tsp_zone {scope = 2; displayName = "Platform"; model = "tsp_object\platform.p3d";};
	class tsp_platform_ramp: tsp_platform {displayName = "Platform (Ramp)"; model = "tsp_object\platform_Ramp.p3d";};
	class tsp_platform_thin: tsp_platform {displayName = "Platform (Thin)"; model = "tsp_object\platform_Thin.p3d";};
	class tsp_platform_weird: tsp_platform {displayName = "Platform (Weird)"; model = "tsp_object\platform_Weird.p3d";};
	class tsp_logo: tsp_zone {displayName = "TSP Logo"; model = "tsp_object\logo.p3d";};
};