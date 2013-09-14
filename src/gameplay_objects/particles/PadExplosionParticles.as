package gameplay_objects.particles
{
	import com.greensock.easing.Quad;
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import classes.stat.Game;
	
	public class PadExplosionParticles extends Particle 
	{
		
		
		public function PadExplosionParticles(x:Number, y:Number) 
		{
			this.x = x;
			this.y = y;
			
			explode();
		}
		
		private var partBit:Bitmap;
		
		private function get pad_bd():BitmapData
		{
			var tbd:BitmapData = new BitmapData(GameView.pad.width, GameView.pad.height);
			tbd.draw(GameView.pad);
			return tbd;
		}
		
		
		public function explode():void
		{
			timeline.autoRemoveChildren = true;
			
			for (var i:uint = 0; i < 40; i++)
			{
				partBit = new Bitmap();
				partBit.bitmapData = new BitmapData(10, 10);
				
				partBit.bitmapData.copyPixels(pad_bd, new Rectangle(i < 20 ? i * 10 : (i-20) * 10, i < 20 ? 0 : 10, 10, 10), new Point());
				
				partBit.x = i < 20 ? i * 10 : (i - 20) * 10;
				partBit.y = i < 20 ? 0 : 10;
				this.addChild(partBit);
				
				tweenVars = new Object();
				tweenVars["scaleX"] = 0;
				tweenVars["scaleY"] = 0;
				tweenVars["ease"] = Quad.easeOut;
				
				tweenVars["x"] = 90*(Math.random()-0.5) + partBit.x;
				tweenVars["y"] = 90*(Math.random()-0.5) + partBit.y;
				timeline.insert(TweenLite.to(partBit, 0.7, tweenVars));
				
			}
			
			
		}
		
		
	}

}