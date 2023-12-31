package gameplay_objects 
{
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ActionMenu extends Entity 
	{
		
		[Embed(source = "../../lib/actions_tiles/bgdisk.png")]
		private static const BG_DISK_PNG:Class;
		
		[Embed(source = "../../lib/actions_tiles/selector.png")]
		private static const SELECTOR_PNG:Class;
		private var selector:Image;
		
		[Embed(source = "../../lib/actions_tiles/options.png")]
		private static const OPTIONS_PNG:Class;
		private var options:Image;
		
		[Embed(source="../../lib/sounds/action_hover.mp3")]
		private static const HOVER_SND:Class;
		private var hoverSnd:Sfx = new Sfx(HOVER_SND);
		
		[Embed(source = "../../lib/sounds/action_invoke.mp3")]
		private static const INVOKE_SND:Class;
		private var invokeSnd:Sfx = new Sfx(INVOKE_SND);
		
		[Embed(source = "../../lib/sounds/option_select.mp3")]
		private static const SELECT_SND:Class;
		private var selectSnd:Sfx = new Sfx(SELECT_SND);
		
		public var leftIndicator:Text;
		
		public static var active:Boolean;
		
		private static var disk:Image;
		
		public static var selectedIndex:int;
		
		public function ActionMenu() 
		{
			disk = new Image(BG_DISK_PNG);
			graphic = disk;
			
			x = FP.halfWidth + SideBar.W / 2 - Image(graphic).width / 2;
			y = FP.halfHeight - PointBar.H / 2 - Image(graphic).height / 2;
			
			
			selector = new Image(SELECTOR_PNG);
			
			selector.x = Image(graphic).width / 2;
			selector.y = Image(graphic).height / 2;
			selector.smooth = true;
			addGraphic(selector);
			selector.visible = false;
			//selector.angle = -60;
			
			
			addGraphic(new Image(OPTIONS_PNG));
			
			leftIndicator = new Text("0");
			addGraphic(leftIndicator);
			
			
			active = false;
		}
		
		
		public function show():void
		{
			if (!active && GameWorld.i != null && GameWorld.i.typeCount("orbiter") > 0 && !Pad.shadowPadOn && !GameWorld.paused && !GameWorld.bombOn)
			{
				selectedIndex = 10; //aribitrary value for none
				
				active = true;
				selector.visible = false;
				GameWorld.i.add(this);
				GameWorld.move = 0;
				
				leftIndicator.text = String((GameWorld.i as World).typeCount("orbiter"));
				leftIndicator.size = 40;
				
				leftIndicator.x = 393 / 2-leftIndicator.width/2;
				leftIndicator.y = 393 / 2 - leftIndicator.height / 2;
				
				if (GameWorld.soundOn) invokeSnd.play();
			}
		}
		
		public function hide():void
		{
			if (active)
			{
				active = false;
				GameWorld.move = 1;
				GameWorld.actionInvoker.visible = true;
			}
			if (this.world != null) this.world.remove(this);
		}
		
		
		private function executeAction():void
		{
			if (selectedIndex != 10)
			{
				if (world != null) if (world.typeFirst("orbiter") != null) GameWorld.del(world.typeFirst("orbiter"));
				
				var ar:Array;
				trace("action selected index: " + String(selectedIndex));
				if (selectedIndex == 0)
				{
					//pad shoots bullets
					GameWorld.doBulletsFromPad();
					
					//GameWorld.doRewind();
				}
				else if (selectedIndex == 1)
				{
					//reverse ball
					var unlocked:Boolean = GameWorld.doUnlockPad();
					var unlckBall:Ball = FP.world.typeFirst("ball") as Ball;
					if (unlckBall != null && !unlocked)
					{
						FP.world.add(new Orbiter(unlckBall));
					}
				}
				else if (selectedIndex == 2 )
				{
					//shadow pad
					GameWorld.pad.doShadow();
				}
				else if (selectedIndex == 3)
				{
					//bomb
					GameWorld.doBomb();
					FP.world.add(new ScoreShow(0, FP.halfWidth-30, FP.halfHeight, "Tap to Deploy"));
				}
				else if (selectedIndex == 4)
				{
					//power
					Ball.doPower();
				}
				else if (selectedIndex == 5)
				{
					//slomo
					GameWorld.doSlomo();
				}
				
				if (GameWorld.soundOn) selectSnd.play();
			}
			else {
				trace("no action selected");
			}
		}
		
		
		private static const innerR:Number = 25;
		private var prevI:int;
		
		override public function update():void 
		{
			if (active)
			{
				if (Input.mouseDown)
				{
					if (
					((Input.mouseX < x + 393/2 - innerR || Input.mouseX > x+393/2+innerR) || (Input.mouseY < y + 393/2 - innerR || Input.mouseY > y+393/2+innerR))
					&& GameWorld.mouseCollideRect(new Rectangle(x-20, y-20, disk.width+40, disk.height+40)) ) 
					{
						selector.visible = true;
						for (var i:uint = 0; i < 6; i++)
						{
							if (getMouseAngle() < 60 *(i+1) && getMouseAngle() > 60*i) 
							{
								selector.angle = -60 * (i + 3);
								
								if (selectedIndex != i)
								{
									if (GameWorld.soundOn) hoverSnd.play();
								}
								
								selectedIndex = i;
							}
						}
					}
					else {
						selector.visible = false;
						selectedIndex = 10;
					}
					
				}
				else
				{
					hide();
					executeAction();
				}
			}
			
			super.update();
		}
		
		private function getMouseAngle():Number
		{
			return (Math.atan2(Input.mouseY - y - 393 / 2, Input.mouseX - x - 393 / 2) * 180 / Math.PI) + 180;
		}
	}
	

}