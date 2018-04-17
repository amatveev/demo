package com.rll.net.files.types 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	/**
	 * SWF file
	 * @author amatveev
	 */
	public class SWFFile extends AbstractFile 
	{
		protected var _loader:Loader;
		protected var _context:LoaderContext;
		/**
		 * Constructor
		 * 
		 * @see com.rll.net.files.types.AbstractFile
		 */
		public function SWFFile(url:String, params:*) 
		{
			super(url, params);
			_typeName = "swf";
			_toStringPropsList.push("loader");
			_loader = new Loader();
		}
		private function handleLoadCompelte(e:Event):void 
		{
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleLoadCompelte);
			if (this.content) {
				_loader.loadBytes(this.content, _context);
			}
		}
		/**
		 * Get load whit loaderContext
		 * @param context 
		 * @see flash.display.Loader flash.system.LoaderContext
		 * @return flash.display.Loader - visible content
		 */
		public function getLoader(context:LoaderContext = null):Loader {
			_context = context;
			this.handleLoadCompelte(null);
			
			return _loader;
		}
		/**
		 * @inheritDoc
		 */
		override public function set content(value:ByteArray):void {
			super.content = value;
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadCompelte);
			_loader.loadBytes(this.content);
		}
		/**
		 * Ref on visible Object
		 * @return flash.display.Loader - visible content
		 */
		public function get loader():Loader 
		{
			return _loader;
		}
		
		public function set loader(value:Loader):void 
		{
			_loader = value;
		}
		
		
		/**
		 * @inheritDoc
		 */
		override public function destroy():void 
		{
			super.destroy();
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleLoadCompelte);
			_loader = null;
		}
	}

}