package gameplay_objects 
{
	import flash.geom.Rectangle;
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
			
			active = false;
		}
		
		
		public function show():void
		{
			if (!active && GameWorld.i != null)
			{
				selectedIndex = 10; //aribitrary value for none
				
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
		
		
		private function executeAction():void
		{
			if (selectedIndex != 10)
			{
				var ar:Array;
				trace("action selected index: " + String(selectedIndex));
				if (selectedIndex == 0)
				{
					//stealth ball
					ar = GameWorld.entitiesByType("ball", world);
					for (var i:uint = 0; i < ar.length; i++)
					{
						(ar[i] as Ball).doStealth();
					}
				}
				else if (selectedIndex == 1)
				{
					//reverse ball
					ar = GameWorld.entitiesByType("ball", world);
					for (var j:uint = 0; j < ar.length; j++)
					if (!(ar[j].reverseOn)) (ar[j] as Ball).doReverse();
				}
				else if (selectedIndex == 2 )
				{
					//shadow pad
					GameWorld.pad.doShadow();
				}
				else if (selectedIndex == 3)
				{
					//shoot
					ar = GameWorld.entitiesByType("ball", world);
					(ar[FP.rand(ar.length)] as Ball).doTarget();
				}
			}
			else {
				trace("no action selected");
			}
		}
		
		
		private static const innerR:Number = 25;
		
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