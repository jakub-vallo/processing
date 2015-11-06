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
  rect(1025,125,150,50);
  fill(0);
  textSize(16);
  text("Delete points", 1060, 155);
  
  //move points
  fill(50,50,200);
  rect(1025,200,150,50);
  fill(255);
  textSize(16);
  text("Move point", 1060, 230);
  
  //generate random points
  fill(200,100,50);
  rect(1025,275,150,50);
  fill(0);
  textSize(16);
  text("Random points", 1050, 305);
  
  //clear
  fill(200,200,200);
  rect(1025,350,150,50);
  fill(0);
  textSize(16);
  text("Clear", 1075, 380);
  
 //algorithms
  
 //ConvexHull
 fill(255,165,0);
 rect(1000,410,1200,40);
 fill(0);
 textSize(16);
 text("ConvexHull-GiftWrap", 1020, 435);
  
}

int c = 0;

int max_points = 1000;
int point_counter = 0;

FloatList xPos = new FloatList();
FloatList yPos = new FloatList();

boolean AddPoints = false;
boolean DeletePoints = false;
boolean MovePoints = false;

boolean IsPointMoving = false;
int movingPointIndex = -1;

float lX = 0;
float lY = 0;

//algorithms
boolean computeConvexHull = false;

void draw() {
  fill(0);
  if (mousePressed && (mouseX != lX || mouseY != lY)) {
    lX = mouseX;
    lY = mouseY;
    //print("mouse", mouseX, mouseY);
    if(mouseButton == RIGHT){
      DisableButtons();
      if(IsPointMoving) CancelPointMoving();
    }
    else {
     
      //select
     if(mouseX > 1025 && mouseX < 1175 && mouseY > 50 && mouseY < 100){
       DisableButtons();
       AddPoints();
     }
     if(mouseX > 1025 && mouseX < 1175 && mouseY > 125 && mouseY < 175){
       DisableButtons();
       DeletePoints();
     }
     if(mouseX > 1025 && mouseX < 1175 && mouseY > 200 && mouseY < 250){
       DisableButtons();
       MovePoints();
     }
     if(mouseX > 1025 && mouseX < 1175 && mouseY > 275 && mouseY < 325){
       DisableButtons();
       RandomPoints();
     }
     if(mouseX > 1025 && mouseX < 1175 && mouseY > 350 && mouseY < 400){
       DisableButtons();
       clearSpace();
     }
    if(mouseX > 1000 && mouseX < 1200 && mouseY > 410 && mouseY < 450){
      DisableButtons();
      computeConvexHull = true;
    }
     
     //draw
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
      DisableButtons();
     }
     if(MovePoints && !IsPointMoving){
      IsPointMoving =  setPointMoving(mouseX, mouseY); 
     }
     
     //algorithms
    if(computeConvexHull){
      convexHull();
      computeConvexHull = false;
    }
    }
  }
}



//algorithms

void convexHull(){
 int index = findPivot();
 if(index != -1){
  //init
  println("Pivot: ", xPos.get(index), yPos.get(index));
   
  float pivotX = xPos.get(index);
  float pivotY = yPos.get(index);
  fill(255,0,0);
  ellipse(pivotX, pivotY,15,15);
   
  FloatList toComputeX = xPos.copy();
  FloatList toComputeY = yPos.copy();
  toComputeX.remove(index);
  toComputeY.remove(index);
   
  FloatList resultX = new FloatList();
  FloatList resultY = new FloatList();
  resultX.append(pivotX);
  resultY.append(pivotY);
  int result = 0;
  
  float headX;
  float headY;
  
  float previousVectorX = 0;
  float previousVectorY = 1;
  float tempVectorX = 0;
  float tempVectorY = 0;
  float vectorX = 0;
  float vectorY = 0;
  
  //algoritmus
  while(true){
    headX = resultX.get(result);
    headY = resultY.get(result);
    
    int add = -1;
    float angel = 10;
    for(int j = 0; j < toComputeX.size(); j++){
      float pointX = toComputeX.get(j);
      float pointY = toComputeY.get(j);
       
      vectorX = pointX - headX;
      vectorY = (600 - pointY) - (600 - headY);
       
      float a = (vectorX * previousVectorX + vectorY * previousVectorY) / ( (sqrt(vectorX*vectorX + vectorY*vectorY)) * (sqrt(previousVectorX*previousVectorX + previousVectorY*previousVectorY)));
      float acos = acos(a);
      println("Angel:", acos, "Points: ", pointX, pointY, " x ", headX, headY, " Vectors: ", previousVectorX, previousVectorY, " x ", vectorX, vectorY);
      if(acos < angel){
       angel = acos;
       add = j;
       tempVectorX = vectorX;
       tempVectorY = vectorY;
      }
   }
   
   //kontrola ukoncenia
   if(toComputeX.get(add) == pivotX && toComputeY.get(add) == pivotY){
     drawLine(headX,headY,toComputeX.get(add),toComputeY.get(add));
     break;
   }
   
   //priprava na dalsiu iteraciu
   previousVectorX = tempVectorX;
   previousVectorY = tempVectorY;
   
   resultX.append(toComputeX.get(add));
   resultY.append(toComputeY.get(add));
   result++;
   drawLine(headX,headY,toComputeX.get(add),toComputeY.get(add));
   toComputeX = xPos.copy();
   toComputeY = yPos.copy();
   for(int i=0; i < toComputeX.size(); i++){
     if(toComputeX.get(i) == resultX.get(result) && toComputeY.get(i) == resultY.get(result)){
       toComputeX.remove(i);
       toComputeY.remove(i);
     }
     else{
      println("Point: ", toComputeX.get(i), toComputeY.get(i)); 
     }
   }
   println("Smallest angel: ", resultX.get(result), resultY.get(result));
     
  }
 }
 else{
  println("Add points"); 
 }
  
}

int findPivot(){
  int index = -1;
  float max = 0;
  for(int i = 0; i < point_counter; i++){
   if(xPos.get(i) > max){
    max = xPos.get(i);
    index = i; 
   }
  }
  return index;
}

void movePoint(float x, float y){
 println("Move point: ", xPos.get(movingPointIndex), yPos.get(movingPointIndex), "To: ", x, y);
  fill(200,200,200);
 ellipse(xPos.get(movingPointIndex), yPos.get(movingPointIndex),15,15);
 
 xPos.remove(movingPointIndex);
 yPos.remove(movingPointIndex);
 
 drawPoint(x,y);
 point_counter--;
 println("List: ", xPos.size(), " ", yPos.size());
}

boolean setPointMoving(float x, float y){
 for(int i = 0;i < point_counter; i++){
   //println(mouseX," ", mouseY, xPos.get(i), yPos.get(i)); 
   if(x > xPos.get(i) - 5 && x < xPos.get(i) + 5 && y > yPos.get(i) - 5 && y < yPos.get(i) + 5){
     movingPointIndex = i; 
     
     fill(50,50,200);
     ellipse(xPos.get(i),yPos.get(i),11,11);
     
     println("Point set moving: ", xPos.get(i), yPos.get(i));
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
   println("Delete point: ",xPos.get(remove_index),yPos.get(remove_index));
   xPos.remove(remove_index);
   yPos.remove(remove_index);
   point_counter--;
   println("List: ", xPos.size(), " ", yPos.size());
  }
  
  
}

void drawPoint(float x, float y){
  println("Add point: ",x,y);
  fill(0);
  ellipse(x,y,10,10);
    
  xPos.append(x);
  yPos.append(y);
  point_counter++;
  println("List: ", xPos.size(), " ", yPos.size());
}

void drawLine(float firstX, float firstY, float secondX, float secondY){
 stroke(0 + c,255 - c, 0);
 strokeWeight(5);
 line(firstX, firstY, secondX, secondY);
 c = c+50;
 if(c>255){
  c = 0; 
 }
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
  ellipse(1015,150,15,15);
}

void MovePoints(){
  MovePoints = true;
      
  fill(200,50,50);
  noStroke();
  ellipse(1015,225,15,15);
}

void RandomPoints(){
  for (int i = 0; i < 10; i++){
    int x = int(random(1000));
    int y = int(random(600));
    drawPoint(x,y);
  }  
}

void clearSpace(){
  fill(200,200,200);
  rect(0,0,1000,600);
  xPos = new FloatList();
  yPos = new FloatList();
  println("List: ", xPos.size(), " ", yPos.size());
  point_counter = 0;
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
 ellipse(1015,150,16,16);
 ellipse(1015,225,16,16); 
}