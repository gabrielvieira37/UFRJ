package InterPack;

import java.awt.BorderLayout;
import java.awt.Color;
import javax.swing.*;

public class ExerciseA {

	public static void main(String[] args){
		JFrame frame = new JFrame();
		JPanel panel = new JPanel();
		panel.setBackground(Color.DARK_GRAY);
		JButton button = new JButton("tesuji");
		JButton buttonTwo = new JButton ("watari");
		panel.add(buttonTwo);
		frame.getContentPane().add(BorderLayout.NORTH,button);
		frame.getContentPane().add(BorderLayout.SOUTH, panel);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		frame.setSize(300, 300);
		frame.setVisible(true);		
		
	}
	
}
