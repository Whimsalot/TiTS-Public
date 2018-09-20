	import classes.Characters.BothriocPidemme;
	import classes.Characters.CarlsRobot;
	import classes.Characters.CrystalGooT1;
	import classes.Characters.CrystalGooT2;
	import classes.Characters.FrogGirl;
	import classes.Characters.GooKnight;
	import classes.Characters.HuntressVanae;
	import classes.Characters.KQ2BlackVoidGrunt;
	import classes.Characters.LapinaraFemale;
	import classes.Characters.Marik;
	import classes.Characters.MyrGoldBrute;
	import classes.Characters.MyrGoldRemnant;
	import classes.Characters.MyrRedCommando;
	import classes.Characters.Naleen;
	import classes.Characters.NaleenMale;
	import classes.Characters.NyreaAlpha;
	import classes.Characters.NyreaBeta;
	import classes.Characters.NyreanPraetorians;
	import classes.Characters.RaskvelFemale;
	import classes.Characters.RaskvelMale;
	import classes.Characters.Queensguard;
	import classes.Characters.WetraxxelBrawler;
	import classes.Characters.ZilFemale;
	import classes.Characters.ZilMale;
	import classes.StringUtil;

// NYREAN_TOURNEY_COUNTER			tracks the numberof tournaments
// NYREAN_TOURNEY_WIN_COUNTER		tracks how may times the PC won a tournament
// NYREAN_TOURNEY_LAST_WINNER		name of the last tournament winner

public var currentRound:int;
public const maxRounds:int = 5;
public var numberOfEnemies:int;
public var genericEnemies:Array;
public var possibleEnemies:Array;
public var currentEnemy:Array;
public var npcDuel:Array;

public function tourneyRound():String
{
	if (currentRound == maxRounds) return "final";
	switch (currentRound)
	{
		case 1: return "first";
		case 2: return "second";
		case 3: return "third"
		case 4: return "fourth";
		case 5: return "fifth";
		default: return "variable not set, plz make a bug report";
	}
}

public function tourneyCurrentEnemyName():String
{
	if (currentEnemy[0].v.a == "") return currentEnemy[0].v.short;
	return ("a " + currentEnemy[0].v.short);
}

//push data for the unique enemies into an array
//this is for enemies that should appear no more that once (ie named characters)
public function tournamentSetUpUniqueEnemies():void
{
	possibleEnemies = [
		{ v: new CarlsRobot(), w: 1 }
	];
	if (rand(2) == 0) possibleEnemies.push( { v: new HuntressVanae(), w: 0 } );
	if (rand(2) == 0) possibleEnemies.push( { v: new KQ2BlackVoidGrunt(), w: 0 } );
	if (rand(3) == 0) possibleEnemies.push( { v: new MyrRedCommando(), w: 0 } );
	if (rand(5) == 0) possibleEnemies.push( { v: new WetraxxelBrawler(), w: 0 } );
	if (rand(5) == 0) possibleEnemies.push( { v: new Queensguard(), w: 0 } );
	if (flags["FEDERATION_QUEST"] >= 3 && rand(2) == 0) possibleEnemies.push( { v: new Marik(), w: 0 } );
}

//put data for the generic enemies into a new array
public function tournamentSetUpGenericEnemies():void
{
	//high weight = more likely to get kicked by the random generator
	genericEnemies = [
		{ v: new BothriocPidemme(), w: 2 },
		{ v: new NyreanPraetorians(), w: 2 },
		{ v: new MyrGoldBrute(), w: 3 },
		{ v: new MyrGoldRemnant(), w: 5 },
		{ v: new GooKnight(), w: 8 },
		{ v: new CrystalGooT1(), w: 10 },
		{ v: new CrystalGooT2(), w: 10 },
		{ v: new NyreaAlpha(), w: 14 },
		{ v: new NyreaBeta(), w: 20 },
		{ v: new FrogGirl(), w: 6 },
		{ v: new ZilFemale(), w: 12 },
		{ v: new ZilMale(), w: 12 },
		{ v: new LapinaraFemale(), w: 18 },
		{ v: new Naleen(), w: 6 },
		{ v: new NaleenMale(), w: 6 },
		{ v: new RaskvelFemale(), w: 14 },
//		{ v: new RaskvelMale(), w: 14 }
	];
}

public function tournamentSetUpEnemies():void
{
	tournamentSetUpUniqueEnemies();

	//draw some names from the hat and fill up the enemy array with them
	while (possibleEnemies.length < numberOfEnemies)
	{
		//I know its kinda stupid to remade this list constantly, but otherwise the characters are treated as references - defeat one and you have defeated all of that type
		tournamentSetUpGenericEnemies();
		possibleEnemies.push(genericEnemies[weightedRandIndex(genericEnemies)]);
	}
}

public function tournamentIntro():Boolean
{
	output("In the gloom of the glowing fungus, you make out several banches lining the sides of the cave. The area in the middle is covered with fine sand of various colors. The hundreds of footprints on the sand give the distint impression that the cave is used for some kind of ceremonys.");
	addButton(0,"Tournament",tournamentSetUp,undefined,"Tournament","Get this party started.");
	addButton(5,"Preliminary",preliminarySetUp,undefined,"Preliminary","Single round against multiple enemies");
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
	output("Congratulation, you are now ready for the main event.");
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
	currentRound = 1;
	numberOfEnemies = 31;
	tournamentSetUpEnemies();
	if (flags["NYREAN_TOURNEY_COUNTER"] == undefined) flags["NYREAN_TOURNEY_COUNTER"] = 1;
	tournamentMainMenu();
}

public function tournamentMainMenu():void
{
	clearOutput();
	clearBust();
	showName("\nTOURNAMENT");
	output("Welcome to the <b>" + flags["NYREAN_TOURNEY_COUNTER"] + ". WORLD MARTIAL ARTS TOURNAMENT</b>");
	output("\n\nYou are currently in the " + tourneyRound() + " of five rounds.\n\n<b>The remaining fighters are:</b>");
	output("\n\n[pc.name]");
	for (var i:int = 0; i < possibleEnemies.length; i++)
	{
		if (i < 15)
		{
			output("\n" + StringUtil.capitalize(possibleEnemies[i].v.short));
		}
	}
	if (possibleEnemies.length > 15) output("\n\n<b>and sixteen more.</b>\n");

	clearMenu();
	tournamentNextRound();
//	addButton(0,"Proceed",tournamentNextRound);
//	addButton(4,"DEBUG",tournamentDEBUG);
	if (possibleEnemies.length > 15) addButton(5, "FullEnemyList", tournamentFullEnemyList);
	else addDisabledButton(5, "FullEnemyList");
//	addButton(0,StringUtil.vapitalize(tourneyRound()) + " round",tournamentNextRound);
//	addButton(1,"Bet money",tournamentMainMenu);
//	addButton(2,"combatInventoryMenu",combatInventoryMenu);
	addButton(13,"Inventory",tournamentInventoryMenu);
	addButton(14,"Withdraw",tournamentWithdraw);
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
	var x:int = rand(possibleEnemies.length);
	
	//get a new enemy from the array
	currentEnemy = new Array(possibleEnemies[x]);

	//purge that enemy from the main list
	possibleEnemies.splice(x,1);

	output("\n\n<b>Your next enemy is " + tourneyCurrentEnemyName() + ".</b>");
	
	//iniate combat
	CombatManager.newGroundCombat();
	CombatManager.setFriendlyActors(pc);
	CombatManager.setHostileActors(currentEnemy[0].v);
	CombatManager.victoryScene(tournamentWonRound);
	CombatManager.lossScene(tournamentDefeat);
	CombatManager.displayLocation(tourneyRound().toUpperCase() + " ROUND");
	clearMenu();
	addButton(0, "Fight", CombatManager.beginCombat);
}

public function tournamentWonRound():void
{
	clearOutput();

	tournamentLoserBracket();

	if (currentRound != maxRounds)
	{
		output("A winner is you! Proceed to the next round for more mindless fighting.\n\n");
		CombatManager.genericVictory();
		currentRound = currentRound + 1;
//		restHeal()
		pc.shieldsRaw = pc.shieldsMax();
		clearMenu();
		addButton(0,"Next",tournamentMainMenu);
	}
	else
	{
		output("<b>Congratulation, you won!</b>\n\nTime to get your prize.\n\n");
		CombatManager.genericVictory();
		clearMenu();
		addButton(0,"Next",tournamentVictory);
	}
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

//maybe put the winning enemy back into the array and make another weightend random to draw the winner.
public function tournamentDefeat():void
{
	clearOutput();
	output("After losing against " + currentEnemy[0].v.a + currentEnemy[0].v.short + " in the " + tourneyRound() + " round, you are removed from the tournament.\n\n<b>Better luck next time.</b>");
	CombatManager.genericLoss();
	IncrementFlag("NYREAN_TOURNEY_COUNTER");
	clearMenu();
	addButton(0,"Next",mainGameMenu);
}

//copy of the normal inventory, leads you back to the tournamentMenu instead of GameMenu
public function tournamentInventoryMenu():void
{
	showBust("");
	showName("\nINVENTORY");
	itemScreen = inventory;
	useItemFunction = inventory;
	
	clearOutput();
	output("What item would you like to use?");
	if(pc.inventory.length > 10) output("\n\n" + multiButtonPageNote());
	output("\n\n");
	inventoryDisplay();
	
	clearMenu();
	var btnSlot:int = -5;
	var i:int = 0;
	while (true)
	{
		if (i % 10 == 0 && (i < pc.inventory.length || !i))
		{
			btnSlot += 5;
			addButton(btnSlot+10, "Drop", dropItem, undefined, "Drop Item", "Drop an item to make room in your inventory.");
			addButton(btnSlot+11, "Interact", itemInteractMenu, undefined, "Interact", "Interact with some of your items.");
			addButton(btnSlot+12, "Key Item", keyItemDisplay, undefined, "Key Items", "View your list of key items.");
			addButton(btnSlot+13, "Unequip", unequipMenu, undefined, "Unequip", "Unequip an item.");
			addButton(btnSlot+14, "Back", tournamentMainMenu);
		}
		
		if (i == pc.inventory.length) break;
		
		addItemButton(btnSlot, pc.inventory[i], useItem, pc.inventory[i]);
		btnSlot++;
		i++;
	}
	
	//Set user and target.
	itemUser = pc;
}

public function tournamentWithdraw():void
{
	clearOutput();
	output("Do you really want to withdraw from the tournament?");
	CombatManager.abortCombat();
	clearMenu();
	addButton(0,"No",tournamentMainMenu);
	addButton(1,"Yes",mainGameMenu);
}
/*
public function tournamentDEBUG():void
{
	clearOutput();

//	output(npcDuel.length);
	for (var i:int = 0; i < npcDuel.length; i++)
	{
		output(npcDuel[i].v + "   " + npcDuel[i].w);
		output("\n");
	}
	output("\n\n");
	for (var j:int = 0; j < possibleEnemies.length; j++)
	{
		output(possibleEnemies[j].v + "   " + possibleEnemies[j].w);
		output("\n");
	}

}	*/

//similiar to the normal weightedRand, but returns the index number of the array instead of v
public function weightedRandIndex(... args):*
{
	var opts:Array;
	
	if (args.length > 0 && args[0] is Array)
	{
		opts = args[0];
	}
	else
	{
		opts = args;
	}
	
	// args = objs
	// { v: value, w: weight };
	// { v: funcRef, w: 10 }, { v: rareFuncRef, w: 1 }
	
	var total:int = 0;
	for (var i:int = 0; i < opts.length; i++)
	{
		total += opts[i].w;
	}
	
	var randSelection:int = rand(total);
	randSelection += 1; 
	// the weights are effectively 1-index, not 0, so if we bump up 1 we'll get the correct answer
	// 4 numbers with the same weight:
	// WRand test: 2499,2461,2561,2479
	
	for (i = 0; i < opts.length; i++)
	{
		randSelection -= opts[i].w;
		if (randSelection <= 0) return i;
	}
	
	// fallback
	return args[rand(opts.length)];
}

