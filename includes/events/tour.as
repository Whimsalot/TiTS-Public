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
	possibleEnemies.push([new CarlsRobot(), "1", "unique robot"]);
	if (rand(2) == 0) possibleEnemies.push([new HuntressVanae(), "1", "unique huntress"]);
	if (rand(2) == 0) possibleEnemies.push([new LapinaraFemale(), "1", "unique lapinara"]);
	if (rand(3) == 0) possibleEnemies.push([new MyrRedCommando(), "1", "unique red myr"]);
	if (rand(5) == 0) possibleEnemies.push([new WetraxxelBrawler(), "1", "unique wetraxxel"]);
}

//push data for the generic enemies into an array
public function tournamentSetUpGenericEnemies():void
{
	genericEnemies = new Array();
	//class, weight, name
//	genericEnemies.push(["new BothriocPidemme()", "1", "bothrioc pidemme"]);
	genericEnemies.push([new BothriocPidemme(), "1", "bothrioc pidemme"]);
	genericEnemies.push([new NyreanPraetorians(), "1", "nyrean praetorians"]);
	genericEnemies.push([new MyrGoldBrute(), "1", "remnant brute"]);
	genericEnemies.push([new MyrGoldRemnant(), "3", "gold remnant"]);
	genericEnemies.push([new MyrGoldSquad(), "2", "gold squad"]);
	genericEnemies.push([new GooKnight(), "4", "ganraen knight"]);
	genericEnemies.push([new CrystalGooT1(), "5", "ganrael ambusher"]);
	genericEnemies.push([new CrystalGooT2(), "5", "ganrael deadeye"]);
	genericEnemies.push([new NyreaAlpha(), "10", "nyrea huntress"]);
	genericEnemies.push([new NyreaBeta(), "7", "nyrea huntress"]);
}

public function tournamentSetUpEnemies():void
{
	tournamentSetUpUniqueEnemies();

	//draw some names from the hat and fill up the enemy array with them
	while (possibleEnemies.length < numberOfEnemies)
	{
	//	possibleEnemies.push(RandomInCollection(genericEnemies));
	//	possibleEnemies.push([new NyreaBeta(), "7", "nyrea huntress"]);

		//I know its kinda stupid to remade this list constantly, but otherwise the characters are treated as references - defeat one you have defeated all of that type
		tournamentSetUpGenericEnemies();
		possibleEnemies.push(genericEnemies[rand(genericEnemies.length)]);
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
			output(StringUtil.capitalize(possibleEnemies[i][2]) + "\n");
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

	output("\n<b>Your next enemy is " + indefiniteArticle(currentEnemy[0][2]) + ".</b>");
	
	//iniate combat
	CombatManager.newGroundCombat();
	CombatManager.setFriendlyActors(pc);
	CombatManager.setHostileActors(currentEnemy[0][0]);
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
	output("After losing against " + indefiniteArticle(currentEnemy[0][2]) + " in the " + tournamentCurrentRound() + " round, you are removed from the tournament.\n\n<b>Better luck next time.</b>");
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
	output(genericEnemies[0][0] + "   " + genericEnemies[0][1] + "   " + genericEnemies[0][2]);
	output("\n");
	output(genericEnemies[1][0] + "   " + genericEnemies[1][1] + "   " + genericEnemies[1][2]);
	output("\n\n");
	output(possibleEnemies[0][0] + "   " + possibleEnemies[0][1] + "   " + possibleEnemies[0][2]);
	output("\n");
	output(possibleEnemies[1][0] + "   " + possibleEnemies[1][1] + "   " + possibleEnemies[1][2]);
	output("\n\n");
	output("\n\n");
	output("\n\n");

	for (var i:int = 0; i < possibleEnemies.length; i++)
	{
		output(possibleEnemies[i][0] + "   " + possibleEnemies[i][1] + "   " + possibleEnemies[i][2]);
		output("\n");
	}
}
