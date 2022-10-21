import peasy.*;

Matrix input;
int[] hidden;
int numOut = 3;
NeuralNetwork brain;
PeasyCam cam;

int samples = 20000;
Matrix[] points;

void setup() {
  size(1000, 1000, P3D);
  cam = new PeasyCam(this, 0, 0, 0, (width+height)*3/4);
  cam.lookAt(width/2, height/2, (width+height)/4);
  noFill();
  
  input = new Matrix(2, 1);
  hidden = new int[1];
  hidden[0] = 6;
  brain = new NeuralNetwork(input.numRows, hidden, numOut);
  points = new Matrix[samples];
  //noLoop();
}

float step = 0.1;
float goal = step;
int flip = 1;
float x = 0; float y = 0;
int pointsIndex = 0;

void draw() {  
  background(200);
  
  //beginShape();
  for (float i = 0; i < 1/(100*step); i++) {
    for (float x_step = 0; x_step < goal; x_step += step) {
      x += step * flip;
      float[][] pos = {{x},{y}};
      input.set(pos);
      Matrix result = brain.computeNetwork(input);
      vertex(width * result.matrix[0][0], height * result.matrix[1][0]);
    }
    for (float y_step = 0; y_step < goal; y_step += step) {
      y += step * flip;
      float[][] pos = {{x},{y}};
      input.set(pos);
      Matrix result = brain.computeNetwork(input);
      if (samples - pointsIndex == 1) break;
      points[pointsIndex++] = result;
      
      //point(width * result.matrix[0][0], height * result.matrix[1][0], (width+height)/2 * result.matrix[2][0]);
    }
    goal += step;
    flip *= -1;
  }
  //endShape();
  
  // draw bounding box
  strokeWeight(1);
  stroke(255);
  line(0, 0, 0, width, 0, 0);
  line(0, 0, 0, 0, height, 0);
  line(0, 0, 0, 0, 0, (width+height)/2);
  line(width, height, (width+height)/2, 0, height, (width+height)/2);
  line(width, height, (width+height)/2, width, 0, (width+height)/2);
  line(width, height, (width+height)/2, width, height, 0);
  
  // draw manifold
  strokeWeight(1);
  stroke(0, 100);
  //fill(0);
  beginShape();
  for (int i = 0; i < pointsIndex; i++) {
    vertex(points[i].matrix[0][0]*width, points[i].matrix[1][0]*height, points[i].matrix[2][0]*(width+height)/2);
  }
  endShape();
  
  if (samples - pointsIndex == 1) {
    x = 0;
    y = 0;
    goal = step;
    pointsIndex = 0;
    points = new Matrix[samples];
    brain = new NeuralNetwork(input.numRows, hidden, numOut);
    
    cam.lookAt(width/2, height/2, (width+height)/4);
  }
  
  //for (int row = 0; row < result.numRows; row++) {
  //  for (int col = 0; col < result.numCols; col++) {
  //    print(result.matrix[row][col] + " ");
  //  }
  //}
  //println();
}
