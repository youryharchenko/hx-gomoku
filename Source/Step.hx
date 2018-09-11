package;

import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFieldType;

class Step extends Sprite {
    private var sx:Int;
    private var sy:Int;
    private var c:Int;
    private var n:Int;
    private var txt:TextField = new TextField();
    private var w = Game.d + 1 + Game.d;
    private var h = Game.d + 1 + Game.d;

    public function new(x:Int, y:Int, c:Int, n:Int) {

        super();

        this.sx = x;
        this.sy = y;
        this.c = c;
        this.n = n;
        
        txt.text = '${n + 1}';
		txt.textColor = Game.bw.get(ac(c));
		txt.autoSize = TextFieldAutoSize.LEFT;
		txt.type = TextFieldType.DYNAMIC;
		txt.x = (w - txt.textWidth) / 2 - 3; //txt.textWidth / 2 + 9;
		txt.y = (h - txt.textHeight) / 2 - 3;//txt.textHeight / 2 + 4;
		txt.width = Game.d + Game.d;
		txt.height = Game.d + Game.d;
		addChild(txt);

        draw();

    }

    private function ac(c:Int):Int {return 3 - c;}

    public function getx():Int {
		return sx;
	}

	public function gety():Int {
		return sy;
	}

    public function getc():Int {
		return c;
	}

    public override function toString():String {
        return('Step{sx: $sx, sy: $sy, x: $x, y: $y, c: $c}');
    }

    public function draw() {

		graphics.clear();

		graphics.beginFill (Game.bg);

		graphics.lineStyle (1, Game.fg);

		graphics.beginFill(Game.bw.get(c));

		var cx = Game.d;
		var cy = Game.d;

		graphics.drawCircle(cx, cy, Game.d);

	}

}