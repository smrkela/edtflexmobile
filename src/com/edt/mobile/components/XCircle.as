package com.edt.mobile.components
{
	import flash.display.Graphics;
	
	import spark.primitives.Ellipse;
	
	public class XCircle extends Ellipse
	{
		
		private var _arc:Number=360;
		private var _startAngle:Number=-90
		
		public function XCircle()
		{
			super();
		}
		
		public function get startAngle():Number
		{
			return _startAngle;
		}
		
		public function set startAngle(value:Number):void
		{
			if(value == _startAngle)
				return;
			
			_startAngle = value;
			
			invalidateDisplayList();
		}
		
		public function get arc():Number
		{
			return _arc;
		}
		
		public function set arc(value:Number):void
		{
			
			if(value == _arc)
				return;
			
			_arc = value;
			
			invalidateDisplayList();
		}
		
		override protected function draw(g:Graphics):void
		{
			
			//super.draw(g);
			
			var graphics:Graphics=g;
			
			var min : Number = Math.min(width/2, height/2);
			
			XCircle.draw(g, min * 2, min, min, arc, startAngle);
		}
		
		public static function draw(graphics:Graphics, sx:Number, sy:Number, radius:Number, arc:Number, startAngle:Number=0):void
		{
			var segAngle:Number;
			var angle:Number;
			var angleMid:Number;
			var numOfSegs:Number;
			var ax:Number;
			var ay:Number;
			var bx:Number;
			var by:Number;
			var cx:Number;
			var cy:Number;
			
			// Move the pen
			graphics.moveTo(sx, sy);
			
			// No need to draw more than 360
			if (Math.abs(arc) > 360)
			{
				arc=360;
			}
			
			numOfSegs=Math.ceil(Math.abs(arc) / 45);
			segAngle=arc / numOfSegs;
			segAngle=(segAngle / 180) * Math.PI;
			angle=(startAngle / 180) * Math.PI;
			
			// Calculate the start point
			ax=sx - Math.cos(angle) * radius;
			ay=sy - Math.sin(angle) * radius;
			
			for (var i:int=0; i < numOfSegs; i++)
			{
				// Increment the angle
				angle+=segAngle;
				
				// The angle halfway between the last and the new
				angleMid=angle - (segAngle / 2);
				
				// Calculate the end point
				bx=ax + Math.cos(angle) * radius;
				by=ay + Math.sin(angle) * radius;
				
				// Calculate the control point
				cx=ax + Math.cos(angleMid) * (radius / Math.cos(segAngle / 2));
				cy=ay + Math.sin(angleMid) * (radius / Math.cos(segAngle / 2));
				
				// Draw out the segment
				graphics.curveTo(cx, cy, bx, by);
			}
		}
	}
}
