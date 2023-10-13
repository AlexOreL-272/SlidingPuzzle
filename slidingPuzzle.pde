final int FIELD_SIZE = 10;
final int W = 1200, H = 800, CELL_SIZE = H / FIELD_SIZE;
int field[][] = new int[FIELD_SIZE][FIELD_SIZE];
int xPos = FIELD_SIZE - 1, yPos = FIELD_SIZE - 1;
int startTime = 0, curTime = 0;
int nextClickToRemoveScrambleFlag = 0;
boolean timerSet = false, solvedFlag = false, 
  firstClick = false, scrambleFlag = false; 

void settings() {
  size(W, H);
}

void setup() {
  textAlign(CENTER, CENTER);
  colorMode(RGB);
  frameRate(60);

  resetField();
}

void draw() {
  background(175);

  drawField();

  fill(200);
  rect(H, 0, W - H, H / 3);
  rect(H, H * 2 / 3, W - H, H / 3);
  fill(0);
  textSize((W - H) / 6);
  text("Scramble!", H * 1.25, H * 0.15);  
  text("Reset!", H * 1.25, H * 0.82);

  if (solvedFlag) {
    text("Solved!", H * 1.25, H * 0.45);
    if (scrambleFlag)
      text(str(curTime / 60000) + "." + nf(float(curTime % 60000) / 1000, 2, 3), H * 1.25, H * 0.55);
  }
  if (timerSet) {
    curTime = millis() - startTime;
    text(str(curTime / 60000) + "." + nf(float(curTime % 60000) / 1000, 2, 3), H * 1.25, H * 0.5);
  }

  if (mousePressed) {
    solvedFlag = solved();

    if (nextClickToRemoveScrambleFlag > 4) {
      nextClickToRemoveScrambleFlag = 0;
      scrambleFlag = false;
    }

    if (solvedFlag) {
      timerSet = false;
      if (scrambleFlag)
        nextClickToRemoveScrambleFlag++;
    }

    if (mouseX > H) {
      int yCoord = mouseY * 3 / H;

      if (yCoord == 0) {
        timerSet = false;
        solvedFlag = false;
        firstClick = true;
        scrambleFlag = true;

        scramble();
      }

      if (yCoord == 2) {
        timerSet = false;
        solvedFlag = false;
        firstClick = false;
        scrambleFlag = false;

        resetField();
      }
    } else {
      if (firstClick) {
        startTime = millis();
        timerSet = true;
        firstClick = false;
      }

      int xCoord = mouseX / CELL_SIZE, 
        yCoord = mouseY / CELL_SIZE;

      if (isAdjacent(xPos, yPos, xCoord, yCoord)) {
        int tmp = field[xCoord][yCoord];
        field[xCoord][yCoord] = 0;
        field[xPos][yPos] = tmp;
        xPos = xCoord;
        yPos = yCoord;
      }
    }
  }
}

void drawField() {
  textSize(CELL_SIZE / 3);
  for (int i = 0; i < FIELD_SIZE; i++) {
    for (int j = 0; j < FIELD_SIZE; j++) {
      float colorX = (float)((field[i][j] - 1) % FIELD_SIZE) / (FIELD_SIZE - 1);
      float colorY = (float)((field[i][j] - 1) / FIELD_SIZE) / (FIELD_SIZE - 1);

      if (field[i][j] != 0)
        fill((1 - colorX) * 255, colorY * 255, colorX * 255);

      square(i * CELL_SIZE, j * CELL_SIZE, CELL_SIZE);
      fill(0);
      text(field[i][j], i * CELL_SIZE + CELL_SIZE * 0.5, j * CELL_SIZE + CELL_SIZE * 0.45);
    }
  }
}

boolean solved() {
  int tmp = field[FIELD_SIZE - 1][FIELD_SIZE - 1];
  field[FIELD_SIZE - 1][FIELD_SIZE - 1] = FIELD_SIZE * FIELD_SIZE;

  for (int i = 0; i < FIELD_SIZE; i++) {
    for (int j = 0; j < FIELD_SIZE; j++) {
      if (field[i][j] != i + j * FIELD_SIZE + 1) {
        field[FIELD_SIZE - 1][FIELD_SIZE - 1] = tmp;
        return false;
      }
    }
  }

  field[FIELD_SIZE - 1][FIELD_SIZE - 1] = tmp;
  return true;
}

void scramble() {
  final long num = FIELD_SIZE * FIELD_SIZE * FIELD_SIZE;
  for (int i = 0; i < num; i++) {
    int xCoord = xPos + round(random(-1.4, 1.4)), yCoord = yPos + round(random(-1.4, 1.4));
    if (xCoord < 0)
      xCoord++;
    if (xCoord >= FIELD_SIZE)
      xCoord--;
    if (yCoord < 0)
      yCoord++;
    if (yCoord >= FIELD_SIZE)
      yCoord--;

    if (isAdjacent(xPos, yPos, xCoord, yCoord)) {
      int tmp = field[xCoord][yCoord];
      field[xCoord][yCoord] = 0;
      field[xPos][yPos] = tmp;
      xPos = xCoord;
      yPos = yCoord;
    }
  }
}

void resetField() {
  for (int i = 0; i < FIELD_SIZE; i++) {
    for (int j = 0; j < FIELD_SIZE; j++) {
      field[i][j] = i + j * FIELD_SIZE + 1;
    }
  }
  field[FIELD_SIZE - 1][FIELD_SIZE - 1] = 0;

  xPos = FIELD_SIZE - 1;
  yPos = FIELD_SIZE - 1;
}

boolean isAdjacent(int ax, int ay, int bx, int by) {
  int xDiff = abs(ax - bx), 
    yDiff = abs(ay - by);

  return (xDiff == 1 || yDiff == 1) && (xDiff == 0 || yDiff == 0);
}
