package
{
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.FP;

    /**
     * This class is a simple means for placing text on the screen.
     *
     * @author Lamine Sissoko
     */
    public class TextDisplay extends Entity
    {
        //public var display:Text = new Text("", 0, 0, 640, 480);
        public var display:Text = new Text("");

        /**
         * Constructor
         */
        public function TextDisplay(_text:String, _x:Number, _y:Number, _color:int, _size:int = 20)
        {
            display = new Text(_text, _x, _y, 640, 480);
            display.color = _color;
            display.size = _size;

            display.scrollX = 0;
            display.scrollY = 0;

            super(x, y, display);
        }

        public function updateText(newText:String):void {
            display.text = newText;
        }

        public function concatText(endText:String):void {
            display.text.concat(endText);
        }

        public function getWidth():uint {
            return display.width;
        }

        public function getHeight():uint {
            return display.height;
        }

        public function setFont(given:String):void {
            display.font = given;
        }

    }
}
