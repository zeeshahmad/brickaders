package gameplay_objects 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
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
		
		public static var active:Boolean;
		
		private var tileClasses:Array;
		private var tiles:Array;
		
		public function ActionMenu() 
		{
			tileClasses = new Array();
			tiles = new Array();
			
			tileClasses.push(POWER_PNG, SHOOT_PNG);
			
			graphic = new Image(BG_DISK_PNG);
			
			x = FP.halfWidth + SideBar.W / 2 - Image(graphic).width / 2;
			y = FP.halfHeight - PointBar.H / 2 - Image(graphic).height / 2;
			
			for (var i:uint = 0; i < tileClasses.length; i++)
			{
				tiles.push(new Image(tileClasses[i]));
				//addGraphic(tiles[i]);
				tiles[i].x = (tiles[0].width + 30) * i;
			}
			
			selector = new Image(SELECTOR_PNG);
			
			selector.x = Image(graphic).width / 2;
			selector.y = Image(graphic).height / 2;
			selector.smooth = true;
			addGraphic(selector);
			selector.angle = -60;
			
			active = false;
		}
		
		
		public function show():void
		{
			
			if (!active && GameWorld.i != null)
			{
				active = true;
				
				
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
			}
			if (this.world != null) this.world.remove(this);
		}
	}
	

}