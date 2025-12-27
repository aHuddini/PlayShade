# PlayShadeTest - Developer Guide

A standalone test application for developing and testing the FadeImageBlur shader effect.

## Project Structure

```
PlayShadeTest/
├── Controls/
│   ├── FadeImageBlur.fx      # HLSL shader source code (EDIT THIS!)
│   └── FadeImageBlur.ps      # Compiled shader (auto-generated)
├── FadeImageBlurEffect.cs    # WPF ShaderEffect wrapper
├── MainWindow.xaml            # Test window UI
├── MainWindow.xaml.cs         # Test window code-behind
├── BuildShader.ps1            # Shader compilation script
└── PlayShadeTest.csproj       # Project file
```

## Editing the Shader

### 1. Edit the Shader Source

Open `Controls/FadeImageBlur.fx` in any text editor. This is the HLSL source code.

**Key parameters you can modify:**
- `blurRadius` - Blur intensity (0-100+)
- `sigma` calculation - Controls blur spread
- `radius` - Kernel size (affects quality vs performance)
- Sampling pattern - How pixels are sampled

### 2. Compile the Shader

After editing `FadeImageBlur.fx`, compile it using:

```powershell
.\BuildShader.ps1
```

Or manually:
```bash
fxc /T ps_3_0 /E main /Fo Controls\FadeImageBlur.ps Controls\FadeImageBlur.fx
```

**Requirements:**
- Windows SDK installed
- `fxc.exe` (HLSL compiler) available in PATH or Windows Kits folder

### 3. Rebuild the Project

After compiling the shader, rebuild the project:

```bash
msbuild PlayShadeTest.csproj /p:Configuration=Release /p:Platform=AnyCPU
```

Or use Visual Studio:
1. Right-click project → Rebuild
2. The compiled `.ps` file will be embedded as a resource

### 4. Test Your Changes

Run `bin\Release\PlayShadeTest.exe` to see your changes in real-time!

## Shader Development Workflow

1. **Edit** `FadeImageBlur.fx`
2. **Compile** with `BuildShader.ps1`
3. **Rebuild** the project
4. **Test** by running the executable
5. **Repeat** until satisfied

## Shader Code Overview

### Main Function
```hlsl
float4 main(float2 uv : TEXCOORD) : COLOR
{
    // Your blur logic here
}
```

### Available Registers
- `s0` - Input texture sampler
- `c0` - Texel size (1.0 / texture width, 1.0 / texture height)
- `c1` - Blur radius
- `c2` - Source image size (reserved)
- `c3` - Target display size (reserved)

### Key Variables
- `uv` - Texture coordinates (0.0 to 1.0)
- `texelSize` - Size of one pixel in UV space
- `blurRadius` - Blur intensity parameter

## Tips for Shader Development

1. **Start Small**: Make small changes and test frequently
2. **Use Comments**: Document your changes in the shader code
3. **Test Different Images**: Try various image sizes and content
4. **Performance**: Large kernels (radius > 20) can be slow
5. **Quality**: More samples = better quality but slower performance

## Common Modifications

### Change Blur Strength
```hlsl
float sigma = blurRadius / 3.2;  // Adjust divisor (lower = stronger blur)
```

### Change Kernel Size
```hlsl
const int radius = 24;  // Increase for stronger blur, decrease for performance
```

### Add Custom Effects
```hlsl
// After blur calculation, modify the result:
color.rgb *= 1.1;  // Brightness boost
color.rgb = pow(color.rgb, 1.0/1.2);  // Gamma correction
```

## Troubleshooting

### Shader Won't Compile
- Check syntax errors in `.fx` file
- Ensure `fxc.exe` is available
- Verify shader model is `ps_3_0` (required for WPF)

### Shader Not Loading
- Ensure `.ps` file is in `Controls/` folder
- Check that `.ps` is included as Resource in project
- Verify URI in `FadeImageBlurEffect.cs` matches project name

### No Visual Changes
- Rebuild the project after compiling shader
- Check that shader compiled successfully (no errors)
- Verify blur radius slider is working

## Resources

- [HLSL Shader Reference](https://docs.microsoft.com/en-us/windows/win32/direct3dhlsl/dx-graphics-hlsl)
- [WPF ShaderEffect Documentation](https://docs.microsoft.com/en-us/dotnet/api/system.windows.media.effects.shadereffect)


## Example: Creating a Box Blur

Replace the Gaussian weight calculation with uniform weights:

```hlsl
// Instead of:
float weight = exp(-distSq / twoSigmaSq);

// Use:
float weight = 1.0;  // Uniform box blur
```

Then normalize by total samples instead of total weight.

