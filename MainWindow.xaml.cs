using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using Microsoft.Win32;

namespace PlayShadeTest
{
    /// <summary>
    /// Simple test window for shader blur - minimal WPF setup
    /// </summary>
    public partial class MainWindow : Window
    {
        private FadeImageBlurEffect blurEffect;

        public MainWindow()
        {
            InitializeComponent();

            // Create blur effect
            blurEffect = new FadeImageBlurEffect
            {
                BlurRadius = 20
            };
            TestImage.Effect = blurEffect;

            // Setup slider
            BlurSlider.ValueChanged += (s, e) =>
            {
                var value = (int)BlurSlider.Value;
                BlurValueText.Text = $"Blur: {value}";
                blurEffect.BlurRadius = value;
            };

            // Update texel size when image loads
            TestImage.Loaded += (s, e) =>
            {
                UpdateTexelSize();
            };
        }

        private void LoadImageButton_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new OpenFileDialog
            {
                Filter = "Image Files|*.jpg;*.jpeg;*.png;*.bmp;*.gif|All Files|*.*",
                Title = "Select Image"
            };

            if (dialog.ShowDialog() == true)
            {
                try
                {
                    var bitmap = new BitmapImage();
                    bitmap.BeginInit();
                    bitmap.CacheOption = BitmapCacheOption.OnLoad;
                    bitmap.UriSource = new Uri(dialog.FileName);
                    bitmap.EndInit();
                    bitmap.Freeze();

                    TestImage.Source = bitmap;
                    UpdateTexelSize();
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Error loading image: {ex.Message}", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                }
            }
        }

        private void UpdateTexelSize()
        {
            if (TestImage.Source is BitmapSource bitmap && blurEffect != null)
            {
                blurEffect.TexelSize = new System.Windows.Point(1.0 / bitmap.PixelWidth, 1.0 / bitmap.PixelHeight);
            }
        }
    }
}
