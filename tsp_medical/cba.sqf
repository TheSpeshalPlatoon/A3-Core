["tsp_cba_medical_helmet", "SLIDER", ["Helmet Damage", "Add this damage if shot in helmet."], ["TSP Medical", "Armor"], [0, 10, 4], true] call CBA_fnc_addSetting;
["tsp_cba_medical_vest", "SLIDER", ["Vest Damage", "Add this damage to if shot in vest."], ["TSP Medical", "Armor"], [0, 10, 5], true] call CBA_fnc_addSetting;

["tsp_cba_medical_total_head", "SLIDER", ["Total - Head", "How much damage this body part can take in total."], ["TSP Medical", "Death"], [0, 10, 5.5], true] call CBA_fnc_addSetting;
["tsp_cba_medical_total_torso", "SLIDER", ["Total - Torso", "How much damage this body part can take in total."], ["TSP Medical", "Death"], [0, 10, 9], true] call CBA_fnc_addSetting;
["tsp_cba_medical_total_limbs", "SLIDER", ["Total - Limbs", "How much damage this body part can take in total."], ["TSP Medical", "Death"], [0, 10, 3.5], true] call CBA_fnc_addSetting;
["tsp_cba_medical_impulse_head", "SLIDER", ["Impulse - Head", "How much damage this body part can take per shot."], ["TSP Medical", "Death"], [0, 10, 5], true] call CBA_fnc_addSetting;
["tsp_cba_medical_impulse_torso", "SLIDER", ["Impulse - Torso", "How much damage this body part can take per shot."], ["TSP Medical", "Death"], [0, 10, 5], true] call CBA_fnc_addSetting;
["tsp_cba_medical_impulse_limbs", "SLIDER", ["Impulse - Limbs", "How much damage this body part can take per shot."], ["TSP Medical", "Death"], [0, 10, 2], true] call CBA_fnc_addSetting;

["tsp_cba_medical_wake_spam", "SLIDER", ["Wake Up Space", "How often you can try to wake up."], ["TSP Medical", "Unconscious"], [0, 10, 5], true] call CBA_fnc_addSetting;
["tsp_cba_medical_wake_chance", "SLIDER", ["Wake Up Chance", "Chance of waking up when tapping space."], ["TSP Medical", "Unconscious"], [0, 1, 0.3], true] call CBA_fnc_addSetting;

[  //-- FAK items
	"tsp_cba_medical_fak", "EDITBOX",
	["First Aid Kit", "Array containing item classnames and quantities."],
	["TSP Medical", "Kits"], '[
        ["ACE_elasticBandage", 2],
        ["ACE_fieldDressing", 2],
        ["ACE_tourniquet", 2],
        ["ACE_painkillers", 2]
    ]', false, {tsp_cba_medical_fak = call compile tsp_cba_medical_fak}
] call CBA_fnc_addSetting;

[  //-- IFAK items
	"tsp_cba_medical_ifak", "EDITBOX",
	["Individual First Aid Kit", "Array containing item classnames and quantities."],
	["TSP Medical", "Kits"], '[
        ["ACE_splint", 2],
        ["ACE_elasticBandage", 4],
        ["ACE_fieldDressing", 4],
        ["ACE_quikclot", 4],
        ["ACE_tourniquet", 2],
        ["ACE_painkillers", 4]
    ]', false, {tsp_cba_medical_ifak = call compile tsp_cba_medical_ifak}
] call CBA_fnc_addSetting;

[  //-- Medikit items
	"tsp_cba_medical_medikit", "EDITBOX",
	["Medikit", "Array containing item classnames and quantities."],
	["TSP Medical", "Kits"], '[
        ["ACE_bodyBag", 2],
        ["ACE_surgicalKit", 1],
        ["ACE_suture", 20],
        ["ACE_splint", 4],
        ["ACE_atropine", 5],
        ["ACE_adenosine", 5],
        ["ACE_epinephrine", 10],
        ["ACE_morphine", 10],
        ["ACE_painkillers", 5],
        ["ACE_quikclot", 10],
        ["ACE_elasticBandage", 10],
        ["ACE_fieldDressing", 10],
        ["ACE_packingBandage", 10],
        ["ACE_tourniquet", 4],
        ["ACE_salineIV", 2],
        ["ACE_salineIV_500", 3],
        ["ACE_salineIV_250", 2]
    ]', false, {tsp_cba_medical_medikit = call compile tsp_cba_medical_medikit}
] call CBA_fnc_addSetting;
