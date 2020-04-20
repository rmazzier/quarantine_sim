shader_type canvas_item;

uniform float variance = 1.;

const float PI = 3.14;
const int k = 10;
const int m = 10;

float gaussian(vec2 pos){
	float factor = 1. / (2. * PI * variance);
	float sqDist = pow(pos.x, 2) + pow(pos.y, 2);
	return factor * exp(- sqDist / (2. * variance));
}

float normpdf(in float x, in float sigma) {
	return 0.39894*exp(-0.5*x*x/(sigma*sigma))/sigma;
}

void fragment() {
	const int mSize = 11;
	const int kSize = (mSize-1)/2;
	float kernel[11]; // please set size equal to mSize
	
	float sigma = 30.;
	float Z = 0.0;
	for (int j = 0; j <= kSize; ++j){
		kernel[kSize+j] =
		kernel[kSize-j] =
			normpdf(float(j), sigma);
	}
	
	for (int j = 0; j < mSize; ++j) {
		Z += kernel[j];
	}
	
	vec3 pixelSum = vec3(0.);
	for(int i = -kSize; i <= kSize; i++){
		for(int j = -kSize; j < kSize; j++){
			vec2 cellIndex = vec2(float(i), float(j));
			vec2 xy = SCREEN_UV;
			vec2 p = xy + cellIndex * SCREEN_PIXEL_SIZE;
			pixelSum += 
				kernel[kSize+i] *
				kernel[kSize+j] *
				texture(SCREEN_TEXTURE, p).rgb;
		}
	}

	COLOR.rgb = pixelSum / (Z * Z);
}