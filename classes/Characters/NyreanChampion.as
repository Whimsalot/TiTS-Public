package classes.Characters 
{
	import classes.CockClass;
	import classes.Creature;
	import classes.Engine.Combat.DamageTypes.TypeCollection;
	import classes.Items.Armor.ChitinArmor;
	import classes.Items.Armor.ChitPlate;
	import classes.Items.Armor.NyreanChain;
	import classes.Items.Melee.Shortsword;
	import classes.Items.Protection.HammerShield;
	import classes.Items.Protection.OzoneAegis;
	import classes.Items.Protection.SalamanderShield;
	import classes.ItemSlotClass;
	import classes.kGAMECLASS;
	import classes.Util.RandomInCollection;
	
	import classes.Items.Guns.TrenchShotgun;
	
	import classes.GLOBAL;
	
	import classes.GameData.CombatAttacks;
	import classes.GameData.CombatManager;
	import classes.Engine.Combat.DamageTypes.*;
	import classes.Engine.Combat.*; 
	import classes.Engine.Interfaces.output;
	import classes.Engine.Utility.weightedRand;

	import classes.Creature;
	import classes.DataManager.Errors.VersionUpgraderError;
	import classes.GameData.GameOptions;
	import classes.StorageClass;
	import flash.net.SharedObject;
	import classes.Util.InCollection;
	import classes.GLOBAL;

	/**
	 * ...
	 * @author Stygs
	 */

	 // Large female fighter, armed with large twohanded sword and a shotgun
	public class NyreanChampion extends Creature
	{
		
		public function NyreanChampion() 
		{
			this._latestVersion = 1;
			this.version = this._latestVersion;
			this._neverSerialize = true; // Setting this will stop a given NPC class from ever being serialized.
			
			this.short = "nyrean champion";
			this.originalRace = "nyrea";
			this.a = "the ";
			this.capitalA = "The ";
			this.tallness = 72;
			this.scaleColor = "green";
			
			this.long = "Standing in the sand of the arena before you is a woman who can best be described as an insect-like amazon, tall, muscular and well-equipped. Her arms and legs are mostly covered in darkened chitin, a natural protection that makes it hard to tell where the body end and her armor begins. Old scars and intricate tattoos cover the unprotected areas of her limbs, making her look even more armored than she already is. A stark contrast to her upper body is her crotch, whose protection can only be described as chainmail loincloth. The undergarment doesn't leave much room for imagination, barely being able to cover her massive ovipositor. Tearing your gaze away from her loins, you see she is holding a longsword and carries a seemingly well-used shotgun on her back, probably looted from some stray myr soldier.";
			
			this.isPlural = false;
			
			this.shield = new (RandomInCollection(HammerShield, OzoneAegis, SalamanderShield))();
			this.meleeWeapon = new Shortsword();
			this.meleeWeapon.hasRandomProperties = true;
			this.meleeWeapon.baseDamage.kinetic.damageValue = 10.0 + kGAMECLASS.chars["PC"].level;
//			this.meleeWeapon.baseDamage.addFlag(DamageFlag.CHANCE_APPLY_STUN);
			this.meleeWeapon.shortName = "Longsword";
			this.meleeWeapon.longName = "longsword";
			this.armor = new (RandomInCollection(ChitinArmor, ChitPlate, NyreanChain))();

			this.rangedWeapon = new TrenchShotgun();
			this.rangedWeapon.hasRandomProperties = true;
			this.rangedWeapon.baseDamage.kinetic.damageValue = 10.0 + kGAMECLASS.chars["PC"].level;;
			this.rangedWeapon.longName = "riot shotgun";

			this.physiqueRaw = levelScalar(5);
			this.reflexesRaw = levelScalar(5);
			this.aimRaw = levelScalar(5);
			this.intelligenceRaw = levelScalar(5);
			this.willpowerRaw = levelScalar(5);
			this.libidoRaw = 30;
			this.shieldsRaw = this.shieldsMax();
			this.energyRaw = 100;
			this.lustRaw = 15;
			
			baseHPResistances = new TypeCollection();
			baseHPResistances.kinetic.damageValue = 10.0;
			baseHPResistances.electric.damageValue = 10.0;
			baseHPResistances.burning.damageValue = 10.0;
			baseHPResistances.drug.damageValue = 50.0;
			baseHPResistances.tease.damageValue = 50.0;
			
			this.level = levelScalar(1.1);
			this.XPRaw = 0;
			this.credits = 0;
			this.HPMod = levelScalar(45);
			this.HPRaw = this.HPMax();
			
			this.femininity = 100;
			this.eyeType = 0;
			this.eyeColor = "red";
			this.thickness = 40;
			this.tone = 29;
			this.hairColor = "red";
			this.furColor = "tawny";
			this.hairLength = 0;
			this.hairType = 0;
			this.beardLength = 0;
			this.beardStyle = 0;
			this.skinType = GLOBAL.SKIN_TYPE_SCALES;
			this.skinTone = "pink";
			this.skinFlags = new Array();
			this.faceType = GLOBAL.TYPE_NYREA;
			this.faceFlags = new Array();
			this.tongueType = GLOBAL.TYPE_NYREA;
			this.lipMod = 1;
			this.earType = GLOBAL.TYPE_NYREA;
			this.antennae = 0;
			this.antennaeType = 0;
			this.horns = 0;
			this.hornType = 0;
			this.armType = 0;
			this.gills = false;
			this.wingType = 0;
			this.legType = GLOBAL.TYPE_NYREA;
			this.legCount = 2;
			this.legFlags = [];
			//0 - Waist
			//1 - Middle of a long tail. Defaults to waist on bipeds.
			//2 - Between last legs or at end of long tail.
			//3 - On underside of a tail, used for driders and the like, maybe?
			this.genitalSpot = 0;
			this.tailType = 0;
			this.tailCount = 0;
			this.tailFlags = [];
			
			//Used to set cunt or dick type for cunt/dick tails!
			this.tailGenitalArg = 0;
			//tailGenital:
			//0 - none.
			//1 - cock
			//2 - vagina
			this.tailGenital = 0;
			//Tail venom is a 0-100 slider used for tail attacks. Recharges per hour.
			this.tailVenom = 0;
			//Tail recharge determines how fast venom/webs comes back per hour.
			this.tailRecharge = 5;
			//hipRating
			//0 - boyish
			//2 - slender
			//4 - average
			//6 - noticable/ample
			//10 - curvy//flaring
			//15 - child-bearing/fertile
			//20 - inhumanly wide
			this.hipRatingRaw = 6;
			//buttRating
			//0 - buttless
			//2 - tight
			//4 - average
			//6 - noticable
			//8 - large
			//10 - jiggly
			//13 - expansive
			//16 - huge
			//20 - inconceivably large/big/huge etc
			this.buttRatingRaw = 6;
			//No dicks here!
			this.cocks = new Array();
			//balls
			this.balls = 0;
			this.cumMultiplierRaw = 1.5;
			//Multiplicative value used for impregnation odds. 0 is infertile. Higher is better.
			this.cumQualityRaw = 1;
			this.cumType = GLOBAL.FLUID_TYPE_CUM;
			this.ballSizeRaw = 2;
			this.ballFullness = 100;
			//How many "normal" orgams worth of jizz your balls can hold.
			this.ballEfficiency = 4;
			//Scales from 0 (never produce more) to infinity.
			this.refractoryRate = 9991;
			this.minutesSinceCum = 9000;
			this.timesCum = 122;
			this.cockVirgin = true;
			this.vaginalVirgin = false;
			this.analVirgin = true;
			//Goo is hyper friendly!
			this.elasticity = 3;
			//Fertility is a % out of 100. 
			this.fertilityRaw = 1;
			this.clitLength = .5;
			this.pregnancyMultiplierRaw = 1;
			
			this.breastRows[0].breastRatingRaw = 6;
			this.nippleColor = "green";
			this.milkMultiplier = 0;
			this.milkType = GLOBAL.FLUID_TYPE_MILK;
			this.milkRate = 1;
			this.ass.wetnessRaw = 0;
			this.ass.loosenessRaw = 2;
			
			this.hairLength = 10;
			
			this.cocks = [];
			this.cocks.push(new CockClass());
			(this.cocks[0] as CockClass).cType = GLOBAL.TYPE_NYREA;
			(this.cocks[0] as CockClass).cLengthRaw = 13;
			(this.cocks[0] as CockClass).cThicknessRatioRaw = 1.66;
			(this.cocks[0] as CockClass).addFlag(GLOBAL.FLAG_KNOTTED);
			(this.cocks[0] as CockClass).virgin = false;
			this.cockVirgin = false;
			
//			this.createPerk("Sneak Attack",0,0,0,0);
 			this.createPerk("Appearance Enabled"); 
			this.createStatusEffect("Force Fem Gender");
//			this.createStatusEffect("Counters Melee");
			this.createStatusEffect("Flee Disabled", 0, 0, 0, 0, true, "", "", false, 0);
			
			isUniqueInFight = true;
			btnTargetText = "N. Champion";
			
			tallness = 68 + (rand(12) - 6);
			
			sexualPreferences.setPref(GLOBAL.SEXPREF_FEMININE,		GLOBAL.REALLY_LIKES_SEXPREF);
			sexualPreferences.setPref(GLOBAL.SEXPREF_BIG_BREASTS,		GLOBAL.REALLY_LIKES_SEXPREF);
			sexualPreferences.setPref(GLOBAL.SEXPREF_BIG_BUTTS,		GLOBAL.KINDA_LIKES_SEXPREF);
			sexualPreferences.setPref(GLOBAL.SEXPREF_NEUTER,			GLOBAL.KINDA_DISLIKES_SEXPREF);
			sexualPreferences.setPref(GLOBAL.SEXPREF_VAGINAL_WETNESS,	GLOBAL.KINDA_LIKES_SEXPREF);
			sexualPreferences.setPref(GLOBAL.SEXPREF_MASCULINE,		GLOBAL.KINDA_LIKES_SEXPREF);

			this._isLoading = false;
		}
		
		public function levelScalar(multiplier:int):Number
		{
			var level:int = kGAMECLASS.chars["PC"].level;
			if (level < 8) level = 8;
			return Math.floor(level * multiplier);
		}
		
		public function tourneyQuips(result:String):String
		{
			switch (result)
			{
				case "winHP": return "<i>“Are all star-walkers this powerful? I heard all the romurs, yet I didnt believe them. Until now.”</i>";
				case "winLust": return "<i>“I am starting to understand why the Queen has taken such a liking to you. With a body like this...”</i>";
				case "loseHP": return "<i>“'Star-walker'? Ha, you are nothing more than a shooting star.”</i>";
				case "loseLust": return "<i>“Well, well, well, I really wonder what Queen Taivra would say if she could see you now.”</i>";
				default: return "variable not set, plz make a bug report";

			}
		}

		override public function get bustDisplay():String
		{
			return "QUEENSGUARD";
		}
		
		override public function CombatAI(alliedCreatures:Array, hostileCreatures:Array):void
		{
			var target:Creature = selectTarget(hostileCreatures);
			if (target == null) return;

			var enemyAttacks:Array = [
				{ v: shoot, w: 5 },
				{ v: melee, w: 15 }
			];
			if (target.lust() >= 50) {
				enemyAttacks.push( { v: nyreaMilkRub, w: 15 } );
				enemyAttacks.push( { v: nyreaPoledance, w: 20 } );
			}
			if (energy() >= 20) enemyAttacks.push( { v: powerStrike, w: 20 } );
			if (energy() >= 15) enemyAttacks.push( { v: whirlwind, w: 15 } );
	
			if (target.shields() <= 0 && (target.HP() / target.HPMax() <= 0.1 || target.HP() <= 100) && energy() >= 15 && rand(2) == 0) whirlwind(target);
			else if (!target.hasStatusEffect("Grappled") && !hasStatusEffect("Net Cooldown") && energy() >= 10 && rand(2) == 0) bolas(target);
			else if (energy() < 20) breather();
			else weightedRand(enemyAttacks)(target);
		}

		private function breather():void
		{
			output("Holding a defensive stance, the nyrean woman seem to be content with slowing down the fight for now, apparently trying to catch her breath and calm down a bit.");
			energy(20);
			lust(-10)
		}

		private function melee(target:Creature):void
		{
			CombatAttacks.MeleeAttack(this, target);
		}

		private function shoot(target:Creature):void
		{
			CombatAttacks.RangedAttack(this, target);
		}

		public function meleeCounter(target:Creature):void
		{
			output("<b>Counter!</b> Sensing an opportunity for a counter attack, the nyrean woman rushes forward, slashing at you with her sword.");
			//CombatAttacks.MeleeAttack(this, target);
			applyDamage(this.meleeDamage(), this, target, "melee");
		}

		private function powerStrike(target:Creature):void
		{
			output("Glaring at you with an intense look in her dark eyes, the nyrean suddenly gripps her oversized sword with both hands, raises it above her head and charges at you with a roaring warcry. ");
			if(combatMiss(this, target))
			{
				output("You barely manage to jump out of her way as her mighty cleave hits the ground where you were standing a second ago.");
			}
			else
			{
				output("You desperately try to avoid her attack, but you are to slow. Her razor-sharp sword " + (target.shieldsRaw > 0 ? "is thankfully blocked by your shield, sending" : "sends") +" you back reeling with the force of her bone-shattering strike.");
				applyDamage(new TypeCollection({ kinetic: this.meleeWeapon.baseDamage.kinetic.damageValue * 3 }, DamageFlag.PENETRATING), this, target, "minimal");
				if(physique()/2 + rand(20) + 1 >= target.physique()/2 + 10 && !target.hasStatusEffect("Stunned"))
				{
					output("\n<b>You’re stunned by the blow!</b>");
					CombatAttacks.applyStun(target, 1);
				}
			}
			energy(-20);
		}

		private function whirlwind(target:Creature):void
		{
			output("Without warning, the your foe swiftly closes the distance between the two of you and starts wailing on you with her sword like a hailstorm, barely giving you time to react to her onslaught.");
			for (var i:int = 0; i < 5; i++)
			{
				output("\n");
				CombatAttacks.SingleMeleeAttackImpl(this, target, true);
			}
			energy(-15);
		}

		public function bolas(target:Creature):void
		{
			createStatusEffect("Net Cooldown", 5, 0, 0, 0, true);

			output("Trying to gauge the distance between the two of you, the nyrean reaches into one of her pouches and pulls out a wad of strings and stones. With a quick swing above her head, she sends a bolas flying in your direction. ");

			if (rangedCombatMiss(this, target, 0, 3))
			{
				output("You jump aside, barely avoiding the stones as they hit the ground next to you.");
			}
			else
			{
				output("You try to jump aside, but to late - the snare hits you, ropes wrapping around your ");
				if (target.legCount <= 1) output("body");
				else if (target.legCount == 2) output("legs");
				else output("front legs");
				output(" and knocking you to the ground with surprising force.");
				applyDamage(new TypeCollection( { kinetic: 9 + rand(2) } ), this, target, "minimal");
				CombatAttacks.applyGrapple(target, 35, false, "You’re stuck in the nyrea’s snare!");
			}
			energy(-10);
		}

		//the two tease attacks are generic nyreans attacks, should be replaced later on
		public function nyreaMilkRub(target:Creature):void
		{
			//Light lust attack, heals some of her HP
			output("Giving you a cocky look, the nyrea pulls up the thin veneer of chain covering her ample bosom and cups her tits, giving them a long, obviously-pleasurable squeeze. A trickle of cream-colored milk spurts out at her touch, barely needing to be coaxed. She winks at you, bringing one of her teats to her lips and drinking long as the other drizzles all over her body, which she deftly rubs into her skin and armor.\n");

			var damage:TypeCollection = new TypeCollection( { tease: 15 } );
			;

			if (rand(10) <= 3 && !target.hasAirtightSuit())
			{
				output("\nGod, that smells delicious...");
			}
			else
			{
				output("\nYou try to contain the watering of your mouth as you watch the lewd display in front of you. What you wouldn’t give for a taste of that sweet cream...");
			}
			applyDamage(damageRand(damage, 15), this, target);
		}

		public function nyreaPoledance(target:Creature):void
		{
			//Her preferred lust attack against males. 
			output("The nyrea plants her spear in the ground, leaning heavily on the sturdy shaft, pressing it between her impressive rack. <i>“Like what you see?”</i> she giggles, voice suddenly sultry as she leans back from the haft, twisting around you give you a full view of her taut ass and long, chitinous legs. She bends over, rubbing her spear through her crack, smearing it with her psuedo-cock’s ample pre. <i>“Come off it already... put your weapons down...</i>");
			//if (enemy is NyreaBeta) output("<i> I promise you’ll be glad you did</i>");
			output("<i> You can’t win against a body like mine... I’m so above your class, offworlder. Just submit, like you know you want to</i>");
			output("<i>.”</i>\n");

			// 9999
			if (target.lust() >= target.lustMax() * 0.75)
			{
				output("\nYou look away from her tantalizing display, doing your best to contain your lust.");
			}
			else
			{
				output("\nYou can’t deny the growing heat in your loins as the nyrea puts on a show for you, all but inviting you into her embrace...");

				var damage:TypeCollection = new TypeCollection( { tease: 15 } );
				applyDamage(damageRand(damage, 15), this, target);
			}
		}
	}
}