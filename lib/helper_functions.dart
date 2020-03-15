int argmax(List<num> X){
  if (X.isEmpty){
    return null;
  }
  var _argmax = 0;
  var max = X[0];
  for (var i = 1; i < X.length; i++){
    if (max < X[i]){
      max = X[i];
      _argmax = i;
    }
  }
  return _argmax;
}

int PitchSpecralHPS(List<double> frequencies, int sample_rate){

  final iOrder = 4;
  final freq_min = 300;
  var freq_out = 0;

  final input_length = ((frequencies.length -1)/iOrder).floor();
  final afHps = frequencies.sublist(0,input_length);
  final k_min =  (freq_min*2*(frequencies.length-1)/sample_rate).round();

  for (var k=2; k <= iOrder; k++){ // iterate through multiples

    var idx = 0;
    for (var j=0; j<frequencies.length; j= j+k){  // down sample frequencies
      if (idx < input_length) {
        afHps[idx] = afHps[idx] * frequencies[j];
      }
      idx++;
    }
  }

  freq_out = argmax(afHps.sublist(k_min,input_length));

  // freq_out = (freq_out + k_min)*(sample_rate/2)/(frequencies.length - 1)

  return freq_out;
}