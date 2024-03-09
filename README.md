_This is the first of my 4 randomat packs. These randomats don't require anything else to work, they work on their own!_

# Settings/Options

_Words in italics_ are console commands.\
Press ` or ~ in a game of TTT to open the console and type in _the words in italics_ (plus a space and a number) to change this mod’s settings. \
\
Alternatively, add the italic text to your __server.cfg__ (for dedicated servers)\
or __listenserver.cfg__ (for peer-to-peer servers)\
\
For example, to turn off randomats triggering at the start of a round of TTT, type in:\
_ttt_randomat_auto 0_\
(1 = on, 0 = off)\
\
_ttt_randomat_auto_ - Default: 0 - Whether the Randomat should automatically trigger on round start.\
_ttt_randomat_auto_chance_ - Default: 1 - Chance of the auto-Randomat triggering.\
_ttt_randomat_auto_silent_ - Default: 0 - Whether the auto-started event should be silent.\
_ttt_randomat_chooseevent_ - Default: 0 - Allows you to choose out of a selection of events.\
_ttt_randomat_rebuyable_ - Default: 0 - Whether you can buy more than one Randomat.\
_ttt_randomat_event_weight_ - Default: 1 - The default selection weight each event should use.\
_ttt_randomat_event_hint_ - Default: 1 - Whether the Randomat should print what each event does when they start.\
_ttt_randomat_event_hint_chat_ - Default: 1 - Whether hints should also be put in chat.\
_ttt_randomat_event_history_ - Default: 10 - How many events should be kept in history. Events in history will are ignored when searching for a random event to start.

# Newly added randomats

1. Go home, you're drunk! - Makes everyone look drunk
1. Copycat! - Someone copies someone else's attributes!
1. Discord Sounds - Dead players can play discord sounds!
1. Borgir - Spawns "borgirs" that increase/decrease your speed

# Randomats

__Randomats that don't have credit were completely made by me__

## 100% Detective Winrate

Whoever has the highest detective winrate is turned into a detective!\
If they were a traitor, someone else is changed into a traitor.\
\
_ttt_randomat_detectivewinrate_ - Default: 1 - Whether this randomat is enabled

## ... That's Lame

Nothing happens.\
\
_ttt_randomat_lame_ - Default: 1 - Whether this randomat is enabled

Originally made by [Owningle](https://steamcommunity.com/sharedfiles/filedetails/?id=2214440295)

## ...% More Speed, Jump Height and Health for everyone

Increases speed, jump height, and current health for everyone by a set percentage\
\
_ttt_randomat_speedjumphealth_ - Default: 1 - Whether this randomat is enabled\
_randomat_speedjumphealth_multiplier_ - Default: 50 - Percent multiplier to stats

Originally made by [HagenSNKL](https://steamcommunity.com/sharedfiles/filedetails/?id=662342819)

## Back to Basics

Strips everything back to base TTT, as much as possible.

- Only the original detective/traitor items can be bought
- Everyone is changed to either a traitor, innocent or detective
- Everyone is changed to a default TTT playermodel
- All non-default weapons are replaced with default ones
- All players that had buy menu items stripped from them have credits refunded
- Sprinting and double-jumping is disabled
- Everyone can inspect bodies
- Fellow traitors are no longer highlighted with an outline around them
- The round-end window now displays the old-school highlights tab, the usual summary tab is disabled

_ttt_randomat_basics_ - Default: 1 - Whether this randomat is enabled\
_randomat_basics_sprinting_ - Default: 0 - Whether sprinting is enabled\
_randomat_basics_multi_jump_ - Default: 0 - Whether multi-jumping is enabled

## BAWK

Turns everyone's models into chickens, corpses disappear on death, a set amount of health, and everyone makes chicken noises.\
\
_ttt_randomat_chickens_ - Default: 1 - Whether this randomat is enabled\
_randomat_chickens_hp_ - Default: 60 - The HP players are set to\
_randomat_chickens_sc_ - Default: 0.25 - The fraction of size players are shrunk to\
_randomat_chickens_sp_ - Default: 0.75 - The movement speed multiplier\
\
Converted to work with randomat 2.0 rather than TTT2, added much more chicken sounds, fixed playermodels not being reset at the start of the next round, removed zombie chicken\
Originally made by [Miko0l](https://steamcommunity.com/sharedfiles/filedetails/?id=2224127289)

## Ban a Randomat

Presents 5 randomats, one of which to be banned by vote. Randomat is banned until this is triggered again.\
\
_ttt_randomat_ban_ - Default: 1 - Whether this randomat is enabled\
_randomat_ban_choices_ - Default: 5 - Number of events you can choose from to ban\
_randomat_ban_vote_ - Default: 1 - Allows all players to vote on the event\
_randomat_ban_votetimer_ - Default: 10 - How long players have to vote on the event\
_randomat_ban_deadvotes_ - Default: 1 - Allow dead people to vote\
\
Changed name from "Choose an Event!", now presents 5 choices and everyone votes by default. Bans rather than triggers the chosen randomat.\
Originally made by [Dem](https://steamcommunity.com/sharedfiles/filedetails/?id=1406495040)

## Blegh

Whenever someone dies, everyone hears a random "Blegh!" sound.\
Also gives everyone random plush sharky models, if installed: <https://steamcommunity.com/sharedfiles/filedetails/?id=2755239782>\
\
_ttt_randomat_bleghsound_ - Default: 1 - Whether this randomat is enabled

## Boing

Jump height is massively increased.\
\
_ttt_randomat_boing_ - Default: 1 - Whether this randomat is enabled\
_randomat_boing_jump_height_ - Default: 220 - Additional jump height added to players

## Boing Warp

Increases everyone's jump power over time\
\
_ttt_randomat_boingwarp_ - Default: 1 - Whether this randomat is enabled

## Boomerang Fu

Continually gives everyone boomerangs, and removes all other weapons.\
\
_ttt_randomat_boomerang_ - Default: 1 - Whether this randomat is enabled\
_randomat_boomerang_timer_ - Default: 2 - Seconds between giving boomerangs if they don't return\
_randomat_boomerang_strip_ - Default: 1 - The event strips your other weapons\
_randomat_boomerang_weaponid_ - Default: weapon_ttt_boomerang_randomat - ID of the weapon given\
\
Credits for the boomerang weapon:

- Mineotopia for creating the shop icon.
- RatchetMario for creating the boomerang model which can found in this pack\
<https://steamcommunity.com/sharedfiles/filedetails/?id=137719037>
- [TheBroomer](https://steamcommunity.com/sharedfiles/filedetails/?id=639521512) and [BocciardoLight](https://steamcommunity.com/sharedfiles/filedetails/?id=922438160) for the weapon and entity code
- Me for cleaning up code and making fixes to make it work with the randomat

## Borgir

Spawns burger props that increase/decrease your speed.\
\
_ttt_randomat_borgir_ - Default: 1 - Whether this randomat is enabled\
_randomat_borgir_count_ - Default: 2 - Number of borgir spawned per person\
_randomat_borgir_range_ - Default: 200 - Distance borgir spawn from the player\
_randomat_borgir_timer_ - Default: 60 - Time between borgir spawns\
_randomat_borgir_faster_mult_ - Default: 0.2 - Number the player's speed multiplier will increase by\
_randomat_borgir_slower_mult_ - Default: 0.2 - Number the player's speed multiplier will decrease by\
_randomat_borgir_faster_cap_ - Default: 3 - The highest speed multiplier a player can get\
_randomat_borgir_slower_cap_ - Default: 0.2 - The lowest speed multiplier a player can get\
\
Changed event name and description, replaced the model of the entity spawned and changed its effect when activated.\
Originally made by [Malivil](https://steamcommunity.com/sharedfiles/filedetails/?id=2055805086)

## Bouncy

Bounce instead of taking fall damage\
\
_ttt_randomat_bouncy_ - Default: 1 - Whether this randomat is enabled\
_randomat_bouncy_speed_retain_ - Default: 0.95 - % of speed retained between bounces\
\
Converted to work with randomat 2.0 rather than TTT2\
Originally made by [Wasted](https://steamcommunity.com/sharedfiles/filedetails/?id=2267954071)

## Bullets, my only weakness

Bullet damage only, everyone is immune to any other form of damage\
\
_ttt_randomat_bullets_ - Default: 1 - Whether this randomat is enabled

## Combo

Triggers a random pair of randomats from a pre-made list.\
The possible pairs are listed below and and be individually turned on/off.\
If one of the randomats in the pair is turned off, then any pair using that randomat won't trigger.\
\
General idea and some combos suggested by u/venort_ on Reddit.

### "Combo: Bunny Hops"

High jumps + bounce instead of fall damage!\
_ttt_randomat_cbbunny_ - Default: 1 - Whether this randomat is enabled

### "Combo: Easy to miss..."

Missing shots damages you, hitting shots heal + H.U.G.E. only!\
_ttt_randomat_cbhugemiss_ - Default: 1 - Whether this randomat is enabled

### "Combo: Pinball"

Zero friction + get knocked away when you bump into someone\
_ttt_randomat_cbpinball_ - Default: 1 - Whether this randomat is enabled

### "Combo: Ice Skating"

Zero friction + shooting pushes you backwards\
_ttt_randomat_cbskating_ - Default: 1 - Whether this randomat is enabled

## Contagious Morality

Killing someone respawns them with your role, limited lives, 3 by default.\
\
_ttt_randomat_morality_ - Default: 1 - Whether this randomat is enabled\
_randomat_morality_lives - Default: 3 - No. of lives players have\
\
Originally made by [Owningle](https://steamcommunity.com/sharedfiles/filedetails/?id=2214440295)

## Copycat

Someone copies someone else's role, health, inventory and playermodel (and name if Custom Roles for TTT is installed)\
\
_ttt_randomat_copycat_ - Default: 1 - Whether this randomat is enabled

## Crab Walk

Everyone can only walk side-to-side\
Original name in German, updated to be compatible with randomat 2.0\
\
_ttt_randomat_crabwalk_ - Default: 1 - Whether this randomat is enabled\
\
Originally made by [Schlurf](https://steamcommunity.com/sharedfiles/filedetails/?id=1394919304)

## Cremation

Bodies burn after a player dies. They cannot be checked, but can be put out after being placed in water.\
Bodies disappear after a while, burning bodies make noise.\
\
_ttt_randomat_cremation_ - Default: 1 - Whether this randomat is enabled\
\
Fixed lua error if bodies were removed before they were removed by this randomat.\
Originally made by [Owningle](https://steamcommunity.com/sharedfiles/filedetails/?id=2214440295)

## Crowbars Only

Can only use, or be damaged by, a buffed crowbar.\
NOTE: This randomat is disabled by default as it's a bit too difficult for the traitors to win.\
\
_ttt_randomat_crowbarsonly_ - Default: 0 - Whether this randomat is enabled

## Dead men tell no lies

When someone dies, everyone is told what their role was\
\
_ttt_randomat_nolies_ - Default: 1 - Whether this randomat is enabled\
\
Originally made by [ruiner189](https://steamcommunity.com/sharedfiles/filedetails/?id=1988901134)

## Deathly Chaos

When someone dies for the first time after this event triggers, a random event triggers!\
\
_ttt_randomat_deathlychaos_ - Default: 1 - Whether this randomat is enabled

## Delayed Start

Triggers a random randomat after a minute.\
\
_ttt_randomat_delay_ - Default: 1 - Whether this randomat is enabled\
_randomat_delay_time_ - Default: 60 - Seconds before randomat is triggered

## Deflation

Players shrink as they take damage, and grow as they gain health\
\
_ttt_randomat_deflation_ - Default: 1 - Whether this randomat is enabled

## Discord Sounds

Secret event.\
Dead players can play discord sounds! Sound cannot be played more than once a second.\
\
_ttt_randomat_discord_ - Default: 1 - Whether this randomat is enabled

## Don't Get Greedy

Everyone gets buyable items over time, but if they're already holding one, they die!\
NOTE: This randomat is disabled by default as it was too confusing for most players\
\
_ttt_randomat_greedy_ - Default: 0 - Whether this randomat is enabled\
_randomat_greedy_timer_min_ - Default: 10 - Min seconds before a weapon tries to be given\
_randomat_greedy_timer_max_ - Default: 60 - Max seconds before a weapon tries to be given\
_randomat_greedy_slap_sound_ - Default: 0 - Whether a slap sound should play on death

## Don't Miss

If you miss a shot, you take damage, but if you hit, then you gain health. Everyone is set to 100 health and 200 max health, so players can heal by being accurate with their shots. Everyone will appear to be injured when this randomat triggers.\
\
_ttt_randomat_dontmiss_ - Default: 1 - Whether this randomat is enabled\
_randomat_dontmiss_damage_ - Default: 5 - Damage dealt for missing\
_randomat_dontmiss_heal_ - Default: 5 - Health gained for healing

## Don’t RDM

The first person to kill someone on their side dies, and their victim respawns at full health.\
\
_ttt_randomat_dontrdm_ - Default: 1 - Whether this randomat is enabled

Modified version of "I'm the captain now" randomat. Fixed compatibility with Custom Roles for TTT and added compatibility with Noxx’s Custom Roles for TTT.\
Originally made by [Owningle](https://steamcommunity.com/sharedfiles/filedetails/?id=2214440295)

## Don't Skip Leg Day

Scales everyone's leg size by a set multiplier.\
\
_ttt_randomat_legday_ - Default: 1 - Whether this randomat is enabled\
_randomat_legday_scale_ - Default: 0.3 - Leg size multiplier\
\
Changed default leg size multiplier, added lower viewheight for all players.\
Originally made by [Spaaz](https://github.com/spaaz/Spaaz-s-Randomats)

## Doomed

You can only look side-to-side, initially sets everyone to look forward.\
\
_ttt_randomat_doomed_ - Default: 1 - Whether this randomat is enabled\
\
Idea from Xenotric on YouTube.

## Drop Shot

While not crouching, damage you deal heals instead.\
Shows a message on a cooldown when a player shoots without crouching.\
\
_ttt_randomat_dropshot_ - Default: 1 - Whether this randomat is enabled\
_randomat_dropshot_message_cooldown_ - Default: 20 - Seconds before 'Player healed!' message appears again, set to 0 to disable

## Ending Flair

For the rest of the current map, a win/lose sound effect plays for everyone at the end of each round\
\
_ttt_randomat_flair_ - Default: 1 - Whether this randomat is enabled\
_randomat_flair_bees_not_the_bees.mp3_ - Default: 1 - Whether this sound can play\
_randomat_flair_clown_ahhohhehey.mp3_ - Default: 1 - Whether this sound can play\
_randomat_flair_clown_circus_intro.mp3_ - Default: 1 - Whether this sound can play\
_randomat_flair_jester_directed_by_robert_b_weide.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_jester_goteeem.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_jester_old_man_laughing.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_killer_valorant_team_kill.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_loss_impostorwin.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_loss_mission_failed.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_loss_oh_no.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_loss_overwatch_defeat.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_loss_pmd_fail.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_loss_sad_trombone.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_loss_sad_violin.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_loss_smallest_violin.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_loss_team_skull.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_lover_what_is_love.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_oldmanloss_yogpod_old_man.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_oldmanwin_tranzit.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_vampire_phantom_of_the_opera.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_botw_spirit_orb.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_congratulations.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_crewmatewin.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_ff_fanfare.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_ff_simon_fanfare.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_here_comes_team_charm.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_mario_64_star.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_nfl_theme.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_old_yogs_outro.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_pmd_fanfare.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_pokemon_fanfare.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_win_zelda_fanfare.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_zombie_mystery_box_laugh.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_zombie_zombies_round_end.mp3_- Default: 1 - Whether this sound can play\
_randomat_flair_zombie_zombies_round_start.mp3_ - Default: 1 - Whether this sound can play

## Événement Aléatoire

A French-themed randomat! Does a lot of things:

Changes most of the game to French! A heck of a lot of custom translations come with this randomat to translate the most commonly used custom TTT weapons, but most of your custom weapons won't have their names translated (I can't translate the whole steam workshop :P).\
Instead those weapons will just have "Le" put in front of their name.\
Replaces the usual death sounds with a French soccer commentator screaming. Everyone can hear them, they are not location-based.\
Replaces the crowbar with a baguette! Model by Devieus and Pasgotti, fixed by me: <https://steamcommunity.com/sharedfiles/filedetails/?id=186267285>\
Plays French themed background music.\
\
_ttt_randomat_french_ - Default: 1 - Whether this randomat is enabled\
_randomat_french_music_ - Default: 1 - Whether french themed music plays

"Chic Magnet" by Dar Golan <https://www.youtube.com/watch?v=BVEC-cQodf0> \
License: CC BY 3.0 <https://goo.gl/Yibru5>

## Everyone has their favourites

Gives everyone their 2 most bought items\
\
_ttt_randomat_favourites_ - Default: 1 - Whether this randomat is enabled\
_randomat_favourites_given_items_count_ - Default: 2 - How many most bought items to give out

## Everyone swaps roles and weapons in 60 seconds! (a.k.a. Role Shuffle!)

Swaps everyone's roles, weapons and credits around, by default 60 seconds after this randomat triggers.\
\
_ttt_randomat_roleshuffle_ - Default: 1 - Whether this randomat is enabled\
_randomat_roleshuffle_time_ - Default: 60 - How long in seconds until roles are shuffled

Changed name from "ROLE SHUFFLE!", fixed randomat registration bug and role weapons not being removed, added a delay of 60 seconds before it's triggered, added a notification to when the roles are shuffled.\
Originally made by [Schlurf](https://steamcommunity.com/sharedfiles/filedetails/?id=1394919304)

## Everyone with a karma damage penalty will explode in ... seconds

Explodes all players with a damage penalty from karma, a set amount of seconds after activation.\
If no players have a karma damage penalty, everyone is given the same random buyable weapon as a reward!\
\
_ttt_randomat_kexplode_ - Default: 1 - Whether this randomat is enabled\
_randomat_kexplode_timer_ - Default: 60 - The time until imperfect karma players explode

The explosion creation code was originally made by [HagenSNKL](https://steamcommunity.com/sharedfiles/filedetails/?id=662342819), from the event: "_A Random Person will explode every ... seconds! Watch out! (EXCEPT DETECTIVES)_"

## Explosive Jumping

Everyone can super-jump, and creates an explosion when they land!\
Everyone is immune to their own explosions.\
NOTE: This randomat is disabled by default as it was causing issues with breaking the sv_gravity convar, and was too overwhelming.\
\
_ttt_randomat_explosivejumping_ - Default: 0 - Whether this randomat is enabled\

## Explosive spectating

Spectators can explode props they posses by pressing left-click.\
\
_ttt_randomat_explosivespectate_ - Default: 1 - Whether this randomat is enabled\
_randomat_explosivespectate_timer_ - Default: 0 - Seconds until the event activates\
_randomat_explosivespectate_damage_ - Default: 100 - Explosion magnitude, scales damage based on distance. For ~20 damage if someone is standing right on top of a prop, set this to about 15\

Changed name from "Pyro-possession - middle click to go boom!", updated to work with randomat 2.0\
Originally made by [Arch](https://steamcommunity.com/sharedfiles/filedetails/?id=1461821324)

## Fastest finger

1st person to type a randomat's name in chat triggers it!\
\
_ttt_randomat_fastestfinger_ - Default: 1 - Whether this randomat is enabled\

## Fetch me their souls

Draws in fog around each player, and slowly spawns in fast zombies around the map.\
Spawns 2 zombies per player alive.\
After all zombies are killed, the fog is lifted and all players are rewarded with infinite ammo for the round!\
\
_ttt_randomat_doground_ - Default: 1 - Whether this randomat is enabled\
_randomat_doground_fogdist_ - Default: 1 - Fog distance multiplier

## First come, first served

Only the 1st person to search a body can see its role.\
If detective-only search is enabled, everyone is given the ability to search bodies.\
\
_ttt_randomat_firstsearch_ - Default: 1 - Whether this randomat is enabled

## Freeze

All Innocents Freeze and become immune to damage every 30 seconds.\
Has a different name each time it’s triggered, there are over 16 different names!

- What's this one? Oh, it's the freeze randomat...
- This is a new one! Wait, it's a freeze randomat...
- It's snowing on Mt. Fuji
- Bing Chilling
- Freezing people to find traitors? Is it really worth it...
- What? Freeze randomat on Earth?
- Shh... It's a Freeze Randomat!
- Freeze randomat! Time to learn how to keep moving...
- Random freezes for everyone!
- Honey, I froze the terrorists
- Icicle-ful strategy, is to keep moving!
- There are more than 12 different freeze randomat names

_ttt_randomat_freeze2_ - Default: 1 - Whether this randomat is enabled\
_randomat_freeze2_duration_ - Default: 5 - Duration of the Freeze (in seconds)\
_randomat_freeze2_timer_ - Default: 30 - How often (in seconds) the Freeze occurs\

Added many more possible names, mostly based on the names of other randomats.\
Originally made by [Dem](https://steamcommunity.com/sharedfiles/filedetails/?id=1406495040)

## Future Proofing

Gives items you buy at the start of the next round, rather than when you buy them.\
\
_ttt_randomat_future_ - Default: 1 - Whether this randomat is enabled

## Ghostly Revenge

Buffs spectator prop possession a lot. Players can move props they possess quickly enough to kill living players!\
Changed name from "Troll Prop"\
\
_ttt_randomat_revenge_ - Default: 1 - Whether this randomat is enabled\
_randomat_revenge_multiplier_ - Default: 4 - Multiplier to all prop possession stats\
_randomat_revenge_timer_ - Default: 0 - Seconds until this event activates

## Go home, you're drunk

Makes everyone's models' bones a jigglebone, and adds a blur effect to the edges of the screen.\
\
_ttt_randomat_drunk_ - Default: 1 - Whether this randomat is enabled

## Gotta buy 'em all

Gives everyone 2 items they haven't bought before.
If someone has bought all detective AND traitor items at least once, they get to choose a randomat at the start of every round for the rest of the map!\
If multiple players have bought all items, they take turns in choosing randomats.\
\
_ttt_randomat_buyemall_ - Default: 1 - Whether this randomat is enabled\
_randomat_buyemall_given_items_count_ - Default: 2 - How many items to give out

## Gun Game 2.0

When someone dies, gives everyone a new gun.\
\
_ttt_randomat_gungame2_ - Default: 1 - Whether this randomat is enabled

Changed name from Gun Game, as base Randomat 2.0 already has a randomat with this name, added support for modded guns\
Originally made by [Dem](https://steamcommunity.com/sharedfiles/filedetails/?id=1406495040)

## Gun Game 3.0

Periodically gives players random buyable weapons. Players can't use normal guns.\
\
_ttt_randomat_gungame3_ - Default: 1 - Whether this randomat is enabled\
_randomat_gungame3_ - Default: 5 - Seconds between weapon changes

Changed name from Gun Game, as base Randomat 2.0 already has a randomat with this name, changed the kind of weapons given\
Originally made by [Dem](https://steamcommunity.com/sharedfiles/filedetails/?id=1406495040)

## Gunfire

Anyone who hasn't shot with a gun for a set amount of time, is set on fire. Shoot to extinguish yourself.\
\
_ttt_randomat_gunfire_ - Default: 1 - Whether this randomat is enabled\
_randomat_gunfire_timer_ - Default: 20 - Seconds a player must not shoot before they are ignited

## Heads Up Dismay

Removes the HUD and scoreboard after a brief delay.\
\
_ttt_randomat_hud_ - Default: 1 - Whether this randomat is enabled

## Hold Space To Slow Down

A player will slow to half speed while they hold space. Will prevent fall damage.\
\
_ttt_randomat_space_ - Default: 1 - Whether this randomat is enabled

## Hot Pursuit

Move faster as more people die, relative to the number of people playing, starts off slow, gets crazy fast by the end!\
\
_ttt_randomat_pursuit_ - Default: 1 - Whether this randomat is enabled\
_randomat_pursuit_mult_ - Default: 1.5 - Movement speed multiplier

## Huff this

Crouching makes you fart.\
Everyone gets this playermodel if installed: <https://steamcommunity.com/sharedfiles/filedetails/?id=614003294>\
\
_ttt_randomat_fart_ - Default: 1 - Whether this randomat is enabled\
_randomat_fart_alt_sound_ - Default: 0 - Whether to use the alternate fart sound

## Huge Problem

Everyone can only use an infinite ammo huge as their main weapon\
\
_ttt_randomat_hugeproblem_ - Default: 1 - Whether this randomat is enabled

## I'm The Captain Now

The first time a detective kills someone on their side, they die, and their victim respawns as a new detective at full health with the detective's weapons.\
NOTE: This randomat is disabled by default as it's a bit too niche and normally doesn't have an effect on the round.\
\
_ttt_randomat_captain_ - Default: 0 - Whether this randomat is enabled\
\
Fixed compatibility with Custom Roles for TTT and added compatibility with Noxx’s Custom Roles for TTT.\
Originally made by [Owningle](https://steamcommunity.com/sharedfiles/filedetails/?id=2214440295)

## I'm sworn to carry your burdens

Move faster the less weapons you have, move slower the more weapons you have.\
Also counts shop items, watch out traitors!\
\
_ttt_randomat_burdens_ - Default: 1 - Whether this randomat is enabled\
_randomat_burdens_multiplier_ - Default: 1 - The speed multiplier is multiplied by this value

## Instant Elevator

Everyone can teleport up and down walls and obstacles by walking into/off them and automatically walk over most obstacles.\
\
_ttt_randomat_elevator_ - Default: 1 - Whether this randomat is enabled

## It's [player]

Changes everyone's playermodel to someone's on the server\
\
_ttt_randomat_duncanevent_ - Default: 1 - Whether this randomat is enabled\
_randomat_duncanevent_disguise_ - Default: 1 - Hide player names or not (1 = on, 0 = off)
_randomat_duncanevent_announce_player_ - Default: 1 - Announce player's model being used

Added description, fixed not hiding names of players properly and not hiding names for traitors\
Originally made by [Legendahkiin](https://steamcommunity.com/sharedfiles/filedetails/?id=2007014855)

## LAST ONE STANDING WINS! BATTLE ROYALE

Turns the round into a battle royale!\
Everyone is innocent, no karma penalties, everyone gets a Fortnite building tool if it’s installed, last one alive wins.\
Everyone gets a radar after 2 minutes to prevent camping.\
\
_ttt_randomat_battleroyale_ - Default: 1 - Whether this randomat is enabled\
_randomat_battleroyale_radar_time_ - Default: 120 - Seconds before everyone is given a radar (Set to 0 to disable)\
_randomat_battleroyale_storm_zones_ - Default: 4 - The number of zones until the storm covers the map (Set to 0 to disable)\
_randomat_battleroyale_storm_wait_time_ - Default: 30 - Seconds after the next zone is announced before the storm moves\
_randomat_battleroyale_storm_move_time_ - Default: 30 - Seconds it takes for the storm to move\
randomat_battleroyale_music - Default: 1 - Whether to play vicotry royale music when someone wins

## LAST \*PAIR\* ALIVE WINS! Duos battle royale

Everyone is turned into an innocent, and placed into pairs, for a duos free-for-all!\
Everyone is innocent, no karma penalties, everyone gets a Fortnite building tool if it’s installed, last pair alive wins.\
Everyone gets a radar after 2 minutes to prevent camping.\
\
_ttt_randomat_battleroyale2_ - Default: 1 - Whether this randomat is enabled\
_randomat_battleroyale2_radar_time_ - Default: 120 - Seconds before everyone is given a radar (Set to 0 to disable)\
_randomat_battleroyale2_storm_zones_ - Default: 4 - The number of zones until the storm covers the map (Set to 0 to disable)\
_randomat_battleroyale2_storm_wait_time_ - Default: 30 - Seconds after the next zone is announced before the storm moves\
_randomat_battleroyale2_storm_move_time_ - Default: 30 - Seconds it takes for the storm to move\
randomat_battleroyale2_music - Default: 1 - Whether to play vicotry royale music when someone wins

## Let's mix it up

When anyone buys something, instead of getting what you bought, you get a random item instead.\
\
_ttt_randomat_mix_ - Default: 1 - Whether this randomat is enabled

## Live Count

Every 30 seconds all players are told how many people are still alive in the current round.\
\
_ttt_randomat_livecount_ - Default: 1 - Whether this randomat is enabled\
_randomat_livecount_timer_ - Default: 30 - Time between live counts\

Changed name from "Live Check!"\
Originally made by [nanz](https://steamcommunity.com/sharedfiles/filedetails/?id=2194776699)

## Make a randomat

A player is randomly chosen to make their own randomat!\
Randomly chosen "causes" are given in a window on the side of the screen. After the player clicks on one, or they take too long to choose, the player can then select from "effects".\
After choosing a cause and effect, a window pops up asking to name the randomat, which then triggers!\
\
_ttt_randomat_make_ - Default: 1 - Whether this randomat is enabled\
_randomat_make_choices_ - Default: 5 - No. of causes/effects you can choose from at once\
_randomat_make_timer_ - Default: 20 - Seconds you have to choose a cause or effect\
_randomat_make_while_dead_ - Default: 1 - Dead players can be chosen to make a randomat

## Memes

Displays a random ASCII art meme every 30 seconds (by default), in the form of a randomat alert.\
\
_ttt_randomat_memes_ - Default: 1 - Whether this randomat is enabled\
_randomat_memes_timer_ - Default: 30 - Seconds between displaying a meme

## My planet needs me

Ragdolls move around, as soon as a player dies.\
Depending on the mass of anyone's playermodel, some people's ragdolls might not move much, some might go flying around the map!\
\
_ttt_randomat_planet_ - Default: 1 - Whether this randomat is enabled

## No more of your little tricks

Disables all traitor traps or anything that relies on a traitor button\
\
_ttt_randomat_traitortraps_ - Default: 1 - Whether this randomat is enabled

## Nice

When you damage someone, you hear a "Michael Rosen nice" sound.\
\
_ttt_randomat_nice_ - Default: 1 - Whether this randomat is enabled

## Nobody

Anyone killed doesn't leave behind a body anymore.\
\
_ttt_randomat_nobody - Default: 1 - Whether this randomat is enabled

## Noir

Turns the color saturation way down, forces everyone to use a revolver, and puts a letterbox effect on the screen.\
This randomat's name is a randomly chosen noir film trope:

- It was a case like any other...
- Rain dripped down from the dark sky...
- That's the thing about this city...
- The dame was there under the streetlight...
- I sat in the office, knowing those traitors were somewhere...
- The case was growing cold...
- The rain fell like dead bullets...
- I sat in the hotel room, as I contemplated my next move...
- I was there in the smoke-filled bar...
- I saw him standing in the cold alleyway...
- The new detective film, "Hot Blood", coming this summer

_ttt_randomat_noir_ - Default: 1 - Whether this randomat is enabled\
_ttt_randomat_noir_music_ - Default: 1 - Whether this randomat plays music

The code that applies the black and white filter was originally made by [Wasted](https://steamcommunity.com/sharedfiles/filedetails/?id=2267954071)\
\
Credit for the copyright-free music used:\
"Deadly Roulette" by Kevin MacLeod <https://incompetech.com/> \
Promoted by MrSnooze <https://youtu.be/iYOvAO1rAM0> \
License: CC BY 3.0 <https://goo.gl/Yibru5>

## Once more, with feeling

Repeats the last randomat that triggered, other than this one\
\
_ttt_randomat_oncemore_ - Default: 1 - Whether this randomat is enabled

## Oof

Everyone hears a Roblox 'oof' sound effect after someone takes damage.\
\
_ttt_randomat_oof_ - Default: 1 - Whether this randomat is enabled

## Outcome? Prop go boom

Makes props explode when they are destroyed.\
\
_ttt_randomat_goboom_ - Default: 1 - Whether this randomat is enabled

## Petrify

Turns players into a stone like figure, playing a stone-dragging sound when they move.\
\
_ttt_randomat_petrify_ - Default: 1 - Whether this randomat is enabled

Originally made by [Owningle](https://steamcommunity.com/sharedfiles/filedetails/?id=2214440295)

## Pinball People

When two players collide, they will be sent flying in opposite directions.\
\
_ttt_randomat_pinball_ - Default: 1 - Whether this randomat is enabled\
_randomat_pinball_mul_ - Default: 10 - Player-flinging velocity multiplier

Originally made by [Owningle](https://steamcommunity.com/sharedfiles/filedetails/?id=2214440295)

## Pistols at dawn

Last 2 (non-jester) players alive have a one-shot pistol showdown!\
They are given 1-shot pistols, infinite ammo, and wallhacks.\
All unspent credits are removed, no other guns/grenades/weapons other than the revolver can be used.\
If innocents/traitors win, the winners have a free-for-all instead!\
\
_ttt_randomat_pistols_ - Default: 1 - Whether this randomat is enabled\
_randomat_pistols_music_ - Default: 1 - Whether music is enabled during showdown\
_randomat_pistols_yellow_tint_ - Default: 1 - Whether a yellow tint screen effect is applied during the duel\
\
Credit for the copyright-free music used:\
"Rattlesnake Railroad" by Brett Van Donsel <https://incompetech.com/> \
License: CC BY 4.0 <https://creativecommons.org/licenses/by/4.0> \
YouTube Source: <https://www.youtube.com/watch?v=WizFTwM_J_8>

## Press E to ping

Whenever a player presses E, a "!" can be seen where they were looking for everyone, for 10 seconds.\
If they were looking at an entity, such as a player or weapon, it will be highlighted for everyone.\
This also works for spectators! (If enabled)\
\
_ttt_randomat_ping_ - Default: 1 - Whether this randomat is enabled\
_randomat_ping_cooldown_ - Default: 10 - Seconds until a player can ping again\
_randomat_ping_global_cooldown_ - Default: 0 - Seconds until anyone can ping again after 1 person pings\
_randomat_ping_spectators_ - Default: 1 - Whether spectators can ping\
_randomat_ping_sound_ - Default: 1 - Whether pinging makes a sound

## Prop Confusion

Secret event (shows up as "Shhh... it's a secret!"), one person is selected to see everyone else as props!\
Only they see props in place of other players, everyone else is unaffected.\
\
_ttt_randomat_propconfusion_ - Default: 1 - Whether this randomat is enabled\

## Random jump height for everyone

Randomly sets the jump height of every player from 0 up to 3x as high as default\
\
_ttt_randomat_randomjump_ - Default: 1 - Whether this randomat is enabled\
_randomat_randomjump_max_multiplier_ - Default: 3.0 - Max multiplier to jump height

## Random sizes for everyone

Everyone becomes a random smaller size, and has corresponding health. The smaller the size, the less health you are set to.\
\
_ttt_randomat_resize_ - Default: 1 - Whether this randomat is enabled\
_randomat_resize_min_ - Default: 25 - Minimum possible size\
_randomat_resize_max_ - Default: 100 - Maximum possible size

Changed name from "Try another perspective on life", now only shrinks players rather than possibly making then larger.\
Originally made by: [Guardain954](https://steamcommunity.com/sharedfiles/filedetails/?id=2068742309)

## Realistic Recoil

Shooting strongly pushes you backwards. Looking down and shooting pushes you into the air.\
\
_ttt_randomat_recoil_ - Default: 1 - Whether this randomat is enabled\
_randomat_recoil_max_ - Default: 15 - Maximum Magnitude a gun can change someone's velocity by.\
_randomat_recoil_mul_ - Default: 6 - Recoil velocity multiplier

Originally made by [Owningle](https://steamcommunity.com/sharedfiles/filedetails/?id=2214440295)

## Redemption Time

Puts someone with their worst traitor partner.\
\
_ttt_randomat_redemption_ - Default: 1 - Whether this randomat is enabled

## Remember Flat Stanley?

Flattens all players' playermodels.\
\
_ttt_randomat_redemption_ - Default: 1 - Whether this randomat is enabled\
_randomat_flatstanley_scale_ - Default: 0.2 - Flatness size multiplier

Originally made by [Spaaz](https://github.com/spaaz/Spaaz-s-Randomats)

## Role Call

Announces a random player's role every 60 seconds\
\
_ttt_randomat_rolecall_ - Default: 1 - Whether this randomat is enabled\
_randomat_rolecall_time_ - Default: 60 - Time between role announcements

## Sahmin

Gun sounds are replaced with "Sahmin".\
\
_ttt_randomat_sahmin_ - Default: 1 - Whether this randomat is enabled

## Sharky and Palp

Puts someone with their best traitor partner.\
\
_ttt_randomat_sharky_ - Default: 1 - Whether this randomat is enabled

## Shh... It's a Secret

Runs another random Randomat event without notifying the players. Also silences all future Randomat events while this event is active.\
\
_ttt_randomat_secret_ - Default: 1 - Whether this event is enabled.

## Shoot and Loot

Killed players drop buyable weapons! New random weapons not held by the player pop out and are thrown around them.\
\
_ttt_randomat_loot_ - Default: 1 - Whether this event is enabled.\
_randomat_loot_drop_number_ - Default: 8 - Number of weapons dropped.\
\
Idea from IAmRoofstone on Reddit

## Simon Says

Everyone copies someone's loadout. Everyone can only use a gun if the chosen person has theirs out.\
\
_ttt_randomat_simonsays_ - Default: 1 - Whether this randomat is enabled\
_randomat_simonsays_strip_basic_weapons_ - Default: 1 - Whether weapons like the crowbar and magneto stick are removed\
_randomat_simonsays_timer_ - Default: 45 - Seconds until the leader changes, if set to 0, the leader only changes after they die

Changed name to "Simon Says", changed the "leader" to only be picked once, or after the leader dies\
Originally made by [ruiner189](https://steamcommunity.com/sharedfiles/filedetails/?id=1988901134)

## Speedrun

Cuts the round time down to 1 minute!\
\
_ttt_randomat_speedrun_ - Default: 1 - Whether this randomat is enabled\
_randomat_speedrun_time_ - Default: 60 - Time in seconds the round will last

## Stop Ghosting

Ghostly t-posing models follow spectators\
\
_ttt_randomat_ghosting_ - Default: 1 - Whether this randomat is enabled\
_randomat_ghosting_stay_upright_ - Default: 0 - Whether ghosts should stay upright when looking up/down

Changed name from "There are ghosts around", converted to work with randomat 2.0 rather than TTT2,\
fixed major bug that would prevent the round from being manually restarted on any map this event activated on.\
Originally made by [Wasted](https://steamcommunity.com/sharedfiles/filedetails/?id=2267954071)

## Super Boing

Everyone can jump very high, high gravity, no fall damage\
\
_ttt_randomat_superboing_ - Default: 1 - Whether this randomat is enabled

## Take a seat! (a.k.a Oh sorry, I thought that was you, Rythian!)

Turns everyone into chairs!\
This randomat gives out this model as well if installed, and changes to its alternate name: [Phoenix Wright Playermodel & NPC](https://steamcommunity.com/sharedfiles/filedetails/?id=396749988)\
\
_ttt_randomat_chairs_ - Default: 1 - Whether this randomat is enabled

## Team Deathmatch

Turns half of everyone into traitors, and half detectives.\
\
_ttt_randomat_deathmatch_ - Default: 1 - Whether this randomat is enabled

Changed name from "Random Team Deathmatch", fixed randomat registration bug\
Originally made by [Schlurf](https://steamcommunity.com/sharedfiles/filedetails/?id=1394919304)

## The Bus

Spawns a bus somewhere on the map that kills anyone it touches...\
\
_ttt_randomat_bus_ - Default: 1 - Whether this randomat is enabled

## The Michael Rosen Rap

Replaces game sounds with Michael Rosen sounds!\
If you don't know what Micheal Rosen YTPs are, well this one essentially replaces game noises wtih someone's voice from an internet meme.\
\
_ttt_randomat_michaelrosen_ - Default: 1 - Whether this randomat is enabled\
_randomat_michaelrosen_trigger_sound_ - Default: 1 - Whether a sound should play when this event triggers. Note: This sound is sometimes a few seconds of "music"\
\
Changed event name and description, removed the footstep sounds, added on trigger sounds and added a convar to toggle them, replaced all sound effects with new ones.\
Originally made by [Malivil](https://steamcommunity.com/sharedfiles/filedetails/?id=2055805086)

## Trigger Happy

Whenever you shoot, everyone else does too!\
\
_ttt_randomat_triggerhappy_ - Default: 1 - Whether this randomat is enabled\
\
Idea from Wolvinof on YouTube.

## Triggered

Applies a red screen effect, shakes the screen and plays a loud sound when someone dies\
NOTE: This randomat is disabled by default as the screen effect and sound is too overwhelming to those who have sensory sensitivity.\
\
_ttt_randomat_triggered_ - Default: 0 - Whether this randomat is enabled

## Unbelievable Guilt

If you kill a player on your team, your head will be forced down for a few seconds.\
\
_ttt_randomat_guilt_ - Default: 1 - Whether this randomat is enabled\
_randomat_guilt_time_ - Default: 5 - Seconds your head is held down

Fixed compatibility with Custom Roles for TTT, added compatibility with Noxx’s Custom Roles for TTT, added message explaining what's happening when someone RDMs\
Originally made by [Owningle](https://steamcommunity.com/sharedfiles/filedetails/?id=2214440295)

## Unconventional Healing

Fall, fire and explosion damage heals!\
\
_ttt_randomat_unconventional_ - Default: 1 - Whether this randomat is enabled

Changed name from "Pyromaniac - fire heals!", added fall and fire damage to heal, fixed major bug with incendiary damage healing\
Originally made by [Arch](https://steamcommunity.com/sharedfiles/filedetails/?id=1461821324)

## Unrealistic Recoil

Shooting strongly pushes you forwards. Looking up and shooting pushes you into the air.\
\
_ttt_randomat_recoil2_ - Default: 1 - Whether this randomat is enabled\
_randomat_recoil2_max_ - Default: 15 - Maximum Magnitude a gun can change someone's velocity by.\
_randomat_recoil2_mul_ - Default: 6 - Recoil velocity multiplier

Originally made by [Owningle](https://steamcommunity.com/sharedfiles/filedetails/?id=2214440295)

## Wasted

Slows the game down for everyone after someone dies for a few seconds.\
Anyone that dies sees a GTA-style "Wasted" screen!\
\
_ttt_randomat_wasted_ - Default: 1 - Whether this randomat is enabled

## Welcome back to TTT

Displays the Yogscast TTT intro, and creates an overlay showing everyone's roles as bodies are searched, and whether they are alive. (Similar to the scoreboard)\
\
_ttt_randomat_welcomeback_ - Default: 1 - Whether this randomat is enabled

## Western

Makes the game look like a western film and plays western music!\
Replaces normal guns with "duel revolvers", everyone gets one.\
When a revolver is used on a player, both players turn around, freeze in place, and duel it out after 5 seconds.\
If a player dies, or neither die after 10 seconds, the duel is over.\
All jesters/independents are set to innocents (If custom roles are being used).\
\
This randomat's name is a randomly chosen western film trope/reference:

- It's high noon...
- The innocent, the traitors, and the ugly
- This town ain't big enough for both of us...
- Go ahead... make my day
- They say he's the fastest gun in the west...
- The quick, and the dead

_ttt_randomat_western_ - Default: 1 - Whether this randomat is enabled\
_randomat_western_music_ - Default: 1 - Whether the western music plays\
\
Credit for the copyright-free music used:\
"Rattlesnake Railroad" by Brett Van Donsel <https://incompetech.com/> \
License: CC BY 4.0 <https://creativecommons.org/licenses/by/4.0> \
YouTube Source: <https://www.youtube.com/watch?v=WizFTwM_J_8>

## What did WE find in our pockets?

Gives everyone the same random buyable weapon\
\
_ttt_randomat_pockets_ - Default: 1 - Whether this randomat is enabled\
randomat_pockets_blocklist - Default: "" - A list of weapon IDs, separated by commas, that cannot be given out.

Changed name from "What did I find in my pocket?", chooses a random weapon to give to everyone instead.\
Originally made by [Malivil](https://steamcommunity.com/sharedfiles/filedetails/?id=2055805086)

## What it's like to be [player]

Everyone gets someone's playermodel and their 2 most bought items.\
\
_ttt_randomat_whatitslike_ - Default: 1 - Whether this randomat is enabled\
_randomat_whatitslike_disguise_ - Default: 0 - Hide each player’s name\
_randomat_whatitslike_given_items_count_ - Default: 2 - How many most bought items to give out

## Who has the best spray?

Everyone is continually forced to use their spray, if looking at a valid surface.\
If sprays don't work on a map, this event does nothing.\
\
_ttt_randomat_spraying_ - Default: 1 - Whether this randomat is enabled

## Who's Who?

Swaps everyone's playermodels\
\
_ttt_randomat_whoswho_ - Default: 1 - Whether this randomat is enabled

Changed name from "Guess Who!", fixed depreciated code that broke this randomat, properly set everyone's playermodels back once round is over, fixed to always swap everyone's models and work with odd amounts of players.\
Originally made by: [Guardain954](https://steamcommunity.com/sharedfiles/filedetails/?id=2068742309)

## Whoa

Everyone is changed to a Crash Bandicoot playermodel (if installed: [PS1's Crash Bandicoot P.M.](https://steamcommunity.com/sharedfiles/filedetails/?id=1009092087)) and is forced to use a "Spin Attack" weapon.\
\
_ttt_randomat_whoa_ - Default: 1 - Whether this randomat is enabled\
_randomat_whoa_timer_ - Default: 3 - Time between being given spin attacks\
_randomat_whoa_strip_ - Default: 1 - The event strips your other weapons\
_randomat_whoa_weaponid_ - Default: weapon_ttt_whoa_randomat - Id of the weapon given

## YEET

When a player is damaged, they are launched up into the air, and a sound effect plays from them.\
By default, this has a 10 second cooldown before a player can be launched by damage again, to prevent infinite loops with fall damage.\
\
_ttt_randomat_yeet_ - Default: 1 - Whether this randomat is enabled\
_randomat_yeet_cooldown_ - Default: 10 - Cooldown between 'yeets', in seconds\
_randomat_yeet_force_ - Default: 1000 - 'Yeet' force

## You spin me right round baby

Taking damage rotates you to the left slightly.\
\
_ttt_randomat_spin_ - Default: 1 - Whether this randomat is enabled

## Zero Friction

Removes friction and gives prop damage immunity, which prevents you from dying if you touch a prop. (Blame Gmod physics...)\
All explosive barrels are also removed from the map, to prevent unexpectedly dying if you bump into one.\
\
_ttt_randomat_friction_ - Default: 1 - Whether this randomat is enabled\
_randomat_friction_friction_ - Default: 0 - Friction amount that is set\
_randomat_friction_nopropdmg_ - Default: 1 - Whether everyone becomes immune to prop damage, else you might die from touching props\
\
Changed name from "Trouble in Terrorist Town: On Ice", converted to work with randomat 2.0 rather than TTT2, fixed prop damage immunity not working, now removes explosive barrels\
Originally made by [Wasted](https://steamcommunity.com/sharedfiles/filedetails/?id=2267954071)
