package rooms 
{
	import flash.utils.Timer;
	import game.*;
	import net.flashpunk.Engine;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.tweens.sound.SfxFader;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;	
	import net.flashpunk.graphics.Text;
	
	/**
	 * This is our game manager class. Here we add our objects and control the flow
	 * and logic of the game.
	 * 
	 * @author Lamine Sissoko
	 */
	public class Level extends LevelLoader
	{
		/**
		 * Level XML.
		 */
		[Embed(source = '../../level/levelBig.oel', mimeType = 'application/octet-stream')] private static const LEVEL:Class;
		
		/**
		 * Background song
		 */
		[Embed(source = '../../assets/save1.mp3')] private const SONG:Class;
		public var backgroundMusic:Sfx = new Sfx(SONG);
		
		/**
		 * Win song
		 */
		[Embed(source = '../../assets/win.mp3')] private const WIN_SONG:Class;
		public var winMusic:Sfx = new Sfx(WIN_SONG);
		
		/**
		 * Camera following information.
		 */
		public const FOLLOW_TRAIL:Number = 50;
		public const FOLLOW_RATE:Number = .9;
		
		/**
		 * Size of the level (so it knows where to keep the player + camera in).
		 */
		public var width:uint;
		public var height:uint;
		
		/**
		 * Game objects
		 */
		public var player:Player;
		public var stripper:WomenLady;
		public var door:ExitDoor;
		
		/**
		 * Timer variables
		 */
		public var countdownTimer:Number;
		public var timer:TextDisplay;
		
		/**
		 * Win/Lose variables
		 */
		public var gameRunning:Boolean;
		public var winDisplay:TextDisplay;
		public var loseDisplay:TextDisplay;
		
		/**
		 * Game volume variables
		 */
		public var muted:Boolean = false;
		public var songVolume:Number;
		public var gameVolume:Number;
		
		/**
		 * Stripper count variables
		 */
		public var numStrippers:int;
		public var strippersSaved:int;
		public var stripperText:TextDisplay;
		
		
		/**
		 * Constructor.
		 */
		public function Level()
		{
			super(LEVEL); // pass the map XML to the super class so it can be loaded
			// store the level's width and height
			width = level.width;
			height = level.height;
			
			gameRunning = true; // signal the start of the game
			countdownTimer = 60; // set the timer to 60 seconds
			strippersSaved = 0; // initialize strippers saved to 0
			
			add(new Floors(level));
			add(new Particles);
			add(new Background);
			
			// add the exit door
			for each (var d:XML in level.objects[0].door)
			{
				door = new ExitDoor(d.@x, d.@y);
				add(door);
			}
			
			// add the player
			for each (var p:XML in level.objects[0].player)
			{
				player = new Player(p.@x, p.@y);
				add(player);
			}
			
			// add the strippers and count them
			numStrippers = 0;
			for each (var g:XML in level.objects[0].stripper)
			{
				stripper = new WomenLady(this, g.@x, g.@y);
				add(stripper);
				numStrippers++;
			}
			
			songVolume = 0.05;
			backgroundMusic.play(songVolume); // play music
			gameVolume = 1;
			FP.volume = gameVolume; // set game volume to max
			
			// display the timer
			timer = new TextDisplay("", 0, 10, 0x00FF00);
			add(timer);
			
			// display the stripper count at the bottom left of the screen
			var stripperTextMessage:String = "Strippers Saved: " + String(strippersSaved) + "/" + numStrippers;
			stripperText = new TextDisplay(stripperTextMessage, 10, 0, 0x00FF00);
			stripperText.y = FP.height - 2.5*stripperText.getHeight();
			add(stripperText);
		}
		
		/**
		 * Update the level.
		 */
		override public function update():void  
		{
			// update entities
			super.update();
			
			// camera following
			cameraFollow();
			
			// restart level
			if (Input.pressed(Key.R)) {
				// stop all music
				backgroundMusic.stop();
				winMusic.stop();
				// create a new Level object
				FP.world = new Level;
			}
			
			// run the timer
			if (gameRunning == true) {
				// update the time remaining
				if (Math.floor(countdownTimer) != 0) {
					// 1/60 seconds per frame * 60 frames = 1 second
					// we are at 60 fps, so every second the clock ticks down one second
					countdownTimer -= 1 / 60;
					// we want our timer to show Minutes:Seconds only
					// Note: ClockTime's timeParse() method takes milliseconds
					var format:Object = { hrs:false, min:true, sec:true, ms:false };
					var time:String = ClockTime.timeParse(countdownTimer * 1000, format);
					// update the timer's display after formatting the time
					timer.updateText(time);
					timer.x = (FP.width / 2) - (timer.getWidth() / 2); // update x position to center
				}
				// lose the game if the timer reaches 0
				else if (Math.floor(countdownTimer) == 0){
					gameOver("lose");
				}
			}
			
			// mute/unmute all game sounds by pressing M
			if (Input.pressed(Key.M)) {
				if (muted == true){
					muted = false;
					FP.volume = gameVolume;
				}else if (muted == false) {
					muted = true;
					FP.volume = 0;
				}
			}
			
			// win the game if the exit door is reached
			if (door.crossed == true && gameRunning==true) {
				gameOver("win");
			}
		}
		
		/**
		 * Ends the game and prints results to the screen.
		 * @param	status 		Endgame status, either "win" or "lose" (non-case sensitive)
		 */
		public function gameOver(status:String):void {			
			// freeze the timer
			gameRunning = false;
			// stop the background music
			backgroundMusic.stop();
			// freeze the player
			player.active = false;
			// remove the timer and stripper count displays
			remove(timer);
			remove(stripperText);
			
			var message:String;
			// show the win message
			if(status.toLowerCase() == "win"){
				// play the win music
				winMusic.play(songVolume);
				message = "Congratulations! You escaped the stripper factory!\n\n" +
								"Number of strippers saved: " + String(strippersSaved) + "/" + String(numStrippers) + "\n" +
								"Time taken: " + String(Math.floor(60 - countdownTimer)) + " seconds\n\n" +
								"Press R to play again.";
				winDisplay = new TextDisplay(message, 0, 0, 0x00FF00);
				winDisplay.x = (FP.width / 2) - (winDisplay.getWidth() / 2);
				winDisplay.y = (FP.height / 2) - (winDisplay.getHeight() / 2);
				add(winDisplay);
			}
			// show the lose message
			else if (status.toLowerCase() == "lose") {
				message = "You did not escape the stripper factory in time...\n\n" +
								"Press R to play again.";
				loseDisplay = new TextDisplay(message, 0, 0, 0x00FF00);
				loseDisplay.x = (FP.width / 2) - (loseDisplay.getWidth() / 2);
				loseDisplay.y = (FP.height / 2) - (loseDisplay.getHeight() / 2);
				add(loseDisplay);
			}
		}
		
		/**
		 * Makes the camera follow the player object.
		 */
		private function cameraFollow():void
		{
			// make camera follow the player
			FP.point.x = FP.camera.x - targetX;
			FP.point.y = FP.camera.y - targetY;
			var dist:Number = FP.point.length;
			if (dist > FOLLOW_TRAIL)
				dist = FOLLOW_TRAIL;
			FP.point.normalize(dist * FOLLOW_RATE);
			FP.camera.x = int(targetX + FP.point.x);
			FP.camera.y = int(targetY + FP.point.y);
			
			// keep camera in room bounds
			FP.camera.x = FP.clamp(FP.camera.x, 0, width - FP.width);
			FP.camera.y = FP.clamp(FP.camera.y, 0, height - FP.height);
		}
		
		/**
		 * Getter functions used to get the position to place the camera when following the player.
		 */
		private function get targetX():Number { return player.x - FP.width / 2; }
		private function get targetY():Number { return player.y - FP.height / 2; }
		
		/**
		 * Update the stripper display count.
		 * @param	increase		The amount by which to increase the count before updating the display.
		 */
		public function updateStripperCount(increase:int):void {
			strippersSaved += increase;			
			var stripperTextMessage:String = "Strippers Saved: " + String(strippersSaved) + "/" + numStrippers;
			stripperText.updateText(stripperTextMessage);
		}
	}
}