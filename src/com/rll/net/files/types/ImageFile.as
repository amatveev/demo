package com.rll.net.files.types 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.ByteArray;
	/**
	 * Class describe Image file jpg, png, etcs
	 * @author amatveev
	 */
	public class ImageFile extends AbstractFile 
	{
		/**
		 * Default value dimansions of image
		 */
		public static const DEFAULT_DIMANSIONS:Object = { w:100, h: 100 };
		private var _bd:BitmapData;
		private var _swfFile:SWFFile;
		/**
		 * Constructor 
		 * Image present Image
		 * @see com.rll.net.files.types.AbstractFile;
		 * @param params object with props w and h (width, height), defult value { w:100, h: 100 }
		 */
		public function ImageFile(url:String, params:* = null) 
		{
			super(url, params);
			_typeName = "ImageFile";
			_toStringPropsList.push("bitmapData");
			if (!params) {
				_params = DEFAULT_DIMANSIONS;
			}
			
			_swfFile = new SWFFile(url, null);
		}
		private function handleLoadComplete(e:Event):void 
		{
			_swfFile.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleLoadComplete);
			
			_bd.draw(_swfFile.loader);
		}
		/**
		 * @return flash.display.BitmapData
		 */
		public function get bitmapData():BitmapData {
			_bd = _bd || new BitmapData(_params.w, _params.h);
			
			if (this.content) {
				_swfFile.loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
				_swfFile.content = this.content;
			}
			
			
			return _bd;
		}
		
		/**
		 * @return flash.display.Bitmap  visible object
		 */
		public function getBitmap(snapping:String = "auto",smooting:Boolean = false):Bitmap {
			return new Bitmap(this.bitmapData, snapping, smooting);
			
		}
		/**
		 * @inheritDoc
		 */
		override public function set content(value:ByteArray):void 
		{
			super.content = value;
			_bd = this.bitmapData;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void 
		{
			super.destroy();
			_swfFile.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleLoadComplete);
			_bd.dispose();
			_swfFile.destroy();
			_bd = null;
			_swfFile = null;
		}
		
	}

}