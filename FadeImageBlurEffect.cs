using System;
using System.Windows;
using System.Windows.Media;
using System.Windows.Media.Effects;
using System.Windows.Media.Media3D;

namespace PlayShadeTest
{
    public class FadeImageBlurEffect : ShaderEffect
    {
        private static PixelShader _pixelShader;

        static FadeImageBlurEffect()
        {
            try
            {
                _pixelShader = new PixelShader();
                _pixelShader.UriSource = new Uri(
                    "pack://application:,,,/PlayShadeTest;component/Controls/FadeImageBlur.ps",
                    UriKind.Absolute);
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"FadeImageBlur: Failed to load shader: {ex.Message}");
            }
        }

        public FadeImageBlurEffect()
        {
            if (_pixelShader != null)
            {
                PixelShader = _pixelShader;
                UpdateShaderValue(InputProperty);
                UpdateShaderValue(TexelSizeProperty);
                UpdateShaderValue(BlurRadiusConstantProperty);
                UpdatePadding();
            }
        }
        
        private void UpdatePadding()
        {
            double padding = BlurRadius;
            PaddingBottom = padding;
            PaddingLeft = padding;
            PaddingRight = padding;
            PaddingTop = padding;
        }

        public static readonly DependencyProperty InputProperty =
            ShaderEffect.RegisterPixelShaderSamplerProperty("Input",
                typeof(FadeImageBlurEffect), 0);

        public Brush Input
        {
            get { return (Brush)GetValue(InputProperty); }
            set { SetValue(InputProperty, value); }
        }

        public static readonly DependencyProperty TexelSizeProperty =
            DependencyProperty.Register("TexelSize", typeof(Point),
                typeof(FadeImageBlurEffect),
                new UIPropertyMetadata(new Point(0.001, 0.001), PixelShaderConstantCallback(0)));

        public Point TexelSize
        {
            get { return (Point)GetValue(TexelSizeProperty); }
            set { SetValue(TexelSizeProperty, value); }
        }

        public static readonly DependencyProperty BlurRadiusProperty =
            DependencyProperty.Register("BlurRadius", typeof(double),
                typeof(FadeImageBlurEffect),
                new PropertyMetadata(10.0, OnBlurRadiusChanged));
        
        private static readonly DependencyProperty BlurRadiusConstantProperty =
            DependencyProperty.Register("BlurRadiusConstant", typeof(double),
                typeof(FadeImageBlurEffect),
                new UIPropertyMetadata(10.0, PixelShaderConstantCallback(1)));

        public double BlurRadius
        {
            get { return (double)GetValue(BlurRadiusProperty); }
            set { SetValue(BlurRadiusProperty, value); }
        }
        
        private static void OnBlurRadiusChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            var effect = (FadeImageBlurEffect)d;
            effect.SetValue(BlurRadiusConstantProperty, e.NewValue);
            effect.UpdatePadding();
        }
    }
}

