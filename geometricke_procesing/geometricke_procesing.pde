void setup(){
  background(200,200,200);
  size(1200,600);
  rect(1000,0,200,600);
  
  //add points
  fill(48,163,28);
  rect(1025,50,150,50);
  fill(0);
  textSize(16);
  text("Add points", 1060, 80);
  
  //delete points
  fill(197,50,50);
  rect(1025,150,150,50);
  fill(0);
  textSize(16);
  text("Delete points", 1060, 180);
  
  //move points
  fill(50,50,200);
  rect(1025,250,150,50);
  fill(255);
  textSize(16);
  text("Move points", 1060, 280);
}

int max_points = 1000;
int point_counter = 0;

FloatList xPos = new FloatList();
FloatList yPos = new FloatList();

boolean AddPoints = false;
boolean DeletePoints = false;
boolean MovePoints = false;

boolean IsPointMoving = false;
int movingPointIndex = -1;


void draw() {
  fill(0);
  if (mousePressed) {
    //print("mouse", mouseX, mouseY); //<>//
    if(mouseButton == RIGHT){
      DisableButtons();
      if(IsPointMoving) CancelPointMoving();
    }
    else {
     if(mouseX > 1025 && mouseX < 1175 && mouseY > 50 && mouseY < 100){
       DisableButtons();
       AddPoints();
     }
     if(mouseX > 1025 && mouseX < 1175 && mouseY > 150 && mouseY < 200){
       DisableButtons();
       DeletePoints();
     }
     if(mouseX > 1025 && mouseX < 1175 && mouseY > 250 && mouseY < 300){
       DisableButtons();
       MovePoints();
     }
     if(AddPoints && mouseX < 1000){
       drawPoint(mouseX,mouseY);
     }
     if(DeletePoints){
       deletePoint(mouseX, mouseY);
     }
     
     if(IsPointMoving){
      movePoint(mouseX, mouseY);
      IsPointMoving = false;
      movingPointIndex = -1;
     }
     
     if(MovePoints && !IsPointMoving){
      IsPointMoving =  setPointMoving(mouseX, mouseY); 
     }
    }
  }
}



void movePoint(float x, float y){
 fill(200,200,200);
 ellipse(xPos.get(movingPointIndex), yPos.get(movingPointIndex),15,15);
 
 xPos.remove(movingPointIndex);
 yPos.remove(movingPointIndex);
 
 drawPoint(x,y);
 point_counter--;
 xPos.append(x);
 yPos.append(y);
}

boolean setPointMoving(float x, float y){
 for(int i = 0;i < point_counter; i++){
   //println(mouseX," ", mouseY, xPos.get(i), yPos.get(i)); 
   if(x > xPos.get(i) - 5 && x < xPos.get(i) + 5 && y > yPos.get(i) - 5 && y < yPos.get(i) + 5){
     movingPointIndex = i; 
     
     fill(50,50,200);
     ellipse(xPos.get(i),yPos.get(i),11,11);
     
     return true;
    }
  }
  
  movingPointIndex = -1;
  return false;
}

void deletePoint(float x, float y){
 int remove_index = -1;
 for(int i = 0;i < point_counter; i++){
   //println(mouseX," ", mouseY, xPos.get(i), yPos.get(i)); 
   if(x > xPos.get(i) - 5 && x < xPos.get(i) + 5 && y > yPos.get(i) - 5 && y < yPos.get(i) + 5){
     remove_index = i; 
     
     fill(200,200,200);
     ellipse(xPos.get(i),yPos.get(i),15,15);
    }
  }
  
  if(remove_index != -1){
   xPos.remove(remove_index);
   yPos.remove(remove_index);
   point_counter--; 
  } 
}

void drawPoint(float x, float y){
  for(int i = 0; i < point_counter; i++){
   if(xPos.get(i) == x && yPos.get(i) == y) return; 
  }
  
  fill(0);
  ellipse(x,y,10,10);
    
  xPos.append(x);
  yPos.append(y);
  point_counter++;
}

void AddPoints(){
  AddPoints = true;
      
  fill(200,50,50);
  noStroke();
  ellipse(1015,75,15,15);
}

void DeletePoints(){
  DeletePoints = true;
      
  fill(200,50,50);
  noStroke();
  ellipse(1015,175,15,15);
}

void MovePoints(){
  MovePoints = true;
      
  fill(200,50,50);
  noStroke();
  ellipse(1015,275,15,15);
}

void CancelPointMoving(){
 IsPointMoving = false;
 fill(200,200,200);
 ellipse(xPos.get(movingPointIndex), yPos.get(movingPointIndex),15,15);
 fill(0);
 ellipse(xPos.get(movingPointIndex), yPos.get(movingPointIndex),10,10);
 movingPointIndex = -1;
}

void DisableButtons(){
 noStroke();
 AddPoints = false;
 DeletePoints = false;
 MovePoints = false;
 
 fill(255);
 ellipse(1015,75,16,16);
 ellipse(1015,175,16,16);
 ellipse(1015,275,16,16); 
}