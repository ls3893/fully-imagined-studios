import java.sql.*;
import javax.swing.*;
import java.awt.*;
import java.awt.event.*;

@SuppressWarnings("serial")
public class testDatabase extends JFrame {
	private JPanel executePanel;
	private JButton runQuery1Button, runQuery2Button, runQuery3Button, clearSQLButton;

	// Creating the main window of our application
	JFrame frame = new JFrame();
	JCheckBox checkBox1 = new JCheckBox("ID");
	JCheckBox checkBox2 = new JCheckBox("NAME");
	JCheckBox checkBox3 = new JCheckBox("SECTION");

	public testDatabase() {

		// get content pane and set its layout
		Container container = getContentPane();
		container.setLayout(new BorderLayout());
		// set up execute panel
		executePanel = new JPanel();
		executePanel.setLayout(new FlowLayout());

		// set up buttons
		runQuery1Button = new JButton("Run Query 1");
		runQuery2Button = new JButton("Run Query 2");
		runQuery3Button = new JButton("Run Query 3");
		clearSQLButton = new JButton("Clear SQL");

		executePanel.add(checkBox1);
		checkBox1.setBounds(0, 0, 50, 50);
		executePanel.add(checkBox2);
		checkBox2.setBounds(50, 50, 100, 100);
		executePanel.add(checkBox3);

		runQuery1Button.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent event) {
				if (event.getSource().equals(runQuery1Button)) {
					try {
						runSQLQuery1();

					} catch (ClassNotFoundException | SQLException e) {
						e.printStackTrace();
					}
				}
			}
		});

        runQuery2Button.addActionListener
        (
          new ActionListener()
          {
            public void actionPerformed(ActionEvent event)
            {
              if(event.getSource().equals(runQuery2Button))
              {
                try {
					runSQLQuery2();
				} catch (ClassNotFoundException | SQLException e) {
					e.printStackTrace();
				}
              }
            }
          }
        );
        
        runQuery3Button.addActionListener
        (
          new ActionListener()
          {
            public void actionPerformed(ActionEvent event)
            {
              if(event.getSource().equals(runQuery3Button))
              {
                try {
					runSQLQuery3();
			 } catch (ClassNotFoundException | SQLException e) {
					e.printStackTrace();
				}
              }
            }
          }
        );
        
		clearSQLButton.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent event) {
				if (event.getSource().equals(clearSQLButton)) {
					try {
						clearSQLQuery();
					} catch (ClassNotFoundException | SQLException e) {
						e.printStackTrace();
					}
				}
			}
		});

		checkBox1.addActionListener(new ActionListener() {
			public void actionPerformed(ActionEvent event) {
				if (event.getSource().equals(checkBox1)) {
					try {
						runSQLQuery4();
					} catch (ClassNotFoundException | SQLException e) {
						e.printStackTrace();
					}
				}
			}
		});

		executePanel.add(runQuery1Button);
		executePanel.add(runQuery2Button);
		executePanel.add(runQuery3Button);
		executePanel.add(clearSQLButton);
		container.add(executePanel, BorderLayout.SOUTH);
		setSize(800, 150);
		setVisible(true);
	}

	public static void main(String args[]) {

		testDatabase dwgui = new testDatabase();
		dwgui.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}

	private void runSQLQuery1() throws ClassNotFoundException, SQLException {

		Connection connection = connect();
		try {
			Statement str = connection.createStatement();
			String sql = "create table " + "testTable" + " (ID VARCHAR(40) not NULL, " + " NAME VARCHAR(50), "
					+ " SECTION VARCHAR(10), " + " PRIMARY KEY (ID))";
			str.executeUpdate(sql);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}// end runSQLQuery
	
	private void runSQLQuery2() throws ClassNotFoundException, SQLException
	{
		
	     Connection connection = connect();
	      try {
	          Statement str = connection.createStatement();
	          String sql = "INSERT INTO "+ "testTable" + " VALUES ('01','Pranshu','1')";    
	          str.executeUpdate(sql); 
	          String sql1 = "INSERT INTO "+ "testTable" + " VALUES ('02','Pranshu','2')";    
	          str.executeUpdate(sql1); 
	         
	          
	      } catch (Exception e) {
	          e.printStackTrace();
	      }
	      
	}//end runSQLQuery
	
	public void runSQLQuery3() throws SQLException, ClassNotFoundException {
		Connection connection = connect();
		String query = "SELECT ID, NAME, SECTION FROM testTable";
	    try (Statement stmt = connection.createStatement()) {
	      ResultSet rs = stmt.executeQuery(query);
	      while (rs.next()) {
	        String ID = rs.getString("ID");
	        String name = rs.getString("NAME");
	        String section = rs.getString("SECTION");
	        System.out.println(ID + ", " + name + ", " + section);
	        JOptionPane.showMessageDialog(null, ID + ", " + name + ", " + section);
	      }
	    } catch (SQLException e) {
	     printSQLException(e);
	    }
	  }

	public void runSQLQuery4() throws SQLException, ClassNotFoundException {
		Connection connection = connect();
		String query = "SELECT ID FROM testTable";
		try (Statement stmt = connection.createStatement()) {
			ResultSet rs = stmt.executeQuery(query);
			while (rs.next()) {
				String ID = rs.getString("ID");
				System.out.println(ID);
				JOptionPane.showMessageDialog(null, ID);
			}
		} catch (SQLException e) {
			printSQLException(e);
		}
	}

  	private void clearSQLQuery() throws ClassNotFoundException, SQLException {
		Connection connection = connect();

		Statement str = connection.createStatement();
		String sql = "drop table " + "testTable";
		str.executeUpdate(sql);

	}// end runSQLQuery

	private Connection connect() throws ClassNotFoundException, SQLException {
		String url = "jdbc:oracle:thin:@localhost:1521:xe";
		String user = "DBAdmin";
		String password = "DBAdmin";

		System.out.println("Connecting to DAtabase");
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection connection = DriverManager.getConnection(url, user, password);
		System.out.println(connection.toString());
		System.out.println("Connection Success");
		return connection;

	}

	public static void printSQLException(SQLException e) {
		while (e != null) {
			System.err.println("\n----- SQLException -----");
			System.err.println("  SQL State:  " + e.getSQLState());
			System.err.println("  Error Code: " + e.getErrorCode());
			System.err.println("  Message:    " + e.getMessage());
			e = e.getNextException();
		}
	}
	
	
}
