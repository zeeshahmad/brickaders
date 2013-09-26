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
			
			if (amount > 0) showString = "+ ";
			else if (amount < 0) showString = "- ";
			else showString = "";
			
			showString += String(Math.abs(amount));
			
			text = new Text(showString);
			text.size = 24;
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