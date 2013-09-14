package gameplay_objects 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Ease;
	import worlds.GameWorld;
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class Pad extends Entity 
	{
		private var img:Image;
		
		public function Pad() 
		{
			var w:Number = 150; //width
			
			
			var pic:BitmapData = new BitmapData(w, 8, true, 0);
			Draw.setTarget(pic);
			Draw.rect(0, 0, w, pic.height, 0x1FB0E0);
			img = new Image(pic);
			graphic = img;
			setHitbox(w, pic.height);
			
			name = "pad";
			type = "pad";
			
			x = SideBar.W;
			y = GameWorld.pointBar.nY-height + 2;
			
			for (var i:int = 0; i < steps; i++) {
                positions.push(x);
                positions.push(y);
            }
		}
		
		public var fixed:Boolean = false;
		
		public function set showFixed(b:Boolean):void
		{
			if (b)
			{
				img.color = 0x8BED61;
			}
			else
			{
				img.color = 0xffffff;
				
			}
			fixed = b;
		}
		
		public var moveTween:VarTween;
		
		public function getToPosition(_x:Number, p:PadPoint):Pad
		{
			moveTween = new VarTween();
			moveTween.tween(this, "x", Math.min(Math.max(_x, SideBar.W),FP.width - width), 0.35, Ease.quadOut);
			moveTween.complete = p.anchor;
			addTween(moveTween, true);
			
			return this;
		}
		
		override public function update():void 
        {
            positions.push(x);
            positions.push(y);
           
            super.update();
        }
		
		private var steps:uint = 5;
        private var positions:Vector.<Number> = new Vector.<Number>;
		
		override public function render():void 
        {
            var lastX:Number = positions.shift();
            var lastY:Number = positions.shift();
            for (var i:int = 0; i < steps; i++) {
                Image(graphic).alpha = i / steps;
                Draw.graphic(graphic, FP.lerp(lastX, x, i / steps), y/*FP.lerp(lastY, y, i / steps)*/);
            }
            Image(graphic).alpha = 1;
            super.render();
        }
		
	}

}