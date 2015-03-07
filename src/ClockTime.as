package {
    /**
     * This class lets us convert a number of milliseconds into a time String.
     *
     * @author Lamine Sissoko
     */
    public class ClockTime {

        public static var timeFormat:Object = {hrs:true, min:true, sec:true, ms:true};

        public function ClockTime():void {
        }

        /**
         * Formats given time int to String
         *
         * @param    time The time in milliseconds to format
         * @param    formatOptions Like the timeFormat object above, specifies our output
         */
        public static function timeParse( time:int , formatOptions:Object):String {
            timeFormat = formatOptions;

            var hr:Number = Math.floor( time / 3600000 );
            var mn:Number = Math.floor( (time % 3600000) / 60000 );
            var sc:Number = Math.floor( ((time % 3600000) % 60000) / 1000 );
            var ms:Number = Math.floor( (((time % 3600000) % 60000) % 1000) / 10 );  //reduce to hundreths

            var hrs:String = (hr > 0) ? ( (hr < 10) ? '0'+hr+':' : hr+':' ) : '00:';
            var min:String = (mn > 0 || hr > 0) ?  ( (mn < 10) ? '0'+mn+':' : mn+':' ) : '00:'; //mn+':' : '0:';
            //var sec:String = (sc < 10) ? '0'+sc+( (timeFormat.ms) ? ':' : '' ) : sc+( (timeFormat.ms) ? ':' : '' );
            var sec:String = (sc < 10) ? '0'+sc+( (timeFormat.ms) ? ':' : '' ) : sc+( (timeFormat.ms) ? '.' : '' );
            var mls:String = (ms < 10) ? '0'+ms : String(ms);

            var format:String = "";
            if(timeFormat.hrs) format += hrs;
            if(timeFormat.min) format += min;
            if(timeFormat.sec) format += sec;
            if(timeFormat.ms) format += mls;

            return format;
        }
    }
}
