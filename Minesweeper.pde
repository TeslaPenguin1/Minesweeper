import de.bezier.guido.*;

public final static int NUM_ROWS = 30;
public final static int NUM_COLS = 30;
public final static int NUM_MINES = 70;

boolean gameLost = false;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList<MSButton>();; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(600, 600);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    
    for(int i = 0; i < buttons.length; i++) {
      for(int j = 0; j < buttons[i].length; j++) {
        buttons[i][j] = new MSButton(i,j);
      }
    }
    
    
    
    setMines();
}
public void setMines()
{
    for(int i = 0; i < NUM_MINES; i++) {  
      int row = (int)(Math.random()*NUM_ROWS);
      int col = (int)(Math.random()*NUM_COLS);
      if (!mines.contains(buttons[row][col])) mines.add(buttons[row][col]);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    for(int i = 0; i < mines.size(); i++) if (!mines.get(i).isFlagged()) return false;
    return true;
}
public void displayLosingMessage()
{
    gameLost = true;
    for(int i = 0; i < mines.size(); i++) mines.get(i).clicked = true;
    for(int i = 0; i < buttons.length; i++) {
      for(int j = 0; j < buttons[i].length; j++) {
        if(buttons[i][j].myLabel.equals("") && buttons[i][j].clicked == true) buttons[i][j].setLabel("L");
      }
    }
}
public void displayWinningMessage()
{
    for(int i = 0; i < buttons.length; i++) {
      for(int j = 0; j < buttons[i].length; j++) {
        buttons[i][j].setLabel("W");
      }
    }
}
public boolean isValid(int r, int c)
{
    if(r < NUM_ROWS && c < NUM_COLS && r > -1 && c > -1) return true;
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r <= row+1; r++) {
      for(int c = col-1; c <= col+1; c++) {
        if (isValid(r, c) && mines.contains(buttons[r][c])) numMines++;
        if (mines.contains(buttons[row][col])) numMines--;
      }
    }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 600/NUM_COLS;
        height = 600/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
      if(!isWon() && !gameLost) {
        if (mouseButton == LEFT && !flagged) clicked = true;
        if (mouseButton == RIGHT && !clicked) flagged = !flagged;
        else if (!flagged && mines.contains(this)) displayLosingMessage();
        else if (countMines(myRow,myCol) > 0) this.setLabel(countMines(myRow,myCol));
        else {
          for(int r = myRow-1; r <= myRow+1; r++) {
            for(int c = myCol-1; c <= myCol+1; c++) {
              if (isValid(r, c) && !buttons[r][c].clicked) buttons[r][c].mousePressed();
            }
          }
        }
      }
    }
    public void draw () 
    {    
        if (flagged && gameLost && !mines.contains(this))
            fill(#890404);
        else if (flagged)
            fill(0);
        else if (isWon() && !mines.contains(this))
            fill(#6DEAAF);
        else if( clicked && mines.contains(this)) 
             fill(255,0,0);
        else if(!clicked)
            fill( 100 );
        else if (gameLost && !mines.contains(this))
            fill(#FA9A9A);
        else 
            fill( 200 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked()
    {
        return clicked;
    }
}
