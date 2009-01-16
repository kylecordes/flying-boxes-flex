package fly
{
	public class WorkOrderPanel
	{
		public function WorkOrderPanel()
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

import java.awt.Color;
import java.awt.Dimension;

import javax.swing.BorderFactory;
import javax.swing.BoxLayout;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.border.Border;


/**
 * @author Kyle
 */
public class WorkOrderPanel extends JPanel {

	private static final long serialVersionUID = 1L;

	private final WorkOrder workOrder;

	private final Border gap = BorderFactory.createEmptyBorder(2, 2, 2, 2);

	public WorkOrderPanel(WorkOrder _workOrder) {
		workOrder = _workOrder;
		setLayout(new BoxLayout(this, BoxLayout.PAGE_AXIS));
		add(new JLabel("Urgency: " + workOrder.getUrgency()));
		add(new JLabel(workOrder.getProduct()));
		add(new JLabel(workOrder.getAddress()));
		setBackground(UrgencyPalette.getColor(workOrder.getUrgency()));
		unHighlight();
		setPreferredSize(new Dimension(150, 60));
		setSize(getPreferredSize());
	}

	public void highlight() {
		setBorder(BorderFactory.createCompoundBorder(BorderFactory.createLineBorder(Color.YELLOW, 3), gap));
		repaint();
	}

	public void unHighlight() {
		setBorder(BorderFactory.createCompoundBorder(BorderFactory.createLineBorder(Color.BLACK, 1), gap));
		repaint();
	}

	public WorkOrder getWorkOrder() {
		return workOrder;
	}

}
