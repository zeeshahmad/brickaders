package gameplay_objects 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ScoreShow extends Entity 
	{
		
		public var showString:String;
		public var text:Text;
		
		public function ScoreShow(amount:int, _x:Number, _y:Number) 
		{
			x = _x;
			y = _y;
			
			var c:uint;
			
			if (amount > 0) {
				showString = "+ ";
				c = 0xffffff;
			}
			else if (amount < 0) {
				showString = "- ";
				c = 0xE73103;
			}
			else {
				showString = "";
				c = 0xB9B9B9;
			}
			
			showString += String(Math.abs(amount));
			
			text = new Text(showString);
			text.size = 24;
			text.color = c;
			addGraphic(text);
			
			var up:MultiVarTween = new MultiVarTween(removeThis);
			up.tween(text, { alpha: 0, y : -text.height }, 0.8, null, 0.5);
			addTween(up, true);
		}
		
		public function removeThis():void
		{
			GameWorld.del(this);
		}
		
	}

}