import classes.Characters.GooKnight;

public function tournamentIntro():Boolean
{
	output("In the gloom of the glowing fungus, you make out several banches lining the sides of the cave. The area in the middle is covered with fine sand of various colors. The hundreds of footprints on the sand give the distint impression that the cave is used for some kind of ceremonys.");
	addButton(0,"Tournament",tournamentMainMenu,undefined,"Tournament","Get this party started.");
	return false;
}

public function tournamentMainMenu():void
{
	clearOutput();
	output("You are currently in round X.\n\n<b>The remaining fighters are:</b>");
	output("\n\n[pc.name]\n\n");
	clearMenu();
	addButton(0,"Next round",tournamentNextRound);
//	addButton(1,"Bet money",tournamentMainMenu);
//	addButton(2,"combatInventoryMenu",combatInventoryMenu);
	addButton(13,"Inventory",tournamentInventoryMenu);
	addButton(14,"Withdraw",tournamentWithdraw);
}

public function tournamentNextRound():void
{
	clearOutput();
	output("Your next enemy is: ADDANMEHEREPLZ");
	CombatManager.newGroundCombat();
	CombatManager.setFriendlyActors(pc);
	CombatManager.setHostileActors(new GooKnight());
	CombatManager.victoryScene(tournamentVictory);
	CombatManager.lossScene(tournamentDefeat);
	CombatManager.displayLocation("GOO KNIGHT");
	clearMenu();
	addButton(0, "Fight!", CombatManager.beginCombat);
}

public function tournamentVictory():void
{
	clearOutput();
	output("A winner is you! Proceed to the next round for more mindless fighting.\n\n");
	clearMenu();
	CombatManager.genericVictory();
	addButton(0,"Next",tournamentMainMenu);
}

public function tournamentDefeat():void
{
	clearOutput();
	output("You lost. Better luck next time.\n\n");
	clearMenu();
	CombatManager.genericLoss();
	addButton(0,"Next",mainGameMenu);
}

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
