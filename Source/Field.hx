package;

import openfl.display.Sprite;


class Field extends Sprite {
    private var sx:Int;
    private var sy:Int;
    private var w = Game.d + 1 + Game.d;
    private var h = Game.d + 1 + Game.d;

    public function new(x:Int, y:Int) {

        super();

        sx = x;
        sy = y;

        draw();
    }

    private function draw() {
        graphics.clear();

		graphics.beginFill (Game.bg);
        graphics.lineStyle (0, Game.bg);
		graphics.drawRect (0, 0, w, h);

        graphics.lineStyle (1, Game.fg);
        graphics.moveTo(Game.d, 0);
		graphics.lineTo(Game.d, h);
        graphics.moveTo(0, Game.d);
		graphics.lineTo(w, Game.d);


		
    }

    public function getx():Int {
		return sx;
	}

	public function gety():Int {
		return sy;
	}

    public override function toString():String {
        return('Field{sx: $sx, sy: $sy, x: $x, y: $y}');
    }
}