package gameplay_objects 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ScoreShow extends Entity 
	{
		/*[Embed(source = "../../lib/sounds/scoreUp.mp3")]
		private static const UP_SND:Class;
		private static var upSnd:Sfx = new Sfx(UP_SND);*/
		
		[Embed(source = "../../lib/sounds/scoreDown.mp3")]
		private static const DOWN_SND:Class;
		private static var downSnd:Sfx = new Sfx(DOWN_SND);
		
		public var showString:String;
		public var text:Text;
		
		public function ScoreShow(amount:int, _x:Number, _y:Number, label:String = "") 
		{
			x = _x;
			y = _y;
			
			var c:uint;
			
			if (amount > 0) {
				showString = label + " +";
				c = 0xffffff;
				//if (GameWorld.soundOn) upSnd.play();
				
			}
			else if (amount < 0) {
				showString = label + " -";
				c = 0xE73103;
				if (GameWorld.soundOn) downSnd.play();
			}
			else {
				showString = label;
				c = 0xB9B9B9;
			}
			
			showString += String(Math.abs(amount));
			
			text = new Text(showString);
			text.size = 24;
			text.color = c;
			graphic = text;
			
			x = Math.min(Math.max(x, SideBar.W), FP.width - text.width);
			y = Math.min(Math.max(y, 0), PointBar.Y - text.height);
			
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