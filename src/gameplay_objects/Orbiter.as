package gameplay_objects 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class Orbiter extends Entity 
	{
		public var b:Ball;
		
		private static const R:uint = 5;
		
		private var orbitTarget:Point;
		private const A:Number = Main.pickRandomFromArray([20, 26]); 
		private const B:Number = Main.pickRandomFromArray([20, 26]);
		
		private var theta:Number; //ellipse rotation
		private var alpha:Number; //random start angle
		
		private var t:Number; //rotating parameter
		private var orbitSpeed:Number;
		
		private var attraction:Number;
		
		public function Orbiter(ball:Ball) 
		{
			b = ball;
			x = b.x;
			y = b.y;
			
			var c:uint = Main.pickRandomFromArray([0x5FB5CD, 0x99D656, 0xFD5E2F]);
			
			var pic:BitmapData = new BitmapData(R*2, R*2, true, 0);
			Draw.setTarget(pic);
			Draw.circlePlus(R, R, R, c, 0.5);
			graphic = new Image(pic);
			
			//setOrigin(R, R);
			//trace(graphic.x, graphic.y);
			type = "orbiter";
			
			t = 0;
			theta = FP.rand(180);
			alpha = FP.rand(180);
			orbitTarget = new Point();
			
			attraction = Main.pickRandomFromArray([16, 14, 15]);
			orbitSpeed = Main.pickRandomFromArray([0.15, 0.1, 0.18]);
		}
		
		
		override public function update():void 
		{
			//trace(orbitTarget);
			
			if (t > 360) t = 0;
			else t += orbitSpeed * GameWorld.timeFactor * FP.rate;
			
			theta += 0.1;
			
			orbitTarget.x = A * Math.cos(t) * Math.cos(theta) - B * Math.sin(t) * Math.sin(theta);
			orbitTarget.y = A * Math.cos(t) * Math.sin(theta) + B * Math.sin(t) * Math.cos(theta);
			
			moveTowards(orbitTarget.x + b.centerX, orbitTarget.y + b.centerY, attraction );
			super.update();
		}
		
		
	}

}