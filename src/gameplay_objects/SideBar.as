package gameplay_objects 
{
	import com.greensock.TweenMax;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class SideBar extends Entity 
	{
		
		public static const W:Number = 100;
		
		public static var waveText:Text;
		
		
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
			
		}
		
		override public function added():void 
		{
			addGraphic(waveText);
			
			
			super.added();
		}
		
	}

}