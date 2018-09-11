package;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import openfl.events.MouseEvent;
import openfl.events.Event;
import haxe.ui.core.Screen;
import haxe.ui.Toolkit;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.containers.dialogs.DialogButton;

class Main extends Sprite {

	private var desk:Desk;
	private var startDialog:StartDialog;
	private var dialog:Dialog;
	private var d:Int = Game.d;
		
	
	public function new () {
		
		super ();

		Toolkit.init();

		desk = new Desk();
		startDialog = new StartDialog();

		desk.x = d;
		desk.y = d;

		addChild(desk);
				
		dialog = Screen.instance.showDialog(startDialog, startDialog.opts, desk.dialogHandler);
		

		//var winWidth:Int = desk.getw() + d * 2;
		//var winHeight:Int = desk.geth() + d * 2;
		
		//Lib.application.window.resize(winWidth, winHeight);

		trace('main.width: ${width}, main.height: ${height}');
		trace('stage.width: ${stage.width}, stage.height: ${stage.height}');
		trace('desk.width: ${desk.width}, desk.height: ${desk.height}');
		trace('win.width: ${Lib.application.window.width}, win.height: ${Lib.application.window.height}');
		trace('screen.width: ${Screen.instance.width}, screen.height: ${Screen.instance.height}');

			
	}

	
/*
	private function addStepHandler(addStep:AddStep):Void {
		trace('AddStepEvent $addStep');		

		var event = addStep.e;
		desk.thinking = true;

		//trace('sx: ${event.stageX}, sy: ${event.stageY}');
		//trace('x: ${event.localX}, y: ${event.localY}');

		var c:Int = 1 + desk.getSteps().length % 2;

		var step = new Step(desk.calcFrom(Math.round(event.localX)), desk.calcFrom(Math.round(event.localY)), c, 0);
		if (step.getx() < 0 || step.gety() < 0 || step.getx() > 14 || step.gety() > 14 || desk.stepExists(step)) {
			Mouse.cursor = MouseCursor.ARROW; //"arrow";
			desk.thinking = false;	
			addStep.preventDefault();
			return;
		}

		desk.addStep(step);
	}
*/
/*
	private function calcStepHandler(event:Event):Void {
		trace('CalcStepEvent start $event');
		
		Mouse.cursor = "wait";
		

		var t = new Timer(100, 1);
		t.addEventListener(TimerEvent.TIMER, function(d:Dynamic) {

			trace('TimerEvent start $d');

			var game = new Game(desk.getSteps(), "play");
			var calcGame = game.calculate();
		
			trace(calcGame);

			if (calcGame.getMessage() == "over")
				desk.play = false;

			var newSteps = calcGame.getSteps();
		
			desk.addStep(newSteps.pop());

			Mouse.cursor = MouseCursor.ARROW;
			desk.thinking = false;

			trace('TimerEvent finish $d');
		});
		t.start();
		
		trace('CalcStepEvent finish $event');

	}
*/
/*
	private function desk_onMouseMove (event:MouseEvent):Void {
		
		var step = new Step(desk.calcFrom(Math.round(event.localX)), desk.calcFrom(Math.round(event.localY)), 0, 0);

		if (!desk.play || step.getx() < 0 || step.gety() < 0 || step.getx() > 14 || step.gety() > 14 || desk.stepExists(step))
			Mouse.cursor = "arrow";
		else
			Mouse.cursor = "hand";
	}
*/
/*
	private function desk_onMouseUp (event:MouseEvent):Void {
		//trace('Desk_onMouseUp start $event');

		if (!desk.play) return;
		if (desk.thinking) return;

		dispatchEvent(new AddStep(event));

		if(!desk.thinking) return;
		
		dispatchEvent(new Event("calcStep", false, false));

		//trace('Desk_onMouseUp finish $event');
	}
*/
/*
	private function desk_renderHandler (event:Event):Void {
		trace('Desk_renderHandler $event');
		//trace('Desk draw');
		desk.draw();
	}
*/	
}


