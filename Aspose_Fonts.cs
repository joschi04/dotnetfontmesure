using System.Diagnostics;
using System.IO;
using Aspose.Imaging;



public class AsposeTest
{
    public static void Run()
    {
        
        
        using (var backgoundImage = Image.Load("./Logo_Datev.png"))
        {
            Graphics gr = new Graphics(backgoundImage);
            var format = new StringFormat();
            System.Console.WriteLine("DefaultFont: " + FontSettings.DefaultFontName);
            var size = gr.MeasureString("Test", new Font(FontSettings.DefaultFontName,10), SizeF.Empty, format);
            
            System.Console.WriteLine("Size.Width = " + size.Width); // Should be 31.15668f +/- 1.0f
            System.Console.WriteLine("Size.Height = " + size.Height); // Should be 16.5625f +/- 1.0f
        }
    }
}