package;

import openfl.events.EventDispatcher;

typedef Point = {
    x:Int,
    y:Int,
    sp:Int
}

typedef Slot = {
    scpX:Int,
    scpY:Int,
    d:Int,
    rs:Int,
    ss:Int
}

typedef Union = {
    point:Point,
    slot:Slot
}

typedef Net = {
    allSlots:Array<Slot>,
    allPoints:Array<Point>,
    union:Array<Union>,
    steps:Array<Step>
}


class Game extends EventDispatcher {

    static public var size:Int = 15;
    static public var d:Int = 20;
    static public var bg:Int = 0xF5F5F5;
	static public var fg:Int = 0x050505;
	static public var bw = [1 => 0x000000, 2 => 0xFFFFFF];

    private var steps:Array<Step>;
    private var message:String;

    public function new(ss:Array<Step>, mess:String) {
        super();

        steps = ss;
        message = mess;
    }

    public override function toString():String {
        return 'Game{message: ${message}, count: ${steps.length}, last: ${steps[steps.length - 1]}';
    }

    public function getMessage():String {
        return message;
    }

    public function calculate():Game {
        return newGame(this);
    }

    public function getSteps():Array<Step> {
        return steps;
    }

    private function newGame(g:Game):Game {
        var net = newNet(g.steps);
        var ret:Game;

        if(checkOver(net))
            ret = new Game(g.getSteps(), 'over. You win!');
        else { 
            var nextStep = calcStep(net);
            var nextNet = applyStep(net, nextStep);
            var steps = g.getSteps();
            steps.push(nextStep);
            if (checkOver(nextNet))                 
                ret = new Game(steps, 'over. I win!');
            else
                ret = new Game(steps, "play");
        }
        return ret;
    }

    private function newNet(sts:Array<Step>):Net {
        return applySteps(initNet(), sts);
    }

    private function initNet():Net {
        var slots = [
            for (i in 0...Game.size) 
                for (j in 0...Game.size) 
                    for (k in 0...5)
                        if (isScpValid(i, j, k)) 
                            {scpX:i, scpY:j, d:k, rs:0, ss: 0}
            ];
        var points = [
            for (i in 0...Game.size) 
                for (j in 0...Game.size) 
                    {x:i, y:j, sp:0}
        ];
        var union = [
            for (p in points) 
                for (s in slots)
                    if (isPointInSlot(p, s)) 
                        {point: p, slot: s}
        ];

        var n:Net = {
            allSlots: slots,
            allPoints: points,
            union: union,
            steps:[]
        };

        return n;
    }

    private function isScpValid(x:Int, y:Int, d:Int):Bool {
        var a = Game.size - 2;
        return (
            d == 0 && y > 1 && y < a ||
            d == 1 && x > 1 && x < a ||
            d == 2 && (x > 1 && y < a) && (x < a && y > 1) ||
            d == 3 && (x > 1 && y > 1) && (x < a && y < a)
        );
    }

    private function isPointInSlot(p:Point, s:Slot):Bool {
        var ds = s.d;
        var xs = s.scpX;
        var ys = s.scpY;
        var xp = p.x;
        var yp = p.y;
        var dx = xp - xs;
        var dy = yp - ys;

        return (
            ds == 0 && dx == 0 && Math.abs(dy) < 3 ||
            ds == 1 && dy == 0 && Math.abs(dx) < 3 ||
            ds == 2 && dx == dy && Math.abs(dx) < 3 ||
            ds == 3 && dx == -dy && Math.abs(dx) < 3
        );
    }

    private function applySteps(net:Net, sts:Array<Step>):Net {
        
        for(s in sts) {
            net = applyStep(net, s);
        }

        return net;
    }

    private function applyStep(net:Net, s:Step):Net {
        net.steps.push(s);

        var nextPoints = nextAllPoints(net, s);
        var nextSlots = nextAllSlots(net, s);
        var nextUnion = [
            for (p in nextPoints) 
                for (s in nextSlots)
                    if (isPointInSlot(p, s)) 
                        {point: p, slot: s}
        ];

        net.allPoints = nextPoints;
        net.allSlots = nextSlots;
        net.union = nextUnion;

        return net;
    }

    private function nextAllPoints(net:Net, st:Step):Array<Point> {
        //var c = 1 + net.steps.length % 2;
        var c = st.getc();
        var x = st.getx();
        var y = st.gety();

        return [
            for (p in net.allPoints) 
                if (p.x == x && p.y == y)
                    {sp: c, x: x, y: y}
                else
                    p
        ];
    }

    private function nextAllSlots(net:Net, st:Step):Array<Slot> {
        //var c = 1 + net.steps.length % 2;
        var c = st.getc();
        var x = st.getx();
        var y = st.gety();
        
        function nextSlot(s:Slot, x:Int, y:Int):Slot {
            var inSlot = isPointInSlot({x: x, y: y, sp: 0}, s);
            var scpx = s.scpX;
            var scpy = s.scpY;
            var st = s.ss;
            var sd = s.d;
            var srs = s.rs;
            var ret:Slot;

            if (inSlot && st == 0) 
                ret = {scpX: scpx, scpY: scpy, d: sd, rs: 1, ss: c};
            else if (inSlot && st == c) 
                ret = {scpX: scpx, scpY: scpy, d: sd, rs: srs + 1, ss: st};
            else if (inSlot && st < 3) 
                ret = {scpX: scpx, scpY: scpy, d: sd, rs: -1, ss: 3};
            else 
                ret = s;

            return ret;
        }

        return [
            for (s in net.allSlots)
                nextSlot(s, x, y) 
        ];        
    }

    private function checkOver(net:Net):Bool {
        var active = activeSlots(net);
        return checkWin(active) || checkDraw(active);
    }

    private function checkWin(active:Map<Int, Array<Slot>>):Bool {
        return [for (s in active.get(1)) if(s.rs == 5) s].length > 0 || [for (s in active.get(2)) if(s.rs == 5) s].length > 0;
    }

    private function checkDraw(active:Map<Int, Array<Slot>>):Bool {
        return active.get(0).length == 0 && active.get(1).length == 0 && active.get(2).length == 0;
    }

    private function activeSlots(net:Net):Map<Int, Array<Slot>> {
        var all = net.allSlots;

        return [
            0 => [for(s in all) if(s.ss == 0) s],
            1 => [for(s in all) if(s.ss == 1) s],
            2 => [for(s in all) if(s.ss == 2) s]
        ];
    }

    private function calcStep(net:Net):Step {
        var c = 1 + net.steps.length % 2;
        var ps:Array<Point>;
        var p:Point;
        var mess:String;

        trace('Calc step for $c');

        function ac(c:Int):Int {return 3 - c;}
        
        ps = findSlot4(net, c);
        mess = 'Slot4: c:$c, points: $ps';

        if(ps.length == 0) {
            ps = findSlot4(net, ac(c));
            mess = 'Slot4: c:${ac(c)}, points: $ps';
        }

        if(ps.length == 0) {
            ps = findPointX(net, c);
            mess = '';
        }

        if(ps.length == 0) {
            ps = calcPointMaxRate(net, c);
            mess = 'MaxRate: c:$c, points: $ps';
        }

        if(ps.length > 0) {
            if (mess.length > 0)
                trace(mess);

            p = ps[(Math.floor(Math.random() * ps.length))];
        } else {
            throw 'Error: new step not found';
        }
        
        return new Step(p.x, p.y, c, net.steps.length);
    }

    private function findSlot4(net:Net, c:Int):Array<Point> {
        var points = [
            for (u in net.union)
                if (u.slot.ss == c && u.slot.rs == 4 && u.point.sp == 0)
                    u.point
        ];

        return points;
    }
    
    private function findPointX(net:Net, c:Int):Array<Point> {
        
        function xPoint(p:Point, c:Int, r:Int):Int {
            var pointSlots = [
                for (u in net.union)
                    if (u.point.x == p.x && u.point.y == p.y)
                        u.slot
            ];

            var i = 0;
            for (s in pointSlots)
                if (s.ss == c && s.rs > r)
                    i++;

            return i;
        }

        function findX(c:Int, r:Int, b:Int):Array<Point> {

            var ep = emptyPoints(net);
            var a = [
                for (p in ep)
                    {r: xPoint(p, c, r), p: p}
            ];

            var m = 0;
            for(e in a) {
                if (e.r > m)
                    m = e.r;
            }

            var ret = [
            for (e in a)
                if (e.r == m && e.r > b)
                    e.p
            ];

            return ret;

        }

        function ac(c:Int):Int {return 3 - c;}
        
        var ps = findX(c, 2, 1);
        var mess = 'FindX: c:$c, r:2, b:1, points: $ps';

        if(ps.length == 0) {
            ps = findX(ac(c), 2, 1);
            mess = 'FindX: c:${ac(c)}, r:2, b:1, points: $ps';
        }

        if (ps.length > 0)
            trace(mess);

        return ps;
    }

    

    private function calcPointMaxRate(net:Net, c:Int):Array<Point> {
        var ep = emptyPoints(net);
        var a = [
            for (p in ep)
                {r: ratePoint(net, p, c), p: p}
        ];

        var m = 0;
        for(e in a) {
            if (e.r > m)
                m = e.r;
        }

        var ret = [
            for (e in a)
                if (e.r == m)
                    e.p
        ];
        
        return ret;
    }

    private function emptyPoints(net:Net):Array<Point> {
        return [
            for (p in net.allPoints)
                if (p.sp == 0)
                    p
        ];
    }

    private function ratePoint(net:Net, point:Point, c:Int):Int {
        var sum = 0;
        var pointSlots = [
            for (u in net.union)
                if(u.point.x == point.x && u.point.y == point.y)
                    u.slot
        ];

        for (s in pointSlots) {
            if (s.ss == 0)
                sum += 1;
            else if (s.ss == 3)
                sum += 0;
            else
                sum += (1 + s.rs) * (1 + s.rs);
        }

        return sum;
    }



}