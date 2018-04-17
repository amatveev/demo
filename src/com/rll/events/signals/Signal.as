package com.rll.events.signals 
{
	import com.rll.core.IDestroyable;
		
	/**
	 * Signal
	 */
	public class Signal implements IDestroyable
	{

		protected var _handlers:Vector.<HandlerEntry>;
		protected var _handlersNeedCloning:Boolean = false;
		
		public var hasHandlers:Boolean = false;		
		public var propagationStopped:Boolean = false;
		public var cancelled:Boolean = false;
		
		/**
		 * Constructor
		 */
		public function Signal() 
		{
			_handlers = new Vector.<HandlerEntry>;	
		}
		/**
		 * Append handle
		 * @param handler
		 * @param priority handle priority 
		 */
		public function addHandler(handler:Function, priority:int=0):void
		{		
			if(_handlersNeedCloning)
			{
				_handlers = _handlers.slice();
				_handlersNeedCloning = false;
			}			
			
			var targetIndex:int = -1;
			var entry:HandlerEntry;
			var i:int = _handlers.length;
			
			while(--i>=0)
			{
				entry = _handlers[i] as HandlerEntry;
				if(targetIndex == -1 && entry.priority<=priority)
				{
					targetIndex = i + 1;
				}				
			}
			
			var entryNew:HandlerEntry = new HandlerEntry(handler, priority);
			
			if(targetIndex == -1)
			{
				_handlers.unshift(entryNew);
			}
			else
			{
				_handlers.splice(targetIndex, 0, entryNew);
			}
					
			hasHandlers = true;
		}
		/**
		 * Remove handler
		 * @param handler handler
		 */
		public function removeHandler(handler:Function):void 
		{
			if(_handlersNeedCloning)
			{
				_handlers = _handlers.slice();
				_handlersNeedCloning = false;
			}
			
			var l:int = _handlers.length;
			for(var i:int = 0; i<l; ++i)
			{
				var entry:HandlerEntry = _handlers[i] as HandlerEntry;
				if(entry.handler == handler)
				{
					entry.destroy();
					_handlers.splice(i, 1);
					if(!_handlers.length)
					{
						hasHandlers = false;
					}
					return;
				}
			}
		}
		
		/**
		 * Dispatch event
		 * @param data any data
		 */
		public function dispatch(data:* = null):void
		{
			if(!hasHandlers)
			{
				return;
			}
			
			_handlersNeedCloning = true;
			propagationStopped = false;
			cancelled = false;
			
			var handlers:Vector.<HandlerEntry> = this._handlers;
			var entry:HandlerEntry;			
			var l:int = handlers.length;
			
			for (var i:int = 0; i<l; ++i)
			{			
				entry = handlers[i] as HandlerEntry;
				if(!entry.erased)
				{
					if(entry.handler.length)
					{
						entry.handler(data);
					}
					else
					{
						entry.handler();
					}										
				}				
				if (propagationStopped) break;
			}
			
			_handlersNeedCloning = false;
		}
		/**
		 * Cancel
		 */
		public function cancel(stopPropagation:Boolean = true):void 
		{
			cancelled = true;
			if (stopPropagation) 
			{
				this.stopPropagation();
			}
		}
		/**
		 * Stop event propagation
		 */
		public function stopPropagation():void
		{
			propagationStopped = true;
		}
		/**
		 * Remove handlers
		 * @param stopPropagation
		 */
		public function removeHandlers(stopPropagation:Boolean = true):void 
		{
			if (stopPropagation) 
			{
				this.stopPropagation();
			}			
			_handlers = new Vector.<HandlerEntry>;	
			_handlersNeedCloning = false;
		}
		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
			this.removeHandlers(true);
		}
	}	
}
import com.rll.core.IDestroyable;

internal class HandlerEntry implements IDestroyable 
{
	public var handler:Function;
	public var priority:int;
	public var erased:Boolean = false;
	
	public function HandlerEntry(handler:Function, priority:int)
	{
		this.handler = handler;
		this.priority = priority;
	}
	
	public function destroy():void
	{
		handler = null;
		erased = true;
	}
}