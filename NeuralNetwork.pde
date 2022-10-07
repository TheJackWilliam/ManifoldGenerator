class NeuralNetwork {
  Layer[] Layers;
  NeuralNetwork(int input, int[] hidden, int output) { // hidden[layer] = numNodes
    Layers = new Layer[hidden.length+1];
    
    Layers[0] = new Layer(input, hidden[0]);
    for (int layer = 1; layer < hidden.length; layer++) {
      Layers[layer] = new Layer(hidden[layer-1], hidden[layer]);
    }
    Layers[hidden.length] = new Layer(hidden[hidden.length-1], output);
  }
  
  Matrix computeNetwork(Matrix input) {
    Matrix result = Layers[0].computeLayer(input);
    for (int layer = 1; layer < Layers.length; layer++) {   
      result = Layers[layer].computeLayer(result);
    }
    return result;
  }
}
