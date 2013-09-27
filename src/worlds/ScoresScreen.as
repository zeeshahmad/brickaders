package worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class ScoresScreen extends World 
	{
		[Embed(source = "../../lib/scores/title.png")]
		private static const TITLE_PNG:Class;
		private var title:Image = new Image(TITLE_PNG);
		
		public function ScoresScreen() 
		{
			title.x = FP.halfWidth - title.width / 2;
			title.y = 50;
			addGraphic(title);
			
			var highs:Array = new Array();
			var highText:Text;
			
			
			for (var i:uint = 0; i < GameWorld.getHighScores().length; i++)
			{
				highText = new Text(String(i + 1) + ". " + String(GameWorld.getHighScores()[i]));
				highText.smooth = true;
				highText.size = 40;
				highText.x = 250;
				highText.y = 200 + i * 50;
				addGraphic(highText);
			}
			
		}
		
		override public function update():void 
		{
			if (Input.mousePressed)
			{
				FP.world = new MainMenuWorld;
			}
			
			super.update();
		}
		
	}

}