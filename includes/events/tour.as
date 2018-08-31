	import classes.Characters.BothriocPidemme;
	import classes.Characters.CarlsRobot;
	import classes.Characters.CrystalGooT1;
	import classes.Characters.CrystalGooT2;
	import classes.Characters.FrogGirl;
	import classes.Characters.GooKnight;
	import classes.Characters.HuntressVanae;
	import classes.Characters.KorgonneFemale;
	import classes.Characters.KorgonneMale;
	import classes.Characters.KQ2BlackVoidGrunt;
	import classes.Characters.LapinaraFemale;
	import classes.Characters.MyrGoldBrute;
	import classes.Characters.MyrGoldRemnant;
	import classes.Characters.MyrRedCommando;
	import classes.Characters.MyrGoldSquad;
	import classes.Characters.Naleen;
	import classes.Characters.NaleenMale;
	import classes.Characters.NyreaAlpha;
	import classes.Characters.NyreaBeta;
	import classes.Characters.NyreanPraetorians;
	import classes.Characters.RaskvelFemale;
	import classes.Characters.RaskvelMale;
	import classes.Characters.Queensguard;
	import classes.Characters.WetraxxelBrawler;
	import classes.StringUtil;

public var currentRound:int;
public const maxRounds:int = 5;
public var numberOfEnemies:int;
public var genericEnemies:Array;
public var possibleEnemies:Array;
public var currentEnemy:Array;
public var npcDuel:Array;

public function tournamentCurrentRound():String
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

//push data for the unique enemies into an array
//this is for enemies that should appear no more that once (ie named characters)
public function tournamentSetUpUniqueEnemies():void
{
	possibleEnemies = new Array();
	//v doenst really matter here, its overwriten later anyway
	//w is weight for the random generator. Keep w LOW! Heigh w is for trash mobs, low w for elites
	possibleEnemies.push( { v: 0, w: 1, c: new CarlsRobot() } );
	if (rand(2) == 0) possibleEnemies.push( { v: 1, w: 1, c: new HuntressVanae() } );
	if (rand(2) == 0) possibleEnemies.push( { v: 2, w: 1, c: new KQ2BlackVoidGrunt() } );
	if (rand(3) == 0) possibleEnemies.push( { v: 3, w: 1, c: new MyrRedCommando() } );
	if (rand(5) == 0) possibleEnemies.push( { v: 4, w: 1, c: new WetraxxelBrawler() } );
}

//put data for the generic enemies into a new array
public function tournamentSetUpGenericEnemies():void
{
	genericEnemies = [
		// indexnumber, weight, class
		//v will be overwriten by the function below, so dont bother setting it
		{ v: 0, w: 1, c: new BothriocPidemme() },
		{ v: 1, w: 1, c: new NyreanPraetorians() },
		{ v: 2, w: 1, c: new MyrGoldBrute() },
		{ v: 3, w: 3, c: new MyrGoldRemnant() },
		{ v: 4, w: 2, c: new MyrGoldSquad() },
		{ v: 5, w: 3, c: new GooKnight() },
		{ v: 6, w: 5, c: new CrystalGooT1() },
		{ v: 7, w: 5, c: new CrystalGooT2() },
		{ v: 8, w: 7, c: new NyreaAlpha() },
		{ v: 9, w: 10, c: new NyreaBeta() },
		{ v: 10, w: 5, c: new FrogGirl() },
		{ v: 11, w: 6, c: new KorgonneFemale() },
		{ v: 12, w: 6, c: new KorgonneMale() },
		{ v: 13, w: 5, c: new LapinaraFemale() },
		{ v: 14, w: 3, c: new Naleen() },
		{ v: 15, w: 3, c: new NaleenMale() },
		{ v: 16, w: 4, c: new RaskvelFemale() },
		{ v: 17, w: 4, c: new RaskvelMale() }
	];
	tournamentFixListIndex(genericEnemies);
}

public function tournamentSetUpEnemies():void
{
	tournamentSetUpUniqueEnemies();
	//draw some names from the hat and fill up the enemy array with them
	while (possibleEnemies.length < numberOfEnemies)
	{
		//I know its kinda stupid to remade this list constantly, but otherwise the characters are treated as references - defeat one and you have defeated all of that type
		tournamentSetUpGenericEnemies();
		possibleEnemies.push(genericEnemies[weightedRand(genericEnemies)]);
	}
}

public function tournamentFixListIndex(list:Array):void
{
	//make sure v values match the index
	for (var i:int = 0; i < list.length; i++)
	{
		list[i].v = i;
	}
}

public function tournamentIntro():Boolean
{
	output("In the gloom of the glowing fungus, you make out several banches lining the sides of the cave. The area in the middle is covered with fine sand of various colors. The hundreds of footprints on the sand give the distint impression that the cave is used for some kind of ceremonys.");
	addButton(0,"Tournament",tournamentSetUp,undefined,"Tournament","Get this party started.");
	return false;
}

public function tournamentSetUp():void
{
	currentRound = 1;
	numberOfEnemies = 31;
	tournamentSetUpEnemies();
	if (flags["TOURNAMENT_COUNTER"] == undefined) flags["TOURNAMENT_COUNTER"] = 1;
	tournamentMainMenu();
}

public function tournamentMainMenu():void
{
	clearOutput();
	clearBust();
	showName("\nTOURNAMENT");
	output("Welcome to the <b>" + flags["TOURNAMENT_COUNTER"] + ". WORLD MARTIAL ARTS TOURNAMENT</b>");
	output("\n\nYou are currently in the " + tournamentCurrentRound() + " of five rounds.\n\n<b>The remaining fighters are:</b>");
	output("\n\n[pc.name]");
	for (var i:int = 0; i < possibleEnemies.length; i++)
	{
		if (i < 15)
		{
			output("\n" + StringUtil.capitalize(possibleEnemies[i].c.short));
		}
	}
	if (possibleEnemies.length > 15) output("\n\n<b>and sixteen more.</b>\n");
	clearMenu();
	tournamentNextRound();
//	addButton(0,"Proceed",tournamentNextRound);
	addButton(4,"DEBUG",tournamentDEBUG);
	if (possibleEnemies.length > 15) addButton(5, "FullEnemyList", tournamentFullEnemyList);
	else addDisabledButton(5, "FullEnemyList");
//	addButton(0,StringUtil.capitalize(tournamentCurrentRound()) + " round",tournamentNextRound);
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
			output("\n" + StringUtil.capitalize(possibleEnemies[i].c.short));
	}
	addDisabledButton(5, "FullEnemyList");
}

public function tournamentLoserBracket():void
{
	var npcToRemove:Array = new Array();
	var y:int = possibleEnemies.length;
	var x:int;

	//first, take the first enemie from the array
	//the, take the last enemie from the array and compared weights
	//the array should have an even amount of objects (since PC and current enemy arnt part of it)
	for (var i:int = 0; i < Math.floor(y / 2); i++)
	{
		if (y >= 2) 
		{
			//put 2 enemies in a new array
			npcDuel = [possibleEnemies[i], possibleEnemies[y - i - 1]];

			//dont remove them just yet (otherwise v doent match the index anymore)
			npcToRemove.push(weightedRand(npcDuel));
		}
	}
	//sort the new arry from high to low - otherwise the index changes might screw it up
	npcToRemove.sort(Array.DESCENDING | Array.NUMERIC);
	//remove the losers from the list of possible enemies
	for (var j:int = 0; j < npcToRemove.length; j++)
	{
		possibleEnemies.splice(npcToRemove[j],1);
	}

//	possibleEnemies.splice(y,1);
//	output(npcDuel.length + " ");
	tournamentFixListIndex(possibleEnemies);
}

public function tournamentNextRound():void
{
	var x:int = rand(possibleEnemies.length);
	
	//get a new enemy from the array
	currentEnemy = new Array(possibleEnemies[x]);

	//purge that enemy from the list and fix the values
	possibleEnemies.splice(x,1);
	tournamentFixListIndex(possibleEnemies);

	output("\n<b>Your next enemy is " + indefiniteArticle(currentEnemy[0].c.short) + ".</b>");
	
	//iniate combat
	CombatManager.newGroundCombat();
	CombatManager.setFriendlyActors(pc);
	CombatManager.setHostileActors(currentEnemy[0].c);
	CombatManager.victoryScene(tournamentWonRound);
	CombatManager.lossScene(tournamentDefeat);
	CombatManager.displayLocation(tournamentCurrentRound().toUpperCase() + " ROUND");
	clearMenu();
	addButton(0, "Fight", CombatManager.beginCombat);
}

public function tournamentWonRound():void
{
	clearOutput();

	tournamentLoserBracket();
	//reduce the enemies by half and cut them off the array
//	numberOfEnemies = Math.floor(numberOfEnemies / 2);
//	possibleEnemies.splice(numberOfEnemies);

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
	IncrementFlag("TOURNAMENT_COUNTER");
	clearMenu();
	addButton(0,"Next",mainGameMenu);
}

public function tournamentDefeat():void
{
	clearOutput();
	output("After losing against " + indefiniteArticle(currentEnemy[0].c.short) + " in the " + tournamentCurrentRound() + " round, you are removed from the tournament.\n\n<b>Better luck next time.</b>");
	CombatManager.genericLoss();
	IncrementFlag("TOURNAMENT_COUNTER");
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

public function tournamentDEBUG():void
{
	clearOutput();

//	output(npcDuel.length);
	for (var i:int = 0; i < npcDuel.length; i++)
	{
		output(npcDuel[i].v + "   " + npcDuel[i].w + "   " + npcDuel[i].c);
		output("\n");
	}
/*	for (var i:int = 0; i < genericEnemies.length; i++)
	{
		output(genericEnemies[i].v + "   " + genericEnemies[i].w + "   " + genericEnemies[i].c);
		output("\n");
	}	*/
	output("\n\n");
	for (var j:int = 0; j < possibleEnemies.length; j++)
	{
		output(possibleEnemies[j].v + "   " + possibleEnemies[j].w + "   " + possibleEnemies[j].c);
		output("\n");
	}

}
