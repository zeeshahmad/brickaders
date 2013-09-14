package gameplay_objects 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Linear;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import worlds.GameWorld;
	
	/**
	 * ...
	 * @author Zeeshan
	 */
	public class Coin extends Entity 
	{
		
		public var ani:TweenMax;
		
		private static const R:Number = 5
		
		public function Coin(_x:Number, _y:Number) 
		{
			x = _x; y = _y;
			
			/*this.graphics.beginFill(Main.pickRandomFromArray([0x99920B, 0xAEA60D, 0xCAC00F, 0xDAD010]));
			this.graphics.drawCircle(0, 0, R);
			this.graphics.drawCircle(0, 0, R/1.5);
			this.graphics.endFill();*/
			
			//scaleX = 0; scaleY = 0;
			//new TweenMax(this, 1, { delay: Math.random(), ease: Back.easeOut, scaleX: 1, scaleY: 1, onComplete: constructAni } );
			
			GameWorld.i.add(this);
		}
		
		public function constructAni():void
		{
			var possibles:Array = [
				{ alpha: 0.7, ease:Back.easeInOut },
				{ scaleX: 0.85, scaleY: 0.85, ease: Linear.easeNone }
			];
			
			var times:Array = [
				1.2,
				1.5
			];
			
			var v:Object = Main.pickRandomFromArray(possibles);
			
			v.yoyo = true;
			v.repeat = -1;
			v.delay = Math.random()*2;
			
			ani = new TweenMax(this, times[possibles.indexOf(v)], v);
			
		}
		
		public function used(score:Boolean):void
		{
			//Main.remove(this);
			//Main.removeObjFromArr(this, GameWorld.coinArray);
			
			if (score)
			{
				//play sound
				//increase score
			}
			
		}
		
		public static function spawnGroup():void
		{
			var _i:uint = Main.pickRandomFromArray([1, 2, 3, 4]);
			var _j:uint = Main.pickRandomFromArray([1, 2, 3, 4]);
			
			var coord:Point = //a random point of top left of group
			new Point(Math.random() * (800 - GameWorld.sideBar.width - _i * 2 * R*2) + GameWorld.sideBar.width,
			Math.random() * (GameWorld.pad.y - _j * 2 * R * 2));
			
			__i: for (var i:uint = 0; i < _i; i++)
			{
				__j: for (var j:uint = 0; j < _j; j++)
				{
					new Coin(coord.x + 2 * 2 * R * i, coord.y + 2 * 2 * R * j);
				}
			}
		}
		
	}
	

}

