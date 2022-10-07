class Layer {
  int numNodes;
  Matrix weights;
  Matrix biases;
  
  Layer(int prevNodes, int currentNodes) {
    numNodes = currentNodes;
    weights = new Matrix(numNodes, prevNodes); // row = node
    biases = new Matrix(numNodes, 1);
  }
  
  Matrix computeLayer(Matrix input) { // input is nx1
    Matrix output = new Matrix(numNodes, 1);
    
    output.set(weights.mult(input));
    output.set(output.add(biases));
    output.applySigmoid();
    
    return output; 
  }
}
