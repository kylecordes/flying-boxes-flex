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

import java.awt.Dimension;
import java.awt.Point;
import java.util.ArrayList;
import java.util.List;

import javax.swing.JLabel;
import javax.swing.JLayeredPane;
import javax.swing.JPanel;


package fly
{
/*
 * This class managers a set of "slots", which are labelled 
 * points on the screen where a widget may belong
 */

	public class Slots
	{



	private JLayeredPane layeredPane;
	
	private List<Point> points = new ArrayList<Point>();

	public function Slots(JLayeredPane layeredPane) {
		this.layeredPane = layeredPane;
	}

	private static final int LEFT_MARGIN = 30;

	private static final int TOP_MARGIN = 3;

	private static final int RIGHT_MARGIN = 3;

	private static final int BOTTOM_MARGIN = 3;

	private static final int HOR_GAP = 38;

	private static final int VER_GAP = 4;

    private static final int LABEL_LAYER = 5;

	private static final int LABEL_OFFSET_X = -25;

	private JPanel samplePanel = new WorkOrderPanel(new WorkOrder(0, "", "", 1));

	private int panelHeight = samplePanel.getHeight();

	private int panelWidth = samplePanel.getWidth();

	private int rowSize = panelHeight + VER_GAP;

	private int colSize = panelWidth + HOR_GAP;

	private int slotsPerColumn = 0;

	public void setupSlots(int numSlots, int height) {
		height -= TOP_MARGIN;
		height -= BOTTOM_MARGIN;
		int newStackSize = height / rowSize;
		if (slotsPerColumn == newStackSize)
			return;
		
		slotsPerColumn = newStackSize;
		
		layeredPane.removeAll();
		points.clear();

		int sizeX = 0, sizeY = 0;

		for (int i = 0; i < numSlots; i++) {
			int row = i % slotsPerColumn;
			int col = i / slotsPerColumn;

			int x = colSize * col + LEFT_MARGIN;
			int y = rowSize * row + TOP_MARGIN;

			int maxX = x + panelWidth + RIGHT_MARGIN;
			int maxY = y + panelHeight + BOTTOM_MARGIN;

			if (maxX > sizeX)
				sizeX = maxX;

			if (maxY > sizeY)
				sizeY = maxY;

			Point point = new Point(x, y);
			points.add(point);

			Point labelPoint = point.getLocation();
			labelPoint.translate(LABEL_OFFSET_X, 0);
			JLabel lab = new JLabel("#" + (i + 1) + ":");
			lab.setSize(lab.getPreferredSize());
			lab.setLocation(labelPoint);
			layeredPane.add(lab, LABEL_LAYER);
		}
		layeredPane.setPreferredSize(new Dimension(sizeX, sizeY));
	}

	public int findNearestSlotIndex(Point point) {
		int nearestIndex = 0;
		Point nearestPointSoFar = null;
		int index = 0;

		for (Point slot : points) {
			if (nearestPointSoFar == null) {
				nearestPointSoFar = slot;
				nearestIndex = index;
			} else {
				if (point.distanceSq(slot) < point
						.distanceSq(nearestPointSoFar)) {
					nearestPointSoFar = slot;
					nearestIndex = index;
				}
			}
			index++;
		}
		return nearestIndex;
	}

	public Point getPoint(int i) {
		return points.get(i);
	}

}
			
			


}