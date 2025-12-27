# PlayShadeTest - Quick Start Guide

## For End Users

1. **Run the app:** Double-click `bin\Release\PlayShadeTest.exe`
2. **Load an image:** Click "Load Image..." button
3. **Adjust blur:** Use the slider to see real-time blur preview
4. **Done!** That's it - simple and fast.

## For Developers

### Edit the Shader

1. **Open** `Controls/FadeImageBlur.fx` in any text editor
2. **Make changes** to the HLSL code
3. **Compile** by running: `.\BuildShader.ps1`
4. **Rebuild** the project in Visual Studio or:
   ```bash
   msbuild PlayShadeTest.csproj /p:Configuration=Release
   ```
5. **Run** `bin\Release\PlayShadeTest.exe` to see your changes!

### Workflow

```
Edit .fx → Compile → Rebuild → Test → Repeat
```

### What to Edit

The shader file (`FadeImageBlur.fx`) contains:
- **Sigma calculation** - Controls blur strength
- **Kernel radius** - Affects quality vs performance
- **Sampling pattern** - How pixels are sampled
- **Weight calculation** - Gaussian distribution

See `DEVELOPER_GUIDE.md for detailed examples.

## Project Structure

```
PlayShadeTest/
├── Controls/
│   ├── FadeImageBlur.fx    ← EDIT THIS (shader source)
│   └── FadeImageBlur.ps    ← Auto-generated (compiled shader)
├── FadeImageBlurEffect.cs  ← WPF wrapper (usually don't need to edit)
├── MainWindow.xaml          ← UI (matches Playnite test window exactly)
├── BuildShader.ps1          ← Compile script
└── DEVELOPER_GUIDE.md       ← Detailed developer documentation
```

## Requirements

- **To run:** Just Windows + .NET Framework 4.6.2
- **To compile shader:** Windows SDK (for fxc.exe)

The compiled shader is included, so you can run the app without the SDK.

## Tips

- Start with small changes
- Test frequently
- Use different images to see how blur affects various content
- Check `DEVELOPER_GUIDE.md` for examples and troubleshooting


