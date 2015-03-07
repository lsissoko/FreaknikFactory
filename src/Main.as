package
{
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    import net.flashpunk.utils.Key;
    import net.flashpunk.utils.Input;
    import rooms.*;

    [SWF(width=640, height=480)]
    /**
     * Main game class.
     */
    public class Main extends Engine
    {
        /**
         * Constructor. Start the game and set the starting world.
         */
        public function Main()
        {
            super(640, 480, 60);
            FP.world = new StartMenu; // new Level;
        }

        override public function update():void {
            super.update();
        }
    }
}
