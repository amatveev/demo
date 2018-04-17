package com.rll.events
{
	import com.rll.core.IDestroyable;
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * Smart EventDispatcher, stored refs on handlers
	 * @author amatveev
	 */
	public class EventDispatcher extends flash.events.EventDispatcher implements IDestroyable
	{
		private var _refsByType:Dictionary;
		
		/**
		 * @inheritDoc
		 */
		public function EventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		/**
		 * @inheritDoc
		 */
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			
			_refsByType = _refsByType || new Dictionary();
			
			var listeners:Vector.<Function> = _refsByType[type] as Vector.<Function>;
			if (listeners == null)
				_refsByType[type] = Vector.<Function>([listener]);
			else if (listeners.indexOf(listener) == -1) // check for duplicates
				listeners.push(listener);
			
		}
		/**
		 * @inheritDoc
		 */
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			super.removeEventListener(type, listener, useCapture);
			if(_refsByType)
			{
				var listeners:Vector.<Function> = _refsByType[type] as Vector.<Function>;
				
				if (listeners && listener.length)
				{
						var len:int = listeners.length;	
						var remainingListeners:Vector.<Function> = new Vector.<Function>();
						
						for (var i:int = 0; i < len; ++i)
						{
							var otherListener:Function = listeners[i];
							if (otherListener != listener) remainingListeners.push(otherListener);
						}
						
						_refsByType[type] = remainingListeners;
				}
			}
			
			
		}
		/**
		 * Remove all events handlers bby type
		 * @param type type of Event
		 */
		public function removeEventListenersByType(type:String):void
		{
			if(_refsByType)
			{
				var listeners:Vector.<Function> = _refsByType[type] as Vector.<Function>;
				if (listeners)
				{
					for(var i:int = 0, l:int = listeners.length; i < l; ++i)
					{
						this.removeEventListener(type, listeners[i]);
					}
				}
			}
		}
		/**
		 * Remove all handlers
		 */
		public function removeAllEventListeners():void
		{
			for(var key:String in _refsByType)
			{
				this.removeEventListenersByType(key);
			}
		
			_refsByType = null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			this.removeAllEventListeners();
			
		}
	}
}