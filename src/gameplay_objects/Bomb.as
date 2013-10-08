package gameplay_objects 
{
	import adobe.utils.CustomActions;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import gameplay_objects.bricks.Brick;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Ease;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class Bomb extends Entity 
	{
		
		[Embed(source = "../../lib/bricks/bomb.png")]
		private static const BOMB_PNG:Class;
		private var pic:Image;
		
		[Embed(source = "../../lib/sounds/bomb.mp3")]
		private static const BOMB_SND:Class;
		private var bombSnd:Sfx = new Sfx(BOMB_SND);
		
		public var to:Point;
		
		public var middle:Image;
		
		public function Bomb(iX:Number, iY:Number, toX:Number, toY:Number) 
		{
			x = iX;
			y = iY;
			
			type = "bomb";
			
			to = new Point(toX, toY);
			
			pic = new Image(BOMB_PNG);
			graphic = pic;
			setHitbox(pic.width, pic.height, pic.width/2, pic.height/2);
			pic.centerOrigin();
			
			var mD:Number = 6;
			var middleBD:BitmapData = new BitmapData(mD, mD, true, 0);
			Draw.setTarget(middleBD);
			Draw.circlePlus(mD / 2, mD / 2, mD / 2, 0xDBE335);
			middle = new Image(middleBD);
			middle.x = -middle.width/2;
			middle.y = -middle.height/2;
			addGraphic(middle);
		}
		
		public var speed:Number;
		public var moveTween:MultiVarTween = new MultiVarTween();
		
		override public function added():void 
		{
			moveTween.tween(this, { x:to.x, y:to.y }, 1.5, Ease.quadOut);
			addTween(moveTween, true);
			
			
			blink();
			bombSnd.complete = explode;
			bombSnd.play();
			
			super.added();
		}
		
		public var diff:Point;
		public var brk:Brick;
		
		public var collided:Boolean = false;
		
		public var blinkTween:MultiVarTween;
		
		public function blink():void
		{
			middle.visible = !middle.visible;
			blinkTween = new MultiVarTween(blink);
			blinkTween.tween(this, { }, 0.05);
			addTween(blinkTween);
		}
		
		override public function update():void 
		{
			if (pic.angle < 360) pic.angle += 4;
			else pic.angle = 0;
			
			
			if (collide("brick", x, y) && !collided)
			{
				collided = true;
				brk = collide("brick", x, y) as Brick;
				diff = new Point(x - brk.x, y - brk.y);
				if (moveTween != null) if (moveTween.active) moveTween.cancel();
			}
			else if (collided)
			{
				x = brk.x + diff.x;
				y = brk.y + diff.y;
			}
			
			super.update();
		}
		
		public function explode():void
		{
			if (blinkTween != null) if (blinkTween.active) blinkTween.cancel();
			
			var a:Array = GameWorld.entitiesByType("brick", FP.world);
			for (var i:uint = 0; i < a.length; i++)
			{
				if ((a[i] as Entity).distanceFrom(this, true) < 70)(a[i] as Brick).destroy();
			}
			GameWorld.del(this);
		}
		
		
	}

}