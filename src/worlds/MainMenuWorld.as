package worlds 
{
	import flash.geom.Rectangle;
	import gameplay_objects.particles.BackgroundStar;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class MainMenuWorld extends World 
	{
		[Embed(source = "../../lib/menu/mainButtons.png")]
		private static const MAIN_BUTTONS_PNG:Class;
		private var mainButtons:Image;
		
		[Embed(source = "../../lib/menu/title.png")]
		private static const TITLE_PNG:Class;
		private var title:Image;
		
		[Embed(source = "../../lib/bg/ship.png")]
		private static const SHIP_PNG:Class;
		private var ship:Image = new Image(SHIP_PNG);
		private var shipY:Number;
		
		[Embed(source = "../../lib/music/menu.mp3")]
		private static const MUSIC_SND:Class;
		public static var music:Sfx = new Sfx(MUSIC_SND);
		
		[Embed(source = "../../lib/sounds/button.mp3")]
		private static const BUTTON_SND:Class;
		public static var buttonSnd:Sfx = new Sfx(BUTTON_SND);
		
		public function MainMenuWorld() 
		{
			mainButtons = new Image(MAIN_BUTTONS_PNG);
			mainButtons.y = FP.height - mainButtons.height;
			addGraphic(mainButtons);
			
			title = new Image(TITLE_PNG);
			title.x = (FP.width - title.width) / 2;
			title.y = - title.height;
			addGraphic(title);
			var tTween:MultiVarTween = new MultiVarTween();
			tTween.tween(title, { y: 70 }, 0.6, Ease.bounceOut);
			addTween(tTween, true);
			
			Main.CURRENT_WORLD = "mainMenuWorld";
		}
		
		override public function begin():void 
		{
			ship.x = -ship.width;
			shipY = FP.rand(FP.width - ship.height - mainButtons.height);
			addGraphic(ship);
			
			if (!music.playing) music.loop();
			
			super.begin();
		}
		
		
		public function mouseCollideImage(i:Image):Boolean
		{
			return GameWorld.mouseCollideRect(new Rectangle(i.x, i.y, i.width, i.height));
		}
		
		override public function update():void 
		{
			if (FP.rand(100) < 5 && typeCount("bgStar") < 30 )
			{
				add(new BackgroundStar());
			}
			
			if (Input.mousePressed)
			{
				if (GameWorld.mouseCollideRect(new Rectangle(mainButtons.x, mainButtons.y, 400, 100)))
				{
					FP.world = new GameWorld;
					music.stop();
				}
				else if (GameWorld.mouseCollideRect(new Rectangle(mainButtons.x + 400, mainButtons.y, 400, 100)))
				{
					FP.world = new Help;
					buttonSnd.play();
				}
				else if (GameWorld.mouseCollideRect(new Rectangle(mainButtons.x, mainButtons.y + 100, 400, 100)))
				{
					FP.world = new ScoresScreen;
					buttonSnd.play();
				}
				else if (GameWorld.mouseCollideRect(new Rectangle(mainButtons.x + 400, mainButtons.y + 100, 400, 100)))
				{
					FP.world = new About;
					buttonSnd.play();
				}
				
				
				
			}
			
			if (ship.x < FP.width) ship.x += 0.15;
			else ship.x = - ship.width;
			ship.y = shipY + 10 * Math.cos(ship.x * Math.PI/12);
			
			super.update();
		}
		
	}

}