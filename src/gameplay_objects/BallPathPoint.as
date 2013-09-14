package gameplay_objects 
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Tween;
	import net.flashpunk.Tweener;
	import net.flashpunk.utils.Draw;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class BallPathPoint extends Entity 
	{
		
		public function BallPathPoint(_x:Number, _y:Number) 
		{
			var picture:BitmapData = new BitmapData(12, 12, true, 0);
			Draw.setTarget(picture);
			
			Draw.circlePlus(6, 6, 6, 0xD00404, 1, true);
			graphic = new Image(picture);
			/*this.graphics.beginFill(0xD00404);
			this.graphics.drawCircle(0, 0, 6);
			this.graphics.endFill();*/
			
			this.x = _x;
			this.y = _y;
			
			/*this.scaleX = 0;
			this.scaleY = 0;
			
			
			
			TweenLite.to(this, 0.6, { scaleX:1, scaleY: 1, ease: Back.easeOut } );
			
			//GameView.ballPathLayer.addChild(this);
			
			TweenLite.to(this, 0.3, { scaleX: 0, scaleY:0, delay: 3, onComplete:Main.remove, onCompleteParams:[this], ease:Back.easeIn } );
			*/
		}
		
		
	}

}