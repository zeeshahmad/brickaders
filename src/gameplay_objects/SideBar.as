package gameplay_objects 
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import worlds.GameOver;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class SideBar extends Entity 
	{
		
		public static const W:Number = 100;
		
		public static var waveText:Text;
		
		[Embed(source = "../../lib/sidebar/musicOff.png")]
		private static const musicOffPng:Class;
		[Embed(source = "../../lib/sidebar/musicOn.png")]
		private static const musicOnPng:Class;
		[Embed(source = "../../lib/sidebar/soundOff.png")]
		private static const soundOffPng:Class;
		[Embed(source = "../../lib/sidebar/soundOn.png")]
		private static const soundOnPng:Class;
		
		[Embed(source = "../../lib/sidebar/pause.png")]
		private static const pausePng:Class;
		[Embed(source = "../../lib/sidebar/giveup.png")]
		private static const GIVEUP_PNG:Class;
		
		private var musicOn:Image;
		private var musicOff:Image;
		private var soundOn:Image;
		private var soundOff:Image;
		
		private var pause:Image;
		private var giveUp:Image;
		
		public var highLabel:Text;
		public var highText:Text;
		
		private var pauseLabel:Text = new Text("Paused");
		
		public function SideBar() 
		{
			var picture:BitmapData = new BitmapData(W, 480, true, 0);
			Draw.setTarget(picture);
			Draw.rect(0, 0, W, 480, 0x2E5C8B); 
			//0x6699CC
			graphic = new Image(picture);
			setHitbox(W, 480);
			
			type = "sidebar";
			
			waveText = new Text("Wave: 1");
			waveText.color = 0xA4DAFB;
			waveText.x = 5;
			waveText.y = 20;
			
			musicOff = new Image(musicOffPng);
			musicOn = new Image(musicOnPng);
			
			soundOff = new Image(soundOffPng);
			soundOn = new Image(soundOnPng);
			
			pause = new Image(pausePng);
			giveUp = new Image(GIVEUP_PNG);
			
			
			addGraphic(musicOff); addGraphic(musicOn);
			addGraphic(soundOff); addGraphic(soundOn);
			addGraphic(pause);
			
			musicOff.x = 10;
			musicOn.x = 10;
			musicOff.y = FP.height - 2*(musicOff.height + 20);
			musicOn.y = FP.height - 2*(musicOn.height + 20);
			
			soundOff.x = 10;
			soundOn.x = 10;
			soundOff.y = musicOff.y + musicOff.height + 20;
			soundOn.y = musicOff.y + musicOff.height + 20;
			
			pause.x = 10;
			pause.y = 110;
			
			highLabel = new Text("High Score:");
			highLabel.size = 15;
			highLabel.x = 5;
			highLabel.y = 40;
			addGraphic(highLabel);
			
			highText = new Text(GameWorld.getHighScores()[0]);
			highText.size = 15;
			highText.smooth = true;
			highText.x = 2;
			highText.y = 60;
			
			pauseLabel.size = 35;
			pauseLabel.x = (FP.width - pauseLabel.width - SideBar.W) / 2 + SideBar.W;
			pauseLabel.y = (PointBar.Y - pauseLabel.height) / 2;
			pauseLabel.smooth = true;
			pauseLabel.visible = false;
			
			giveUp.x = (FP.width - SideBar.W - giveUp.width) / 2 + SideBar.W;
			giveUp.y = 300;
			
			giveUp.visible = false;
			
		}
		
		override public function added():void 
		{
			addGraphic(waveText);
			addGraphic(highText);
			addGraphic(pauseLabel);
			addGraphic(giveUp);
			
			super.added();
		}
		
		public var resumeDelay:Number;
		public var resumeTween:MultiVarTween;
		
		override public function update():void 
		{
			if (Input.mousePressed)
			{
				if (GameWorld.mouseCollideRect(new Rectangle(pause.x, pause.y, pause.width, pause.height)))
				{
					if (!GameWorld.paused)
					{
						pauseLabel.text = "Game Paused";
						pauseLabel.width = pauseLabel.textWidth;
						pauseLabel.visible = true;
						giveUp.visible = true;
						pauseLabel.x = (FP.width - pauseLabel.width - SideBar.W) / 2 + SideBar.W;
						GameWorld.move = 0;
						GameWorld.paused = true;
					}
					else if ((resumeTween != null && !resumeTween.active) || resumeTween == null)
					{
						if (true)
						{
							resumeDelay = 2;
							
							resumeTween = new MultiVarTween(resumeGame);
							resumeTween.tween(this, { resumeDelay: 0 }, 2);
							addTween(resumeTween, true);
						}
					}
				}
			}
			
			if (GameWorld.paused)
			{
				if (Input.mousePressed && GameWorld.mouseCollideRect(new Rectangle(giveUp.x, giveUp.y, giveUp.width, giveUp.height)))
				{
					FP.world = new GameOver;
				}
				
				else if (resumeTween != null) {if (resumeTween.active)
				{
					pauseLabel.text = "Action resumes in " + String(Math.ceil(resumeDelay));
					pauseLabel.x = (FP.width - pauseLabel.width - SideBar.W) / 2 + SideBar.W;
				}}
			}
			
			super.update();
		}
		
		public function resumeGame():void
		{
			GameWorld.move = 1;
			GameWorld.paused = false;
			pauseLabel.visible = false;
			giveUp.visible = false;
		}
		
	}

}