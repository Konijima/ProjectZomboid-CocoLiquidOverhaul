# Coco Liquid Overhaul 1.6
A mod presented by the Coco Labs community focusing on increasing the possibilities with the game liquids. Store liquid in a "Water Jug" and "Large Gas Can". Take and Place Water Jugs on any dispenser to refill them.
  
## New Features:
- Added burn corpse with any fuel container + (Matches or Lighter)  
- Updated for beta 41.55 IWBUMS.  
  
## Features:
- 3D Models.  
- Add/Siphon gasoline to/from vehicle with any fuel containers.  
- Multiple translation now available.  
- Pour fuel on the ground.  
- Vanilla Gas Can (Store Fuel/Water).  
- Large Gas Can (Store Fuel/Water).  
- Water Jug (Take/Place on dispenser & store water/fuel).  
- Replaceable Water Dispenser Bottles (Water/Fuel/Empty).  
- Dynamic Water Dispenser (Change to empty bottle when depleted).  
- Choose fuel container in Gas Pump Context menu.  
- Choose fuel container in Generator Context menu.  
- Add/Siphon Fuel with any fuel container.  
- View any liquid container's content in the Context menu.  

## Items/Objects:
![Large Gas Can](https://github.com/cocolabs/pz-liquid-overhaul/blob/master/media/textures/Item_Coco_LargePetrolCan.png?raw=true)
![Empty Water Jug](https://github.com/cocolabs/pz-liquid-overhaul/blob/master/media/textures/Item_Coco_WaterGallonEmpty.png?raw=true)
![Water Jug](https://github.com/cocolabs/pz-liquid-overhaul/blob/master/media/textures/Item_Coco_WaterGallonFull.png?raw=true)
![Water Jug with fuel](https://github.com/cocolabs/pz-liquid-overhaul/blob/master/media/textures/Item_Coco_WaterGallonPetrol.png?raw=true)
  
![Empty Dispenser](https://github.com/cocolabs/pz-liquid-overhaul/blob/master/resources/BigWaterBottle/Dispenser/New3D/location_business_office_generic_01_48_empty.png?raw=true)
![Empty Bottle Dispenser](https://github.com/cocolabs/pz-liquid-overhaul/blob/master/resources/BigWaterBottle/Dispenser/New3D/location_business_office_generic_01_48_bottle.png?raw=true)
![Water Dispenser](https://github.com/cocolabs/pz-liquid-overhaul/blob/master/resources/BigWaterBottle/Dispenser/New3D/location_business_office_generic_01_48_water.png?raw=true)
![Fuel Dispenser](https://github.com/cocolabs/pz-liquid-overhaul/blob/master/resources/BigWaterBottle/Dispenser/New3D/location_business_office_generic_01_48_fuel.png?raw=true)
  
## Known Bugs:
- Dispenser context menu is difficult to open using Controller.
- Vanilla dispenser appearance change after the first click only.  
- Drinking from "Water Jug" animation is broken.  
  
## Available Languages
- English
- French
- Polish
- Brazilian Portuguese
- Spanish
  
## Compatibility  
This mod overrides the following features/functions:  
- Gas Pump Context Menu  
- Generator Context Menu  
- ISAddGasolineToVehicle:start  
- ISAddGasolineToVehicle:update  
- ISAddGasolineToVehicle:perform  
- ISTakeGasolineFromVehicle:start  
- ISTakeGasolineFromVehicle:update  
- ISTakeGasolineFromVehicle:perform  
- ISVehicleMenu.FillPartMenu  
- ISVehiclePartMenu.getGasCanNotEmpty  
- ISVehiclePartMenu.getGasCanNotFull  
  
### THINGS TO CHECK WHEN GAME UPDATES  
- Check if Drink / WashYourself / WashClothes changed.  
- Check if anything related to Fuel changed.  
- Check if anything related to Water changed.  
- Check if anything related to Dispenser changed.  
- Check if anything related to Generator changed.  
- Check if anything related to Vehicle Fuel changed.  
  
### THINGS TO DO WHEN UPDATING THE MOD  
- Increment version number when new features added.
- Do not increment version number when releasing Hotfix.
- Add compatibility notes to readme if new/changed overrides.  
- Update version number in mod.info, CLO.lua and readme.md title.  
- Update Readme and workshop.txt descriptions.  
  
## Workshop
Workshop ID: 2539452952  
Mod ID: CocoLiquidOverhaul  
  
## Credits  
**Yooks** - For everything he does to help make modding easier & organized.  
**Coco Labs Community** - For being awesome and supportive.  
**Tchernobill** - For helping fix item categories.  
**Dylan123** - For the Water Jug 3D model.  
**Corporal** - For the Polish Translation.  
**TehaGP** - For the Brazilian Portuguese Translation.  
**Path** - For the liquid capacity and re-balance.  
**Slash** - For the Spanish Translation.  
