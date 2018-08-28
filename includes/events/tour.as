	import classes.Characters.BothriocPidemme;
	import classes.Characters.CarlsRobot;
	import classes.Characters.CrystalGooT1;
	import classes.Characters.CrystalGooT2;
	import classes.Characters.GooKnight;
	import classes.Characters.HuntressVanae;
	import classes.Characters.LapinaraFemale;
	import classes.Characters.MyrGoldBrute;
	import classes.Characters.MyrGoldRemnant;
	import classes.Characters.MyrRedCommando;
	import classes.Characters.MyrGoldSquad;
	import classes.Characters.NyreaAlpha;
	import classes.Characters.NyreaBeta;
	import classes.Characters.NyreanPraetorians;
	import classes.Characters.Queensguard;
	import classes.Characters.WetraxxelBrawler;
	import classes.StringUtil;

public var currentRound:int;
public var numberOfEnemies:int;
public var genericEnemies:Array;
public var possibleEnemies:Array;
public var currentEnemy:Array;

public function tournamentCurrentRound():String
{
	switch (currentRound)
	{
		case 1: return "first";
		case 2: return "second";
		case 3: return "third"
		case 4: return "fourth";
		case 5: return "final";
		default: return "variable not set, plz make a bug report";
	}
}

//push data for the unique enemies into an array
//this is for enemies that should appear no more that once (ie named characters)
public function tournamentSetUpUniqueEnemies():void
{
	possibleEnemies = new Array();
	//v doenst really matter here, its overwriten later anyway
	possibleEnemies.push( { v: 0, w: 10, c: new CarlsRobot() } );
	if (rand(2) == 0) possibleEnemies.push( { v: 1, w: 10, c: new HuntressVanae() } );
	if (rand(2) == 0) possibleEnemies.push( { v: 2, w: 10, c: new KQ2BlackVoidGrunt() } );
	if (rand(3) == 0) possibleEnemies.push( { v: 3, w: 10, c: new MyrRedCommando() } );
	if (rand(5) == 0) possibleEnemies.push( { v: 4, w: 10, c: new WetraxxelBrawler() } );
}

//push data for the generic enemies into an array
public function tournamentSetUpGenericEnemies():void
{
	genericEnemies = new Array();

	// indexnumber, weight, class
	genericEnemies.push( { v: 0, w: 1, c: new BothriocPidemme() } );
	genericEnemies.push( { v: 1, w: 1, c: new NyreanPraetorians() } );
	genericEnemies.push( { v: 2, w: 1, c: new MyrGoldBrute() } );
	genericEnemies.push( { v: 3, w: 3, c: new MyrGoldRemnant() } );
	genericEnemies.push( { v: 4, w: 2, c: new MyrGoldSquad() } );
	genericEnemies.push( { v: 5, w: 3, c: new GooKnight() } );
	genericEnemies.push( { v: 6, w: 5, c: new CrystalGooT1() } );
	genericEnemies.push( { v: 7, w: 5, c: new CrystalGooT2() } );
	genericEnemies.push( { v: 8, w: 7, c: new NyreaAlpha() } );
	genericEnemies.push( { v: 9, w: 10, c: new NyreaBeta() } );
	genericEnemies.push( { v: 10, w: 5, c: new FrogGirl() } );
	genericEnemies.push( { v: 11, w: 6, c: new KorgonneFemale() } );
	genericEnemies.push( { v: 12, w: 6, c: new KorgonneMale() } );
	genericEnemies.push( { v: 13, w: 5, c: new LapinaraFemale() } );
	genericEnemies.push( { v: 14, w: 3, c: new Naleen() } );
	genericEnemies.push( { v: 15, w: 3, c: new NaleenMale() } );
	genericEnemies.push( { v: 16, w: 4, c: new RaskvelFemale() } );
	genericEnemies.push( { v: 17, w: 4, c: new RaskvelMale() } );

	//make sure values match the index
	for (var i:int = 0; i < genericEnemies.length; i++)
	{
		genericEnemies[i].v = i;
	}
}

public function tournamentSetUpEnemies():void
{
	tournamentSetUpUniqueEnemies();

	var x:int;
	//draw some names from the hat and fill up the enemy array with them
	while (possibleEnemies.length < numberOfEnemies)
	{
		//I know its kinda stupid to remade this list constantly, but otherwise the characters are treated as references - defeat one you have defeated all of that type
		tournamentSetUpGenericEnemies();
		possibleEnemies.push(genericEnemies[weightedRand(genericEnemies)]);
	}

	//make sure values match the index
	for (var i:int = 0; i < possibleEnemies.length; i++)
	{
		possibleEnemies[i].v = i;
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
	output("\n\n[pc.name]\n");
	for (var i:int = 0; i < possibleEnemies.length; i++)
	{
		if (i < 15)
		{
			output(StringUtil.capitalize(possibleEnemies[i].c.short) + "\n");
		}
	}
	if (possibleEnemies.length > 15) output("\n<b>and sixteen more.</b>\n");
//	output(possibleEnemies.length);
	clearMenu();
	tournamentNextRound();
//	addButton(0,"Proceed",tournamentNextRound);
	addButton(5,"DEBUG",tournamentDEBUG);
//	addButton(0,StringUtil.capitalize(tournamentCurrentRound()) + " round",tournamentNextRound);
//	addButton(1,"Bet money",tournamentMainMenu);
//	addButton(2,"combatInventoryMenu",combatInventoryMenu);
	addButton(13,"Inventory",tournamentInventoryMenu);
	addButton(14,"Withdraw",tournamentWithdraw);
}

public function tournamentNextRound():void
{
//	clearOutput();
	
	var x:int = rand(numberOfEnemies);
	
	//get a new enemy from the array
	currentEnemy = new Array(possibleEnemies[x]);

	//purge that enemy from the list
	possibleEnemies.splice(x,1);

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
	//reduce the enemies by half and cut them off the array
	numberOfEnemies = Math.floor(numberOfEnemies / 2);
	possibleEnemies.splice(numberOfEnemies);

	clearOutput();
	if (currentRound != 5)
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
	clearMenu();
	addButton(0,"No",tournamentMainMenu);
	addButton(1,"Yes",mainGameMenu);
}

public function tournamentDEBUG():void
{
	clearOutput();

	for (var i:int = 0; i < genericEnemies.length; i++)
	{
		output(genericEnemies[i].v + "   " + genericEnemies[i].w + "   " + genericEnemies[i].c);
		output("\n");
	}
	output("\n\n");
	for (var j:int = 0; j < possibleEnemies.length; j++)
	{
		output(possibleEnemies[j].v + "   " + possibleEnemies[j].w + "   " + possibleEnemies[j].c);
		output("\n");
	}

}
