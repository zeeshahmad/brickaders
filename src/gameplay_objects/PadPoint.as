package gameplay_objects 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class PadPoint extends Entity 
	{
		[Embed(source = "../../lib/point/pointani.png")]
		public static const POINT_SHEET:Class;
		
		public var pointSpritemap:Spritemap = new Spritemap(POINT_SHEET, 256, 256);
		
		private static const framesForSheet:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29];
		
		public var pointType:String;
		
		public var anchorLine:Image;
		
		public function PadPoint(_x:Number) 
		{
			pointSpritemap.add("added", framesForSheet, 60, false);
			
			var radius:Number = 16;
			pointSpritemap.scale = 1 / 4;
			graphic = pointSpritemap;
			setHitbox(radius * 2, radius * 2);
			x = _x - halfWidth;
			y = 480 - radius * 2 - 20;
			
			FP.world.add(this);
			
			pointSpritemap.play("added");
			
			var lineBD:BitmapData = new BitmapData(2, y - GameWorld.pointBar.nY, false, 0);
			anchorLine = new Image(lineBD);
			anchorLine.scaleY = 0;
			
			addGraphic(anchorLine);
			anchorLine.y = - ( y - GameWorld.pointBar.nY);
			anchorLine.x = halfWidth - anchorLine.width / 2;
			
			anchorTween.tween(anchorLine, "scaleY", 1, 0.25, Ease.quadOut);
		}
		
		private var anchorTween:VarTween = new VarTween();
		
		public function anchor():void
		{
			addTween(anchorTween, true);
		}
		
		public function disappear():PadPoint
		{
			pointSpritemap.alpha = 0.8;
			anchorLine.alpha = 0.8;
			
			var dtween:VarTween = new VarTween(r);
			dtween.tween(pointSpritemap, "alpha", 0, 0.5, Ease.quadIn);
			addTween(dtween, true);
			var dtween2:VarTween = new VarTween(r);
			dtween2.tween(anchorLine, "alpha", 0, 0.5, Ease.quadIn);
			addTween(dtween2, true);
			return this;
		}
		
		public function r():void
		{
			if (world != null) world.remove(this);
		}
		
	}

}