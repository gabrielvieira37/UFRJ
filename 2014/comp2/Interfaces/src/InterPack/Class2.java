package InterPack;

import java.awt.BorderLayout;

import javax.swing.*;

import java.awt.Label;
import java.awt.GridLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;


public class Class2 {
	

	
	public static void main(String[] args){
		GridLayout grid = new GridLayout(1,16);
		JPanel panel2 = new JPanel(grid);
		JFrame frame = new JFrame();
		JPanel panel = new JPanel(grid);
		JButton button = new JButton("Start");
		
		
		
		for (int i=0; i<16 ; i++){
		panel.add(new Label(Integer.toString(i)));
		JCheckBox ch = new JCheckBox();
		ch.setSelected(true);
		if ( i == 2 || i == 7 || i == 10 || i == 11){
				panel2.add(ch);
			}
			else {
				panel2.add(new JCheckBox());
			}
		}

		if (button.isSelected()){
			System.out.println("CheckBox 2 is Selected");
			System.out.println("CheckBox 7 is Selected");
			System.out.println("CheckBox 10 is Selected");
			System.out.println("CheckBox 11 is Selected");
			
		}
		
		
		
	
		frame.getContentPane().add(BorderLayout.CENTER,panel);
		frame.getContentPane().add(BorderLayout.SOUTH,panel2);
		frame.getContentPane().add(BorderLayout.NORTH,button);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
		
		
		frame.setSize(400, 100);
		frame.setVisible(true);	
		
		
		
		
	}

	
	

}
