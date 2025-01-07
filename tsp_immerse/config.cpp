class CfgPatches {
    class tsp_immerse {requiredAddons[] = {"tsp_core", "A3_Map_Data", "A3_Map_Data_Exp", "A3_Map_Enoch_Data", "A3_Data_F_ParticleEffects"}; units[] = {};};
};

class CfgCloudlets {
	class Default;
	class HDust1: Default {
		interval = "0.01 - 0.01* ((density*1.7) interpolate [0,0.6,0,0.6])";
		lifeTime = 6;
        weight = 1.8;
        volume = 1.3;
		rubbing = 0.01;
		size[] = {3, 6};
		sizeCoef = 1;
		lifeTimeVar = 10;
		MoveVelocityVar[] = {0.15, 0.15, 0.15};
		sizeVar = 0.4;
        smokeZoomCoef = 0.00012857;
	};
	class HDust1M: Default {
		interval = "0.01 - 0.01* ((density*1.7) interpolate [0,0.6,0,0.6])";
		lifeTime = 3;
        weight = 1.8;
        volume = 1.2;
		rubbing = 0.01;
		size[] = {3, 6};
		sizeCoef = 1;
		lifeTimeVar = 10;
		MoveVelocityVar[] = {0.15, 0.15, 0.15};
		sizeVar = 0.4;
        smokeZoomCoef = 0.00012857;
	};
    class HDust1L: Default {
		interval = "0.01 - 0.01* ((density*1.7) interpolate [0,0.6,0,0.6])";
		lifeTime = 4;
        weight = 1.8;
        volume = 1.2;
		rubbing = 0.01;
		size[] = {3, 6};
		sizeCoef = 1;
		lifeTimeVar = 10;
		MoveVelocityVar[] = {0.15, 0.15, 0.15};
		sizeVar = 0.4;
        smokeZoomCoef = 0.00012857;
	};
	class HDust1Long: Default {
		interval = "0.015 - 0.007* ((density*1.7) interpolate [0,0.6,0,0.6])";
		lifeTime = 10;
        weight = 1.8;
        volume = 1.2;
		rubbing = 0.01;
		size[] = {5, 10, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15};
		sizeCoef = 1;
		lifeTimeVar = 10;
		sizeVar = 0.25;
        smokeZoomCoef = 0.00012857;
	};
    class HDust1LongBig: Default {
		interval = "0.015 - 0.007* ((density*1.7) interpolate [0,0.6,0,0.6])";
		lifeTime = 10;
        weight = 1.8;
        volume = 1.2;
		rubbing = 0.01;
		size[] = {5, 10, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15};
		sizeCoef = 1;
		lifeTimeVar = 10;
		sizeVar = 0.25;
        smokeZoomCoef = 0.00012857;
	};
    class HWater1: Default {
		interval = "0.002 - 0.001 * ((density*1.8) interpolate [0,0.6,0,0.6])";
		lifeTime = 15;
        weight = 1.65;
		volume = 1.2;
		rubbing = 0.01;
		size[] = {5, 10, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 20, 20, 20, 20};
		sizeCoef = 1;
		lifeTimeVar = 1;
		sizeVar = 0.25;
        smokeZoomCoef = 0.00012857;
	};	
	class HWater2: Default {
		interval = "0.002 - 0.001 * ((density*1.8) interpolate [0,0.6,0,0.6])";
		lifeTime = 10;
		weight = 1.55;
		volume = 1.2;
		rubbing = 0.01;
		size[] = {5, 10, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 20, 20, 20, 20};
		sizeCoef = 1;
		lifeTimeVar = 1;
		sizeVar = 0.25;
        smokeZoomCoef = 0.82857;
	};	
	class HWater3: Default {
		interval = 0.0007;
		lifeTime = 1.2;
		weight = 1.5;
		volume = 1.2;
		rubbing = 0;
		size[] = {1.2, 2.5};
		sizeCoef = 1.5;
		lifeTimeVar = 0.8;
		sizeVar = 0;
	};
};
