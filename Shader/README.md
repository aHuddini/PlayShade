# FadeImageBlur Shader

Gaussian blur shader for WPF ShaderEffect implementation.

## Files

- `FadeImageBlur.fx` - HLSL source code
- `FadeImageBlur.ps` - Compiled pixel shader (ps_3_0)

## Compilation

```bash
fxc /T ps_3_0 /E main /Fo FadeImageBlur.ps FadeImageBlur.fx
```

## Usage

Shader registers:
- `s0` - Input texture sampler
- `c0` - Texel size (1.0 / texture width, 1.0 / texture height)
- `c1` - Blur radius (matches WPF BlurEffect.Radius)
- `c2` - Source image size (reserved)
- `c3` - Target display size (reserved)

## Notes

- Shader Model 3.0 required for WPF ShaderEffect compatibility
- Fixed radius of 24 (49×49 kernel) for maximum blur support
- Weights naturally fall off beyond effective radius (3×sigma)
- Sigma calculation: `sigma = blurRadius / 3.2` (matches WPF BlurEffect)

