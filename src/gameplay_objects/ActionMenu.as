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
		
		public static var active:Boolean;
		
		private var tileClasses:Array;
		private var tiles:Array;
		
		public function ActionMenu() 
		{
			tileClasses = new Array();
			tiles = new Array();
			
			tileClasses.push(POWER_PNG, SHOOT_PNG);
			
			
			
			for (var i:uint = 0; i < tileClasses.length; i++)
			{
				tiles.push(new Image(tileClasses[i]));
				addGraphic(tiles[i]);
				tiles[i].x = (tiles[0].width + 30) * i;
			}
			
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