# PlayShade

A repo quickly spruced up to organize the creation of shader effects for use/test in Playnite. Also includes a quick test application to test custom shader effects.

.fx files need to be first created with relevant shader code (HLSL) and then compiled with fxc to generate the final .ps file that can be used in WPF environments. Shader effects should target ps_2_0 (ps_3_0 doesn't seem to work for Playnite's WPF framework).

Currently includes a shader effect for Gaussian Blur. The blur is meant to be an alternative replacement for WPF's BlurEffect control in Playnite.

## Quick Start

1. **Run the application**
   
2. **Load an image** and adjust the blur slider to see real-time preview

## Features

- ✅ **Real-time blur preview** - Adjust blur amount with a slider and see results instantly
- ✅ **Load any image** - Test the blur effect on any image file (JPG, PNG, BMP, GIF)
- ✅ **Simple interface** - Clean, minimal UI focused on testing the blur shader
- ✅ **No dependencies** - Standalone executable, no Playnite installation required

## For Developers

See [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) for:
- How to edit the shader source code
- Shader compilation workflow
- Common modifications and examples
- Troubleshooting guide

## Building

```bash
cd source\PlayShadeTest
msbuild PlayShadeTest.csproj /p:Configuration=Release /p:Platform=AnyCPU
```

## Requirements

- .NET Framework 4.6.2
- Windows (WPF application)
- Windows SDK (for shader compilation - optional, pre-compiled shader included)

## Files

- `Controls/FadeImageBlur.fx` - HLSL shader source (edit this!)
- `Controls/FadeImageBlur.ps` - Compiled shader (auto-generated)
- `FadeImageBlurEffect.cs` - WPF ShaderEffect wrapper
- `BuildShader.ps1` - Shader compilation script

## Usage

1. Run `PlayShadeTest.exe`
2. Click "Load Image..." to select an image file
3. Use the slider to adjust blur amount (0-100)
4. See the blur effect update in real-time

Perfect for testing shader modifications and seeing results instantly!
