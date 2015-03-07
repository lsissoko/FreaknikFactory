package game
{	
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.tweens.misc.*;
	import net.flashpunk.tweens.motion.*;
	
	import rooms.Level;
	
	/**
	 * This will be a "collectible" class. The Player will run around trying to grab
	 * WomenLady objects.
	 * 
	 * @author Lamine Sissoko
	 */
	public class WomenLady extends Moveable
	{
		// set our individual frame sizes (our spritesheets have 32x32 individual frames)
		public var frameW:Number =32;
		public var frameH:Number = frameW;
		// embed our spritesheet images
		[Embed(source = '../../assets/stripper1.png')] private const SPRITESHEET1:Class;
		[Embed(source = '../../assets/stripper2.png')] private const SPRITESHEET2:Class;
		[Embed(source = '../../assets/stripper3.png')] private const SPRITESHEET3:Class;
		public var spritesheet:Spritemap;
		
		/**
		 * Movement constants.
		 */
		public const MAXX:Number = 300;
		public const MAXY:Number = 800;
		public const GRAV:Number = 1500;
		public const FLOAT:Number = 3000;
		public const ACCEL:Number = 1200;
		public const DRAG:Number = 800;
		public const JUMP:Number = -500;
		public const LEAP:Number = 1.5;
		
		/**
		 * Movement properties.
		 */
		public var onSolid:Boolean;
		public var spdX:Number = 0;
		public var spdY:Number = 0;
		
		public var level:Level;
		public var saved:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function WomenLady(level:Level, x:int = 0, y:int = 0) {
			// set coordinates to the input (x,y) values
			this.x = x;
			this.y = y;
			
			// reference to the Level object that will create and contain this WomenLady object
			this.level = level;
			
			// set type for collision
			type = "WomenLady";
			
			// choose a random stripper image
			var stripperChoice:int = int(Math.random() * 3);
			if(stripperChoice==0)
				spritesheet = new Spritemap(SPRITESHEET1, frameW, frameH);
			else if(stripperChoice==1)
				spritesheet = new Spritemap(SPRITESHEET2, frameW, frameH);
			else if(stripperChoice==2)
				spritesheet = new Spritemap(SPRITESHEET3, frameW, frameH);
			
			// add animations
			spritesheet.add("dance1", [0, 1, 2, 0, 2, 1], 3, true);
			spritesheet.add("dance2", [0, 2, 1, 0, 1, 2], 3, true);
			// choose which animation to play
			var danceChoice:int = int(Math.random()*2);
			if (danceChoice == 0)
				spritesheet.play("dance1");
			else if (danceChoice == 1)
				spritesheet.play("dance2");
			// set the class' graphic to be our spritesheet (it's really a frame of the sheet)
			graphic = spritesheet;
			/**
			// create a hitbox for collisions
			spritesheet.originX = spritesheet.width / 2;
			spritesheet.originY = spritesheet.height / 2;
			spritesheet.x = -spritesheet.originX;
			spritesheet.y = -spritesheet.originY;
			spritesheet.smooth = true;
			setHitbox(spritesheet.width, spritesheet.height, frameW / 2, frameH / 2);*/
			// create a hitbox for collisions
			spritesheet.smooth = true;
			setHitbox(spritesheet.width, spritesheet.height);
		}
		
		override public function update():void {
			super.update();
			
			checkFloor();
			gravity();
			move(spdX * FP.elapsed, spdY * FP.elapsed);
			
			// if the Player collides with this object
			if (collide("Player", x, y)) {
				// remove the object
				FP.world.remove(this);
				// increment the stripper count, then update its display
				level.updateStripperCount(1);
			}
			
			// remove at the end of the game
			if (level.gameRunning == false)
				FP.world.remove(this);
		}
		
		private function checkFloor():void
		{
			if (collide(solid, x, y + 1))
				onSolid = true;
			else
				onSolid = false;
		}
		
		/**
		 * Applies gravity.
		 */
		private function gravity():void
		{
			if (onSolid)
				return;
			
			var g:Number = GRAV;
			if (spdY < 0 && !Input.check("JUMP"))
				g += FLOAT;
			
			spdY += g * FP.elapsed;
			if (spdY > MAXY)
				spdY = MAXY;
		}
	}
	
}