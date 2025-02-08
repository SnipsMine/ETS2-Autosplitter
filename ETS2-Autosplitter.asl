state("eurotrucks2")
{

}

state("amtrucks")
{
	
}

init
{	
	vars.pauzed = false;
	vars.isBlack = false;
	vars.old_loading = false;
	vars.new_loading = false;
	vars.loadTime  = new DateTime(1,1,1);
	
	vars.start_time = null;
	vars.old_time = null;
	vars.time = null;
	
	vars.seconds = null;
	vars.pref_time = null;
	vars.game_seconds = null;
	
	vars.scale = 0;
		
}

startup{
	
	refreshRate = 120;
	
	settings.Add("loadRemoval", true, "Remove load times");
	settings.SetToolTip("loadRemoval", "Removes the load times from the game");
	
	settings.Add("igt", false, "In game time");
	settings.SetToolTip("igt", "If checked uncheck the load time remover and check Start to make this work\nWhen checked the timer will automatically start when the IGT changes, the time elapsed in game will be displayed on the game time timer.");
	
	settings.Add("realSeconds", false, "Real time seconds", "igt");
	settings.SetToolTip("realSeconds", "When checked the real time seconds per minute will be used. Else the approximation of  the IGT seconds will be used.");

}

update{
	DateTime start = DateTime.Now;
	string[]  file_names = {"Local\\SimTelemetrySCS", "Local\\SCSTelemetry"};
	int file_size = 16 * 1024;

	// Assumes another process has created the memory-mapped file.
	// MemoryMappedFile created by: https://github.com/RenCloud/scs-sdk-plugin
	foreach (string file_name in file_names)
	{
		try
		{
			using (var mmf = System.IO.MemoryMappedFiles.MemoryMappedFile.OpenExisting(file_name))
			{
				using (var accessor = mmf.CreateViewAccessor(0, file_size))
				{
					bool pauzed;
					accessor.Read(4, out pauzed);
					vars.pauzed = pauzed;
					
					
					uint time;
					accessor.Read(64, out time);
					if (settings["igt"]){
						int year = (int)(time/525948.766)+1;
						int month = (int)(time/43829.0639)+1;
						int day = (int)(time/1440) +1;
						int hour = (int)(time/60);
						int minute = (int)(time);

						print("Year: " + year + ", Month: " + (month - (year - 1) * 12 )+ ", day: " + (int)(day - (month - 1) * 30.4368499) +", hour: " + (hour - (day-1) * 24 ) + ", minute: " + (minute - (hour) * 60) );

						vars.old_time = vars.time;
						vars.time = new DateTime(year,  month - (year - 1) * 12 , (int)(day - (month - 1) * 30.4368499), hour - (day-1) * 24 , minute - (hour) * 60, 00);
					}
					float scale;
					accessor.Read(700, out scale);
					vars.scale = scale;
				}
			}
		}catch(FileNotFoundException e){
			print("file " + file_name + " does not exist");
		}
	}
	DateTime end = DateTime.Now;
	//print("Time Update: " + (end-start).ToString());
}

start{
	if (settings["igt"]) {  
		vars.start_time = vars.time;
		vars.seconds = DateTime.Now;
		vars.game_seconds = new TimeSpan(0, 0, 0);
		
		if (vars.old_time < vars.time){
			return true;
		}
	}
}

gameTime{
	if(settings["igt"]){
		DateTime start = DateTime.Now;
		TimeSpan gametime  = (DateTime) vars.time - (DateTime) vars.start_time;
		
		if (vars.old_time < vars.time){
			vars.game_seconds = new TimeSpan(0, 0, 0);
			if (settings["realSeconds"]) {  
				vars.seconds = DateTime.Now;
			}
			return gametime;
			
		}else{
			if (settings["realSeconds"]) { 
			    	if (vars.pauzed == false){
					return  gametime + (DateTime.Now - vars.seconds);
				}
			}else{
				DateTime start2 = DateTime.Now;
				vars.pref_time = vars.seconds;
				vars.seconds = DateTime.Now;
				print("Total time between runs: " + (vars.seconds - vars.pref_time).ToString());
				//TimeSpan game_seconds = TimeSpan.FromTicks(Convert.ToInt64(vars.scale * (vars.seconds - vars.pref_time).Ticks) + 1) ;
				//vars.game_seconds += game_seconds;
				DateTime end = DateTime.Now;
				
				//print("Time gametime: " + (end-start).ToString() + ", Time calculate seconds: " + (end-start2).ToString());
				return  gametime /*+ vars.game_seconds*/;
			}
		}
	}
}

split{
	if (vars.old_loading == true && vars.new_loading == false && (DateTime.Now - (DateTime) vars.loadTime).Seconds > 1){
	
		return true;
	}
}

isLoading
{
	DateTime start = DateTime.Now;
	if (settings["loadRemoval"]) {  
		System.Drawing.Bitmap bmp = new System.Drawing.Bitmap(100, 100);
		
		int x = 80;
		int y = 80;
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
		
		DateTime end = DateTime.Now;
		//print("Time isLoading: " + (end-start).ToString());

		if(vars.pauzed == true && vars.isBlack == true)	
		{
			vars.old_loading = vars.new_loading;
			vars.new_loading = true;
			if (vars.old_loading == false){
				vars.loadTime = DateTime.Now;
			}
			return true;
		}else{
			vars.old_loading = vars.new_loading;
			vars.new_loading = false;
			return false;
		}	
	}else{
		DateTime end = DateTime.Now;
		//print("Time isLoading: " + (end-start).ToString());
		return true;
	}
	
}
