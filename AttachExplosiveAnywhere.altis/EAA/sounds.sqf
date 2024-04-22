class eaa_plant_sound
{
	name = "explosive plant sound";						// display name
	sound[] = { "EAA\Sounds\plantSound.ogg", 1, 1, 100 };	// file, volume, pitch, maxDistance
	titles[] = { 0, "" };			// subtitles

	titlesFont = "LCD14";		// OFP:R - titles font family
	titlesSize = 0;			// OFP:R - titles font size

	forceTitles = 0;			// Arma 3 - display titles even if global show titles option is off (1) or not (0)
	titlesStructured = 0;		// Arma 3 - treat titles as Structured Text (1) or not (0)
	soundDuration = 12;
};