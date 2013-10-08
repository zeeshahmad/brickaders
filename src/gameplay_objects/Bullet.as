package gameplay_objects 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import gameplay_objects.bricks.Brick;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.World;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class Bullet extends Entity 
	{
		private var speed:Number;
		private var direction:Number;
		
		public function Bullet(from:Point, dir:Number, spd:Number, radius:Number, w:World) 
		{
			speed = spd;
			direction = dir;
			
			var r:Number = radius;
			var pic:BitmapData = new BitmapData(r * 2, r * 2, true, 0);
			Draw.setTarget(pic);
			Draw.circlePlus(r, r, r, 0xffffff);
			
			graphic = new Image(pic);
			setHitbox(pic.width, pic.height);
			
			x = from.x - halfWidth;
			y = from.y - halfHeight;
			
			w.add(this);
			
		}
		
		private var b:Brick;
		
		override public function update():void 
		{
			moveBy(speed * Math.cos(direction) * GameWorld.move * GameWorld.timeFactor, speed * Math.sin(direction) * GameWorld.move * GameWorld.timeFactor);
			
			if (collide("pad", x, y))
			{
				var hitPadScore:int = -20 - Math.ceil(GameWorld.wave * 0.1);
				GameWorld.addScore( hitPadScore);
				if (world != null) world.add(new ScoreShow(hitPadScore, x, y - 20));
				end();
			}
			//angle < Math.PI - heightAngle && angle > heightAngle
			
			if (collide("brick", x, y))
			{				
				(collide("brick", x, y) as Brick).destroy();
				end();
			}
			
			
			if (x < SideBar.W) direction = Math.asin(Math.sin(direction));
			if (x + width > FP.width) direction = Math.atan2(Math.sin(direction), -Math.abs(Math.cos(direction)));
			if (y < 0) end();
			if (y + height > GameWorld.pointBar.y) end();
			
			super.update();
		}
		
		public function end():void
		{
			if (world != null) world.remove(this);
		}
		
		
	}

}