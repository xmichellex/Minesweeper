

import de.bezier.guido.*;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20; 
public final static int NUM_COLS = 20; 
public final static int NUM_BOMBS = 20; 
private MSButton[][] buttons; //2d array of minesweeper buttons
//ArrayList of just the minesweeper buttons that are mined
private ArrayList <MSButton> bombs = new ArrayList <MSButton>();

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r = 0; r < NUM_ROWS; r++) { 
        for(int c = 0; c < NUM_COLS; c++) { 
            buttons[r][c] = new MSButton(r,c); 
        }
    }
    
    
    setBombs();
}
public void setBombs()
{
    //your code
    for(int i = 0; i < NUM_BOMBS; i++) { 
    int row = (int)(Math.random()*20); 
    int col = (int)(Math.random()*20); 
    if(!bombs.contains(buttons[row][col])) {  
        bombs.add(buttons[row][col]); 
        } 
    //i--;
    }
} 

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
    int markBombs = 0; 
    for(int i = 0; i < bombs.size(); i++) 
    { 
        if(bombs.get(i).isMarked == true) 
            markBombs++; 
    } 
    if(markBombs == bombs.size()) 
        return true; 
    for(int i = 0; i < bombs.size(); i++) 
    { 
        if(bombs.get(i).isClicked() == true) 
            displayLosingMessage(); 
    } 
    return false;
}
public void displayLosingMessage()
{
    //your code here
    for(int i = 0; i < bombs.size(); i++) 
    { 
        bombs.get(i).setClicked(true); 
    } 
    buttons[10][8].setLabel("Y");
    buttons[10][9].setLabel("O"); 
    buttons[10][10].setLabel("U"); 
    buttons[11][8].setLabel("L"); 
    buttons[11][9].setLabel("O"); 
    buttons[11][10].setLabel("S"); 
    buttons[11][11].setLabel("E"); 
}
public void displayWinningMessage()
{
    //your code here
    buttons[10][8].setLabel("Y");
    buttons[10][9].setLabel("O"); 
    buttons[10][10].setLabel("U"); 
    buttons[11][8].setLabel("W"); 
    buttons[11][9].setLabel("I"); 
    buttons[11][10].setLabel("N"); 
    buttons[11][11].setLabel("!"); 
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {

         width = 400/NUM_COLS;
         height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    { 
        if(mouseButton == LEFT) 
        { 
            if(clicked == false) { 
                clicked = true; 
                if(keyPressed == true) 
                    marked=!marked;
                else if(bombs.contains(this)) 
                    displayLosingMessage(); 
                else if(countBombs(r, c) > 0) 
                    setLabel(""+countBombs(r, c));
                else 
                {
                    for(int i= -1; i < 2; i++) { 
                        for(int j = -1; j < 2; j++) { 
                            if(isValid(r+i,c+j)==true) {
                                if(buttons[r+i][c+j].isClicked() == false) { 
                                    //recursively call mousepressed
                                    buttons[r+i][c+j].mousePressed(); 
                        } 
                    } 
                }
            }
        }
    } 
} 
    public void draw () 
    {    
        if (marked)
            fill(0);
         else if( clicked && bombs.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        
        if(r >= 0 && r < 20 && c >= 0 && c <20) 
            return true; 
        else  
          return false;
    }
   
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        
        for(int i= -1; i < 2; i++) { 
            for(int j = -1; j < 2; j++) { 
                if(isValid(row+i,col+j) && bombs.contains(buttons[row+i][col+j])) {
                    numBombs++;
                }
            }  
        }     
        return numBombs;
    } 
}  
