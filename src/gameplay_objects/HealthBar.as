package gameplay_objects 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class HealthBar extends Entity 
	{
		[Embed(source = "../../lib/pointbar/healthbar_border.png")]
		private static const BORDER_PNG:Class;
		private var border:Image;
		[Embed(source = "../../lib/pointbar/health_bit.png")]
		private static const BIT_PNG:Class;
		
		public function HealthBar() 
		{
			border = new Image(BORDER_PNG);
			graphic = border;
			bits = new Array();
		}
		
		public var bits:Array;
		
		override public function added():void 
		{
			
			x = SideBar.W + (FP.width - SideBar.W - border.width) / 2;
			y = PointBar.Y + (PointBar.H - border.height) / 2;
			
			
			var b:Image;
			for (var i:uint = 0; i < 10; i++)
			{
				b = new Image(BIT_PNG);
				bits.push(b);
				b.x = 13 + i * 17.5;
				b.y = 11.5;
				addGraphic(b);
				
			}
			
			super.added();
		}
		
		public function showHealth(h:uint):void
		{
			for (var i:uint = 0; i < bits.length; i++)
			{
				bits[i].visible = (i < h);
			}
		}
		
	}

}