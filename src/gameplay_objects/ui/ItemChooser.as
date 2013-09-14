package gameplay_objects.ui 
{
	import com.greensock.TweenLite;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class ItemChooser extends Entity 
	{
		
		private var titleField:TextField = new TextField();
		
		private static const PADDING:Number = 10;
		
		private var images:Array;
		
		public function ItemChooser(title:String, _images:Array, columns:uint) 
		{
			images = _images;
			
			titleField.defaultTextFormat = new TextFormat("Arial", 17, 0xFFFFFF, true);
			titleField.text = title;
			titleField.autoSize = TextFieldAutoSize.CENTER;
			titleField.border = false;
			titleField.selectable = false;
			
			//draw bg
			graphics.beginFill(0, 0.8);
			
			graphics.drawRoundRect(0, 0, 
			(images[0].width + PADDING) * columns + PADDING, 
			(images[0].width + PADDING) * Math.ceil(images.length / columns) + titleField.height + 2*PADDING, 
			20);
			
			graphics.endFill();
			
			titleField.x = (width - titleField.width) / 2;
			titleField.y = PADDING.valueOf();
			addChild(titleField);
			
			var tBit:Bitmap;
			for (var i:uint = 0; i < images.length; i++)
			{
				tBit = images[i];
				tBit.smoothing = true;
				tBit.x = ((i) % columns) * (tBit.width + PADDING) + PADDING;
				tBit.y = Math.floor(i / columns) * (tBit.height + PADDING) + PADDING + titleField.y + titleField.height;
				addChild(tBit);
			}
			
			addEventListener(MouseEvent.CLICK, onChoose);
			
			var _x:Number = (800 - width) / 2;
			var _y:Number = (480 - height) / 2;
			
			x = _x;
			y = _y - 50;
			alpha = 0.1;
			
			appearTween = new TweenLite(this, 0.4, { alpha:1, y:_y } );
			
			appearTween.vars.onReverseComplete = function(i:uint, ins:Sprite):void
			{
				if (onChooseAction != null) onChooseAction.apply(ins, [i]);
				Main.remove(ins);
			}
			appearTween.vars.onReverseCompleteParams = [i, this];
			
		}
		
		private var appearTween:TweenLite;
		
		public function onChoose(e:MouseEvent):void
		{
			for (var i:uint = 0; i < images.length; i++)
			{
				if ((images[i] as Bitmap).hitTestPoint(e.stageX, e.stageY, true))
				{
					if (appearTween != null) appearTween.reverse(true);
					break;
				}
			} 
		}
		
		public var onChooseAction:Function;
	}
	

}