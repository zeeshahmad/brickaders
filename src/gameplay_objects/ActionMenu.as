package gameplay_objects 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ActionMenu extends Entity 
	{
		
		[Embed(source = "../../lib/actions_tiles/power.png")]
		private static const POWER_PNG:Class;
		[Embed(source = "../../lib/actions_tiles/shoot.png")]
		private static const SHOOT_PNG:Class;
		
		[Embed(source = "../../lib/actions_tiles/bgdisk.png")]
		private static const BG_DISK_PNG:Class;
		
		[Embed(source = "../../lib/actions_tiles/selector.png")]
		private static const SELECTOR_PNG:Class;
		private var selector:Image;
		
		[Embed(source = "../../lib/actions_tiles/options.png")]
		private static const OPTIONS_PNG:Class;
		private var options:Image;
		
		public static var active:Boolean;
		
		public static var selectedIndex:int;
		
		public function ActionMenu() 
		{
			
			graphic = new Image(BG_DISK_PNG);
			
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
			
			active = false;
		}
		
		
		public function show():void
		{
			if (!active && GameWorld.i != null)
			{
				active = true;
				selector.visible = false;
				GameWorld.i.add(this);
				GameWorld.move = 0;
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
		
		private static const innerR:Number = 25;
		
		override public function update():void 
		{
			if (active)
			{
				if (Input.mouseDown)
				{
					if (
					(Input.mouseX < x + 393/2 - innerR || Input.mouseX > x+393/2+innerR)
					|| (Input.mouseY < y + 393/2 - innerR || Input.mouseY > y+393/2+innerR)
					)
					{
						selector.visible = true;
						for (var i:uint = 0; i < 6; i++)
						{
							if (getMouseAngle() < 60 *(i+1) && getMouseAngle() > 60*i) 
							{
								selector.angle = -60 * (i + 3);
								selectedIndex = i;
							}
						}
					}
					else selector.visible = false;
					
				}
				else
				{
					hide();
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