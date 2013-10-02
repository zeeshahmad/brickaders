package gameplay_objects 
{
	import flash.geom.Point;
	import gameplay_objects.bricks.Brick;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
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
		
		public var to:Point;
		
		public function Bomb(iX:Number, iY:Number, toX:Number, toY:Number) 
		{
			x = iX;
			y = iY;
			
			
			to = new Point(toX, toY);
			
			pic = new Image(BOMB_PNG);
			graphic = pic;
			setHitbox(pic.width, pic.height, pic.width/2, pic.height/2);
			pic.centerOrigin();
		}
		
		public var speed:Number;
		
		override public function added():void 
		{
			speed = 1;
			super.added();
		}
		
		override public function update():void 
		{
			moveTowards(to.x, to.y, speed);
			if (pic.angle < 360) pic.angle += 4;
			else pic.angle = 0;
			
			if (collide("brick", x, y))
			{
				var brk:Brick = collide("brick", x, y) as Brick;
				//TODO working here
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
		}
		
	}

}