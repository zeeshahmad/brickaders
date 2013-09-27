package gameplay_objects 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BallEnemy extends Entity 
	{
		
		[Embed(source = "../../lib/ball/ballEnemy.png")]
		private static const PNG:Class;
		public var img:Image;
		
		private var speed:Number = 1.2;
		
		public function BallEnemy() 
		{
			img = new Image(PNG);
			graphic = img;
			setHitbox(img.width, img.height);
			
			x = SideBar.W + FP.rand(FP.width - SideBar.W - img.width);
			y = -height;
			
			type = "ballenemy";
		}
		
		
		
		override public function update():void 
		{
			y += speed * GameWorld.move * FP.rate * GameWorld.timeFactor;
			
			if (y > FP.height * 0.6)
			speed = -Math.abs(speed);
			
			if (collide("ball", x, y))
			{
				(collide("ball", x, y) as Ball).removeOrbiters(false);
				(collide("ball", x, y) as Ball).destroy();
				GameWorld.doGameOver();
			}
			
			
			if (speed < 0 && y < -height) if (world != null) world.remove(this);
			
			super.update();
		}
		
	}

}