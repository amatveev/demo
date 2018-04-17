package com.rll.net.files.events
{
	import com.rll.net.files.types.AbstractFile;
	
	import flash.events.Event;
	/**
	 * Events FileEvent
	 * @author amatveev
	 */
	public class FileEvent extends Event
	{
		/**
		 * Broadcast when file can't be loaded
		 */
		public static const FILE_ERROR:String = "fileError";
		/**
		 * Broadcast when file loaded
		 */
		public static const FILE_PROGRESS:String = "fileProgress";
		/**
		 * Broadcast when file starting loading
		 */
		public static const FILE_START:String = "fileStart";
		/**
		 * Broadcast when file loaded
		 */
		public static const FILE_COMPLETE:String = "fileComplete";
		/**
		 * Ref on file
		 */
		protected var _file:AbstractFile;
		/**
		 * 
		 */
		public function FileEvent(type:String, file:AbstractFile = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_file = file;
		}
		
		public override function toString():String 
		{ 
			return formatToString(
				"FileEvent", 
				"type",
				"file", 
				"bubbles", 
				"cancelable", 
				"eventPhase"); 
		}
		/**
		 * @inheritDoc
		 */
		public override function clone():Event
		{ 
			return new FileEvent(type, _file, bubbles, cancelable);
		}
		
		/**
		 * Ref of file
		 * @return com.rll.net.files.types.AbstractFile
		 */
		public function get file():AbstractFile 
		{
			return _file;
		}
		
		public function set file(value:AbstractFile):void 
		{
			_file = value;
		}
		
	}
}