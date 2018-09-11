package;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.ui.Mouse;
import openfl.ui.MouseCursor;
import openfl.events.MouseEvent;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import haxe.ui.containers.dialogs.Dialog;
import haxe.ui.core.Screen;
import haxe.ui.containers.dialogs.DialogButton;


class Desk extends Sprite {
	
	public var thinking:Bool;
	public var play:Bool;

	private var size:Int = Game.size;
	private var d:Int;
	private var w:Int;
	private var h:Int;
	
	private var steps:Array<Step> = [];
	private var fields:Array<Sprite> = [];

	private var t = new Timer(100, 1);
	private var dialog:Dialog;
	private var overDialog:OverDialog;

	
	public function new () {
		
		super ();

		d = Game.d;

		w = (d + 1 + d) * (size + 1);
		h = w;

		draw();

		//addEventListener (MouseEvent.MOUSE_OVER, onMouseOver);

		for (i in 0...Game.size) 
			for (j in 0...Game.size) {
				var f = new Field(i, j);

				f.x = calcTo(i);
				f.y = calcTo(j);

        		f.addEventListener (MouseEvent.MOUSE_UP, field_onMouseUp);
				f.addEventListener (MouseEvent.MOUSE_OVER, field_onMouseOver);
				f.addEventListener (MouseEvent.MOUSE_OUT, field_onMouseOut);

				addChild(f);
		}

		t.addEventListener(TimerEvent.TIMER, function(d:Dynamic) {

			trace('TimerEvent start $d');

			var game = new Game(steps, "play");
			var calcGame = game.calculate();
		
			trace(calcGame);

			if (calcGame.getMessage() == "play") {
				var newSteps = calcGame.getSteps();
				addStep(newSteps.pop());
					
			} else {
				play = false;

				overDialog = new OverDialog();
				overDialog.opts.title = 'Game ${calcGame.getMessage()}';
				dialog = Screen.instance.showDialog(overDialog, overDialog.opts, dialogHandler);
				
			}

			Mouse.cursor = MouseCursor.ARROW;
			thinking = false;

			trace('TimerEvent finish $d');
		});


			
	}

	public function dialogHandler(b:DialogButton):Void {
		trace(b);

		for (s in steps) {
			removeChild(s);
		}

		steps = [];

		switch(b.id) {
			case 'black':
				startBlack();
			case '4':
				startBlack();
			case 'white':
				startWhite();
			case 'quit':
				//Lib.application.window.close();

		}
		
	}

	public function startBlack() {
		addStep(new Step(7, 7, 1, 0));
		thinking = true;
		play = true;

		queryAI();
	
	}

	public function startWhite() {
		addStep(new Step(7, 7, 1, 0));
		thinking = false;
		play = true;
	}

	private function queryAI() {
		Mouse.cursor = "wait";
		
		t.start();

	}

	private function onMouseOver (event:MouseEvent):Void {
		if (!play) return;
		if (thinking) return;
		//trace('Desk $event');
		Mouse.cursor = "arrow";
	}

	private function field_onMouseOver (event:MouseEvent):Void {
		if (!play) return;
		if (thinking) return;
		//trace('Field $event');
		Mouse.cursor = "hand";
	}

	private function field_onMouseOut (event:MouseEvent):Void {
		if (!play) return;
		if (thinking) return;
		//trace('Field $event');
		Mouse.cursor = "arrow";
	}

	private function field_onMouseUp (event:MouseEvent):Void {
		if (!play) return;
		if (thinking) return;
		var field:Field = event.currentTarget;
		trace('Field ${field} $event');

		var c:Int = 1 + steps.length % 2;
		var step:Step =  new Step(field.getx(), field.gety(), c, steps.length);

		addStep(step);

		queryAI();
	}

	private function step_onMouseOver (event:MouseEvent):Void {
		if (thinking) return;
		//trace('Field $event');
		Mouse.cursor = "arrow";
	}

	public function draw() {

		function ac(c:Int):Int {return 3 - c;}

		graphics.clear();

		graphics.beginFill (Game.bg);
		graphics.lineStyle (2, Game.fg);
		graphics.drawRect (0, 0, w, h);

	}

	public function getSteps():Array<Step> {
		return steps;
	}

	public function stepExists(step:Step):Bool {
		for(s in steps) {
			if (s.getx() == step.getx() && s.gety() == step.gety()) return true;
		}
		return false;
	}

	public function calcTo(i:Int):Int {
		return (d + 1 + d) * (i + 1) - d;
	}

	public function calcFrom(i:Int):Int {
		return Math.round(i / (d + 1 + d)) - 1;
	}

	public function addStep(s:Step) {
		
		steps.push(s);
		trace('New step: ${steps.length} $s');
		//trace('Steps: $steps');
		s.x = calcTo(s.getx());
		s.y = calcTo(s.gety());
		s.addEventListener (MouseEvent.MOUSE_OVER, step_onMouseOver);
		addChild(s);
		//stage.invalidate();
	}

	public function getw():Int {
		return w;
	}

	public function geth():Int {
		return h;
	}
	
}
