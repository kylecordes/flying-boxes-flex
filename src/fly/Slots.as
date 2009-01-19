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
import flash.geom.Point;

import mx.controls.Label;
import mx.core.Container;
import mx.core.UIComponent;

/*
 * This class manages a set of "slots", which are labelled 
 * points on the screen where a widget may belong
 */
 
	public class Slots
	{
		private var layeredPane:Container;
		
		private var points:Array = [];
	
		public function Slots(layeredPane:mx.core.Container) {
			this.layeredPane = layeredPane;
		}
	
		private static var LEFT_MARGIN:int = 30;
	
		private static var TOP_MARGIN:int = 3;
	
		private static var RIGHT_MARGIN:int = 3;
	
		private static var BOTTOM_MARGIN:int = 3;
	
		private static var HOR_GAP:int = 38;
	
		private static var VER_GAP:int = 4;
	
	    private static var LABEL_LAYER:int = 5;
	
		private static var LABEL_OFFSET_X:int = -25;
	
		//private var samplePanel:UIComponent = new WorkOrderPanel(new WorkOrder(0, "", "", 1));
		private var samplePanel:UIComponent = new Tile();
	
		private var panelHeight:int;
	
		private var panelWidth:int;
	
		private var rowSize:int;
	
		private var colSize:int;
	
		private var slotsPerColumn:int = 0;
	
		public function setupSlots(numSlots:int, height:int):void {
			//samplePanel.height = 30;
			
			panelHeight = samplePanel.height;
			panelWidth = samplePanel.width;
			rowSize = panelHeight + VER_GAP;
			colSize = panelWidth + HOR_GAP;
			
			height -= TOP_MARGIN;
			height -= BOTTOM_MARGIN;
			var newStackSize:int = height / rowSize;
			//if (slotsPerColumn == newStackSize)	return;
			
			slotsPerColumn = newStackSize;
			
			layeredPane.removeAllChildren();
			points = [];
	
			var sizeX:int = 0;
			var sizeY:int = 0;
	
			for (var i:int = 0; i < numSlots; i++) {
				var row:int = i % slotsPerColumn;
				var col:int = i / slotsPerColumn;
	
				var x:int = colSize * col + LEFT_MARGIN;
				var y:int = rowSize * row + TOP_MARGIN;
	
				var maxX:int = x + panelWidth + RIGHT_MARGIN;
				var maxY:int = y + panelHeight + BOTTOM_MARGIN;
	
				if (maxX > sizeX)
					sizeX = maxX;
	
				if (maxY > sizeY)
					sizeY = maxY;
	
				var point:Point = new Point(x, y);
				points.push(point);
	
				var labelPoint:Point = point.clone();
				labelPoint.offset(LABEL_OFFSET_X, 0);
				var lab:Label = new Label();
				lab.text = "#" + (i + 1) + ":";
				//lab.setSize(lab.getPreferredSize());
				lab.x = labelPoint.x;
				lab.y = labelPoint.y;
				layeredPane.addChild(lab);
				// put it on top, on the  LABEL_LAYER);
			}
			//layeredPane.setPreferredSize(new Dimension(sizeX, sizeY));
		}
	
		public function findNearestSlotIndex(point:Point):int {
			var nearestIndex:int = 0;
			var nearestPointSoFar:Point = null;
			var index:int = 0;
	
			for each (var slot:Point in points) {
				if (nearestPointSoFar == null) {
					nearestPointSoFar = slot;
					nearestIndex = index;
				} else {
					if (Point.distance(point, slot) < 
						Point.distance(point, nearestPointSoFar)) {
						nearestPointSoFar = slot;
						nearestIndex = index;
					}
				}
				index++;
			}
			return nearestIndex;
		}
	
		public function getPoint(i: int):Point {
			return points[i];
		}
	}
}
