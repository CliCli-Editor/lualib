# Sound

Audio

## get_by_handle

```lua
function Sound.get_by_handle(py_sound: py.SoundEntity)
  -> Sound
```

## handle

```lua
py.SoundEntity
```

Sound object
## play

```lua
function Sound.play(player: Player, sound: py.AudioKey, options?: Sound.PlayOptions)
  -> Sound?
```

Play sound

@*param* `player` — Player

@*param* `sound` — Audio

@*param* `options` — Play option
## play_3d

```lua
function Sound.play_3d(player: Player, sound: py.AudioKey, point: Point, options?: Sound.Play3DOptions)
  -> Sound?
```

Play 3D sound

@*param* `player` — Player

@*param* `sound` — Audio

@*param* `point` — Target point

@*param* `options` — Play option
## play_with_object

```lua
function Sound.play_with_object(player: Player, sound: py.AudioKey, unit: Unit, options?: Sound.PlayUnitOptions)
  -> Sound?
```

Follow the unit to play the sound

@*param* `player` — Player

@*param* `sound` — Audio

@*param* `unit` — Following unit

@*param* `options` — Play option
## set_volume

```lua
(method) Sound:set_volume(player: Player, volume: integer)
```

 Set volume

@*param* `player` — Player

@*param* `volume` — volume(0-100)
## stop

```lua
(method) Sound:stop(player: Player, is_immediately?: boolean)
```

Stop playing sound

@*param* `player` — Player

@*param* `is_immediately` — Whether to stop immediately

# Sound.Play3DOptions

## ensure

```lua
boolean
```

Ensure to play
## fade_in

```lua
number
```

Involution time
## fade_out

```lua
number
```

Fade out time
## height

```lua
number
```

Altitude
## loop

```lua
boolean
```

Cyclic or not

# Sound.PlayOptions

## fade_in

```lua
number
```

Involution time
## fade_out

```lua
number
```

Fade out time
## loop

```lua
boolean
```

Cyclic or not

# Sound.PlayUnitOptions

## ensure

```lua
boolean
```

Ensure to play
## fade_in

```lua
number
```

Involution time
## fade_out

```lua
number
```

Fade out time
## loop

```lua
boolean
```

Cyclic or not
## offset_x

```lua
number
```

XAxis shift
## offset_y

```lua
number
```

YAxis shift
## offset_z

```lua
number
```

ZAxis shift

