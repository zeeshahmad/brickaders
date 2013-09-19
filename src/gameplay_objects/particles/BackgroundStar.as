package gameplay_objects.particles 
{
	import flash.display.BitmapData;
	import gameplay_objects.PointBar;
	import gameplay_objects.SideBar;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Ease;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BackgroundStar extends Entity 
	{
		
		[Embed(source = "../../../lib/bg/star1.png")]
		private static const STAR1_PNG:Class;
		[Embed(source = "../../../lib/bg/star2.png")]
		private static const STAR2_PNG:Class;
		[Embed(source = "../../../lib/bg/star3.png")]
		private static const STAR3_PNG:Class;
		[Embed(source = "../../../lib/bg/star4.png")]
		private static const STAR4_PNG:Class;
		
		private var img:Image;
		
		public function BackgroundStar() 
		{
			type = "bgStar";
			layer = 1;
			
			/*var p:BitmapData = new BitmapData(2 * r, 2 * r, true, 0);
			Draw.setTarget(p);
			Draw.circlePlus(r, r, r, 0xffffff);
			img = new Image(p);*/
			img = new Image(Main.pickRandomFromArray([STAR1_PNG, STAR2_PNG, STAR3_PNG, STAR4_PNG]));
			graphic = img;
			
			img.alpha = 0;
			var r:Number = img.width/2;
			
			x = FP.rand(FP.width - 2 * r - SideBar.W) + SideBar.W;
			y = FP.rand(PointBar.Y - 2 * r - 20);
		}
		private var time:Number = Main.pickRandomFromArray([3,4,5]);
		
		override public function added():void 
		{
			// animation
			var t:MultiVarTween = new MultiVarTween(fadeAway);
			t.tween(img, { alpha:1 }, time);
			addTween(t);
			
			super.added();
		}
		
		private function fadeAway():void
		{
			clearTweens();
			var t2:MultiVarTween = new MultiVarTween(removeStar);
			t2.tween(img, { alpha:0 }, time, Ease.quadInOut, 1);
			addTween(t2);
		}
		
		private function removeStar():void
		{
			if (world != null) world.recycle(this);
		}
		
	}

}