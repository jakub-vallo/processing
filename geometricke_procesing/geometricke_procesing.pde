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



void draw() {
  fill(0);
  if (mousePressed) {
    //print("mouse", mouseX, mouseY);
    if(mouseButton == RIGHT){
      DisableButtons();
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
        for(int i = 0;i < point_counter; i++){
          if(mouseX > xPos.get(i) - 5 && mouseX < xPos.get(i) + 5 && mouseY > yPos.get(i) + 5 && mouseY < yPos.get(i) + 5){
            print("bla");
            xPos.remove(i);
            yPos.remove(i);
            point_counter--;
            
            fill(200,200,200);
            ellipse(xPos.get(i),yPos.get(i),10,10);
          }
        }
     }
    }
  }
}



void drawPoint(float x, float y){
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