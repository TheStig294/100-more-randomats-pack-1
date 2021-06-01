AddCSLuaFile()

if SERVER then
	resource.AddWorkshop( "2122924789" )
  end

sound.Add( {
	name = "donc_fire",
	channel = 19,
	volume = 1.0,
	level = 90,
	pitch = { 95, 110 },
	sound = "donc/donc.mp3"
} )

sound.Add( {
	name = "donc_rubber_01",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 150,
	sound = "donc/donc_rubber_01.mp3"
} )
sound.Add( {
	name = "donc_rubber_02",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 150,
	sound = "donc/donc_rubber_02.mp3"
} )

sound.Add( {
	name = "donc_rubber_03",
	channel = CHAN_AUTO,
	volume = 1.0,
	level = 150,
	sound = "donc/donc_rubber_03.mp3"
} )


