package worlds 
{
	import flash.geom.Rectangle;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author ...
	 */
	public class GameOver extends World 
	{
		[Embed(source = "../../lib/over/bgart.png")]
		private static const BG_PNG:Class;
		[Embed(source = "../../lib/over/gameoverLabel.png")]
		private static const GAMEOVER_PNG:Class;
		[Embed(source = "../../lib/over/menu.png")]
		private static const MENU_PNG:Class;
		[Embed(source = "../../lib/over/playAgain.png")]
		private static const AGAIN_PNG:Class;
		
		public var bgArt:Image = new Image(BG_PNG);
		public var gameOverText:Image = new Image(GAMEOVER_PNG);
		public var menuButton:Image = new Image(MENU_PNG);
		public var againButton:Image = new Image(AGAIN_PNG);
		
		public static var gameScore:uint = 0;
		public var score:Text;
		
		public function GameOver() 
		{
			bgArt.x = (FP.width - bgArt.width) / 2;
			bgArt.y = (FP.height - bgArt.height) / 2;
			addGraphic(bgArt);
			
			gameOverText.x = (FP.width - gameOverText.width) / 2;
			gameOverText.y = 20;
			addGraphic(gameOverText);
			
			menuButton.x = againButton.width;
			menuButton.y = FP.height - menuButton.height;
			addGraphic(menuButton);
			
			againButton.x = 0;
			againButton.y = FP.height - againButton.height;
			addGraphic(againButton);
			
			//this game score
			//gameScore = 6360;
			score = new Text("Score: " + String(gameScore));
			score.smooth = true;
			score.size = 42;
			
			score.color = 0x5CE998;
			score.y = 80;
			score.x = (FP.width - score.width) / 2;
			addGraphic(score);
			
			var highs:Array = new Array();
			var highText:Text;
			
			for (var i:uint = 0; i < GameWorld.getHighScores().length; i++)
			{
				highText = new Text(String(i + 1) + ". " + String(GameWorld.getHighScores()[i]));
				highText.smooth = true;
				highText.size = 40;
				highText.x = 250;
				highText.y = 120 + i * 50;
				if (GameWorld.getHighScores()[i] == gameScore) highText.color = 0x5CE998;
				addGraphic(highText);
			}
			
		}
		
		override public function update():void 
		{
			if (Input.mousePressed)
			{
				if (GameWorld.mouseCollideRect(new Rectangle(againButton.x, againButton.y, againButton.width, againButton.height)))
				{
					FP.world = new GameWorld;
				}
			}
			
			super.update();
		}
		
	}

}