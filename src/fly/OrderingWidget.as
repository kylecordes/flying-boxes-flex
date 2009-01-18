/*
 * Sample code from a user group talk:
 * Direct Manipulation with Swing
 * 
 * Copyright 2005 Kyle Cordes
 * http://kylecordes.com
 * http://oasisdigital.com
 *
 * Feel free to mine this for ideas and snippets for your own projects.
 */

package fly
{
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.core.Container;
	import mx.events.ResizeEvent;	
	
	public class OrderingWidget extends mx.core.Container
	
	{
		public function OrderingWidget()
		{
			slots = new Slots(this);
			addEventListener(ResizeEvent.RESIZE, resized);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
		{
			//
		}
	
		private var panels:Array = new Array();  // of tiles
		private var dragging:Tile;
		private var grabXoffset:int;
		private var grabYoffset:int;
		private var slots:Slots;
	
		public function draggedTo(tile:Tile, x:Number, y:Number):void {
			if (tile != null) {
				var index:int = slots.findNearestSlotIndex(new Point(tile.x, tile.y));
	
				if (index < 0)
					index = 0;
				if (index >= panels.size())
					index = panels.size();
	
	            panels.remove(tile);
	            panels.add(index, tile);
				startDrifting();
			}
		}
	
		private function resized():void {
			slots.setupSlots(panels.size(), height);
			placeWidgets();
		}
	
	    public function driftPositions():void {
			var i:int = 0;
			var anyMoved:Boolean = false;
			for each (var pan:Tile in panels) {
				if (pan != dragging) {
					var destination:Point  = slots.getPoint(i);
					var newX:int = closerCoord(pan.x, destination.x);
					var newY:int = closerCoord(pan.y, destination.y);
	
					if (newY != pan.y || newX != pan.x) {
						pan.move(newX, newY);
						anyMoved = true;
					}
				}
				i++;
			}
			if (!anyMoved) {
				removeEventListener(Event.ENTER_FRAME, driftPositions);
			}
		}
	
		private static function closerCoord(current:int , target:int):int {
			var gap:int = Math.abs(current - target);
			var speed:int = Math.ceil(gap * 0.07);
			if (current > target) {
				return current - speed;
			} else {
				return current + speed;
			}
		}
		
		private function startDrifting():void {
			addEventListener(Event.ENTER_FRAME, driftPositions);
		}
	
		public function load(workOrders:Array):void {
			panels.clear();
			for each (var s:String in workOrders) {
				var tile:Tile = new Tile();
				tile.lab1.text = s;
				panels.push(tile);
			}
			resized();
		}
	
		private function placeWidgets():void {
			var i:int = 0;
			for each (var pan:Tile in panels) {
				addChild(pan);
				var p:Point = slots.getPoint(i);
				pan.move(p.x, p.y);
				i++;
			}
		}

		public function startedDragging(tile:Tile):void {
			// TODO come up to the top
			dragging = tile;
		}

		public function doneDragging():void {
			// TODO sink back down
			dragging = null;
			// TODO store the new order of the tiles.

		}
	}
}

