package 
{
	import game.*;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import rooms.Level;
	
	import net.flashpunk.graphics.Text
	
	/**
	 * ...
	 * @author Lamine Sissoko
	 */
	public class StartMenu extends World 
	{
		private var display:TextDisplay;
		
		override public function begin():void {		
			// display start instructions
			display = new TextDisplay("FREAKNIK FACTORY", 0, 10, 0x00FF00);
			display.x = (FP.width / 2) - (display.getWidth() / 2); // center the x value
			add(display);
			
			var displayMessage:String = "\n\n\n\n\n\n\nDIRECTIONS:\n" +
					"o Save as many strippers as possible from the stripper\nfactory " +
					"before time runs out.\n\n\n" + 
					"CONTROLS:\n" +
					"o ARROWS to move & jump\n" +
					"o X to open the exit door\n" +
					"o M to mute/unmute the music\n\n\n\n\n\n\n" +
					"\t\t\t  Press SPACE to start playing";
			display = new TextDisplay(displayMessage, 0, 10, 0x00FF00);
			display.x = (FP.width / 2) - (display.getWidth() / 2); // center the x value
			add(display);
			
			super.begin();
		}
		
		/**
		 * Constructor
		 */
		public function StartMenu() {}
		
		override public function update():void {
			super.update();
			
			// start the game when the spacebar is pressed
			if (Input.pressed(Key.SPACE))
				FP.world = new Level;
		}
	}
	
}