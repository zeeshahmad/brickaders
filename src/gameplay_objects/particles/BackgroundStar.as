package gameplay_objects.particles 
{
	import flash.display.BitmapData;
	import gameplay_objects.PointBar;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BackgroundStar extends Entity 
	{
		
		private var img:Image;
		
		public function BackgroundStar() 
		{
			type = "bgStar";
			
			var r:Number = Main.pickRandomFromArray([4, 5, 6]);
			
			
			var p:BitmapData = new BitmapData(2 * r, 2 * r, true, 0);
			Draw.setTarget(p);
			Draw.circlePlus(r, r, r, 0xffffff);
			img = new Image(p);
			graphic = img;
			
			img.alpha = 0;
			
			x = FP.rand(FP.width - 2 * r);
			y = FP.rand(PointBar.Y - 2 * r);
		}
		
		override public function added():void 
		{
			var time:Number = Main.pickRandomFromArray([3, 6, 9]);
			//start animation
			var t:MultiVarTween = new MultiVarTween();
			t.tween(img, { alpha:Main.pickRandomFromArray([0.3,0.6,0.8]) }, time);
			addTween(t);
			var t2:MultiVarTween = new MultiVarTween(removeStar);
			t2.tween(img, { alpha:0 }, Main.pickRandomFromArray([0.3, 0.6, 0.8]), null, time);
			addTween(t2);
			
			
			super.added();
		}
		
		private function removeStar():void
		{
			if (world != null) world.recycle(this);
		}
		
	}

}