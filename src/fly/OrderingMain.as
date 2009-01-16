package fly
{
	public class OrderingMain
	{
		public function OrderingMain()
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

import java.awt.BorderLayout;
import java.util.ArrayList;
import java.util.List;

import javax.swing.BorderFactory;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.UIManager;

import swingtalk.randomdata.RandomData;

public class OrderingMain {

	private final OrderingWidget orderingWidget = new OrderingWidget();

	private void createAndShowGUI() {
		JFrame frame = new JFrame("Demo");
		JPanel panel = new JPanel(new BorderLayout());
		JLabel topLabel = new JLabel("Drag and drop the work orders.");
		topLabel.setBorder(BorderFactory.createEmptyBorder(3, 3, 3, 3));
		panel.add(topLabel, BorderLayout.NORTH);
		panel.add(orderingWidget.getComponent(), BorderLayout.CENTER);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		panel.setOpaque(true); // content panes must be opaque
		frame.setContentPane(panel);
		frame.pack();
		frame.setVisible(true);

		populateRandomSampleData();
	}

	private void populateRandomSampleData() {
		List<WorkOrder> wos = new ArrayList<WorkOrder>();
		for (int i = 0; i < 30; i++) {
			String product = "Delivery for " + RandomData.makeName();
			int urgency = (int) (System.nanoTime() % 4 + 1);
			WorkOrder wo = new WorkOrder(i, RandomData.makeAddress(), product,
					urgency);
			wos.add(wo);
		}

		orderingWidget.load(wos);
	}

	public static void main(String[] args) throws Exception {
		try {
			UIManager
				.setLookAndFeel("com.jgoodies.looks.plastic.PlasticXPLookAndFeel");
		} catch(Exception e) {
			System.err.println("L&F not available:" + e.getMessage());
		}

		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				new OrderingMain().createAndShowGUI();
			}
		});
	}

}
