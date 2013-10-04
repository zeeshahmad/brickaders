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
		[Embed(source = "../../lib/sounds/bomb_blip.mp3")]
		private static const BOMB_BLIP_SND:Class;
		private var blipSnd:Sfx = new Sfx(BOMB_BLIP_SND);
		
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
			
			var mD:Number = 3;
			var middleBD:BitmapData = new BitmapData(mD, mD, false, 0xDED90C);
			middle = new Image(middleBD);
			middle.x = -middle.width/2;
			middle.y = -middle.height/2;
			addGraphic(middle);
		}
		
		public var speed:Number;
		public var moveTween:MultiVarTween = new MultiVarTween();
		public var bombTween:MultiVarTween = new MultiVarTween(explode);
		public static const BOMB_TIME:Number = 4;
		public var bombTime:Number;
		public var blinkInterval:Number;
		
		override public function added():void 
		{
			moveTween.tween(this, { x:to.x, y:to.y }, 3, Ease.quadOut);
			addTween(moveTween, true);
			
			blinkInterval = 1;
			bombTime = BOMB_TIME;
			prevTime = BOMB_TIME;
			bombTween.tween(this, { bombTime:0 }, bombTime);
			addTween(bombTween, true);
			
			super.added();
		}
		
		public var diff:Point;
		public var brk:Brick;
		
		public var collided:Boolean = false;
		
		public var blinkTween:MultiVarTween;
		public var prevTime:Number;
		
		override public function update():void 
		{
			
			if (pic.angle < 360) pic.angle += 4;
			else pic.angle = 0;
			
			if (bombTween.active)
			{
				if (Math.ceil(prevTime) > Math.ceil(bombTime)) blipInSecond(BOMB_TIME-bombTime);
				prevTime = bombTime;
			}
			
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
			var a:Array = GameWorld.entitiesByType("brick", FP.world);
			for (var i:uint = 0; i < a.length; i++)
			{
				if ((a[i] as Entity).distanceFrom(this, true) < 50)(a[i] as Brick).destroy();
			}
			GameWorld.del(this);
		}
		
		public var blipTweens:Array;
		
		public function blipInSecond(s:Number):void
		{
			if (blipTweens != null)
			for (var j:uint = 0; j< blipTweens.length; j++)
			{
				blipTweens[j].cancel();
			}
			
			blipTweens = new Array();
			var bt:MultiVarTween;
			var n:int = Math.ceil(Math.abs(2*s));
			for (var i:uint = 0; i < n; i++)
			{
				bt = new MultiVarTween(doBlip);
				bt.tween(this, { }, 1 / n, null, i / n);
				addTween(bt, true);
			}
		}
		
		public function doBlip():void
		{
			if (GameWorld.soundOn) blipSnd.play();
			if (middle.visible) middle.visible = false;
			else middle.visible = true;
		}
		
	}

}