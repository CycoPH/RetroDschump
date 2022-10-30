using DschumpLevelEditor.Helpers;
using System;
using System.Drawing;
using System.Windows.Forms;

namespace DschumpLevelEditor
{
    public partial class AtariColorPicker : Form
    {
        private byte selectedColorIndex;
        private Color selectedColor;
        private AtariPalette myPalette;

        public AtariColorPicker(AtariPalette myPalette)
        {
            this.myPalette = myPalette;
            InitializeComponent();
        }

        public byte PickedColorIndex()
        {
            return selectedColorIndex;
        }

        public Color Pick(byte oldColorIndex)
        {
            selectedColorIndex = oldColorIndex;
            RenderPalette();
            DrawSelection(selectedColorIndex, selectedColorIndex);
            ShowDialog();
            return selectedColor;
        }

        private void RenderPalette()
        {
            var matrix = new Bitmap(128+16,256+16);
            var gr = Graphics.FromImage(matrix);
            gr.Clear(this.BackColor);
            for (var y = 0; y < 16; y++)
            {
				// Vertical marks
                gr.DrawString($"{y:X}", this.Font, new SolidBrush(ForeColor), 16 * 8 + 2, y * 16);
                for (var x = 0; x < 8; x++)
                    gr.FillRectangle(new SolidBrush(myPalette.GetColor(y * 16 + x * 2)), x * 16, y * 16, 16, 16);
            }
            gr.DrawRectangle(new Pen(new SolidBrush(Color.White)), (selectedColorIndex % 16) * 8, (selectedColorIndex / 16) * 16, 15, 15);
            
            // Horizontal marks
            for (var x = 0; x < 8; x++)
                gr.DrawString($"{(x*2):X}", this.Font, new SolidBrush(this.ForeColor), 16 * x, 16 * 16 + 2);
            // Clear the old image and set new bitmap
			pictureBox1.Image?.Dispose();
			pictureBox1.Image = matrix;
            
            gr.Dispose();
            //matrix.Dispose();
        }

        private void DrawSelection(int oldColor, int newColor)
        {
            var w = pictureBox2.Width;
            var h = pictureBox2.Height;
            labelOldCol.Text = $@"${oldColor:X2} - {oldColor}";
            labelNewCol.Text = $@"${newColor:X2} - {newColor}";
            var clr = new Bitmap(w, h);
            var gr = Graphics.FromImage(clr);
            gr.FillRectangle(new SolidBrush(myPalette.GetColor(oldColor)), 0, 0, w, h / 2);
            gr.FillRectangle(new SolidBrush(myPalette.GetColor(newColor)), 0, h / 2, w, h / 2);
            gr.Dispose();
            pictureBox2.Image?.Dispose();
            pictureBox2.Image = clr;
        }

        private void pictureBox1_Click(object sender, EventArgs e)
        {

        }

        private void pictureBox1_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                selectedColorIndex = (byte)((e.X / 16)*2 + (e.Y / 16) * 16);
                selectedColor = myPalette.GetColor(selectedColorIndex);
                this.Close();
            }
        }

        private void pictureBox1_MouseMove(object sender, MouseEventArgs e)
        {
            if (e.X < 128 && e.Y < 256)
            {
                int index = (e.X / 16)*2 + (e.Y / 16) * 16;
                DrawSelection(selectedColorIndex, index);
            }
        }
    }
}