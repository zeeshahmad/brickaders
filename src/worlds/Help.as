package worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Help extends World 
	{
		
		[Embed(source = "../../lib/help/slide1.png")]
		private static const SLIDE_1:Class;
		[Embed(source = "../../lib/help/slide2.png")]
		private static const SLIDE_2:Class;
		[Embed(source = "../../lib/help/slide3.png")]
		private static const SLIDE_3:Class;
		[Embed(source = "../../lib/help/slide4.png")]
		private static const SLIDE_4:Class;
		[Embed(source = "../../lib/help/slide5.png")]
		private static const SLIDE_5:Class;
		[Embed(source = "../../lib/help/slide6.png")]
		private static const SLIDE_6:Class;
		
		private var slide1:Image = new Image(SLIDE_1);
		private var slide2:Image = new Image(SLIDE_2);
		private var slide3:Image = new Image(SLIDE_3);
		private var slide4:Image = new Image(SLIDE_4);
		private var slide5:Image = new Image(SLIDE_5);
		private var slide6:Image = new Image(SLIDE_6);
		
		private var slides:Array;
		
		private var current:uint = 0;
		
		public function Help() 
		{
			slides = new Array(slide1, slide2, slide3, slide4, slide5, slide6);
			
			current = 0;
			
			addGraphic(slide1);
			
			Main.CURRENT_WORLD = "help";
		}
		
		override public function update():void 
		{
			if (Input.mousePressed)
			{
				if (current < 5)
				{
					current++;
					addGraphic(slides[current]);
					
				}
				else {
					FP.world = new MainMenuWorld;
				}
			}
			
			super.update();
		}
		
	}

}