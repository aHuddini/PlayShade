// Gaussian blur shader for WPF ShaderEffect - improved version
// Compile with: fxc /T ps_3_0 /E main /Fo ShaderV3.ps ShaderV3.fx

sampler2D input : register(s0);
float2 texelSize : register(c0);      // 1.0 / texture width, 1.0 / height
float blurRadius : register(c1);      // user-controlled blur amount (0–100 typical)
float2 sourceSize : register(c2);     // source image dimensions (optional)
float2 targetSize : register(c3);     // render target dimensions (optional)

float4 main(float2 uv : TEXCOORD) : COLOR
{
    // Early exit - no blur
    if (blurRadius <= 0.01)
        return tex2D(input, uv);

    // Control sigma growth to prevent fragmentation at extreme values
    // Base: roughly matches WPF BlurEffect at low–medium values
    // Cap + soft curve prevents sparse sampling artifacts
    float sigmaBase = blurRadius / 3.4;
    float sigma = min(sigmaBase, 12.0);                    // hard cap (adjust 10–15)
    sigma = sigma * (1.0 + 0.08 * saturate(sigmaBase - 12.0)); // slight extra strength

    float twoSigmaSq = 2.0 * sigma * sigma;

    float4 color       = 0.0;
    float  totalWeight = 0.0;

    // Fixed kernel size - large enough for strong blur, but not insane
    const int radius = 24;          // 49×49 = 2401 max taps

    // Weight threshold to skip near-zero contributions (saves perf + reduces noise)
    const float minWeight = 0.0004;

    [loop]
    for (int x = -radius; x <= radius; ++x)
    {
        [loop]
        for (int y = -radius; y <= radius; ++y)
        {
            float2 offs = float2(x, y);
            float distSq = dot(offs, offs);

            float weight = exp(-distSq / twoSigmaSq);

            // Skip very small weights - prevents fragmentation & saves instructions
            if (weight < minWeight)
                continue;

            float2 sampleUV = uv + offs * texelSize;

            color       += tex2D(input, sampleUV) * weight;
            totalWeight += weight;
        }
    }

    // Normalize or fallback gracefully
    if (totalWeight > 0.00001)
    {
        return color / totalWeight;
    }
    else
    {
        // Very extreme blur or numerical issue → return center pixel
        return tex2D(input, uv);
    }
}