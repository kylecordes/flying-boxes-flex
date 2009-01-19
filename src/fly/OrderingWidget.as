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
	
		private var tiles:Array = new Array();  // of tiles
		private var dragging:Tile;
		private var grabXoffset:int;
		private var grabYoffset:int;
		private var slots:Slots;
	
		public function draggedTo(tile:Tile, x:Number, y:Number):void {
			if (tile != null) {
				var index:int = slots.findNearestSlotIndex(new Point(tile.x, tile.y));
	
				if (index < 0)
					index = 0;
				if (index >= tiles.length)
					index = tiles.length;
	
				tiles.splice(tiles.indexOf(tile), 1)
				tiles.splice(index, 0, tile);
				startDrifting();
			}
		}
	
	    public function driftPositions(event:Event):void {
			var i:int = 0;
			var anyMoved:Boolean = false;
			for each (var tile:Tile in tiles) {
				if (tile != dragging) {
					var destination:Point  = slots.getPoint(i);
					var newX:int = closerCoord(tile.x, destination.x);
					var newY:int = closerCoord(tile.y, destination.y);
	
					if (newY != tile.y || newX != tile.x) {
						tile.move(newX, newY);
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
			var speed:int = Math.ceil(gap * 0.3);
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
			removeAllChildren();
			tiles = new Array();
			for each (var s:String in workOrders) {
				var tile:Tile = new Tile();
				tile.par = this;
				tile.labelText = s;
				tiles.push(tile);
			}
			resized(null);
		}
	
		private function resized(re:ResizeEvent):void {
			slots.setupSlots(tiles.length, height);
			placeWidgets();
		}
	
		private function placeWidgets():void {
			var i:int = 0;
			for each (var tile:Tile in tiles) {
				addChild(tile);
				var p:Point = slots.getPoint(i);
				tile.move(p.x, p.y);
				i++;
			}
		}

		public function startedDragging(tile:Tile):void {
			setChildIndex(tile, numChildren-1) // come up to the top of the Z order
			dragging = tile;
		}

		public function doneDragging():void {
			dragging = null;
			startDrifting();
			// TODO store the new order of the tiles.

		}
	}
}

