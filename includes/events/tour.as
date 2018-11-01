	import classes.Characters.BothriocPidemme;
	import classes.Characters.CarlsRobot;
	import classes.Characters.CommanderSchora;
	import classes.Characters.CrystalGooT1;
	import classes.Characters.CrystalGooT2;
	import classes.Characters.FrogGirl;
	import classes.Characters.GooKnight;
	import classes.Characters.HuntressVanae;
	import classes.Characters.LapinaraFemale;
	import classes.Characters.Marik;
	import classes.Characters.MyrGoldBrute;
	import classes.Characters.MyrGoldRemnant;
	import classes.Characters.MyrRedCommando;
	import classes.Characters.Naleen;
	import classes.Characters.NaleenMale;
	import classes.Characters.NyreaAlpha;
	import classes.Characters.NyreaBeta;
	import classes.Characters.NyreanChampion;
	import classes.Characters.RedMyrPyro;
	import classes.Characters.Queensguard;
	import classes.Characters.WetraxxelBrawler;
	import classes.Characters.ZilFemale;
	import classes.Characters.ZilMale;
	import classes.Characters.Abrax;
	import classes.Characters.Brabax;
	import classes.Characters.Califax;
	import classes.Items.Accessories.TamWolf;
	import classes.StringUtil;
	import classes.Engine.Interfaces.*;
	import classes.Engine.Utility.weightedRandIndex;

// NYREAN_TOURNEY_COUNTER			tracks the numberof tournaments
// NYREAN_TOURNEY_WIN_COUNTER		tracks how may times the PC won a tournament
// NYREAN_TOURNEY_LAST_WINNER		name of the last tournament winner

public var currentRound:int;
public var maxRounds:int;
public var numberOfEnemies:int;
public var genericEnemies:Array;
public var possibleEnemies:Array;
public var currentEnemy:Array;
public var npcDuel:Array;
public var allowHeal:Boolean;
public var allowBet:Boolean;
public var bettingPot:int;
public var tourneyWinner:Object;

/*ideas for possible enemies
 * bothric duelist - Maybe dual wielder since they have four arms
 * (Red?) Myr Pyro - a fire ant, basicly
 * Zo’dee ?
*/

public function tourneyRound():String
{
	if (currentRound == maxRounds) return "final";
	switch (currentRound)
	{
		case 1: return "first";
		case 2: return "second";
		case 3: return "third";
		case 4: return "fourth";
		case 5: return "fifth";
		default: return "variable not set, plz make a bug report";
	}
}

public function tourneymaxRounds():String
{
	switch (maxRounds)
	{
		case 1: return "one";
		case 2: return "two";
		case 3: return "three";
		case 4: return "four";
		case 5: return "five";
		case 6: return "six";
		case 7: return "seven";
		default: return "variable not set, plz make a bug report";
	}
}

public function tourneyCurrentEnemyName(useThe:Boolean = false):String
{
	if (currentEnemy[0].v.a == "") return currentEnemy[0].v.short;
	if (useThe) return ("the " + currentEnemy[0].v.short);
	return ("a " + currentEnemy[0].v.short);
}

//push data for the unique enemies into an array
//this is for enemies that should appear no more that once (ie named characters)
public function tournamentSetUpUniqueEnemies():void
{
	possibleEnemies = [
		//at least one of them should be there in all cases
		{ v: new NyreanChampion(), w: 0 },
		{ v: new Abrax(), w: 0 }
	];
	if(flags["NYREAN_TOURNEY_COUNTER"] >= 1) {
		if (rand(2) == 0) possibleEnemies.push( { v: new NyreanChampion(), w: 0 } );
		if (rand(3) == 0) possibleEnemies.push( { v: new NyreanChampion(), w: 0 } );
		if (rand(2) == 0) possibleEnemies.push( { v: new HuntressVanae(), w: 0 } );
		if (rand(3) == 0) possibleEnemies.push( { v: new MyrRedCommando(), w: 0 } );
		if (rand(5) == 0) possibleEnemies.push( { v: new WetraxxelBrawler(), w: 0 } );
		if (rand(5) == 0) possibleEnemies.push( { v: new Queensguard(), w: 0 } );
		if (rand(5) == 0) possibleEnemies.push( { v: new CommanderSchora(), w: 0 } );
		if (rand(5) == 0) possibleEnemies.push( { v: new Califax(), w: 0 } );
	}
	if (flags["FEDERATION_QUEST"] >= 3 && rand(2) == 0) possibleEnemies.push( { v: new Marik(), w: 0 } );
	if (rand(2) == 0) possibleEnemies.push( { v: new Brabax(), w: 0 } );
}

//put data for the generic enemies into a new array
public function tournamentSetUpGenericEnemies():void
{
	//high weight = more likely to get kicked by the random generator
	//dont use w=0 here, or they will never get moved into the real enemy list
	genericEnemies = [
		{ v: new NyreanChampion(), w: 1 },
		{ v: new BothriocPidemme(), w: 1 },
		{ v: new MyrGoldBrute(), w: 3 },
		{ v: new MyrGoldRemnant(), w: 5 },
		{ v: new GooKnight(), w: 8 },
		{ v: new NyreaAlpha(), w: 10 },
		{ v: new RedMyrPyro(), w: 12 },
		{ v: new ZilFemale(), w: 12 },
		{ v: new ZilMale(), w: 12 },
		{ v: new NyreaBeta(), w: 18 },
		{ v: new CrystalGooT1(), w: 20 },
		{ v: new CrystalGooT2(), w: 20 },
		{ v: new LapinaraFemale(), w: 25 }
	];
}

public function tournamentSetUpEnemies():void
{
	tournamentSetUpUniqueEnemies();

	//draw some names from the hat and fill up the enemy array with them
	while (possibleEnemies.length < numberOfEnemies)
	{
		//I know its kinda stupid to remake this list constantly, but otherwise the characters are treated as references - defeat one and you have defeated all of that type
		tournamentSetUpGenericEnemies();
		possibleEnemies.push(genericEnemies[weightedRandIndex(genericEnemies)]);
	}
}

public function tournamentIntro():Boolean
{
	output("In the gloom of the glowing fungus, you make out several banches lining the sides of the cave. The area in the middle is covered with fine sand of various colors. The hundreds of footprints on the sand give the distint impression that the cave is used for some kind of ceremonys.");
	if (pc.accessory is SiegwulfeItem || pc.hasTamWolf()) addDisabledButton(0,"Tournament","Tournament","Everyone fights on their own in this tournament. Companions or pets of any kinds are not allowed.");
	else addButton(0,"Tournament",function():void {
		if (flags["NYREAN_TOURNEY_COUNTER"] < 3) flags["NYREAN_TOURNEY_COUNTER"] = 3;
		tournamentSetUp();
	},undefined,"Tournament","Tourney 3 - regular tourney.");	
	addButton(1,"Tournament",function():void {
		flags["NYREAN_TOURNEY_COUNTER"] = 2;
		tournamentSetUp();
	},undefined,"Tournament","Tourney 2 - regular tourney.");	
	addButton(2,"Tourney",tournamentSetUp,undefined,"Tourney","Tourney 1 - shorter tourney and weaker enemy selection.");
	addButton(4,"Preliminary",preliminarySetUp,undefined,"Preliminary","Single round against multiple enemies.");
	addButton(5,"Champion Test",championTestFight,undefined,"Champion Test","Fight against a single champion.");
	addButton(10,"Team Test",teamTest,undefined,"Team Test","Try a team fight.");
	return false;
}

public function preliminarySetUp():void
{
	tournamentSetUpGenericEnemies();
	if (flags["NYREAN_TOURNEY_COUNTER"] == undefined) flags["NYREAN_TOURNEY_COUNTER"] = 1;
	
	output("Welcome to the preliminary round of the <b>" + flags["NYREAN_TOURNEY_COUNTER"] + ". WORLD MARTIAL ARTS TOURNAMENT</b>");
	output("\n\nTo qualify, you need to proved your mettle against multiple enemies at the same time.");

	CombatManager.newGroundCombat();
	CombatManager.setFriendlyActors(pc);
	CombatManager.setHostileActors(weightedRand(genericEnemies), weightedRand(genericEnemies), weightedRand(genericEnemies));
	CombatManager.victoryScene(preliminaryVictory);
	CombatManager.lossScene(preliminaryDefeat);
	CombatManager.displayLocation("PRELIMINARY");
	clearMenu();
	addButton(0, "Fight", CombatManager.beginCombat);
}

public function preliminaryVictory():void
{
	output("Congratulation, you are now ready for the main event.\n\n");
	CombatManager.genericVictory();
	clearMenu();
	addButton(0,"Tournament",tournamentSetUp,undefined,"Tournament","Get this party started.\n\n");
}

public function preliminaryDefeat():void
{
	output("How do you expect to win the tourney if you cannot even win this training round?\n\n");
	CombatManager.genericLoss();
	clearMenu();
	addButton(0,"Next",mainGameMenu);
}

public function tournamentSetUp():void
{
	if (flags["NYREAN_TOURNEY_COUNTER"] == undefined) flags["NYREAN_TOURNEY_COUNTER"] = 1;
	if (flags["NYREAN_TOURNEY_COUNTER"] == 1) maxRounds = 4;
	else maxRounds = 5;
	numberOfEnemies = (Math.pow(2, maxRounds) - 1);
	currentRound = 1;
	bettingPot = 0;
	allowBet = true;
	tournamentSetUpEnemies();
	tournamentMainMenu();
}

public function tourneyBetweenRounds(option:String):void
{
	clearOutput();
	switch(option)
	{
/*		case "shield":
			pc.shieldsRaw = pc.shieldsMax();
			output("You spend a while bringing your shield generator back up to par.");
			break;	*/
		case "health":
//			restHeal()
			//allways gives +30% max HP & bonus for high physique
			pc.HP((pc.HPMax() * 0.3) + Math.floor(pc.PQ() / 5));
			output("Considering your " + (pc.HPQ() < 50 ? "gaping " : "") + "wounds, you decide to look for the local medico or whatever counts as healer around here. You find her (or rather him, considering the nyrean biology) in a small alcove of the cave, together with some bedding made from moss and what appears to be a medical locker looted from a gold myr camp. She seems to be used to wounded visitors as she hands you a small pouch without a second thought. Inside is some sort of grainy goo, fabric scraps and herbs you never seen before. You feel a burning sensation when you apply the herbs and the goo, but it stops nearly instantly as you wrap the rags around your wound. As weird as this first aid kit seems, you can't deny it's effectiveness as your wounds slowly start to heal.");
			output("\n\nAfter sitting on one of the unused beds for a bit, you get the feeling it is time to head back into the arena.");
			output("\n\nDEBUG STATS:");
			output("\nPQ: " + pc.PQ() / 5);
			output("\nValue:" + ((pc.HPMax() * 0.3) + Math.floor(pc.PQ() / 5)));
			break;
		case "energy":
			//allways gives +30% max energy & bonus for high physique
			pc.energy((pc.energyMax() * 0.3) + Math.floor(pc.PQ() / 5));
			output("Exhausted as you are, you take a short break from the proceedings to gather your strength. Sitting down on a stone bench backstage area of the rink, you start observing the remaining fighters, watching them attack, dodge and counter. Slowly, you vision starts to fade into black and before you even realized your fatigue, you have fallen asleep.");
			output("\n\nSuddenly you hear a voice right besides you, calling your name. Startled by this, you nearly fall of the bench, only to see one of the palace pretorians standing next to you, looking at you with a hint of worry on her face. <i>“My " + pc.mf("king", "queen") +", you should hurry up. The next round is about to start.”</i>");
			output("\n\nStill a little sluggish, you make your way back into the arena.");
			output("\n\nDEBUG STATS:");
			output("\nPQ: " + pc.PQ() / 5);
			output("\nValue:" + ((pc.energyMax() * 0.3) + Math.floor(pc.PQ() / 5)));
			break;
		case "lust":
//			pc.orgasm();
			pc.lust((pc.LQ() * 0.5) - 75);
			output("You spend some time jerking off in a secluded part of the cavern, trying to calm down your lust.");
			output("\n\nDEBUG STATS:");
			output("\nLQ: " + pc.LQ());
			output("\nValue:" + ((pc.LQ() * 0.5) - 75));
			break;
	}
	allowHeal = false;
	CombatManager.abortCombat();
	processTime(20);
	clearMenu();
	addButton(0,"Next",tournamentMainMenu);
}

public function tournamentMainMenu():void
{
	clearOutput();
	clearBust();
	showName("\n" + tourneyRound().toUpperCase() + " ROUND");

	pc.shieldsRaw = pc.shieldsMax();

	output("Welcome to the <b>" + flags["NYREAN_TOURNEY_COUNTER"] + ". WORLD MARTIAL ARTS TOURNAMENT</b>");
	output("\n\nYou are currently in the " + tourneyRound() + " of " + tourneymaxRounds() + " rounds. It seems you have a bit of time left before the next round starts, how do you want to spend it?");
	output("\n\nYou could place a quick bet or prepare yourself for the next battle.");

	clearMenu();
//	tournamentNextRound();
	addButton(0,"Proceed",tournamentNextRound, undefined, "Proceed", "Onwards to the next round.");
	addButton(1,"Bet Credits",tourneyBetMenu);
	if (pc.credits >= 200 && allowBet) addButton(1, "Bet Credits", tourneyBetMenu, undefined, "Bet Credits", "Place a bet on yourself and get get some extra cash if you win the tourney.");
	else if (!allowBet) addDisabledButton(1, "Bet Credits", "Bet Credits", "You allready placed a bet for this round.");
	else addDisabledButton(1, "Bet Credits", "Bet Credits", "You don’t think you have enough spare money for this.");

	if(currentRound != 1) {
		if (!allowHeal)
		{
//			addDisabledButton(5, "Fix Shield", "Fix Shield", "You don't have enough time for this, the next round is about to start.");
			addDisabledButton(5, "First Aid", "First Aid", "You don't have enough time for this, the next round is about to start.");
			addDisabledButton(6, "Short Rest", "Short Rest", "You don't have enough time for this, the next round is about to start.");
			addDisabledButton(7, "Masturbate", "Masturbate", "You don't have enough time for this, the next round is about to start.");
		}
		else {
//			if (pc.shieldsRaw < pc.shieldsMax()) addButton(5,"Fix Shield",tourneyBetweenRounds, "shield");
//			else addDisabledButton(5, "Fix Shield");
			if(pc.HPRaw < pc.HPMax()) addButton(5,"First Aid",tourneyBetweenRounds, "health", "First Aid", "Bandage your wounds and gain back some health.");
			else addDisabledButton(5, "First Aid");
			if(pc.energyRaw < pc.energyMax()) addButton(6,"Short Rest",tourneyBetweenRounds, "energy", "Short Rest", "Take a break and gather some energy.");
			else addDisabledButton(6, "Short Rest");
			if(pc.lust() > 0) addButton(7, "Masturbate", tourneyBetweenRounds, "lust", "Masturbate", "Look for a quite corner and lower your lust a bit.");
			else addDisabledButton(7, "Masturbate");
		}
	}
	addButton(14,"Withdraw",tournamentConfirmWithdraw);
}

public function tournamentFullEnemyList():void
{
	clearOutput();
	output("[pc.name]");
	for (var i:int = 0; i < possibleEnemies.length; i++)
	{
			output("\n" + StringUtil.capitalize(possibleEnemies[i].v.short));
	}
	addDisabledButton(5, "FullEnemyList");
}

public function tournamentLoserBracket():void
{
	var npcToRemove:Array = new Array();
	var y:int = possibleEnemies.length;
	var j:int;
	
	//first, take the first enemie from the array
	//then, take the last enemy from the array and compare weights
	//the array should have an even amount of objects (since PC and current enemy arnt part of it)
	for (var i:int = 0; i < Math.floor(y / 2); i++)
	{
		if (y >= 2) 
		{
			j = y - i - 1;
			//put 2 enemies in a new array
			npcDuel = [possibleEnemies[i], possibleEnemies[j]];

			//determine the weaker one and put them in the loosers louch
			if (weightedRandIndex(npcDuel) == 0) npcToRemove.push(i);
			else npcToRemove.push(j);
				
		/*	//debug
			output("array length: " + npcDuel.length + "\n");
			output(i + "   " + npcDuel[0].v + "   " + npcDuel[0].w + "\n");
			output(j + "   " + npcDuel[1].v + "   " + npcDuel[1].w + "\n");
			output("array length: " + npcToRemove.length + "\n");
			output(npcToRemove[i] + "\n\n");	*/
		}
	}

	//sort the new arry so high numbers get removed first - otherwise the index changes might screw it up
	npcToRemove.sort(Array.DESCENDING | Array.NUMERIC);
	//remove the losers from the list of possible enemies
	for (var k:int = 0; k < npcToRemove.length; k++)
	{
		possibleEnemies.splice(npcToRemove[k],1);
	}
}

public function tournamentNextRound():void
{
	clearOutput();
//	var x:int = rand(possibleEnemies.length);
//	var x:int = weightedRandIndex(possibleEnemies);
	var x:int;
	output("<b>The remaining fighters are:</b>");
	output("\n\n[pc.name]");
	for (var i:int = 0; i < possibleEnemies.length; i++)
	{
		if (i < 15)
		{
			output("\n" + StringUtil.capitalize(possibleEnemies[i].v.short));
		}
	}
	if (possibleEnemies.length > 15) output("\n\n<b>and sixteen more.</b>");
	
	//that way, the earlier rounds should have the more generic enemies
	if (possibleEnemies.length <= 8) x = rand(possibleEnemies.length);
	else x = weightedRandIndex(possibleEnemies);

	//get a new enemy from the array
	currentEnemy = new Array(possibleEnemies[x]);

	//purge that enemy from the main list
	possibleEnemies.splice(x,1);

	output("\n\n<b>Your next enemy will be " + tourneyCurrentEnemyName() + ".</b>");
	
	//iniate combat
	CombatManager.newGroundCombat();
	CombatManager.setFriendlyActors(pc);
	CombatManager.setHostileActors(currentEnemy[0].v);
	CombatManager.victoryScene(tournamentWonRound);
	CombatManager.lossScene(tournamentDefeat);
	CombatManager.displayLocation(tourneyRound().toUpperCase() + " ROUND");
	
	clearMenu();
	addButton(0, "Fight", CombatManager.beginCombat);
	if (possibleEnemies.length > 15) addButton(5, "FullEnemyList", tournamentFullEnemyList);
	addButton(14,"Withdraw",tournamentConfirmWithdraw, true);
}

public function tournamentWonRound():void
{
	var tEnemy:Object = currentEnemy[0].v;
	var tNextScene:Function = tournamentMainMenu;
	clearOutput();

	tournamentLoserBracket();

	if (currentRound != maxRounds)
	{
		output("A winner is you! Proceed to the next round.\n\n");
		if (tEnemy.short == "nyrean champion")
		{
			if (enemy.HP() <= 0) output(tEnemy.tourneyQuips("winHP"));
			else output(tEnemy.tourneyQuips("winLust"));
			output("\n\n");
		}
		currentRound = currentRound + 1;
		allowHeal = true;
		allowBet = true;
	}
	else
	{
		output("As " + (tEnemy.a = "" ? "" : "the ") + tEnemy.short + " sinks to the ground, its takes you a moment to realize its meaning: You are the winner of the " + flags["NYREAN_TOURNEY_COUNTER"] + ". cave tourney, and rightfully so!");
		output("\n\nYou made " + bettingPot + " credits with your placed bets!\n\n");
		pc.credits += bettingPot;
		tNextScene = tournamentVictory;
	}
	CombatManager.genericVictory();
	clearMenu();
	addButton(0, "Next", function():void {
		userInterface.hideNPCStats();
		userInterface.leftBarDefaults();
		generateMap();
		tNextScene();
	});
}

public function tournamentVictory():void
{
	clearOutput();
	showTaivra();
	output("As Queen Taivra gives you a basket full of rock candy and a 5 $ gift card for Seifyns shop, you start to wonder if that was really worth the hassle.\n\nTime to get back to probe hunting!");
	IncrementFlag("NYREAN_TOURNEY_COUNTER");
	IncrementFlag("NYREAN_TOURNEY_WIN_COUNTER");
	clearMenu();
	addButton(0,"Next",mainGameMenu);
}

//maybe put the winning enemy back into the array and make another weightend random to draw the winner of the tourney.
public function tournamentDefeat():void
{
	var tEnemy:Object = currentEnemy[0].v;
	clearOutput();
	output("After losing against " + tEnemy.a + tEnemy.short + " in the " + tourneyRound() + " round, you are removed from the tournament.\n\n");
	if (tEnemy.short == "nyrean champion")
	{
		if (pc.HP() <= 0) output(tEnemy.tourneyQuips("loseHP"));
		else output(tEnemy.tourneyQuips("loseLust"));
		output("\n\n");
	}
	output("<b>Better luck next time.</b>");
	CombatManager.genericLoss();
	IncrementFlag("NYREAN_TOURNEY_COUNTER");
	clearMenu();
	addButton(0,"Next",mainGameMenu);
}

public function tournamentConfirmWithdraw(addCurrentEnemy:Boolean = false):void
{
	clearOutput();
	output("Do you really want to withdraw from the tournament?");
	clearMenu();
	addButton(0,"No",tournamentMainMenu);
	addButton(1,"Yes", tournamentWithdraw, addCurrentEnemy);
}

public function tournamentWithdraw(addCurrentEnemy:Boolean = false):void
{
	clearOutput();
	CombatManager.abortCombat();
	tourneyDetermineNPCWinner(addCurrentEnemy);
	IncrementFlag("NYREAN_TOURNEY_COUNTER");
	output("Having withdrawn from the fights, you spend a while watching the rest of the tournament from the sidelines. In the end, " + (tourneyWinner.a = "" ? "" : "a ") + tourneyWinner.short + " wins and reaps the rewards. After the public ceremony is over, the party moves over to the palace for the main celebration.");
	output("\n\nSadly, quitters like you are not allowed to take part, even if they are royalty. As such, you collect your stuff and make your way back out into the underground.");
	
	processTime(60);
	clearMenu();
	addButton(0,"Next",mainGameMenu);
}

//compare the first and the second element in the array, kick the loser, repeat the whole process until only 1 is left
public function tourneyDetermineNPCWinner(addCurrentEnemy:Boolean = true):void
{
	if (addCurrentEnemy) possibleEnemies.push(currentEnemy[0]);
	possibleEnemies.sortOn("w", Array.DESCENDING | Array.NUMERIC);
	while (possibleEnemies.length > 1)
	{
		var x:int = 0;
		npcDuel = [possibleEnemies[0], possibleEnemies[1]];
//		output("Teilnehmer: " + possibleEnemies[0].v.short + " und " + possibleEnemies[1].v.short);

		if (weightedRandIndex(npcDuel) == 1) x = 1;
		possibleEnemies.splice(x, 1);
//		output("   Sieger: " + possibleEnemies[0].v.short + "\n")
	}
	tourneyWinner = possibleEnemies[0].v;
//	output("\n\n<b>Current Winner is: </b>" + tourneyWinner.short);
}

//*****************************
//***** Bet related stuff *****
//*****************************

public function tourneyBetMenu():void
{
	clearOutput();
	output("After looking around for a moment, you find the local bookmaker - an old nyrean woman - sitting on a battered wooden desk near the entrance of the cavern.");
	output("\n\nDo you want to bet credits on your victory in the tourney? The more enemies are left, the better the final payout will be. However, if you lose a fight or withdraw the money will be forfeited.");

	clearMenu();
	//cant access this menu if you have less than 100
	addButton(0,"Bet 100",tourneyBet, 100);
	if (pc.credits >= 200) addButton(1,"Bet 200",tourneyBet, 200);
	else addDisabledButton(1, "Bet 200")
	if (pc.credits >= 500) addButton(2,"Bet 500",tourneyBet, 500);
	else addDisabledButton(2, "Bet 500")
	if (pc.credits >= 1000) addButton(3,"Bet 1000",tourneyBet, 1000);
	else addDisabledButton(3, "Bet 1000")
	addButton(14,"Back",tournamentMainMenu);
}

public function tourneyBet(bet:int):void
{
	clearOutput();
	output("With a self-confident smile, you hand " + bet + " credits to the bookie and recieve a small receipt from her in turn. It is made out of crude paper and coved in irrecognizable symbols, but surely she wouldn't try to trick her " + pc.mf("king", "queen") +", would she?");
	output("\n\nPutting the slip in your pocket, you make your way back to the arena.");
	processTime(5);
	
	//todo: lower the payout if the PC has won multiple turneys
	pc.credits -= bet;
	bettingPot += bet + Math.round(bet / (10 / (numberOfEnemies + 1)));
	allowBet = false;
	
	clearMenu();
	addButton(0,"Next",tournamentMainMenu);
}

public function championTestFight():void
{
	clearOutput();
	output("GL & HF");

	CombatManager.newGroundCombat();
	CombatManager.setFriendlyActors(pc);
	CombatManager.setHostileActors(new NyreanChampion());
	CombatManager.victoryScene(preliminaryVictory);
	CombatManager.lossScene(preliminaryDefeat);
	CombatManager.displayLocation("ENEMY TEST");
	clearMenu();
	addButton(0, "Fight", CombatManager.beginCombat);
}

public function teamTest():void
{
	clearOutput();
	output("Choose your ally for this fight:");

	clearMenu();
	addButton(0, "Queensguard", teamTestFight, Queensguard, "Queensguard","She is a bodyguard, after all.");
	addButton(1, "Queen Taivra", teamTestFight, Taivra, "Queen Taivra","She didn't become a queen for nohing.");
	addButton(2, "Princess Taivris", teamTestFight, Princess, "Princess Taivris","Bad fighter, but her tease attacks are quite usefull.\n\n<b>Attack:</b> 3\10\n<b>Defense:</b> 5\10\n<b>Tease:</b> 8\10");
	addButton(5, "Dane", teamTestFight, Dane, "Dane","Why not [rival.name]'s former bodyguard?");
}

public function teamTestFight(tAlly:Object):void
{
	clearOutput();
	output("GL & HF");

	CombatManager.newGroundCombat();
	CombatManager.setFriendlyActors(pc);
	CombatManager.setFriendlyActors([pc, new tAlly()]);
	CombatManager.setHostileActors([new NyreanChampion(), new NyreanChampion()]);
	CombatManager.victoryScene(preliminaryVictory);
	CombatManager.lossScene(preliminaryDefeat);
	CombatManager.displayLocation("TEAM TEST");
	clearMenu();
	addButton(0, "Fight", CombatManager.beginCombat);
}
