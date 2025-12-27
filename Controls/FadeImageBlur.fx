// Gaussian blur shader for WPF ShaderEffect
// Compile: fxc /T ps_3_0 /E main /Fo FadeImageBlur.ps FadeImageBlur.fx

sampler2D input : register(s0);
float2 texelSize : register(c0);      // 1.0 / texture size
float blurRadius : register(c1);      // Blur radius (matches WPF BlurEffect.Radius)
float2 sourceSize : register(c2);      // Source image size
float2 targetSize : register(c3);      // Target display size

float4 main(float2 uv : TEXCOORD) : COLOR
{
    if (blurRadius <= 0.01)
        return tex2D(input, uv);

    float sigma = blurRadius / 3.2;    // Matches WPF BlurEffect
    float twoSigmaSq = 2.0 * sigma * sigma;
    const int radius = 24;             // 49×49 = 2401 taps max

    float4 color = 0.0;
    float totalWeight = 0.0;

    for (int x = -radius; x <= radius; ++x)
    {
        for (int y = -radius; y <= radius; ++y)
        {
            float2 offs = float2(x, y);
            float distSq = dot(offs, offs);
            float weight = exp(-distSq / twoSigmaSq);
            float2 sampleUV = uv + offs * texelSize;

            color += tex2D(input, sampleUV) * weight;
            totalWeight += weight;
        }
    }

    return totalWeight > 0.00001 ? color / totalWeight : float4(0, 0, 0, 0);
}
