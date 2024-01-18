ArrayList<Circle> dft(FloatList x){
    int N = x.size();
    ArrayList<Circle> X = new ArrayList<Circle>();

    for (int k = 0; k < N; ++k) {
        float re = 0;
        float im = 0;

        for (int n = 0; n < N; ++n) {
            float phi = (TWO_PI * k * n) / N;
            re += x.get(n) * cos(phi);
            im += x.get(n) * sin(phi);
        }
        re = re / N;
        im = im / N;

        float amp = sqrt(re*re + im*im);
        float phase = atan2(im,re);

        Circle circ = new Circle(amp, k, phase, re, im);
        X.add(circ);
    }
    return X;
}


PVector epiCycle(float x, float y, float rotation, ArrayList<Circle> fourier){

    for (int i = 0; i < fourier.size(); ++i) {
        float prevx = x;
        float prevy = y;
        
        Circle circ = fourier.get(i); 
        float freq = circ.getFreq();
        float phase = circ.getPhase();
        float radius = circ.getAmp();

        x += radius * cos(freq * time + phase + rotation);
        y += radius * sin(freq * time + phase + rotation);
        
        stroke(255, 100);
        noFill();
        circle(prevx, prevy, radius * 2);
        
        stroke(255);
        line(prevx, prevy, x, y);
        
        fill(255);
        circle(x,y,0.5);
    }
    return (new PVector(x,y));
}