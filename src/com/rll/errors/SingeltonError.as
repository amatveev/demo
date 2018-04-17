package com.rll.errors
{
	/**
	 * SingeltonError -  Error of singelton class
	 * @author amatveev
	 */
	public class SingeltonError extends Error
	{
		public function SingeltonError(message:* = "", id:* = 0)
		{
			message = "This is Singelton. Please use getInstance method";
			super(message, id);
		}
	}
}