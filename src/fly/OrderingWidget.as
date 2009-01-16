package fly
{
	public class OrderingWidget
	{
		public function OrderingWidget()
		{
		}

	}
}




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
package swingtalk.ordering;

import java.awt.Component;
import java.awt.Dimension;
import java.awt.Point;
import java.awt.event.ActionListener;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionListener;
import java.beans.EventHandler;
import java.util.ArrayList;
import java.util.List;

import javax.swing.BorderFactory;
import javax.swing.JComponent;
import javax.swing.JLayeredPane;
import javax.swing.JScrollPane;
import javax.swing.Timer;


/**
 * @author Kyle
 */
public class OrderingWidget implements MouseListener, MouseMotionListener {  // ActionListener

	private List<WorkOrderPanel> panels = new ArrayList<WorkOrderPanel>();

	private WorkOrderPanel dragging;

	private int grabXoffset, grabYoffset;

	private final JLayeredPane layeredPane = new JLayeredPane();

	private final JScrollPane scrollPane = new JScrollPane(layeredPane);

	private final Slots slots = new Slots(layeredPane);
	
	private final Timer moveTimer;

	public OrderingWidget() {
		layeredPane.addMouseListener(this);
		layeredPane.addMouseMotionListener(this);

		scrollPane.setBorder(BorderFactory.createEmptyBorder());
		scrollPane.setPreferredSize(new Dimension(500, 400));
		scrollPane.setVerticalScrollBarPolicy(JScrollPane.VERTICAL_SCROLLBAR_NEVER);
		scrollPane.setHorizontalScrollBarPolicy(JScrollPane.HORIZONTAL_SCROLLBAR_ALWAYS);

		scrollPane.addComponentListener(new ComponentAdapter() {
			public void componentResized(ComponentEvent e) {
				resized();
            }
        });

        moveTimer = new Timer(25, (ActionListener) EventHandler.create(
                ActionListener.class, this, "driftPositions"));
    }

	// **************** Mouse Event Handlers ******************
	
	public void mouseEntered(MouseEvent e) {
	}

	public void mouseExited(MouseEvent e) {
	}

	public void mouseMoved(MouseEvent e) {
	}

	public void mousePressed(MouseEvent e) {
		Component c = layeredPane.getComponentAt(e.getPoint());
		if (c instanceof WorkOrderPanel) {
			dragging = (WorkOrderPanel) c;
			dragging.highlight();
			layeredPane.setLayer(dragging, 20);
			grabXoffset = e.getX() - c.getX();
			grabYoffset = e.getY() - c.getY();
		}
	}

	public void mouseReleased(MouseEvent e) {
		if (dragging != null) {
			layeredPane.setLayer(dragging, 10);
			dragging.unHighlight();
			dragging = null;
			startDrifting();
			storeOrder();
		}
	}

	public void mouseClicked(MouseEvent e) {
		if (e.getClickCount() == 2) {
            // double clicked
		}
	}

	public void mouseDragged(MouseEvent e) {
		if (dragging != null) {
			Point upperLeftPoint = e.getPoint();
			upperLeftPoint.translate(-grabXoffset, -grabYoffset);
			int index = slots.findNearestSlotIndex(upperLeftPoint);

			if (index < 0)
				index = 0;
			if (index >= panels.size())
				index = panels.size();

            panels.remove(dragging);
            panels.add(index, dragging);

			dragging.setLocation(upperLeftPoint);
			startDrifting();
		}
	}

	private void resized() {
		if (scrollPane.isVisible()) {
			int height = scrollPane.getViewport().getHeight();
			slots.setupSlots(panels.size(), height);
			placeWidgets();
		}
	}

    public void driftPositions() {
		int i = 0;
		boolean anyMoved = false;
		for (WorkOrderPanel pan : panels) {
			if (pan != dragging) {
				Point destination = slots.getPoint(i);
				int newX = closerCoord(pan.getX(), destination.x);
				int newY = closerCoord(pan.getY(), destination.y);

				if (newY != pan.getY() || newX != pan.getX()) {
					pan.setLocation(newX, newY);
					anyMoved = true;
				}
			}
			i++;
		}
		if (!anyMoved)
			moveTimer.stop();
	}

	private static int closerCoord(int current, int target) {
		float gap = Math.abs(target - current);
		int increment = (int) Math.ceil(0.1 * gap);
		if (current > target) {
			return current - increment;
		} else {
			return current + increment;
		}
	}

	public JComponent getComponent() {
		return scrollPane;
	}

	private void startDrifting() {
		moveTimer.start();
	}

	public void load(List<WorkOrder> workOrders) {
		panels.clear();
		for (WorkOrder workOrder : workOrders) {
			panels.add(new WorkOrderPanel(workOrder));
		}
		resized();
	}

	private void placeWidgets() {
		int i = 0;
		for (WorkOrderPanel pan : panels) {
			layeredPane.add(pan, 10);
			Point p = slots.getPoint(i);
			pan.setLocation(p);
			i++;
		}
	}

	private void storeOrder() {
		
	}
}