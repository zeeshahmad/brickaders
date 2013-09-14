package gameplay_objects 
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class CollisionAngleDisplay extends Entity 
	{
		private static const cl:uint = 0x757575;
		
		private var displayField:TextField = new TextField(); 
		
		
		
		public function CollisionAngleDisplay(_x:Number, _y:Number, i:uint, ang:Number) 
		{
			x = _x;
			y = _y;
			
			
			var tSize:uint = 50;
			
			do {
				displayField.defaultTextFormat = new TextFormat("_sans", tSize, cl);
				displayField.text = String(Math.round(ang)) + "°";
				displayField.autoSize = TextFieldAutoSize.CENTER;
				displayField.selectable = false;
				displayField.border = false;
				tSize--;
				
			} while ( displayField.textHeight > 13);
			
			displayField.y = i % 2 == 1 ? 10 * (i == 3? -1:1):0;
			displayField.x = i % 2 == 0 ? 10 * (i == 2? -1:1):0;
			
			//addChild(displayField);
			
			
			//alpha = 0;
			
			
			//TweenLite.to(this, 0.3, { delay:0.3, alpha:1 } );
			//TweenLite.to(this, 0.3, { overwrite: false, delay: 2, onComplete: Main.remove, onCompleteParams: [this], alpha:0} );
			
			//Main.getStage().addChild(this);
			
			
		}
		
	}

}