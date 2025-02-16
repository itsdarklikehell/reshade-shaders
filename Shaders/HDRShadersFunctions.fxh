/**	All credits go to respective authors like:
*	Lilium
*	Pumbo
*	All the people that worked on defining the standards
*
*	Tweaks and edits by MaxG3D
*
*	Special thanks to SpecialK, and HDR Den server
**/

#pragma once

#pragma warning(disable : 3571) // disable warning about potentially using pow on a negative value

/////////////////////////////////////////////
//DEFINITIONS
/////////////////////////////////////////////

// These are from the "color_space" enum in ReShade
#define RESHADE_COLOR_SPACE_SDR        	0
#define RESHADE_COLOR_SPACE_SCRGB       	1
#define RESHADE_COLOR_SPACE_BT2020_PQ   	2

// This uses the enum values defined in "IN_COLOR_SPACE"
#define DEFAULT_COLOR_SPACE 1

// "BUFFER_COLOR_SPACE" is defined by ReShade.
// "ACTUAL_COLOR_SPACE" uses the enum values defined in "IN_COLOR_SPACE".
#if BUFFER_COLOR_SPACE == RESHADE_COLOR_SPACE_SRGB
  #define ACTUAL_COLOR_SPACE 0
#elif BUFFER_COLOR_SPACE == RESHADE_COLOR_SPACE_SCRGB
  #define ACTUAL_COLOR_SPACE 1
#elif BUFFER_COLOR_SPACE == RESHADE_COLOR_SPACE_BT2020_PQ
  #define ACTUAL_COLOR_SPACE 2
#else
  #define ACTUAL_COLOR_SPACE 1
#endif

#define PI 3.1415927410125732421875f

#define UINT_MAX 4294967295
#define  INT_MAX 2147483647
#define MIN3(A, B, C) min(A, min(B, C))
#define MAX3(A, B, C) max(A, max(B, C))
#define MAX4(A, B, C, D) max(A, max(B, max(C, D)))
#define MAX5(A, B, C, D, E) max(A, max(B, max(C, max(D, E))))
#define MAXRGB(Rgb) max(Rgb.r, max(Rgb.g, Rgb.b))
#define MINRGB(Rgb) min(Rgb.r, min(Rgb.g, Rgb.b))
#define lumCoeffHDR float3(0.2627f, 0.6780f, 0.0593f)
#define lumCoeffsRGB float3(0.299f, 0.587f, 0.114f)
#define lumCoeffLinear float3(0.2126f, 0.7152f, 0.0722f)
#define FP32_MIN asfloat(0x00800000)
#define FP32_MAX asfloat(0x7F7FFFFF)
#define FLT16_MAX 65504.f

uniform float frametime < source = "frametime"; >;
uniform float2 mouse_delta < source = "mousedelta"; >;
uniform float2 mouse_point < source = "mousepoint"; >;
uniform bool overlay_open < source = "overlay_open"; >;

/////////////////////////////////////////////
//BLUE NOISE
/////////////////////////////////////////////

#define NoiseScale float2(12.9898, 78.2330)		//12.9898, 78.2330
#define NoiseStrength (20000)	   					//43758.5453
#define BlendFactor (1/9.0)						//0.5/9.0
#define ScaleFactor (1.5)							//2.1
#define BiasFactor (0.3) 							//0.5

// Blue Noise: https://www.shadertoy.com/view/7sGBzW
#define HASH(p) (sin(dot(p, NoiseScale + frametime)) * NoiseStrength - floor(sin(dot(p, NoiseScale + frametime)) * NoiseStrength))
#define BlueNoise(p) ( \
	( \
	(  HASH(p+float2(-1,-1)) + HASH(p+float2(0,-1)) + HASH(p+float2(1,-1))  \
	+ HASH(p+float2(-1, 0)) - 8.* HASH( p )      + HASH(p+float2(1, 0))  \
	+ HASH(p+float2(-1, 1)) + HASH(p+float2(0, 1)) + HASH(p+float2(1, 1))  \
	) * BlendFactor * ScaleFactor + BiasFactor )

/////////////////////////////////////////////
//STATIC CONST
/////////////////////////////////////////////

static const float sRGB_max_nits = 80.f;
static const float ReferenceWhiteNits_BT2408 = 203.f;
static const float sourceHDRWhitepoint = 80.f / sRGB_max_nits;
static const float HDR10_max_nits = 10000.f;
static const float mid_gray = 0.18f;

static const float PQ_constant_N = (2610.0 / 4096.0 / 4.0);
static const float PQ_constant_M = (2523.0 / 4096.0 * 128.0);
static const float PQ_constant_C1 = (3424.0 / 4096.0);
static const float PQ_constant_C2 = (2413.0 / 4096.0 * 32.0);
static const float PQ_constant_C3 = (2392.0 / 4096.0 * 32.0);
static const float PQMaxWhitePoint = HDR10_max_nits / sRGB_max_nits;

static const float3 BT2020_PrimaryRed = float3(0.6300, 0.3400, 0.0300);
static const float3 BT2020_PrimaryGreen = float3(0.3300, 0.6000, 0.0800);
static const float3 BT2020_PrimaryBlue = float3(0.1500, 0.0600, 1.0000);
static const float3 BT2020_WhitePoint = float3(0.3127, 0.3290, 0.3583);

/////////////////////////////////////////////
//STATIC CONST - GAUSSIAN KERNELS
/////////////////////////////////////////////

static const float Weights5[5] =
{
  0.0613595978134402,
  0.24477019552960988,
  0.38774041331389975,
  0.24477019552960988,
  0.0613595978134402
};

static const float Weights7[7] =
{
  0.005979789403041253,
  0.060625762867880836,
  0.2418428470867933,
  0.38310320128456915,
  0.2418428470867933,
  0.060625762867880836,
  0.005979789403041253
};

static const float Weights11[11] =
{
  0.000003381766950162007f,
  0.0002292725895775324f,
  0.005977006954929783f,
  0.0605975531721828f,
  0.24173031550285376f,
  0.38292494002701216f,
  0.24173031550285376f,
  0.0605975531721828f,
  0.005977006954929783f,
  0.0002292725895775324f,
  0.000003381766950162007f
};

static const float Weights13[13] =
{
  0.000002260003935204924f,
  0.00008615416577823069f,
  0.0016805913296610252f,
  0.016841326223814207f,
  0.08703948648194361f,
  0.23281133341733654f,
  0.3230776967550624f,
  0.23281133341733654f,
  0.08703948648194361f,
  0.016841326223814207f,
  0.0016805913296610252f,
  0.00008615416577823069f,
  0.000002260003935204924f
};

/////////////////////////////////////////////
//NAN-INF FIX
/////////////////////////////////////////////

bool IsNAN(const float input)
{
	if (isnan(input) || isinf(input))
		return true;
	else
		return false;
}

float fixNAN(const float input)
{
	if (IsNAN(input))
		return 0.f;
	else
		return input;
}

float3 fixNAN(float3 input)
{
	if (IsNAN(input.r))
		input.r = 0.f;
	else if (IsNAN(input.g))
		input.g = 0.f;
	else if (IsNAN(input.b))
		input.b = 0.f;

	return input;
}

float SafeDivide(float a, float b)
{
	return (b != 0.0f) ? a / b : 0.0f;
}

/////////////////////////////////////////////
//CONVERSIONS - LUMA
/////////////////////////////////////////////

float Luminance(float3 color, float3 lumCoeff)
{
	return dot(color, lumCoeff);
}

float sRGBToLinear(float color)
{
	const float a = 0.055f;

	[flatten]
	if (color >= 1.f || color <= 0.f)
	{
		// Nothing to do
	}
	else if (color <= 0.04045f)
		color = color / 12.92f;
	else
		color = pow((color + a) / (1.0f + a), 2.4f);

	return color;
}

float3 sRGBToLinear(float3 color)
{
	return float3(
		sRGBToLinear(color.r),
		sRGBToLinear(color.g),
		sRGBToLinear(color.b));
}

float LinearTosRGB(float channel)
{
	if (channel <= 0.0031308f)
	{
		channel = channel * 12.92f;
	}
	else
	{
		channel = 1.055f * pow(channel, 1.f / 2.4f) - 0.055f;
	}
	return channel;
}

float3 LinearTosRGB(float3 Color)
{
	return float3(LinearTosRGB(Color.r), LinearTosRGB(Color.g), LinearTosRGB(Color.b));
}

float3 LinearToPQ(float3 linearCol)
{
	linearCol /= HDR10_max_nits;

	float3 colToPow = pow(linearCol, PQ_constant_N);
	float3 numerator = PQ_constant_C1 + PQ_constant_C2 * colToPow;
	float3 denominator = 1.f + PQ_constant_C3 * colToPow;
	float3 pq = pow(numerator / denominator, PQ_constant_M);

	return pq;
}

float3 PQToLinear(float3 ST2084)
{
	float3 colToPow = pow(ST2084, 1.0f / PQ_constant_M);
	float3 numerator = max(colToPow - PQ_constant_C1, 0.f);
	float3 denominator = PQ_constant_C2 - (PQ_constant_C3 * colToPow);
	//denominator = max(denominator, 1e-10f);
	float3 linearColor = pow(numerator / denominator, 1.f / PQ_constant_N);

	linearColor *= HDR10_max_nits;

	return linearColor;
}

float RangeCompressPow(float x, float Pow)
{
	return 1.0 - pow(exp(-x), Pow);
}

float LumaCompress(float val, float MaxValue, float ShoulderStart, float Pow)
{
	float v2 = ShoulderStart + (MaxValue - ShoulderStart) * RangeCompressPow((val - ShoulderStart) / (MaxValue - ShoulderStart), Pow);
	return val <= ShoulderStart ? val : v2;
}

float3 DisplayMapColor (float3 color, float luma, float HdrMaxNits)
{
	luma = Luminance(color, lumCoeffHDR);
	float maxOutputLuminance = HdrMaxNits / sRGB_max_nits;
	float compressedHDRLuminance = LumaCompress(luma, maxOutputLuminance, maxOutputLuminance, 1);
	return color * compressedHDRLuminance / luma;
}

/////////////////////////////////////////////
//CONVERSIONS - CHROMA
/////////////////////////////////////////////

static const float3x3 XYZ_2_sRGB_MAT = float3x3(
	3.2409699419, -1.5373831776, -0.4986107603,
	-0.9692436363, 1.8759675015, 0.0415550574,
	0.0556300797, -0.2039769589, 1.0569715142);
static const float3x3 sRGB_2_XYZ_MAT = float3x3(
	0.4124564, 0.3575761, 0.1804375,
	0.2126729, 0.7151522, 0.0721750,
	0.0193339, 0.1191920, 0.9503041);
static const float3x3 XYZ_2_AP1_MAT = float3x3(
	1.6410233797, -0.3248032942, -0.2364246952,
	-0.6636628587, 1.6153315917, 0.0167563477,
	0.0117218943, -0.0082844420, 0.9883948585);
static const float3x3 AP1_2_XYZ_MAT = float3x3(
	0.6624541811, 0.1340042065, 0.1561876870,
	0.2722287168, 0.6740817658, 0.0536895174,
	-0.0055746495, 0.0040607335, 1.0103391003);
static const float3x3 D65_2_D60_CAT = float3x3(
	1.01303, 0.00610531, -0.014971,
	0.00769823, 0.998165, -0.00503203,
	-0.00284131, 0.00468516, 0.924507);
static const float3x3 D60_2_D65_CAT = float3x3(
	0.987224, -0.00611327, 0.0159533,
	-0.00759836, 1.00186, 0.00533002,
	0.00307257, -0.00509595, 1.08168);
static const float3 AP1_RGB2Y = float3(
	0.2722287168,
	0.6740817658,
	0.0536895174 );
static const float3x3 Wide_2_XYZ_MAT = float3x3(
	0.5441691, 0.2395926, 0.1666943,
	0.2394656, 0.7021530, 0.0583814,
	-0.0023439, 0.0361834, 1.0552183);
static const float3x3 BT709_2_BT2020 = float3x3(
	0.627401924722236, 0.329291971755002, 0.0433061035227622,
	0.0690954897392608, 0.919544281267395, 0.0113602289933443,
	0.0163937090881632, 0.0880281623979006, 0.895578128513936);
static const float3x3 BT2020_2_BT709 = float3x3(
	1.66049621914783, -0.587656444131135, -0.0728397750166941,
	-0.124547095586012, 1.13289510924730, -0.00834801366128445,
	-0.0181536813870718, -0.100597371685743, 1.11875105307281);

static const float3x3 XYZ_2_BT2020_MAT = float3x3(
	0.6369580483, 0.1446169032, 0.1688809751,
	0.2627002120, 0.6779980715, 0.0593017165,
	0.0000000000, 0.0280726930, 1.0609850576
);

static const float3x3 BT2020_2_XYZ_MAT = float3x3(
	1.71665118797126, -0.355670783776392, -0.253366281373659,
	-0.666684351832489, 1.61648123663494, 0.015768545813911,
	0.0176398574453105, -0.0427706132578086, 0.942103121235473
);

static const float3x3 AP1_2_BT2020_MAT = float3x3(
	1.6410233797, -0.3248032942, -0.2364246952,
	-0.6636628587, 1.6153315917, 0.0167563477,
	0.0117218943, -0.0082844420, 0.9883948585
);

static const float3x3 BT2020_2_AP1_MAT = float3x3(
	0.6624541811, 0.1340042065, 0.1561876870,
	0.2722287168, 0.6740817658, 0.0536895174,
	-0.0055746495, 0.0040607335, 1.0103391003
);

/////////////////////////////////////////////
//CONVERSIONS - CHROMA (FUNCTIONS)
/////////////////////////////////////////////

float3 XYZ_2_sRGB_MAT(float3 color)
{
	return mul(XYZ_2_sRGB_MAT, color);
}
float3 sRGB_2_XYZ_MAT(float3 color)
{
	return mul(sRGB_2_XYZ_MAT, color);
}


float3 XYZ_2_AP1_MAT(float3 color)
{
	return mul(XYZ_2_AP1_MAT, color);
}
float3 AP1_2_XYZ_MAT(float3 color)
{
	return mul(AP1_2_XYZ_MAT, color);
}


float3 BT709_2_BT2020(float3 color)
{
	return mul(BT709_2_BT2020, color);
}
float3 BT2020_2_BT709(float3 color)
{
	return mul(BT2020_2_BT709, color);
}


float3 XYZ_2_BT2020_MAT(float3 color)
{
	return mul(XYZ_2_BT2020_MAT, color);
}
float3 BT2020_2_XYZ_MAT(float3 color)
{
	return mul(BT2020_2_XYZ_MAT, color);
}


float3 AP1_2_BT2020_MAT(float3 color)
{
	return mul(AP1_2_BT2020_MAT, color);
}
float3 BT2020_2_AP1_MAT(float3 color)
{
	return mul(BT2020_2_AP1_MAT, color);
}

/////////////////////////////////////////////
//OKLAB
/////////////////////////////////////////////

float3 RGBToOKLab(float3 c)
{
	float l = (0.4122214708f * c.r) + (0.5363325363f * c.g) + (0.0514459929f * c.b);
	float m = (0.2119034982f * c.r) + (0.6806995451f * c.g) + (0.1073969566f * c.b);
	float s = (0.0883024619f * c.r) + (0.2817188376f * c.g) + (0.6299787005f * c.b);

	float l_ = pow(abs(l), 1.f / 3.f) * sign(l);
	float m_ = pow(abs(m), 1.f / 3.f) * sign(m);
	float s_ = pow(abs(s), 1.f / 3.f) * sign(s);

	return float3(
		(0.2104542553f * l_) + (0.7936177850f * m_) - (0.0040720468f * s_),
		(1.9779984951f * l_) - (2.4285922050f * m_) + (0.4505937099f * s_),
		(0.0259040371f * l_) + (0.7827717662f * m_) - (0.8086757660f * s_)
	);
}

float3 OKLabToRGB(float3 c)
{
	float l_ = c.x + 0.3963377774f * c.y + 0.2158037573f * c.z;
	float m_ = c.x - 0.1055613458f * c.y - 0.0638541728f * c.z;
	float s_ = c.x - 0.0894841775f * c.y - 1.2914855480f * c.z;

	float l = l_*l_*l_;
	float m = m_*m_*m_;
	float s = s_*s_*s_;

	float3 rgb;
	rgb.r = + 4.0767245293f*l - 3.3072168827f*m + 0.2307590544f*s;
	rgb.g = - 1.2681437731f*l + 2.6093323231f*m - 0.3411344290f*s;
	rgb.b = - 0.0041119885f*l - 0.7034763098f*m + 1.7068625689f*s;
	return rgb;
}

float3 oklab_to_oklch(float3 lab) {
	float L = lab[0];
	float a = lab[1];
	float b = lab[2];
	return float3(
		L,
		sqrt((a*a) + (b*b)),
		atan2(b, a)
	);
}

float3 oklch_to_oklab(float3 lch) {
	float L = lch[0];
	float C = lch[1];
	float h = lch[2];
	return float3(
		L,
		C * cos(h),
		C * sin(h)
	);
}

float3 oklch_to_linear_srgb(float3 lch) {
	return OKLabToRGB(
			oklch_to_oklab(lch)
	);
}

float3 linear_srgb_to_oklch(float3 rgb) {
	return oklab_to_oklch(
		RGBToOKLab(rgb)
	);
}

/////////////////////////////////////////////
//MISC - FUNCTIONS
/////////////////////////////////////////////

float2 GetResolution()
{
	return float2(BUFFER_WIDTH, BUFFER_HEIGHT);
}

float2 GetPixelSize()
{
	return float2(BUFFER_RCP_WIDTH, BUFFER_RCP_HEIGHT);
}

float GetAspectRatio()
{
	return BUFFER_WIDTH * BUFFER_RCP_HEIGHT;
}

float4 GetScreenParams()
{
	return float4(GetResolution(), GetPixelSize());
}

float AngleBetween(float2 v1, float2 v2)
{
	return acos(dot(normalize(v1), normalize(v2)));
}

float AverageValue(float3 Color)
{
	return dot(Color, float3(1.f / 3.f, 1.f / 3.f, 1.f / 3.f));
}

float2 ProjectOnto(float2 a, float2 b)
{
	return dot(a, b) / dot(b, b) * b;
}

/////////////////////////////////////////////
//MISC - BLURS
/////////////////////////////////////////////

float4 BoxBlur(sampler s, float2 uv, float blurSize, int DownsampleAmount)
{
	float4 color = float4(0.0, 0.0, 0.0, 0.0);
	int samples = 3; // Number of samples in each direction (total samples will be (2*samples + 1)^2)

	for (int x = -samples; x <= samples; ++x)
	{
		for (int y = -samples; y <= samples; ++y)
		{
			float2 offset = float2(x, y) * GetPixelSize() * DownsampleAmount * blurSize;
			color += tex2D(s, uv + offset);
		}
	}

	// Average the accumulated color
	float sampleCount = (2 * samples + 1) * (2 * samples + 1);
	return color / sampleCount;
}

float4 CircularBlur(sampler s, float2 uv, float blurSize, int sampleCount, int DownsampleAmount)
{
	float4 color = float4(0.0, 0.0, 0.0, 0.0);
	float radius = blurSize;
	float sampleAngle = 2.0 * 3.14159265359 / sampleCount; // Divide circle into equal segments

	for (int i = 0; i < sampleCount; ++i)
	{
		float angle = sampleAngle * i;
		float2 offset = float2(cos(angle), sin(angle)) * radius * GetPixelSize() * DownsampleAmount;
		color += tex2D(s, uv + offset);
	}

	return color / sampleCount;
}

float GaussianSimple(float x, float sigma)
{
	return exp(-0.5 * (x * x) / (sigma * sigma)) / (sigma * sqrt(2.0 * 3.14159265358979323846));
}

/////////////////////////////////////////////
//MISC - Depth
/////////////////////////////////////////////

float GetLinearizedDepth(sampler depthSampler, float2 texcoord)
{
	float depth = 0.0;

	// Adjust texcoord for potential shader settings
	#if RESHADE_DEPTH_INPUT_IS_UPSIDE_DOWN
		texcoord.y = 1.0 - texcoord.y;
	#endif
	texcoord.x /= RESHADE_DEPTH_INPUT_X_SCALE;
	texcoord.y /= RESHADE_DEPTH_INPUT_Y_SCALE;
	#if RESHADE_DEPTH_INPUT_X_PIXEL_OFFSET
		texcoord.x -= RESHADE_DEPTH_INPUT_X_PIXEL_OFFSET * BUFFER_RCP_WIDTH;
	#else
		texcoord.x -= RESHADE_DEPTH_INPUT_X_OFFSET / 2.000000001;
	#endif
	#if RESHADE_DEPTH_INPUT_Y_PIXEL_OFFSET
		texcoord.y += RESHADE_DEPTH_INPUT_Y_PIXEL_OFFSET * BUFFER_RCP_HEIGHT;
	#else
		texcoord.y += RESHADE_DEPTH_INPUT_Y_OFFSET / 2.000000001;
	#endif

	// Sample depth from the provided sampler
	depth = tex2Dlod(depthSampler, float4(texcoord, 0, 0)).x * RESHADE_DEPTH_MULTIPLIER;

	// Apply depth transformations based on shader settings
	#if RESHADE_DEPTH_INPUT_IS_LOGARITHMIC
		static const float C = 0.01;
		depth = (exp(depth * LOG(C + 1.0)) - 1.0) / C;
	#endif
	#if RESHADE_DEPTH_INPUT_IS_REVERSED
		depth = 1.0 - depth;
	#endif

	// Linearize depth value
	static const float N = 1.0;
	depth /= RESHADE_DEPTH_LINEARIZATION_FAR_PLANE - depth * (RESHADE_DEPTH_LINEARIZATION_FAR_PLANE - N);

	// Clamp the depth value to ensure it's within the valid range [0, 1]
	return saturate(depth);
}

/////////////////////////////////////////////
//SATURATION - CONVERSIONS
/////////////////////////////////////////////

float HuetoRGB(float p, float q, float t)
{
	if (t < 0.0f) t += 1.0f;
	if (t > 1.0f) t -= 1.0f;
	if (t < 1.0f / 6.0f) return p + (q - p) * 6.0f * t;
	if (t < 1.0f / 2.0f) return q;
	if (t < 2.0f / 3.0f) return p + (q - p) * (2.0f / 3.0f - t) * 6.0f;
	return p;
}

float3 RGBtoHSL(float3 color)
{
	float max = MAXRGB(color);
	float min = MINRGB(color);
	float delta = max - min;
	float h = 0.0f;
	float s = 0.0f;
	float l = (max + min) * 0.5f;

	if (delta > 0.0f)
	{
		s = SafeDivide(delta, (l < 0.5f ? (max + min) : (2.0f - max - min)));
		if (color.r == max)
			h = SafeDivide((color.g - color.b), delta) + (color.g < color.b ? 6.0f : 0.0f);
		else if (color.g == max)
			h = SafeDivide((color.b - color.r), delta) + 2.0f;
		else
			h = SafeDivide((color.r - color.g), delta) + 4.0f;
		h /= 6.0f;
	}

	return float3(h, s, l);
}

float3 HSLtoRGB(float3 hsl)
{
	float h = hsl.x;
	float s = hsl.y;
	float l = hsl.z;

	float r, g, b;

	if (s == 0.0f)
	{
		r = g = b = l; // achromatic
	}
	else
	{
		float q = l < 0.5f ? l * (1.0f + s) : l + s - l * s;
		float p = 2.0f * l - q;
		r = HuetoRGB(p, q, h + 1.0f / 3.0f);
		g = HuetoRGB(p, q, h);
		b = HuetoRGB(p, q, h - 1.0f / 3.0f);
	}

	return float3(r, g, b);
}

float3 RGBtoHSV(float3 color)
{
	float max = MAXRGB(color);
	float min = MINRGB(color);
	float delta = max - min;
	float h = 0.0f;
	float s = (max == 0.0f) ? 0.0f : delta / max;
	float v = max;

	if (delta != 0.0f)
	{
		if (color.r == max)
			h = (color.g - color.b) / delta + (color.g < color.b ? 6.0f : 0.0f);
		else if (color.g == max)
			h = (color.b - color.r) / delta + 2.0f;
		else
			h = (color.r - color.g) / delta + 4.0f;
		h /= 6.0f;
	}

	return float3(h, s, v);
}

float3 HSVtoRGB(float3 hsv)
{
	float h = hsv.x * 6.0f;
	float s = hsv.y;
	float v = hsv.z;

	int i = (int)floor(h);
	float f = h - i;
	float p = v * (1.0f - s);
	float q = v * (1.0f - s * f);
	float t = v * (1.0f - s * (1.0f - f));

	float3 rgb;
	switch (i % 6)
	{
		case 0: rgb = float3(v, t, p); break;
		case 1: rgb = float3(q, v, p); break;
		case 2: rgb = float3(p, v, t); break;
		case 3: rgb = float3(p, q, v); break;
		case 4: rgb = float3(t, p, v); break;
		case 5: rgb = float3(v, p, q); break;
	}

	return rgb;
}

float3 RGBtoHSI(float3 color)
{
	float r = color.r;
	float g = color.g;
	float b = color.b;

	float num = 0.5 * ((r - g) + (r - b));
	float den = sqrt((r - g) * (r - g) + (r - b) * (g - b));
	float h = acos(num / max(den, 0.00001));

	if (b > g) h = 2.0 * 3.14159 - h;
	h /= 2.0 * 3.14159;

	float sum = r + g + b;
	float intensity = sum / 3.0;
	float minRGB = MIN3(r, g, b);
	float saturation = 1.0 - (3.0 / sum) * minRGB;

	return float3(h, saturation, intensity);
}

float3 HSItoRGB(float3 hsi)
{
	float h = hsi.x * 2.0 * 3.14159;
	float s = hsi.y;
	float i = hsi.z;

	float r, g, b;

	if (h < 2.0 * 3.14159 / 3.0)
	{
		b = i * (1.0 - s);
		r = i * (1.0 + s * cos(h) / cos(3.14159 / 3.0 - h));
		g = 3.0 * i - (r + b);
	}
	else if (h < 4.0 * 3.14159 / 3.0)
	{
		h = h - 2.0 * 3.14159 / 3.0;
		r = i * (1.0 - s);
		g = i * (1.0 + s * cos(h) / cos(3.14159 / 3.0 - h));
		b = 3.0 * i - (r + g);
	}
	else
	{
		h = h - 4.0 * 3.14159 / 3.0;
		g = i * (1.0 - s);
		b = i * (1.0 + s * cos(h) / cos(3.14159 / 3.0 - h));
		r = 3.0 * i - (g + b);
	}

	return float3(r, g, b);
}

float3 RGBtoYUV(float3 color)
{
	float3 yuv;
	yuv.x = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
	yuv.y = -0.14713 * color.r - 0.28886 * color.g + 0.436 * color.b;
	yuv.z = 0.615 * color.r - 0.51499 * color.g - 0.10001 * color.b;
	return yuv;
}

float3 YUVtoRGB(float3 yuv)
{
	float3 rgb;
	rgb.r = yuv.x + 1.13983 * yuv.z;
	rgb.g = yuv.x - 0.39465 * yuv.y - 0.58060 * yuv.z;
	rgb.b = yuv.x + 2.03211 * yuv.y;
	return rgb;
}

/////////////////////////////////////////////
//SATURATION - FUNCTIONS
/////////////////////////////////////////////

float3 LumaSaturation(float3 color, float amount)
{
	float luminanceHDR = Luminance(color, lumCoeffHDR);
	return lerp(luminanceHDR, color, amount);
}

float3 HSLSaturation(float3 color, float amount)
{
	float3 hsl = RGBtoHSL(color.rgb);
	hsl.y *= amount;
	return HSLtoRGB(hsl);
}

float3 HSVSaturation(float3 color, float amount)
{
	float maxVal = MAXRGB(color);
	float3 hsv = RGBtoHSV(color.rgb);
	hsv.y *= amount;
	float3 hsvProcessed = HSVtoRGB(hsv);
	return max(HSVtoRGB(hsv), 0.0 - maxVal);
}

float3 HSISaturation(float3 color, float amount)
{
	float3 hsi = RGBtoHSI(color.rgb);
	hsi.y *= amount;
	return HSItoRGB(hsi);
}

float3 YUVSaturation(float3 color, float amount)
{
	float3 yuv = RGBtoYUV(color.rgb);
	yuv.yz *= amount;
	return YUVtoRGB(yuv);
}

float3 AverageSaturation(float3 color, float amount)
{
	float avg = (color.r + color.g + color.b) / 3.0f;
	return lerp(avg.xxx, color.rgb, amount);
}

float3 MaxSaturation(float3 color, float amount)
{
	float maxVal = MAXRGB(color);
	return max(lerp(maxVal.xxx, color.rgb, amount), 0.0 - maxVal);
}

float3 ColorfulnessSaturation(float3 color, float amount)
{
	float maxVal = MAXRGB(color);
	float minVal = MINRGB(color);
	float chroma = maxVal - minVal;
	float3 adjustedColor = max(lerp(chroma, color, amount), 0.0 - maxVal);

	return adjustedColor;
}

float3 VibranceSaturation(float3 color, float amount)
{
	float luminanceHDR = Luminance(color, lumCoeffHDR);
	float maxVal = MAXRGB(color);
	float minVal = MINRGB(color);
	float chroma = sign((maxVal - minVal) * (-1.0));
	return lerp(luminanceHDR.xxx, color, amount -1.0 - chroma);
}

float3 AdaptiveSaturation(float3 color, float amount)
{
	float luminanceHDR = Luminance(color, lumCoeffHDR);
	float3 gray = float3(luminanceHDR, luminanceHDR, luminanceHDR);
	float3 colorDiff = color - gray;
	float initialSaturation = length(colorDiff) / max(luminanceHDR, 1e-5);
	float modulation = smoothstep(0.0, 1.0, initialSaturation);
	float factor = 1.0 + (amount - 1.0) * (modulation);

	return lerp(gray, color, factor);
}

float3 OKLABSaturation(float3 color, float amount)
{
	float3 oklab = RGBToOKLab(color);
	float3 oklch = oklab_to_oklch(oklab);
	oklch.y *= amount;
	oklab = oklch_to_oklab(oklch);
	return OKLabToRGB(oklab);
}

float3 ExpandGamut(float3 HDRColor, float ExpandGamut)
{
	const float3x3 sRGB_2_AP1 = mul(XYZ_2_AP1_MAT, mul(D65_2_D60_CAT, sRGB_2_XYZ_MAT));
	const float3x3 AP1_2_sRGB = mul(XYZ_2_sRGB_MAT, mul(D60_2_D65_CAT, AP1_2_XYZ_MAT));
	const float3x3 Wide_2_AP1 = mul(XYZ_2_AP1_MAT, Wide_2_XYZ_MAT);
	const float3x3 ExpandMat = mul(Wide_2_AP1, AP1_2_sRGB);

	float3 ColorAP1 = mul(sRGB_2_AP1, HDRColor);

	float LumaAP1 = dot(ColorAP1, AP1_RGB2Y);
	if (LumaAP1 <= 0.f)
	{
		return HDRColor;
	}
	float3 ChromaAP1 = ColorAP1 / LumaAP1;

	float ChromaDistSqr = dot(ChromaAP1 - 1, ChromaAP1 - 1);
	//float ExpandAmount = (1 - exp2(-4 * ChromaDistSqr)) * (1 - exp2(-4 * ExpandGamut * LumaAP1 * LumaAP1));
	float ExpandAmount = (1 - exp2(-1 * ChromaDistSqr)) * (1 - exp2(-1 * ExpandGamut * LumaAP1));

	float3 ColorExpand = mul(ExpandMat, mul(LumaAP1, ChromaAP1));
	ColorAP1 = lerp(ColorAP1, ColorExpand, ExpandAmount);

	HDRColor = mul(AP1_2_sRGB, ColorAP1);
	return HDRColor;
}

/////////////////////////////////////////////
//TMOs
/////////////////////////////////////////////

//ACES
float3 ACES(float3 color)
{
	float a = 2.51f;
	float b = 0.03f;
	float c = 2.43f;
	float d = 0.59f;
	float e = 0.14f;

	return (color * ((a * color) + b)) / (color * ((c * color) + d) + e);
}

float3 ACES_Inverse(float3 color)
{
	float a = 2.51f;
	float b = 0.03f;
	float c = 2.43f;
	float d = 0.59f;
	float e = 0.14f;

	color = saturate(color);
	float3 fixed_numerator = (-d * color) + b;
	float3 variable_numerator_part1 = (d * color) - b;
	float3 variable_numerator = sqrt((variable_numerator_part1 * variable_numerator_part1) - (4.f * e * color * ((c * color) - a)));
	float3 denominator = 2.f * ((c * color) - a);
	float3 result1 = (fixed_numerator + variable_numerator) / denominator;
	float3 result2 = (fixed_numerator - variable_numerator) / denominator;
	color = max(result1, result2);
	return color;
}

//Reinhard
float3 Reinhard_Inverse(float3 color)
{
	return (color * (1.0 + color)) / (1.0 + color / (HDR10_max_nits * HDR10_max_nits));
}

//Hybrid Log-Gamma
float3 HLG_Inverse(float3 color)
{
	float a = 0.17883277;
	float b = 0.28466892;
	float c = 0.55991073;

	float3 x = color;
	float3 y = pow((a * x + b), 1.0 / c);

	return y;
}

//BT2390
float3 BT2390_Inverse(float3 color)
{
	float a = 0.17883277;
	float b = 0.28466892;
	float c = 0.55991073;

	color = max(color, 0.0);
	float3 x = color;
	return (pow(x, 1.0/2.4) * (c * x + b) / (c * x + a));
}