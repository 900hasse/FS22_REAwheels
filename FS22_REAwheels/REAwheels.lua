--
-- REA Script
-- author: 900Hasse
-- date: 23.11.2022
--
-- V1.1.0.0
--
-----------------------------------------
-- TO DO
---------------
-- 
-- 



-----------------------------------------
-- KNOWN ISSUES
---------------
-- 
-- 

print("----------------------------------")
print("----- REA wheels by 900Hasse -----")
print("----------------------------------")
REAwheels = {};

function REAwheels.prerequisitesPresent(specializations)
    return true
end;

function REAwheels:loadMap(name)
end

function REAwheels:update(dt)
	-----------------------------------------------------------------------------------
	-- Global settings
	-----------------------------------------------------------------------------------
	-- Save global values
	if REAwheels.GlobalValuesSet ~= true then
		-----------------------------------------------------------------------------------
		-- Global settings of wheel tiretypes and friction
		-----------------------------------------------------------------------------------
		-- Tiretypes
		local TireTypeMUD = 1;
		local TireTypeOFFROAD = 2;
		local TireTypeSTREET = 3;
		local TireTypeCRAWLER = 4;

		-- Groundtypes
		local ROAD = 1;
		local HARD_TERRAIN = 2;
		local SOFT_TERRAIN = 3;
		local FIELD = 4;

		-- TireType sink parameters
		REAwheels.TireTypeMaxSinkFrictionReduced = {1,1,1,1};
		REAwheels.TireTypeSinkStuckLevel = {1,1,1,1};
		REAwheels.TireTypeMinRollingCoeff = {1,1,1,1};
		REAwheels.TireTypeSinkPerMeterSpinning = {0.1,0.1,0.1,0.1};

		-- Min wheel size(radius) to be effected by mod
		REAwheels.MinWheelRadius = 0.15;

		-- Factor max sink of wheel based on radius(original value 0.2)
		REAwheels.WheelRadiusMaxSinkFactor = 0.5;

		-- Sink parameters when wheel in conctact with a lowspot with water (percentage)
		REAwheels.TireTypeMaxSinkFrictionReducedLowSpot = 100;
		REAwheels.TireTypeSinkStuckLevelLowSpot = 75;

		local SnowCoeffFactor = 1;
		-------------------------------------
		-- MUD
		-- TireType on different groundtypes
		SnowCoeffFactor = 0.5;
		REAwheels:SetFrictionCoeff(TireTypeMUD,ROAD,1.0,0.95,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeMUD,HARD_TERRAIN,0.8,0.9,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeMUD,SOFT_TERRAIN,0.8,0.85,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeMUD,FIELD,0.7,0.85,SnowCoeffFactor);
		-- Sink parameters (percentage)
		REAwheels.TireTypeMaxSinkFrictionReduced[TireTypeMUD] = 35;
		REAwheels.TireTypeSinkStuckLevel[TireTypeMUD] = 95;
		REAwheels.TireTypeSinkPerMeterSpinning[TireTypeMUD] = 0.04;
		-- Min rolling coefficient
		REAwheels.TireTypeMinRollingCoeff[TireTypeMUD] = 0.04;
		-------------------------------------
		-- OFFROAD
		-- TireType on different groundtypes
		SnowCoeffFactor = 0.7;
		REAwheels:SetFrictionCoeff(TireTypeOFFROAD,ROAD,1.4,0.95,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeOFFROAD,HARD_TERRAIN,0.9,0.85,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeOFFROAD,SOFT_TERRAIN,0.8,0.8,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeOFFROAD,FIELD,0.7,0.75,SnowCoeffFactor);
		-- Sink parameters (percentage)
		REAwheels.TireTypeMaxSinkFrictionReduced[TireTypeOFFROAD] = 40;
		REAwheels.TireTypeSinkStuckLevel[TireTypeOFFROAD] = 90;
		REAwheels.TireTypeSinkPerMeterSpinning[TireTypeOFFROAD] = 0.03;
		-- Min rolling coefficient
		REAwheels.TireTypeMinRollingCoeff[TireTypeOFFROAD] = 0.03;
		-------------------------------------
		-- STREET
		-- TireType on different groundtypes
		SnowCoeffFactor = 0.5;
		REAwheels:SetFrictionCoeff(TireTypeSTREET,ROAD,1.7,0.95,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeSTREET,HARD_TERRAIN,0.7,0.8,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeSTREET,SOFT_TERRAIN,0.65,0.75,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeSTREET,FIELD,0.6,0.6,SnowCoeffFactor);
		-- Sink parameters (percentage)
		REAwheels.TireTypeMaxSinkFrictionReduced[TireTypeSTREET] = 50;
		REAwheels.TireTypeSinkStuckLevel[TireTypeSTREET] = 80;
		REAwheels.TireTypeSinkPerMeterSpinning[TireTypeSTREET] = 0.02;
		-- Min rolling coefficient
		REAwheels.TireTypeMinRollingCoeff[TireTypeSTREET] = 0.02;
		-------------------------------------
		-- CRAWLER
		-- TireType on different groundtypes
		SnowCoeffFactor = 0.6;
		REAwheels:SetFrictionCoeff(TireTypeCRAWLER,ROAD,1.0,0.85,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeCRAWLER,HARD_TERRAIN,1.0,0.85,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeCRAWLER,SOFT_TERRAIN,0.9,0.8,SnowCoeffFactor);
		REAwheels:SetFrictionCoeff(TireTypeCRAWLER,FIELD,0.8,0.75,SnowCoeffFactor);
		-- Sink parameters (percentage)
		REAwheels.TireTypeMaxSinkFrictionReduced[TireTypeCRAWLER] = 40;
		REAwheels.TireTypeSinkStuckLevel[TireTypeCRAWLER] = 95;
		REAwheels.TireTypeSinkPerMeterSpinning[TireTypeCRAWLER] = 0.03;
		-- Min rolling coefficient
		REAwheels.TireTypeMinRollingCoeff[TireTypeCRAWLER] = 0.1;

		-- Global values set
		REAwheels.GlobalValuesSet = true
		print("Global REA variables loaded")
	end;

	-----------------------------------------------------------------------------------
	-- Check if REAwheels.Dynamic dirt is loadad and all map is scanned for low spots
	-----------------------------------------------------------------------------------
	-- Initialize variable for Dynamic dirt
	if REAwheels.DynamicDirtActivated == nil then
		REAwheels.DynamicDirtFound = false;
		REAwheels.DynamicDirtActivated = false;
	end;
	-- Check if Dynamic dirt is loaded and all map scanned
	if not REAwheels.DynamicDirtActivated then
		-- Check if dynamic dirt is loaded
		if not REAwheels.DynamicDirtFound and g_modIsLoaded.FS22_READynamicDirt ~= nil then
			print("REA Dynamic dirt: Found by REA")
			REAwheels.DynamicDirtFound = true;
		end;
		-- If dynamic dirt is loaded wait until all area is scanned before starting functions
		if REAwheels.DynamicDirtFound then
			if WheelsUtil.LowspotScanCompleted ~= nil then
				if WheelsUtil.LowspotScanCompleted then
					print("REA Dynamic dirt: Scan completed detected by REA")
					REAwheels.DynamicDirtActivated = true;
				end;
			end;
		end;
	end;

	-----------------------------------------------------------------------------------
	-- Read wetness from gound
	-----------------------------------------------------------------------------------
	REAwheels.GroundWetnessFactor = g_currentMission.environment.weather:getGroundWetness();

	-----------------------------------------------------------------------------------
	-- Add REA functionality
	-----------------------------------------------------------------------------------
	-- Get number of vehicles
	local numVehicles = table.getn(g_currentMission.vehicles);
	-- If vehicles present run code
	if numVehicles ~= nil then
		-- Run code for vehicles
		if numVehicles >= 1 then
			for VehicleIndex=1, numVehicles do
				-- Save "vehicle" to local
				local vehicle = g_currentMission.vehicles[VehicleIndex];			
				-- Check if current vehicle exists
				if vehicle ~= nil then
					-- If vehicle have wheels calculate friction and add rolling resistance
					if vehicle.spec_wheels ~= nil and vehicle.isAddedToPhysics then
						-- If vehicle is motorized save for each wheel
						local MotorizedVehicle = false;
						if vehicle.spec_motorized ~= nil then
							MotorizedVehicle = true;
						end;
						-- Run calculations for wheel
						local numWheels = table.getn(vehicle.spec_wheels.wheels);
						for WheelIndex=1,numWheels do
							-- Save wheel to local
							local wheel = vehicle.spec_wheels.wheels[WheelIndex];
							-- Update deformation
							REAwheels:UpdateDeformaton(vehicle.spec_wheels,wheel,MotorizedVehicle);
							-- If REA dynamic dirt activated check if wheel is in a lowspot with water
 							if REAwheels.DynamicDirtActivated then
								-- Get number of lowspots
								local NumOfLowspots = table.getn(WheelsUtil.LowspotWaterLevelNode);
								-- If any lowspot is created evaluate if wheel is in contact
								if NumOfLowspots > 0 then
									-- If wheel is moving update
									local MinSpeedForUpdate = 0.1;
									if vehicle:getLastSpeed() > MinSpeedForUpdate then
										-- Get if wheel is in lowspot with water
										wheel.InLowspotWithWater = REAwheels:GetIsInLowspotWithWater(wheel);
									end;
								else
									-- If no lowspots created
									wheel.InLowspotWithWater = false;
								end;
							end;
						end;
						---------------------------------
						-- Run server side code
						---------------------------------
						if g_server ~= nil then
							-- If vehicle is a powerconsumer and rolling resistance should be ignored when implement is working
							local PowerConsumerActivated = false;
							if vehicle.spec_powerConsumer ~= nil then
								if vehicle.spec_powerConsumer.forceNode ~= nil then
									PowerConsumerActivated = vehicle:doCheckSpeedLimit();
								end;
							end;
							-- Update wheels
							REAwheels:UpdateWheels(vehicle.spec_wheels,vehicle.spec_crawlers,MotorizedVehicle,PowerConsumerActivated,dt);
						end;
					end;
				end;
			end;
		end;
	end;
end;


--------------------------------------------------------------------
-- Function to set friction coefficient of dry and wet ground
--------------------------------------------------------------------
function REAwheels:SetFrictionCoeff(TireType,Groundtype,CoeffDry,CoeffFactorWet,CoeffFactorSnow)
	-- Names of tiretypes and groundtypes
	TireTypeName = {"MUD","OFFROAD","STREET","CRAWLERS"};
	GroundTypeName = {"ROAD","HARD TERRAIN","SOFT TERRAIN","FIELD"};
	-- Print original values
	print("REAwheels: Original friction coefficient for tiretype '" .. TireTypeName[TireType] .. "' on groundtype '" .. GroundTypeName[Groundtype] .. "' Dry=" .. WheelsUtil.tireTypes[TireType].frictionCoeffs[Groundtype] .. ", Wet=" .. WheelsUtil.tireTypes[TireType].frictionCoeffsWet[Groundtype] .. ", Snow=" .. WheelsUtil.tireTypes[TireType].frictionCoeffsSnow[Groundtype])
	-- Friction coefficient for dry ground
	WheelsUtil.tireTypes[TireType].frictionCoeffs[Groundtype] = CoeffDry;
	-- Friction coefficient for wet ground
	WheelsUtil.tireTypes[TireType].frictionCoeffsWet[Groundtype] = CoeffDry*CoeffFactorWet;
	-- Friction coefficient for snowy ground
	WheelsUtil.tireTypes[TireType].frictionCoeffsSnow[Groundtype] = CoeffDry*CoeffFactorSnow;
	-- Print edited values
	print("REAwheels: Edited friction coefficient for tiretype '" .. TireTypeName[TireType] .. "' on groundtype '" .. GroundTypeName[Groundtype] .. "' Dry=" .. WheelsUtil.tireTypes[TireType].frictionCoeffs[Groundtype] .. ", Wet=" .. WheelsUtil.tireTypes[TireType].frictionCoeffsWet[Groundtype] .. ", Snow=" .. WheelsUtil.tireTypes[TireType].frictionCoeffsSnow[Groundtype])
end;


-----------------------------------------------------------------------------------	
-- Function to calculate friction and add rolling resistance
-----------------------------------------------------------------------------------
function REAwheels:UpdateWheels(spec_wheels,spec_crawlers,MotorizedVehicle,PowerConsumerActivated,dt)

	-- How many wheels do the vehicle have
	local numWheels = table.getn(spec_wheels.wheels);

	-- Check if wheels added to physics
	if spec_wheels.isAddedToPhysics then

		-- Tiretypes
		local TireTypeMUD = 1;
		local TireTypeOFFROAD = 2;
		local TireTypeSTREET = 3;
		local TireTypeCRAWLER = 4;

		-- Check if crawlers present and get track length and front wheel of track
		if spec_crawlers ~= nil then
			REAwheels:GetCrawlerLength(spec_crawlers);
		end;

		-- Loop to calculate and update fricton, rolling resistance and sideway resistance for each wheel
		for Wheel=1,numWheels do
			-- Save to local variable wheel
			local wheel = spec_wheels.wheels[Wheel];
			-- Check if wheel shape is created
			if wheel.wheelShapeCreated then
				------------------------------------------------------
				-- Get the speed of wheel
				------------------------------------------------------
				-- Update speed calculated from xDrive
				REAwheels:WheelSpeedFromXdrive(wheel,dt);
				-- Update sideway speed and direction of active wheel
				REAwheels:UpdateWheelDirectionAndSpeed(wheel,dt);
				-- Update wheel distance based on xDrive
				REAwheels:WheelDistanceFromXdrive(wheel,dt);


				-- Determine type of tire based on tiretrackindex
				REAwheels:UpdateTireType(spec_wheels,wheel);
				-- Small wheels
				if wheel.WheelToSmall == nil then
					if wheel.radiusOriginal < REAwheels.MinWheelRadius then
					-- print info
						-- Wheel name
						local Name = "";
						if wheel.repr ~= nil then
							if getName(wheel.repr) ~= nil then
								Name = getName(wheel.repr);
							end;
						end;
						--Print info
						print("----------------------")
						print("Small wheel, this wheel will get limited effects by REA")
						print("Name: " .. spec_wheels:getFullName() .. ": " .. Name ..  ", Wheel size: " .. wheel.radiusOriginal * 2 .. "m , Min size: " .. REAwheels.MinWheelRadius * 2 .. "m")
						print("----------------------")					
						wheel.WheelToSmall = true;
					else
						-- Wheel will get full effect
						wheel.WheelToSmall = false;
					end;
				end;

				-- Ground types
				local ROAD = 1;
				local HARD_TERRAIN = 2;
				local SOFT_TERRAIN = 3;
				local FIELD = 4;
				-- Get ground type
				local groundType = 0;
				if wheel.densityType ~= nil and wheel.lastColor[4] ~= nil then
					local isOnField = wheel.densityType ~= 0;
					local depth = wheel.lastColor[4];
					groundType = WheelsUtil.getGroundType(isOnField, wheel.contact ~= Wheels.WHEEL_GROUND_CONTACT, depth);
				end;
				-- Read width and Radius to use when calculating frictino
				local ActWheeleWidth = wheel.width;
				local ActWheeleRadius = wheel.radiusOriginal;
				-- Read sink into the ground
				local MinWheelSink = 0.001;
				local ActWheelSink = MinWheelSink;
				if wheel.sink ~= nil then
					ActWheelSink = math.abs(math.max(wheel.sink,MinWheelSink));
				end;
				-- If REA dynamic dirt activated check if wheel is in a lowspot with water
				local WheelInLowspotWithWater = false;
				if REAwheels.DynamicDirtActivated then
					WheelInLowspotWithWater = wheel.InLowspotWithWater;
				end;

				------------------------------------------------------
				-- Calculate and update friction for wheel
				------------------------------------------------------
				local MinSpeedToUpdateFriction = 0.1;
				local MinSpeedToAddForce = MinSpeedToUpdateFriction;
				-- Calculate friction of wheel
				if MotorizedVehicle then

					------------------------------------------------------
					-- Save original friction scale
					if wheel.OrgFrictionScale == nil then
						wheel.OrgFrictionScale = wheel.frictionScale;
					end;
					-- Update friction if wheel is turning
					if wheel.SpeedBasedOnXdrive > MinSpeedToUpdateFriction then

						------------------------------------------------------
						-- Friction calculation
						local TireFriction = 0;
						if wheel.CrawlerTrackLength == nil then
							-- Friction for tires
							TireFriction = (ActWheeleWidth*2)+(ActWheeleRadius/2);
							-- If additinal wheels add more friction
							if wheel.additionalWheels ~= nil then
								local numAdditionalWheels = table.getn(wheel.additionalWheels);
								TireFriction = TireFriction+(numAdditionalWheels*(TireFriction*0.5));
							end;
						else
							-- Friction for crawlers
							TireFriction = (ActWheeleWidth*1.33)+(wheel.CrawlerTrackLength/2);
						end;

						------------------------------------------------------
						-- Sink Friction calculation
						-- Read parameters for current tiretype
						local ActWheelMaxSinkReducedFrictionPercentage = REAwheels.TireTypeMaxSinkFrictionReduced[wheel.tireType];
						local ActWheelStuckPerectangeLevel = REAwheels.TireTypeSinkStuckLevel[wheel.tireType];
						-- If wheel is in a lowspot make wheel able to get stuck
						if WheelInLowspotWithWater then
							ActWheelMaxSinkReducedFrictionPercentage = REAwheels.TireTypeMaxSinkFrictionReducedLowSpot;
							ActWheelStuckPerectangeLevel = REAwheels.TireTypeSinkStuckLevelLowSpot;
						end;
						-- Calculate sink percentage
						local ActWheelSinkPercentage = (ActWheelSink / (REAwheels.WheelRadiusMaxSinkFactor*ActWheeleRadius))*100;
						local FrictionFactorBySink = 1;

						-- Calculate reduced friction casued by sink
						if ActWheelSinkPercentage < ActWheelStuckPerectangeLevel then
							FrictionFactorBySink = 1-((ActWheelMaxSinkReducedFrictionPercentage*(ActWheelSinkPercentage/100))/100);
							-- If wheel is in a lowspot with water decrease friction
							if WheelInLowspotWithWater then
								FrictionFactorBySink = FrictionFactorBySink * 0.5;
							end;
						else
							FrictionFactorBySink = 0.05;
						end;

						------------------------------------------------------
						-- Add the calculated friction to wheel
						wheel.frictionScale = TireFriction*FrictionFactorBySink;
						-- Increase friction for small wheels
						if wheel.WheelToSmall == true then
							wheel.frictionScale = wheel.frictionScale * 2.0;
						end;
					else
						-- Use original friction when wheel is not turning
						wheel.frictionScale = wheel.OrgFrictionScale;
					end;
				else
					-- If vehicle not motorized use higher friction to avoid strange behavior when towing
					-- use default value
				end;

				------------------------------------------------------
				-- Rolling and sideway resistance for wheel
				------------------------------------------------------
				if wheel.node ~= nil and wheel.wheelShape ~= nil then
					local MinLoad = 0.01;
					-- Save load on wheel to use for rolling resistance calculation
					local ActWheelLoad = 0.000;
					if getWheelShapeContactForce(wheel.node, wheel.wheelShape) ~= nil and wheel.contact ~= Wheels.WHEEL_NO_CONTACT then
						ActWheelLoad = math.max(getWheelShapeContactForce(wheel.node, wheel.wheelShape),ActWheelLoad);
					end;
					-- Smoothe force
					if wheel.SmootheWheelLoad == nil then
						wheel.SmootheWheelLoad = 0;
					end;
					wheel.SmootheWheelLoad =  (wheel.SmootheWheelLoad*0.9)+(ActWheelLoad*0.1);

					-- Condition to add force
					if (wheel.RollingDirectionSpeed >= MinSpeedToAddForce or wheel.SideWaySpeed >= MinSpeedToAddForce) and wheel.SmootheWheelLoad >= MinLoad then
						local SidewayForceToAdd = 0;
						local RollingForceToAdd = 0;
						local MinForce = 0;

						-- Determine if this is the rear wheel of crawler track
						local CrawlerRearWheel = false;
						if wheel.CrawlerFrontWheel ~= nil and wheel.CrawlerRearWheel ~= nil then
							CrawlerRearWheel = wheel.CrawlerRearWheel;
						end;

						-- Rolling resistance in rolling direction
						------------------------------------------------------
						-- Calculate force to add
						if wheel.RollingDirectionSpeed >= MinSpeedToAddForce then
							-- If crawler rear will, use minimum sink
							if CrawlerRearWheel then
								ActWheelSink = MinWheelSink;
							end;
							-- Rolling reistance coefficient = sqrt(WheelSink(m)*((WheelRadius(m)*2)))
							-- Calculate coefficient
							local ActWheelRollConf = math.sqrt(ActWheelSink/(ActWheeleRadius*2));
							-- If coefficient to low use min value
							if ActWheelRollConf < REAwheels.TireTypeMinRollingCoeff[wheel.tireType] then
								ActWheelRollConf  = REAwheels.TireTypeMinRollingCoeff[wheel.tireType];
							end;
							-- Rolling resistance(kN) = coefficient*(Wheelload(kN)/WheelRadius(m))
							-- Calculate resistance force
							local ActWheelRollForce = math.max(ActWheelRollConf*(wheel.SmootheWheelLoad/ActWheeleRadius),MinForce);
							-- Factor of calulated force to add
							local RollingResistanceForceFactor = 0.3;
							-- Decrease rolling resistance of implement when active
							if PowerConsumerActivated then
								RollingResistanceForceFactor = RollingResistanceForceFactor * 0.3;
							end;
							-- Decrease rolling resistance of small wheels
							if wheel.WheelToSmall == true then
								RollingResistanceForceFactor = RollingResistanceForceFactor * 0.4;
							end;
							-- Calculate force with force factor
							RollingForceToAdd = ActWheelRollForce*RollingResistanceForceFactor;
							-- Add force slowly in low speed
							if wheel.RollingDirectionSpeed < 1 then
								RollingForceToAdd = RollingForceToAdd*wheel.RollingDirectionSpeed;
							end;
						end;
						-- Sideway resistance
						------------------------------------------------------
						-- Calculate force to add
						if wheel.SideWaySpeed >= MinSpeedToAddForce then
							-- Rolling reistance coefficient = sqrt(WheelSink(m)*((WheelRadius(m)*2)))
							-- Min sink depending on groundtype
							local MinSink = 0;
							if groundType == SOFT_TERRAIN then
								MinSink = 0.04;
							elseif groundType == FIELD then
								MinSink = 0.06;
							end;
							-- Calculate coefficient
							local ActWheelRollConf = math.sqrt(math.max(MinSink,ActWheelSink)/(ActWheeleRadius*2));
							-- If coefficient to low use min value
							if ActWheelRollConf < REAwheels.TireTypeMinRollingCoeff[wheel.tireType] then
								ActWheelRollConf  = REAwheels.TireTypeMinRollingCoeff[wheel.tireType];
							end;
							-- Rolling resistance(kN) = coefficient*(Wheelload(kN)/WheelRadius(m))
							-- Calculate resistance force
							local ActWheelRollForce = math.max(ActWheelRollConf*(wheel.SmootheWheelLoad/ActWheeleRadius),MinForce);
							-- In case of negative force, use zero force
							if ActWheelRollForce < 0 then
								ActWheelRollForce = 0;
							end;
							-- Factor of calulated farco to add
							local SidewayResistanceForceFactor = 1.0;
							if PowerConsumerActivated then
								SidewayResistanceForceFactor = SidewayResistanceForceFactor / 2;
							end;
							-- Calculate force with force factor
							SidewayForceToAdd = ActWheelRollForce*SidewayResistanceForceFactor;
							-- Add force slowly in low speed
							if wheel.SideWaySpeed < 1 then
								SidewayForceToAdd = SidewayForceToAdd*wheel.SideWaySpeed;
							end;
						end;
						------------------------------------------------------
						-- Add force in the other direction fo the moving direction
						local LForceX, LForceY, LForceZ = localDirectionToLocal(wheel.REASpeedNode,wheel.node,-(wheel.SideWayMovingDirection*SidewayForceToAdd),0,-(wheel.RollingMovingDirection*RollingForceToAdd));						
						local WForceX, WForceY, WForceZ = localDirectionToWorld(wheel.node,LForceX,LForceY,LForceZ);
						-- Get translation where force should be added
						local WheelX, WheelY, WheelZ = getTranslation(wheel.driveNode);
						-- Add the calculated force to physics
						addForce (wheel.node, WForceX, WForceY, WForceZ, WheelX, WheelY, WheelZ, true);

						-- DEBUG
						if REAwheels.DebugForce then
							local RollingDirection = "Rolling: D=" .. wheel.RollingMovingDirection .. " / S=" .. REAwheels:RoundValueTwoDecimals(wheel.RollingDirectionSpeed) .. " / F=" .. REAwheels:RoundValueTwoDecimals(wheel.RollingMovingDirection*RollingForceToAdd);
							local SidewayDirection = "Sideway: D=" .. wheel.SideWayMovingDirection .. " / S=" .. REAwheels:RoundValueTwoDecimals(wheel.SideWaySpeed) .. " / F=" .. REAwheels:RoundValueTwoDecimals(wheel.SideWayMovingDirection*SidewayForceToAdd);
							local Posistion = getName(wheel.repr);
							DebugUtil.drawDebugNode(wheel.REASpeedNode,Posistion .. " Sink:" .. REAwheels:RoundValueTwoDecimals(ActWheelSink) .. " " .. RollingDirection .. ", " .. SidewayDirection .. ", Load:" .. REAwheels:RoundValueTwoDecimals(wheel.SmootheWheelLoad) .. ", Fric:" .. REAwheels:RoundValueTwoDecimals(wheel.frictionScale), false)

							--local RollingDirection ="Rolling: D=" .. wheel.RollingMovingDirection .. " F=" .. REAwheels:RoundValueTwoDecimals(-(wheel.RollingMovingDirection*RollingForceToAdd)) .. " S=" .. REAwheels:RoundValueTwoDecimals(wheel.RollingDirectionSpeed)
							--local SidewayDirection ="Sideway: D=" .. wheel.SideWayMovingDirection .. " F=" .. REAwheels:RoundValueTwoDecimals(-(wheel.SideWayMovingDirection*SidewayForceToAdd)) .. " S=" .. REAwheels:RoundValueTwoDecimals(wheel.SideWaySpeed)
							--local Nothing,TireTypeName = REAwheels:DetermineTireType(wheel.tireTrackAtlasIndex);
							--DebugUtil.drawDebugNode(wheel.repr,"Max/Act: " .. wheel.maxDeformation .. " / " .. REAwheels:RoundValueTwoDecimals(wheel.deformation) .. " " .. RimRadius, false)
							--DebugUtil.drawDebugNode(wheel.repr,"Org/New: " .. REAwheels:RoundValueTwoDecimals(wheel.OrgFrictionScale) .. " / " .. REAwheels:RoundValueTwoDecimals(wheel.frictionScale) .. " " .. TireTypeName, false)
						end;
					end;
				end;
			end;
		end;
	end;
end;


-----------------------------------------------------------------------------------	
-- Function to determine which tireType based on tireTrackAtlasIndex
-----------------------------------------------------------------------------------
function REAwheels:DetermineTireType(tireTrackAtlasIndex)
	-- Constants to use for each tireTypeName
	local TireTypeMUD = "mud";
	local TireTypeOFFROAD = "offRoad";
	local TireTypeSTREET = "street";
	local TireTypeCRAWLER = "crawler";
	-- Value to return
	local tireTypeName = TireTypeMUD;
	-- Check tiretrackindex to see if value present
	if tireTrackAtlasIndex ~= nil then
		-- Check number to determine which tiretypename
		if tireTrackAtlasIndex == 0 then
			tireTypeName = TireTypeMUD;
		elseif tireTrackAtlasIndex == 1 then
			tireTypeName = TireTypeSTREET;
		elseif tireTrackAtlasIndex == 2 then
			tireTypeName = TireTypeOFFROAD;
		elseif tireTrackAtlasIndex == 3 then
			tireTypeName = TireTypeOFFROAD;
		elseif tireTrackAtlasIndex == 4 then
			tireTypeName = TireTypeSTREET;
		elseif tireTrackAtlasIndex == 5 then
			tireTypeName = TireTypeCRAWLER;
		elseif tireTrackAtlasIndex == 6 then
			tireTypeName = TireTypeCRAWLER;
		elseif tireTrackAtlasIndex == 7 then
			tireTypeName = TireTypeCRAWLER;
		elseif tireTrackAtlasIndex == 8 then
			tireTypeName = TireTypeSTREET;
		elseif tireTrackAtlasIndex == 9 then
			tireTypeName = TireTypeMUD;
		elseif tireTrackAtlasIndex == 10 then
			tireTypeName = TireTypeOFFROAD;
		elseif tireTrackAtlasIndex == 11 then
			tireTypeName = TireTypeOFFROAD;
		elseif tireTrackAtlasIndex == 12 then
			tireTypeName = TireTypeOFFROAD;
		elseif tireTrackAtlasIndex == 13 then
			tireTypeName = TireTypeCRAWLER;
		elseif tireTrackAtlasIndex == 14 then
			-- Not used
			tireTypeName = TireTypeMUD;
		elseif tireTrackAtlasIndex == 15 then
			-- Not used
			tireTypeName = TireTypeMUD;
		else
			tireTypeName = TireTypeMUD;
		end
		-- Return tireType
		return WheelsUtil.getTireType(tireTypeName),tireTypeName;
	end
	-- Return tireType
	return 0,"Nothing found";
end


-----------------------------------------------------------------------------------	
-- Function to round value, delete decimals
-----------------------------------------------------------------------------------
function REAwheels:RoundValue(x)
	return x>=0 and math.floor(x+0.5) or math.ceil(x-0.5)
end


-----------------------------------------------------------------------------------	
-- Function to round value with two decimals
-----------------------------------------------------------------------------------
function REAwheels:RoundValueTwoDecimals(x)
	x = x*100;
	x = x>=0 and math.floor(x+0.5) or math.ceil(x-0.5);
	x = x/100;
	return x;
end


-----------------------------------------------------------------------------------	
-- Function to update tiretype based on tiretypeindex
-----------------------------------------------------------------------------------
function REAwheels:GetCrawlerLength(spec_crawlers)
	-- Get number of crawlers
	for _,crawler in pairs(spec_crawlers.crawlers) do
		local CrawlerNumWheels = table.getn(crawler.wheels);	
		if CrawlerNumWheels > 1 then
			-- Check connected wheels
			for _,CrawlerWheel in pairs(crawler.wheels) do
				local wheel = CrawlerWheel.wheel;
				local LongestDistance = 0;
				local DistanceOnVehicle;
				local FrontWheelRepr;
				for _,OtherCrawlerWheel in pairs(crawler.wheels) do
					local OtherWheel = OtherCrawlerWheel.wheel;
					-- Get longest distance
					local Dx, Dy, Dz = localToLocal(wheel.repr, OtherWheel.repr, 0, 0, 0)
					if math.abs(Dz) > LongestDistance then
						LongestDistance = math.abs(Dz);
					end;
					-- Determine if this is the front crawler wheel
					local Px, Py, Pz = localToLocal(OtherWheel.repr, OtherWheel.node, 0, 0, 0)
					if DistanceOnVehicle == nil then
						DistanceOnVehicle = Pz;
						FrontWheelRepr = OtherWheel.repr;
					else
						if Pz > DistanceOnVehicle then
							DistanceOnVehicle = Pz;
							FrontWheelRepr = OtherWheel.repr;
						end;
					end;
				end;
				-- Save lenght of track
				wheel.CrawlerTrackLength = LongestDistance;
				-- Check if this is the front wheel
				if wheel.repr == FrontWheelRepr then
					wheel.CrawlerFrontWheel = true;
					wheel.CrawlerRearWheel = false;
				else
					wheel.CrawlerFrontWheel = false;
					wheel.CrawlerRearWheel = true;
				end;
			end;
		end;
	end;
end;

-----------------------------------------------------------------------------------	
-- Function to update tiretype based on tiretypeindex
-----------------------------------------------------------------------------------
function REAwheels:UpdateTireType(spec_wheels,wheel)
	if wheel.TireTypeCheckedByREA == nil then
		local TireTypeCRAWLER = 4;
		-- Wheel name
		local Name = "";
		if wheel.repr ~= nil then
			if getName(wheel.repr) ~= nil then
				Name = getName(wheel.repr);
			end;
		end;
		-- Get tiretype based on tiretrackatlasindex
		local TireTypeBasedOnTireTrackIndex,TireTypeName = REAwheels:DetermineTireType(wheel.tireTrackAtlasIndex);				
		if TireTypeBasedOnTireTrackIndex ~= nil then
			if TireTypeBasedOnTireTrackIndex ~= wheel.tireType and not wheel.tireType == TireTypeCRAWLER then
				-- Check if tiretrackindex present
				local OriginalTireType = wheel.tireType;
				local OriginalTireTypeName = WheelsUtil.tireTypes[OriginalTireType].name;
				wheel.tireType = TireTypeBasedOnTireTrackIndex;
				--Print info
				print("----------------------")
				print("REA changed tiretype")
				print("Name: " .. spec_wheels:getFullName() .. ": " .. Name ..  ", Original tiretype: " .. OriginalTireType .. "=" .. OriginalTireTypeName .. ", new tiretype: " .. TireTypeBasedOnTireTrackIndex .. "=" .. TireTypeName)
				print("----------------------")					
			end
		else
			--Print info
			print("----------------------")
			print("No tiretype could be determined by REA")
			print("Name: " .. spec_wheels:getFullName() .. ": " .. Name)
			print("----------------------")
		end;
		-- Save status to avoid check every cycle
		wheel.TireTypeCheckedByREA = true;
	end
end;

-----------------------------------------------------------------------------------	
-- Function to update max deformation
-----------------------------------------------------------------------------------
function REAwheels:UpdateDeformaton(spec_wheels,wheel,MotorizedVehicle)
	-- Update deformation of tire
	if wheel.TireDeformationCheckedByREA == nil and wheel.tireType ~= TireTypeCRAWLER and wheel.outerRimWidthAndDiam ~= nil then
		if wheel.outerRimWidthAndDiam[2] ~= nil then
			-- Wheel name
			local Name = "";
			if wheel.repr ~= nil then
				if getName(wheel.repr) ~= nil then
					Name = getName(wheel.repr);
				end;
			end;
			-- Save original deformation
			local OriginalDeformation = wheel.maxDeformation;
			local MaxDeformationFactorMotorized = 0.3;
			local MaxDeformationFactorTools = 0.15;
			local MaxDeformationFactor = 0;
			if MotorizedVehicle then
				MaxDeformationFactor = MaxDeformationFactorMotorized;
			else
				MaxDeformationFactor = MaxDeformationFactorTools;
			end;
			-- Calculate rim size and tire thickness
			local RimRadius = ((wheel.outerRimWidthAndDiam[2] * 2.54) / 100) / 2;
			local TireThickness = wheel.radiusOriginal - RimRadius;
			-- Calculate factor of max deformation
			local DeformationFactor = (TireThickness - wheel.width) + 1;
			-- Calculate new deformation
			local NewDeformation = TireThickness * math.min(MaxDeformationFactor,MaxDeformationFactor*DeformationFactor);
			-- Update deformation
			if NewDeformation > OriginalDeformation then
				wheel.maxDeformation = NewDeformation;
			end;
			wheel.TireDeformationCheckedByREA = true;
		else
			wheel.TireDeformationCheckedByREA = true;
		end;
	else
		wheel.TireDeformationCheckedByREA = true;
	end;
end


-----------------------------------------------------------------------------------	
-- Function to get wheelslip
-----------------------------------------------------------------------------------
function REAwheels:GetWheelSlipFactor(WheelSpeed,VehicleSpeed)
	local WheelSlip = 0;
	if WheelSpeed > 1 then
		-- Calculate differance
		local SpeedDiff = math.abs(VehicleSpeed - WheelSpeed);
		if SpeedDiff > 1 and VehicleSpeed < WheelSpeed then
			-- Calculate slip
			WheelSlip = REAwheels:RoundValueTwoDecimals(SpeedDiff / WheelSpeed);
		end;
	end;
	return MathUtil.clamp(WheelSlip, 0, 1);
end


-----------------------------------------------------------------------------------	
-- Function to get if wheel is on soft ground
-----------------------------------------------------------------------------------
function REAwheels:GetOnSoftGround(wheel)
	-- Get ground type
	local groundType = 0;
	if wheel.lastColor[4] ~= nil then
		local isOnField = false;
		local isOnRoad = false;
		local depth = wheel.lastColor[4];
		groundType = WheelsUtil.getGroundType(isOnField, isOnRoad, depth);
	end;
	local WheelIsOnSoftGround = false;
	if (groundType == 3 or groundType == 4) or (wheel.lastTerrainValue > 0 and wheel.lastTerrainValue < 5) then
		WheelIsOnSoftGround = true;
	end;
	return WheelIsOnSoftGround;
end


-----------------------------------------------------------------------------------	
-- Function to determine if wheel is in a lowspot with
-----------------------------------------------------------------------------------
function REAwheels:GetIsInLowspotWithWater(Wheel)
	-- Get translation of wheel
	local WheelX, WheelY, WheelZ = getWorldTranslation(Wheel.driveNode);
	-- Get number of lowspots
	local NumOfLowspots = table.getn(WheelsUtil.LowspotWaterLevelNode);
	-- Loop to calculate and update fricton, rolling resistance and sideway resistance for each wheel
	for LowSpot=1,NumOfLowspots do
		-- Get depth of first lospot to determine if water in low spots
		local lX, WaterLevel, lZ = getTranslation(WheelsUtil.LowspotWaterLevelNode[LowSpot]);
		-- Check if there is water in lowspots
		if WaterLevel > 0 then
			-- Get distance betweene wheel and lowspot
			local LowspotX, LowspotY, LowspotZ = getWorldTranslation(WheelsUtil.LowspotRootNode[LowSpot]);
			-- Calculate distance
			local DistanceX = math.abs(WheelX-LowspotX);
			local DistanceY = math.abs(WheelY-LowspotY);
			local DistanceZ = math.abs(WheelZ-LowspotZ);
			-- Determine if the wheel in range of lowspot
			if DistanceX <= WheelsUtil.LowspotSize[LowSpot] and DistanceZ <= WheelsUtil.LowspotSize[LowSpot] then
				-- Check if wheel is below waterlevel
				if (DistanceY - WaterLevel) - Wheel.radiusOriginal <= 0 then
					return true;
				end;
			end;
		else
			return false;
		end;
	end;
	return false;
end


-----------------------------------------------------------------------------------	
-- Function to smoothe value
-----------------------------------------------------------------------------------
function REAwheels:SmootheValue(SmoothedValue,RealValue)
	-- If no smoothevalue use the real value
	if SmoothedValue == nil then
		ActValue = RealValue;
	else
		ActValue = SmoothedValue;
	end;
	-- Return the smoothed value
	return (ActValue*0.9)+(RealValue*0.1);
end


-----------------------------------------------------------------------------------	
-- Function to calculate speed based on xDrive(wheel position)
-----------------------------------------------------------------------------------
function REAwheels:WheelSpeedFromXdrive(wheel,dt)
	-- initialize last xDrive
	if wheel.xDriveLast == nil then
		wheel.xDriveLast = 0;
		wheel.xDriveLastKMH = 0;
		wheel.xDriveDirection = 0;
		wheel.xDriveLastDirection = 0;
		wheel.xDriveSignedSpeedSmoothed = 0;
	end;
	-- Get differance from last call
	local RadDiff = wheel.netInfo.xDrive - wheel.xDriveLast;
	-- Save last xDrive
	wheel.xDriveLast = wheel.netInfo.xDrive;
	-- If wheel starts a new turn assume that the speed is constant and return last calulated speed
	if math.abs(RadDiff) > 3.14 then
		-- Return speed in KMH
		wheel.SpeedBasedOnXdrive = wheel.xDriveLastKMH;
		wheel.DirectionBasedOnXdrive = wheel.xDriveLastDirection;
	-- If not a new turn calculate a neww speed
	else
		-- Calculate speed
		local DistanceTraveled = REAwheels:RoundValueTwoDecimals(RadDiff * wheel.radiusOriginal);
		local MeterPerSecond = DistanceTraveled/(dt/1000);
		-- Convert to KMH
		local WheelSpeedSigned = MeterPerSecond*3.6;
		-- Smoothe value
		wheel.xDriveSignedSpeedSmoothed =  (wheel.xDriveSignedSpeedSmoothed*0.7)+(WheelSpeedSigned*0.3);
		-- Save direction of wheel rotation
		local WheelSpeedSignedSmoothed = wheel.xDriveSignedSpeedSmoothed;
		local WheelSpeedSmoothed = math.abs(WheelSpeedSignedSmoothed);
		local MinSpeedForUpdate = 0.25;
		if WheelSpeedSmoothed >= MinSpeedForUpdate then
			if WheelSpeedSignedSmoothed > 0 then
				wheel.xDriveDirection = 1;
			elseif WheelSpeedSignedSmoothed < 0 then
				wheel.xDriveDirection = -1;
			end;
		elseif WheelSpeedSmoothed < MinSpeedForUpdate then
			wheel.xDriveDirection = 0;
			wheel.xDriveSignedSpeedSmoothed = 0;
		end;
		-- Save speed if wheel starts a new turn
		wheel.xDriveLastKMH = WheelSpeedSmoothed;
		wheel.xDriveLastDirection = wheel.xDriveDirection;
		-- Return speed in KMH
		wheel.SpeedBasedOnXdrive = WheelSpeedSmoothed;
		wheel.DirectionBasedOnXdrive = wheel.xDriveDirection;
	end;
end


-----------------------------------------------------------------------------------	
-- Function to calculate expected and actual moved distance of wheel 
-----------------------------------------------------------------------------------
function REAwheels:WheelDistanceFromXdrive(wheel,dt)
	-- initialize last xDrive
	if wheel.DistancexDriveLast == nil then
		wheel.DistanceLastPosition = {0,0,0};
		wheel.DistancexDriveLast = 0;
	end;
	-- Get position of wheel
	local x,y,z = getWorldTranslation(wheel.repr);
	-- Calculate differance in position from last call
	local dx, dy, dz = worldDirectionToLocal(wheel.repr, x-wheel.DistanceLastPosition[1], y-wheel.DistanceLastPosition[2], z-wheel.DistanceLastPosition[3]);
	-- Save position for next call
	wheel.DistanceLastPosition[1], wheel.DistanceLastPosition[2], wheel.DistanceLastPosition[3] = x, y, z;

	-- Get differance from last call
	local RadDiff = math.abs(wheel.DistancexDriveLast - wheel.netInfo.xDrive);
	-- Save last xDrive
	wheel.DistancexDriveLast = wheel.netInfo.xDrive;
	-- If wheel starts a new turn assume no change and return zero change
	if RadDiff > 3.14 then
		wheel.ExpectedDistanceTraveled = 0;
		wheel.ActualDistanceTraveled = 0;
	-- If not a new turn calculate distance traveled
	else
		-- Calculate expected moved distance
		wheel.ExpectedDistanceTraveled = RadDiff * wheel.radiusOriginal;
		wheel.ActualDistanceTraveled = MathUtil.vector3Length(dx, dy, dz)
	end;
end


-----------------------------------------------------------------------------------	
-- Calculate sideway speed of wheel
-----------------------------------------------------------------------------------
function REAwheels:UpdateWheelDirectionAndSpeed(wheel,dt)
	-- Create node to calculate speed and direction
	if wheel.REASpeedNode == nil then
		local REASpeedNode = createTransformGroup("REASpeedNode")
		link(wheel.node, REASpeedNode);
		setTranslation(REASpeedNode, localToLocal(wheel.repr,wheel.node,0,0,0));
		setRotation(REASpeedNode,0,0,0);
		setScale(REASpeedNode, 1, 1, 1)
		wheel.REASpeedNode = REASpeedNode;
	end;
	-- Update steeting angle of wheel
	if wheel.steeringAngle ~= 0 then 
		setRotation(wheel.REASpeedNode,0,wheel.steeringAngle,0);
	end;

	-- Calculate speed based on the position change
	local x,y,z = getWorldTranslation(wheel.REASpeedNode);
	if wheel.REASpeedLastPosition == nil then
		wheel.REASpeedLastPosition = {x,y,z};
	end;
	local SpeedDiffX, SpeedDiffY, SpeedDiffZ = worldDirectionToLocal(wheel.REASpeedNode, x-wheel.REASpeedLastPosition[1], y-wheel.REASpeedLastPosition[2], z-wheel.REASpeedLastPosition[3]);
	wheel.REASpeedLastPosition[1], wheel.REASpeedLastPosition[2], wheel.REASpeedLastPosition[3] = x, y, z;

	-- Rolling direction, calculate speed of wheel in direction
	wheel.RollingDirectionSpeed, wheel.RollingDirectionSpeedSigned, wheel.RollingMovingDirection = REAwheels:CalcSpeedAndDirection(wheel.RollingDirectionSpeedSigned,SpeedDiffZ,dt);
	-- SideWay direction, calculate speed of wheel in direction
	wheel.SideWaySpeed, wheel.SideWaySpeedSigned, wheel.SideWayMovingDirection = REAwheels:CalcSpeedAndDirection(wheel.SideWaySpeedSigned,SpeedDiffX,dt);

end;


-----------------------------------------------------------------------------------	
-- Function to calculate speed and direcrtion based on movement
-----------------------------------------------------------------------------------
function REAwheels:CalcSpeedAndDirection(LastSpeedSigned,MovedDistance,dt)
	-- Calculate speed of wheel
	local SpeedSigned = (MovedDistance / dt)*3600;
	local SpeedSignedSmoothe = REAwheels:SmootheValue(LastSpeedSigned,SpeedSigned)
	local Speed = SpeedSignedSmoothe;
	-- Remove sign
	if Speed < 0 then
		Speed = Speed*(-1); 
	end;
	-- Moving direction
	local MovingDirection = 0;
	if SpeedSigned > 0.01 then
		MovingDirection = 1;
	elseif SpeedSigned < -0.01 then
		MovingDirection = -1;
	end;
	-- Return result
	return Speed, SpeedSignedSmoothe, MovingDirection;
end


-----------------------------------------------------------------------------------	
-- Edited update wheel sink
-----------------------------------------------------------------------------------
function REAwheels:REAupdateWheelSink(wheel, dt, groundWetness)
    if wheel.supportsWheelSink then
        if self.isServer and self.isAddedToPhysics then
            local spec = self.spec_wheels

            local maxSink = wheel.maxWheelSink
            local sinkTarget = wheel.sinkTarget
            local interpolationFactor = 1

			-----------------------------------------
			-- REA 
			-- Get wheel speed
			local WheelSpeed = 0;
			if wheel.RollingDirectionSpeed ~= nil and wheel.SideWaySpeed ~= nil and wheel.SpeedBasedOnXdrive ~= nil then
				WheelSpeed = math.max(wheel.RollingDirectionSpeed, wheel.SideWaySpeed, wheel.SpeedBasedOnXdrive);
			else
				WheelSpeed = self:getLastSpeed();
			end;
			-- Init smoothe NoiseValue
			if wheel.NoiseValueSmoothed == nil then
				wheel.NoiseValueSmoothed = 0;
			end
			-- Sink update min speed
			local MinWheelSpeed = 0.1
			-----------------------------------------

            if wheel.contact ~= Wheels.WHEEL_NO_CONTACT and WheelSpeed >= MinWheelSpeed then
                local x, _, z = getWorldTranslation(wheel.repr)

                local noiseValue = 0;
				local loadFactor = 1;
                if wheel.densityType > 0 then
                    -- Round to 1cm to avoid sliding when not moving
                    local xPerlin = math.floor(x*100)*0.01
                    local zPerlin = math.floor(z*100)*0.01

                    local perlinNoise = Wheels.perlinNoiseSink
                    local noiseSink = 0.5 * (1 + getPerlinNoise2D(xPerlin*perlinNoise.randomFrequency, zPerlin*perlinNoise.randomFrequency, perlinNoise.persistence, perlinNoise.numOctaves, perlinNoise.randomSeed))

                    perlinNoise = Wheels.perlinNoiseWobble
                    local noiseWobble = 0.5 * (1 + getPerlinNoise2D(xPerlin*perlinNoise.randomFrequency, zPerlin*perlinNoise.randomFrequency, perlinNoise.persistence, perlinNoise.numOctaves, perlinNoise.randomSeed))

                    -- estimiate pressure on surface
                    local gravity = 9.81
                    local tireLoad = getWheelShapeContactForce(wheel.node, wheel.wheelShape)
                    if tireLoad ~= nil then
                        local nx,ny,nz = getWheelShapeContactNormal(wheel.node, wheel.wheelShape)
                        local dx,dy,dz = localDirectionToWorld(wheel.node, 0,-1,0)
                        tireLoad = -tireLoad*MathUtil.dotProduct(dx,dy,dz, nx,ny,nz)
                        tireLoad = tireLoad + math.max(ny*gravity, 0.0) * wheel.mass -- add gravity force of tire
                    else
                        tireLoad = 0
                    end
                    tireLoad = tireLoad / gravity

					-----------------------------------------
					-- REA 
					-- Get size of wheel surface
					local WheelWidth = wheel.width;
					-- Tires
					if wheel.CrawlerTrackLength == nil then
						-- If additinal wheels add more friction
						if wheel.additionalWheels ~= nil then
							local numAdditionalWheels = table.getn(wheel.additionalWheels);
							for AddWheel=1,numAdditionalWheels do
								-- Add width off additional wheels
								WheelWidth = WheelWidth + (wheel.additionalWheels[AddWheel].width * 0.75);
							end;
						end;
					-- Crawlers
					else
						WheelWidth = WheelWidth+(wheel.CrawlerTrackLength/2);
					end;
					-- Calculate loadfactor
					loadFactor = MathUtil.clamp((tireLoad / WheelWidth) / 5 ,0 , 1);
 
					-- If REA dynamic dirt is loaded and wheel in standing
					local wetnessFactor = groundWetness;
					if REAwheels.DynamicDirtActivated and wheel.InLowspotWithWater then
						wetnessFactor = 1;
					end;

					local MinSinkFactor = loadFactor + wetnessFactor;
					noiseValue = (0.4*MinSinkFactor)+(0.6*noiseWobble);

					-- DEBUG
					if REAwheels.DebugSink then
						local OriginalLoadFactor = math.min(1.0, math.max(0, tireLoad / wheel.maxLatStiffnessLoad))
						--DebugUtil.drawDebugNode(wheel.driveNode,"Wetness: " .. REAwheels.GroundWetnessFactor, false)
						DebugUtil.drawDebugNode(wheel.driveNode,"Tireload: " .. REAwheels:RoundValueTwoDecimals(tireLoad) .. ", loadFactor new/org : " .. REAwheels:RoundValueTwoDecimals(loadFactor) .. " / " .. REAwheels:RoundValueTwoDecimals(OriginalLoadFactor) .. ", total width: " .. REAwheels:RoundValueTwoDecimals(WheelWidth) .. ", Friction scale: " .. REAwheels:RoundValueTwoDecimals(wheel.frictionScale) .. ", NoiseValue: " .. REAwheels:RoundValueTwoDecimals(wheel.NoiseValueSmoothed) .. ", Wheelspeed: " .. REAwheels:RoundValueTwoDecimals(WheelSpeed), false)
					end;
					-----------------------------------------
                end

				-- Smoothe noise value
				if noiseValue > 0 then
					wheel.NoiseValueSmoothed = (wheel.NoiseValueSmoothed*0.4)+(noiseValue*0.6);
				else
					wheel.NoiseValueSmoothed = 0;
				end;

                maxSink = Wheels.MAX_SINK[wheel.densityType] or maxSink
				
				-----------------------------------------
				-- REA 
				local WheelRadiusMaxSink = REAwheels.WheelRadiusMaxSinkFactor*wheel.radiusOriginal;
				-----------------------------------------

                -- plowing effect
                if wheel.densityType == FieldGroundType.PLOWED and wheel.oppositeWheelIndex ~= nil then
                    local oppositeWheel = spec.wheels[wheel.oppositeWheelIndex]
                    if oppositeWheel.densityType ~= nil and oppositeWheel.densityType ~= FieldGroundType.PLOWED then
                        maxSink = maxSink * 1.3
                    end
                end

				-----------------------------------------
				-- REA 
				------------------------------------------------------
				-- Sink from spinning the wheel
				------------------------------------------------------
				-- initialize sink from spinning the wheel without movement
				if wheel.SinkFromSpinning == nil then
					wheel.SinkFromSpinning = 0;
				end;
				-- Get expected and actual moved distance for wheel
				local ExpectedDistance = wheel.ExpectedDistanceTraveled;
				local ActualDistance = wheel.ActualDistanceTraveled;
				-- Increas sink
				if wheel.contact ~= Wheels.WHEEL_NO_CONTACT and REAwheels:GetOnSoftGround(wheel) then
					if ExpectedDistance > ActualDistance then
						-- If sink has not reached the limit add more sink
						if wheel.SinkFromSpinning >= WheelRadiusMaxSink then
							-- Max sink reached
							wheel.SinkFromSpinning = WheelRadiusMaxSink;
						else
							-- Constant for sink per meter
							local AddSinkPerMeter = REAwheels.TireTypeSinkPerMeterSpinning[wheel.tireType];
							-- Factor by load
							local MinSpinLoadFactor = 0.5;
							local SpinLoadFactor = MathUtil.clamp(loadFactor*2, MinSpinLoadFactor, 1)
							-- Lower sink when not in field
							if wheel.densityType == WheelsUtil.GROUND_FIELD then
								AddSinkPerMeter = AddSinkPerMeter * 1;
							elseif wheel.densityType == WheelsUtil.GROUND_SOFT_TERRAIN then
								AddSinkPerMeter = AddSinkPerMeter * 0.7;
							elseif wheel.densityType == WheelsUtil.GROUND_HARD_TERRAIN then
								AddSinkPerMeter = AddSinkPerMeter * 0.5;
							else
								AddSinkPerMeter = AddSinkPerMeter * 1;
							end;
							-- Calculate sink by spinning
							local DistanceDiff = ExpectedDistance - ActualDistance;
							local SinkToAddFromSpinning = DistanceDiff * (AddSinkPerMeter * SpinLoadFactor);
							-- Increase sink when low
							local ExtraSinkFromSpinningFactor = 1;
							if wheel.SinkFromSpinning < (WheelRadiusMaxSink/2) and wheel.SinkFromSpinning > 0 then
								ExtraSinkFromSpinningFactor = 2 - (wheel.SinkFromSpinning / (WheelRadiusMaxSink/2));
							end;
							-- Add sink
							wheel.SinkFromSpinning = math.min(wheel.SinkFromSpinning + (SinkToAddFromSpinning * ExtraSinkFromSpinningFactor),WheelRadiusMaxSink);
						end;
					end;
				end;
				-- Decrease sink
				if wheel.SinkFromSpinning > 0 then
					-- Calculate how much sink should be lowered
					local MinDecreaseSinkPerMeter = 0.3;
					-- Decrease sink by rolling the wheel
					if ActualDistance > 0 then
						wheel.SinkFromSpinning = wheel.SinkFromSpinning - (ActualDistance * MinDecreaseSinkPerMeter);
					end;
					if wheel.SinkFromSpinning < 0 then
						wheel.SinkFromSpinning = 0;
					end;
				end;
				-- Sinktarget
				local sinkTargetNoise = math.min(0.2*wheel.radiusOriginal, math.min(maxSink, wheel.maxWheelSink) * wheel.NoiseValueSmoothed);

                sinkTarget = math.min(wheel.SinkFromSpinning+sinkTargetNoise, WheelRadiusMaxSink);
				-----------------------------------------

            elseif wheel.contact == Wheels.WHEEL_NO_CONTACT then
                sinkTarget = 0
                interpolationFactor = 0.05 -- smoother interpolation back to normal radius in case we directly sink again after having ground contact -> this avoid jittering
            end

            if wheel.sinkTarget < sinkTarget then
                wheel.sinkTarget = math.min(sinkTarget, wheel.sinkTarget + (0.05 * math.min(30, math.max(0, WheelSpeed-0.2)) * (dt/1000) * interpolationFactor))
            elseif wheel.sinkTarget > sinkTarget then
                wheel.sinkTarget = math.max(sinkTarget, wheel.sinkTarget - (0.05 * math.min(30, math.max(0, WheelSpeed-0.2)) * (dt/1000) * interpolationFactor))
            end

            if math.abs(wheel.sink - wheel.sinkTarget) > 0.001 then
                wheel.sink = wheel.sinkTarget

                local radius = wheel.radiusOriginal - wheel.sink
                if radius ~= wheel.radius then
                    wheel.radius = radius
                    if self.isServer then
                        self:setWheelPositionDirty(wheel)

                        local sinkFactor = (wheel.sink/maxSink) * (1 + (0.4 * groundWetness))
                        wheel.sinkLongStiffnessFactor = (1.0 - (0.10 * sinkFactor))
                        wheel.sinkLatStiffnessFactor  = (1.0 - (0.20 * sinkFactor))
                        self:setWheelTireFrictionDirty(wheel)
                    end
                end
            end
        end
    end
end


-----------------------------------------------------------------------------------	
-- Edited onUpdateTick
-----------------------------------------------------------------------------------
function REAwheels:REAonUpdateTick(dt, isActiveForInput, isActiveForInputIgnoreSelection, isSelected)
    local spec = self.spec_wheels
    for _, wheel in pairs(spec.wheels) do
        if wheel.rotSpeedLimit ~= nil then
            local dir = -1
            if self:getLastSpeed() <= wheel.rotSpeedLimit then
                dir = 1
            end
            wheel.currentRotSpeedAlpha = MathUtil.clamp(wheel.currentRotSpeedAlpha + dir*(dt/1000), 0, 1)
            wheel.rotSpeed    = wheel.rotSpeedDefault * wheel.currentRotSpeedAlpha
            wheel.rotSpeedNeg = wheel.rotSpeedNegDefault * wheel.currentRotSpeedAlpha
        end
    end
    if self.isClient then
        local groundWetness = REAwheels.GroundWetnessFactor;
        local groundIsWet = groundWetness > 0.15
        for _,wheel in pairs(spec.wheels) do
            if wheel.driveGroundParticleSystems ~= nil then

                local states = wheel.driveGroundParticleStates
                local enableSoilPS = false

				-- Get speed and direction from wheel
                local wheelSpeed = 0;
                local wheelActualSpeed = 0;
                local wheelDirection = 0;
				local wheelSlip = 0;
				local MinSpeed = 0.5;
				if wheel.SpeedBasedOnXdrive ~= nil and wheel.RollingDirectionSpeed ~= nil then
					wheelActualSpeed = wheel.RollingDirectionSpeed;
					wheelDirection = wheel.DirectionBasedOnXdrive;
					wheelSpeed = wheel.SpeedBasedOnXdrive;
					-- Get slip factor
					wheelSlip = REAwheels:GetWheelSlipFactor(wheelSpeed,wheelActualSpeed);
				end;

				-- Get wheel sink
				local WheelSink = REAwheels:GetWheelSinkClientSide(wheel);

				-- Enable soil particles
				if (wheel.lastTerrainValue > 0 and wheel.lastTerrainValue < 5) or (wheelSlip > 0.05 and REAwheels:GetOnSoftGround(wheel)) then
					enableSoilPS = wheelDirection ~= 0;
                end

				-- Save wheel direction and use REA wheel direction
				local OriginalWheelDirecton = self.movingDirection;
				self.movingDirection = wheelDirection;

                local sizeScale = 2 * wheel.width * wheel.radiusOriginal
                states.driving_dry = enableSoilPS
                states.driving_wet = enableSoilPS and groundIsWet
                states.driving_dust = not groundIsWet
                for psName, state in pairs(states) do
                    local typedPs = wheel.driveGroundParticleSystems[psName]
                    for _, ps in ipairs(typedPs) do
                        if state and wheelDirection ~= 0 then
                            if self.movingDirection < 0 then
                                setRotation(ps.emitterShape, 0, math.pi+wheel.steeringAngle, 0)
                            else
                                setRotation(ps.emitterShape, 0, wheel.steeringAngle, 0)
                            end
                            local scale
                            if psName ~= "driving_dust" then
                                scale = self:getDriveGroundParticleSystemsScale(ps, math.min(wheelSpeed,50)) * math.min(wheelSlip * 20,1)
								-- Compensate for wheel sink
								ps.offsets[2] = WheelSink*0.7;
								ps.offsets[3] = ((WheelSink*0.7)*wheelDirection)*(-1);
                            else
                                scale = self:getDriveGroundParticleSystemsScale(ps, self.lastSpeedReal)
                            end
 
							if ps.isTintable then
                                -- interpolate between different ground colors to avoid unrealisitic particle color changes
                                if ps.lastColor == nil then
                                    ps.lastColor = {ps.wheel.lastColor[1],ps.wheel.lastColor[2],ps.wheel.lastColor[3]}
                                    ps.targetColor = {ps.wheel.lastColor[1],ps.wheel.lastColor[2],ps.wheel.lastColor[3]}
                                    ps.currentColor = {ps.wheel.lastColor[1],ps.wheel.lastColor[2],ps.wheel.lastColor[3]}
                                    ps.alpha = 1
                                end
                                if ps.alpha ~= 1 then
                                    ps.alpha = math.min(ps.alpha + dt/1000, 1)
                                    ps.currentColor = {MathUtil.vector3ArrayLerp(ps.lastColor, ps.targetColor, ps.alpha)}
                                    if ps.alpha == 1 then
                                        ps.lastColor[1] = ps.currentColor[1]
                                        ps.lastColor[2] = ps.currentColor[2]
                                        ps.lastColor[3] = ps.currentColor[3]
                                    end
                                end
                                if ps.alpha == 1 and ps.wheel.lastColor[1] ~= ps.targetColor[1] and ps.wheel.lastColor[2] ~= ps.targetColor[2] and ps.wheel.lastColor[3] ~= ps.targetColor[3] then
                                    ps.alpha = 0
                                    ps.targetColor[1] = ps.wheel.lastColor[1]
                                    ps.targetColor[2] = ps.wheel.lastColor[2]
                                    ps.targetColor[3] = ps.wheel.lastColor[3]
                                end
                            end
                            if scale > 0 then
                                ParticleUtil.setEmittingState(ps, true)
                                if ps.isTintable then
                                    setShaderParameter(ps.shape, "psColor", ps.currentColor[1], ps.currentColor[2], ps.currentColor[3], 1, false)
                                end
                            else
                                ParticleUtil.setEmittingState(ps, false)
                            end
                            -- emit count
                            local maxSpeed = 50
                            local circum = wheel.radiusOriginal
                            local maxWheelRpm = maxSpeed / circum
							local WheelFactorMin = 0.01;
							local WheelFactorMax = 1.0;
							local wheelRotFactor = MathUtil.clamp(wheelSpeed/maxSpeed,WheelFactorMin,WheelFactorMax);
                            local emitScale = scale * wheelRotFactor * sizeScale
                            if psName ~= "driving_dust" then
								-- If dynamic dirt is activated get if wheel is located inside a lowspot with water
								local WheelInLowspotWithWater = false;
								if REAwheels.DynamicDirtActivated then
									WheelInLowspotWithWater = wheel.InLowspotWithWater;
								end;
								-- Dirt factor from wetness
								local WetnessFactor = 0;
								local MaxWetnessFromGround = 2;
								if WheelInLowspotWithWater then
									WetnessFactor = 3;
								else
									WetnessFactor = math.min((groundWetness * 2) + 1,MaxWetnessFromGround);
								end;
								-- Emitscale
								emitScale = (emitScale * 3) * WetnessFactor;
								-- During low speed add scale slowly
								if wheelSpeed < 1 then
									emitScale = wheelSpeed * emitScale;
								end;
							end;

							-- DEBUG
                            --if psName ~= "driving_dust" then
								---DebugUtil.drawDebugNode(wheel.driveNode, "Emit: " .. REAwheels:RoundValueTwoDecimals(emitScale) .. ", Wheel direction: " .. self.movingDirection .. ", Wheelspeed: " .. REAwheels:RoundValueTwoDecimals(wheelSpeed), false)
							--end;

                            ParticleUtil.setEmitCountScale(ps, MathUtil.clamp(emitScale, ps.minScale, ps.maxScale))
                            ParticleUtil.setParticleSystemSpeed(ps, ps.particleSpeed * wheelRotFactor)
                            ParticleUtil.setParticleSystemSpeedRandom(ps, ps.particleRandomSpeed * wheelRotFactor)
                        else
                            ParticleUtil.setEmittingState(ps, false)
                        end
                    end
                    states[psName] = false
                end

				-- Return original wheel direction
				self.movingDirection  = OriginalWheelDirecton;

            end
        end
    end
end


-----------------------------------------------------------------------------------	
-- Edited updateWheelTireTracks
-----------------------------------------------------------------------------------
function REAwheels:REAupdateWheelTireTracks(wheel)
	if wheel.CreatingTracks == nil then
		wheel.CreatingTracks = false;
		wheel.TrackSystemRutsActive = false;
		wheel.TrackSystemTracksActive = false;
		wheel.TireTrackAlphaSmoothed = 0;
		wheel.TimerDelayChangePattern = 0;
		wheel.AttachedToMotorizedVehicle = false;
	end;
	-- Get speed and direction from wheel
	local wheelSpeed = 0;
	local wheelActualSpeed = 0;
	local wheelDirection = 0;
	if wheel.SpeedBasedOnXdrive ~= nil and wheel.RollingDirectionSpeed then
		wheelSpeed = wheel.SpeedBasedOnXdrive;
		wheelActualSpeed = wheel.RollingDirectionSpeed;
		wheelDirection = wheel.DirectionBasedOnXdrive;
	end;
	-- Get wheel sink
	local WheelSink = REAwheels:GetWheelSinkClientSide(wheel)
	-- Calculated to get correct radius on client side
	local wheelActualRadius = wheel.radiusOriginal - WheelSink;
    -- using netinfo because of tire deformation
    local wx, wy, wz = wheel.netInfo.x, wheel.netInfo.y, wheel.netInfo.z
    wx = wx + wheel.xOffset

	-- Depending on wheel contact choose tiretrack height
	local WheelContactObject = 1;
	local WheelContactGround = 2;
	if wheel.contact == WheelContactObject then
		wy = wy - wheel.radiusOriginal
	else
		wy = wy - wheelActualRadius
	end;

	if wheel.TrackSystemRutsActive then
		wz = wz + ((WheelSink * 1) * wheelDirection);
	end;
	wx, wy, wz = localToWorld(wheel.node, wx,wy,wz)

	-- If wheel is not in contact with an object use terrain height
	local WheelContactGround = 2;
	if wheel.contact == WheelContactGround then
		wy = getTerrainHeightAtWorldPos(g_currentMission.terrainRootNode, wx, 0, wz);
	end;

    local r, g, b, a, t = self:getTireTrackColor(wheel, wx, wy, wz)
    if wheel.tireTrackIndex ~= nil then

		-- Determine if wheel should create a rut
		local StartRutFactor = 0.3;
		local StopRutFactor = 0.1;
		-- Get slip factor
		local wheelSlip = REAwheels:GetWheelSlipFactor(wheelSpeed,wheelActualSpeed);
		-- Start and stop rut
		local RequestRuts = wheelSlip > StartRutFactor and wheel.AttachedToMotorizedVehicle;
		local RequestTracks = ((wheelSlip < StopRutFactor) and WheelSink < (REAwheels.WheelRadiusMaxSinkFactor*wheel.radiusOriginal) * 0.3) or not wheel.AttachedToMotorizedVehicle;
		-- Request change pattern
		local RequestChangedPattern = (RequestRuts and not wheel.TrackSystemRutsActive) or (RequestTracks and not wheel.TrackSystemTracksActive);
		local ChangePattern = false;
		local PatternChanged = false;

		-- Delay changing of pattern
		local NumberOfDelaysBeforeChange = 5;
		if RequestChangedPattern then
			if wheel.TimerDelayChangePattern < NumberOfDelaysBeforeChange then
				wheel.TimerDelayChangePattern = wheel.TimerDelayChangePattern + 1;
			end;
		else
			wheel.TimerDelayChangePattern = 0;
		end;
		-- Delay finished
		local RequestDelayed = false;
		if wheel.TimerDelayChangePattern >= NumberOfDelaysBeforeChange then
			RequestDelayed = true;
		end;
		-- Change pattern
		if RequestDelayed and wheel.TireTrackAlphaSmoothed < 0.1 then
			ChangePattern = true;
		end;

		-- Change track pattern
		if not wheel.CreatingTracks then
			if g_currentMission.tireTrackSystem ~= nil and wheel.hasTireTracks then
				if ChangePattern then
					local WidthFactor = 0;
					local TrackAtlasIndex = 0;
					local RutAtlasIndex = 4;
					local AdditionalWheelTrackAtlasIndex = 0;
					-- Activate ruts track system
					if RequestRuts then
						WidthFactor = 1.75;
						TrackAtlasIndex = RutAtlasIndex;
						wheel.TrackSystemRutsActive = true;
						wheel.TrackSystemTracksActive = false;
					-- Activate tracks track system
					elseif RequestTracks then
						WidthFactor = 1;
						TrackAtlasIndex = wheel.tireTrackAtlasIndex;
						wheel.TrackSystemRutsActive = false;
						wheel.TrackSystemTracksActive = true;
					end;
					-- Delete tire track for wheel before changing pattern
					g_currentMission.tireTrackSystem:destroyTrack(wheel.tireTrackIndex);
					wheel.tireTrackIndex = g_currentMission.tireTrackSystem:createTrack(wheel.width * WidthFactor, TrackAtlasIndex);
					if wheel.additionalWheels ~= nil then
						for _, additionalWheel in pairs(wheel.additionalWheels) do
							if g_currentMission.tireTrackSystem ~= nil and additionalWheel.tireTrackIndex ~= nil then
								if RequestRuts then
									TrackAtlasIndex = RutAtlasIndex;
								else
									TrackAtlasIndex = additionalWheel.tireTrackAtlasIndex;
								end;
								-- Destroy current track index and create new one with new pattern.
								g_currentMission.tireTrackSystem:destroyTrack(additionalWheel.tireTrackIndex)
								additionalWheel.tireTrackIndex = g_currentMission.tireTrackSystem:createTrack(additionalWheel.width * WidthFactor, TrackAtlasIndex)
								PatternChanged = true;
							end
						end
					end
				end;
			end;
		end;

		-- Allow track system to make tracks or ruts
		local AllowTracksystem = r ~= nil and self:getAllowTireTracks() and not ChangePattern;

		-- Create tracks
        if AllowTracksystem then
			-- Settings for ruts
			local RequestedAlpha = 0;
			if wheel.TrackSystemRutsActive then
				if WheelSink < (REAwheels.WheelRadiusMaxSinkFactor*wheel.radiusOriginal) * 0.7 then
					RequestedAlpha = math.max(math.min(wheelSlip*3,1),WheelSink*10);
				else
					RequestedAlpha = 1;
				end;
			else
				RequestedAlpha = math.max(math.min(WheelSink*20,1),wheel.dirtAmount);
			end;
			-- Smoothe value
			if RequestDelayed then
				if wheel.TireTrackAlphaSmoothed > 0.05 then
					wheel.TireTrackAlphaSmoothed = wheel.TireTrackAlphaSmoothed * 0.5;
				end;
			else
				wheel.TireTrackAlphaSmoothed =  (wheel.TireTrackAlphaSmoothed*0.8)+(RequestedAlpha*0.2);
			end;

			-- DEBUG
			--DebugUtil.drawDebugNode(wheel.driveNode,"WS: " .. REAwheels:RoundValueTwoDecimals(wheelSpeed) .. ", MS: " .. REAwheels:RoundValueTwoDecimals(wheelActualSpeed), false)
			--DebugUtil.drawDebugNode(wheel.driveNode,"Contact: " .. wheel.contact, false)

            -- we are using wheel node instead of root node -> direction of wheel component could be different compared to the root component
            local ux,uy,uz = localDirectionToWorld(wheel.node, 0, 1, 0)
            local tireDirection = self.movingDirection
            if wheel.tireIsInverted then
                tireDirection = tireDirection * -1
            end
            -- we are using dirtAmount as alpha value -> realistic dirt fadeout
            g_currentMission.tireTrackSystem:addTrackPoint(wheel.tireTrackIndex, wx, wy, wz, ux, uy, uz, r, g, b, wheel.TireTrackAlphaSmoothed, a, tireDirection)
            if wheel.additionalWheels ~= nil then
                for _, additionalWheel in pairs(wheel.additionalWheels) do
                    if additionalWheel.tireTrackIndex ~= nil then
                        wx, wy, wz = worldToLocal(wheel.node, getWorldTranslation(additionalWheel.wheelTire))
                        wy = wy - wheel.radius
                        wx = wx + wheel.xOffset
                        wx, wy, wz = localToWorld(wheel.node, wx,wy,wz)
                        wy = math.max(wy, getTerrainHeightAtWorldPos(g_currentMission.terrainRootNode, wx, wy, wz))
                        tireDirection = self.movingDirection
                        if additionalWheel.tireIsInverted then
                            tireDirection = tireDirection * -1
                        end
                        g_currentMission.tireTrackSystem:addTrackPoint(additionalWheel.tireTrackIndex, wx, wy, wz, ux, uy, uz, r, g, b, wheel.TireTrackAlphaSmoothed, a, tireDirection)
                    end
                end
            wheel.CreatingTracks = true;
			end
        else
            g_currentMission.tireTrackSystem:cutTrack(wheel.tireTrackIndex)
            if wheel.additionalWheels ~= nil then
                for _, additionalWheel in pairs(wheel.additionalWheels) do
                    if additionalWheel.tireTrackIndex ~= nil then
                        g_currentMission.tireTrackSystem:cutTrack(additionalWheel.tireTrackIndex)
                    end
                end
            end
			wheel.CreatingTracks = false;
        end
    end
end


-- deep dumps the contents of the table and it's contents' contents
function REAwheels:deepdump( tbl )
    local checklist = {}
    local function innerdump( tbl, indent )
        checklist[ tostring(tbl) ] = true
        for k,v in pairs(tbl) do
            print(indent..k,v,type(v),checklist[ tostring(tbl) ])
            if (type(v) == "table" and not checklist[ tostring(v) ]) then innerdump(v,indent.."    ") end
        end
    end
    print("=== DEEPDUMP -----")
    checklist[ tostring(tbl) ] = true
    innerdump( tbl, "" )
    print("------------------")
end


-----------------------------------------------------------------------------------	
-- Edited FrontloaderAttacher:onLoad to unlock frontloader axis
-----------------------------------------------------------------------------------
function REAwheels:FrontLoaderOnLoad(savegame)
    if self.configurations["frontloader"] ~= nil then
        local spec = self.spec_frontloaderAttacher
        local attacherJointsSpec = self.spec_attacherJoints

        spec.attacherJoint = {}
        local key = string.format("vehicle.frontloaderConfigurations.frontloaderConfiguration(%d)", self.configurations["frontloader"]-1)
        if self.xmlFile:hasProperty(key..".attacherJoint") and self:loadAttacherJointFromXML(spec.attacherJoint, self.xmlFile, key..".attacherJoint", 0) then
            table.insert(attacherJointsSpec.attacherJoints, spec.attacherJoint)

            local frontAxisLimitJoint = self.xmlFile:getValue(key..".attacherJoint#frontAxisLimitJoint", false)
            if frontAxisLimitJoint and false then
                local frontAxisJoint = self.xmlFile:getValue(key..".attacherJoint#frontAxisJoint", 1)
                if self.componentJoints[frontAxisJoint] ~= nil then
                    spec.frontAxisJoint = frontAxisJoint
                else
                    print("Warning: Invalid front-axis joint '"..tostring(frontAxisJoint).."' in '"..self.configFileName.."'")
                end
            end

            ObjectChangeUtil.updateObjectChanges(self.xmlFile, "vehicle.frontloaderConfigurations.frontloaderConfiguration", self.configurations["frontloader"], self.components, self)
        else
            -- first config is "no-frontloader"-option
            ObjectChangeUtil.updateObjectChanges(self.xmlFile, "vehicle.frontloaderConfigurations.frontloaderConfiguration", 1, self.components, self)
            spec.attacherJoint = nil
        end
    end
end


if REAwheels.ModActivated == nil then

	addModEventListener(REAwheels);

	--WORK
	REAwheels.ModActivated = true;
	REAwheels.DebugForce = false;
	REAwheels.DebugSink = true;
	REAwheels.FilePath = g_currentModDirectory;
	REAwheels.GroundWetnessFactor = 0;
	REAwheels.SeasonsLoaded = false;
	print("mod activated")

	--WORK
	-- Exchange standard GIANT'S functions for editet by REA
	-- Change Giant's "Wheels" with REA adjusted
	Wheels.updateWheelSink = REAwheels.REAupdateWheelSink;
	FrontloaderAttacher.onLoad = REAwheels.FrontLoaderOnLoad;

	--Wheels.onUpdateTick = REAwheels.REAonUpdateTick;
	--Wheels.updateWheelTireTracks = REAwheels.REAupdateWheelTireTracks;
	-- Change Giant's "Vehicle" with REA adjusted


	-- Standard functions exchanged
	print("New REA functions loaded")

end;
