package gameplay_objects 
{
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class PointBar extends Entity 
	{
		
		public static var pointLimit:uint;
		public static var pointCount:uint;
		public static var enabled:Boolean;
		
		public static var points:Array;
		
		public var nY:Number;//initial y value
		
		public function PointBar() 
		{
			
			var picture:BitmapData = new BitmapData(800 - SideBar.W, 70, true, 0);
			Draw.setTarget(picture);
			Draw.rect(0, 0, 800 - SideBar.W, picture.height.valueOf(), 0xffffff); //0xF57516  0xFBDB24
			Draw.rect(0, 0, picture.width, 5, 0xA0D305);
			graphic = new Image(picture);
			setHitbox(800 - SideBar.W, picture.height.valueOf());
			
			y = 480 - this.height;
			nY = y.valueOf();
			
			x = SideBar.W;
			
		}
		
		override public function added():void 
		{
			enabled = true;
			
			super.added();
		}
		
		private var p:PadPoint;
		
		override public function update():void 
		{
			if (Input.mouseDown)
			{
				if (collidePoint(x, y, Input.mouseX, Input.mouseY))
				{
					if (enabled)
					{
						enabled = false;
						
						//put point
						p = new PadPoint(Input.mouseX);
						GameWorld.pad.getToPosition(Input.mouseX - GameWorld.pad.halfWidth, p);
						GameWorld.pad.showFixed = true;
					}
					else
					{
						if (p != null) {
							
						}
						
						
					}
				}
			}
			
			super.update();
		}
		
		public function clear():void
		{
			if (p != null) if (p.world != null) p.disappear();
			enabled = true;
		}
		
		
	}

}