package game
{
    import net.flashpunk.*;
    import net.flashpunk.utils.*;
    import net.flashpunk.graphics.*;
    import net.flashpunk.tweens.misc.*;
    import net.flashpunk.tweens.motion.*;

    /**
     * This class represents the door used to finish the game.
     *
     * @author Lamine Sissoko
     */
    public class ExitDoor extends Moveable
    {
        // set our individual frame sizes
        public var frameW:Number = 32;
        public var frameH:Number = 64;
        // embed our spritesheet image
        [Embed(source = '../../assets/door.png')] private const DOOR_PIC:Class;
        // spritemap takes the FRAME SIZE (not the tilemap size)
        public var image:Spritemap = new Spritemap(DOOR_PIC, frameW, frameH);

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

        /**
         * Door crossing/opening flag
         */
        public var crossed:Boolean = false;

        /**
         * Constructor
         */
        public function ExitDoor(x:int = 0, y:int = 0) {
            // set coordinates to the input (x,y) values
            this.x = x;
            this.y = y;

            // set type for collisions
            type = "Exit Door";

            // add animations
            image.add("anim1", [0]);
            image.add("anim2", [0, 1], 5, true);
            // play the first animation
            image.play("anim1");
            // set the class' graphic to be our spritesheet (it's really a frame of the sheet)
            graphic = image;

            // create a hitbox for collisions
            image.smooth = true;
            setHitbox(image.width, image.height);
        }

        override public function update():void {
            super.update();

            checkFloor();
            gravity();
            move(spdX * FP.elapsed, spdY * FP.elapsed);

            if (collide("Player", x, y)) {
                // play the second animation
                image.play("anim2");

                // open door if player presses X
                if(Input.check(Key.X))
                    crossed = true;
            }
            else
                image.play("anim1");
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
