package worlds 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class About extends World 
	{
		[Embed(source = "../../lib/about/title.png")]
		private static const TITLE_PNG:Class;
		private var title:Image = new Image(TITLE_PNG);
		
		public function About() 
		{
			title.x = (FP.width - title.width) / 2;
			title.y = 30;
			addGraphic(title);
			
			var aboutString:String = "\n\nMade using the Flash Punk game engine in AS3. \n\nCreated by Zeeshan Ahmad";
			
			var abouttext:Text = new Text(aboutString, 5);
			abouttext.y = title.y + title.height + 5;
			abouttext.size = 25;
			abouttext.smooth = true;
			addGraphic(abouttext);
		}
		
		override public function update():void 
		{
			if (Input.mousePressed)
			{
				FP.world = new MainMenuWorld;
			}
			
			super.update();
		}
		
	}

}