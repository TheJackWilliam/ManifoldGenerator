import peasy.*;

Matrix input;
int[] hidden;
int numOut = 3;
NeuralNetwork brain;
PeasyCam cam;

int samples = 20000;
Matrix[] points;
int pointsIndex = 0;

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


//int flip = 1;

float step = 0.1;
float t = 0;
float x = 0; float y = 0;
float scaling = 0.01, traverseRate = 0.01;
void traverseSpiral() {
  x = scaling * exp(t*traverseRate)*cos(t);
  y = scaling * exp(t*traverseRate)*sin(t);
  t += step;
  
  step *= 1 - 0.0001;
}

void resetManifold() {
  t = 0;
  x = 0;
  y = 0;
  pointsIndex = 0;
  points = new Matrix[samples];
  step = 0.1;
  cam.lookAt(width/2, height/2, (width+height)/4);  
}

void draw() {  
  background(200);
  
  if ((frameCount-1) % (60*5) == 0) {
    brain = new NeuralNetwork(input.numRows, hidden, numOut);
  }
  resetManifold();
  for (float i = 0; i < samples; i++) {
    for (float j = 0; j < 1/(step); j++) {
      traverseSpiral();
      float[][] pos = {{x},{y}};
      input.set(pos);
      Matrix result = brain.computeNetwork(input);
      if (samples - pointsIndex == 1) break;
      points[pointsIndex++] = result;
    }
    if (samples - pointsIndex == 1) break;
  }
  brain.incrementLerp(5);
  
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
    stroke(points[i].matrix[0][0]*255, points[i].matrix[1][0]*255, points[i].matrix[2][0]*255);
    vertex(points[i].matrix[0][0]*width, points[i].matrix[1][0]*height, points[i].matrix[2][0]*(width+height)/2);
  }
  endShape();
  
  //for (int row = 0; row < result.numRows; row++) {
  //  for (int col = 0; col < result.numCols; col++) {
  //    print(result.matrix[row][col] + " ");
  //  }
  //}
  //println();
}


  //beginShape();
  //for (float i = 0; i < 1/(100*step); i++) {
  //  for (float x_step = 0; x_step < goal; x_step += step) {
  //    x += step * flip;
  //    float[][] pos = {{x},{y}};
  //    input.set(pos);
  //    Matrix result = brain.computeNetwork(input);
  //    vertex(width * result.matrix[0][0], height * result.matrix[1][0]);
  //  }
  //  for (float y_step = 0; y_step < goal; y_step += step) {
  //    y += step * flip;
  //    float[][] pos = {{x},{y}};
  //    input.set(pos);
  //    Matrix result = brain.computeNetwork(input);
  //    if (samples - pointsIndex == 1) break;
  //    points[pointsIndex++] = result;
      
  //    //point(width * result.matrix[0][0], height * result.matrix[1][0], (width+height)/2 * result.matrix[2][0]);
  //  }
  //  goal += step;
  //  flip *= -1;
  //}
  //endShape();
