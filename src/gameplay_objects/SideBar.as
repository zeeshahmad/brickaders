package gameplay_objects 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	
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
		
		private var musicOn:Image;
		private var musicOff:Image;
		private var soundOn:Image;
		private var soundOff:Image;
		
		
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