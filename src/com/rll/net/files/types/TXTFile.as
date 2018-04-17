package com.rll.net.files.types 
{
	
	import flash.utils.ByteArray;

	/**
	 * File contains text
	 * @author amatveev
	 */
	public class TXTFile extends AbstractFile 
	{
		/**
		 * contains contant of file
		 */
		protected var _text:String;
		
		/**
		 * Constructor of text file
		 * @see com.rll.net.files.types.AbstractFile;
		 */
		public function TXTFile(url:String, params:String) 
		{
			super(url, params);
			_toStringPropsList.push("text");
		}
		/**
		 * @return Text file content
		 * 
		 */
		public function get text():String 
		{
			
			return _text;
		}
		/**
		 * @param value text content
		 */
		public function set text(value:String):void 
		{
			_text = value;
			_content.writeUTFBytes(_text);
			_content.position = 0;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set content(value:ByteArray):void 
		{
			super.content = value;
			
			_text = _content.readUTFBytes(_content.bytesAvailable);
		}
		
	}

}