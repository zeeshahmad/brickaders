package gameplay_objects 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author ...
	 */
	public class FieldBar extends Entity 
	{
		[Embed(source = "../../lib/ball/fieldbar.png")]
		private static const FIELDBAR_PNG:Class;
		[Embed(source = "../../lib/ball/fieldbarinner.png")]
		private static const FIELDBAR_INNER_PNG:Class;
		
		public var img:Image;
		public var inner:Image;
		
		public static var fieldOn:Boolean = false;
		
		public var fill:Boolean;
		
		public function FieldBar() 
		{
			img = new Image(FIELDBAR_PNG);
			graphic = img;
			name = "fieldbar";
			
			inner = new Image(FIELDBAR_INNER_PNG);
			inner.x = 47;
			inner.y = (img.height - inner.height) / 2;
			addGraphic(inner);
			
			inner.smooth = true;
			fill = false;
		}
		
		public function set transparency(value:Number):void
		{
			var t:VarTween = new VarTween();
			var t2:VarTween = new VarTween();
			t.tween(img, "alpha", value, 0.3);
			t2.tween(inner, "alpha", value, 0.3);
			addTween(t, true);
			addTween(t2, true);
			
		}
		
		public function fillUp():void
		{
			fill = true;
		}
		
		override public function update():void 
		{
			if (fill && !ActionMenu.active)
			{
				if (GameWorld.fieldLeft < GameWorld.FIELD_TOTAL) {
					GameWorld.fieldLeft += 0.4;
					inner.scaleX = GameWorld.fieldLeft / GameWorld.FIELD_TOTAL;
				}
				else fill = false;
			}
			
			
			super.update();
		}
		
		
		
	}

}