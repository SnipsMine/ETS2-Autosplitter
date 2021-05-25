state("eurotrucks2")
{

}

init
{
		vars.pauzed = false;
		vars.isBlack = false;

}

isLoading
{
		var file_name = "Local\\SimTelemetrySCS";
		int file_size = 16 * 1024;
		
		long offset = 0x10000000; // 256 megabytes
        long length = 0x20000000; // 512 megabytes

		// Assumes another process has created the memory-mapped file.
		// MemoryMappedFile created by: https://github.com/RenCloud/scs-sdk-plugin/tree/v.1.9.0
        using (var mmf = System.IO.MemoryMappedFiles.MemoryMappedFile.OpenExisting(file_name))
        {
            using (var accessor = mmf.CreateViewAccessor(0, file_size))
            {
                bool pauzed;
				accessor.Read(4, out pauzed);
				vars.pauzed = pauzed;
			}
		}
		
		System.Drawing.Bitmap bmp = new System.Drawing.Bitmap(100, 100);
		
		int x = 0;
		int y = 0;
		System.Drawing.Rectangle bounds = new System.Drawing.Rectangle(x, y, bmp.Width, bmp.Height);
		using (System.Drawing.Graphics g = System.Drawing.Graphics.FromImage(bmp)){
		        g.CopyFromScreen(bounds.Location, System.Drawing.Point.Empty, bounds.Size);
		}
		for(x=0; x<bmp.Width; x++)
		{
			for(y=0; y<bmp.Height; y++)
			{
				System.Drawing.Color pixel = bmp.GetPixel(x,y);
				if(pixel.G == 0 && pixel.B == 0 && pixel.R == 0)
				{
					vars.isBlack = true;
				}else
				{
					vars.isBlack = false;
					break;
				}
			}
			if (vars.isBlack == false)
			{
				break;
			}
		}
		
		print("pauzed: " + vars.pauzed + ", is black: " + vars.isBlack);
		
		if(vars.pauzed == true && vars.isBlack == true)	
		{
			return true;
		}else{
			return false;
		}	
}