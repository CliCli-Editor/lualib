# Math

Mathematical library

All use Angle system

## acos

```lua
function Math.acos(value: number)
  -> float: number
```

Inverse cosine (Angle system）

@*param* `value` — Real number

@*return* `float` — Real number
## asin

```lua
function Math.asin(value: number)
  -> float: number
```

arcsine）

@*param* `value` — Real number

@*return* `float` — Real number
## atan

```lua
function Math.atan(y: number, x: number)
  -> float: number
```

Inverse tangent）

@*return* `float` — Real number
## cos

```lua
function Math.cos(value: number)
  -> float: number
```

Cosine (Angle system）

@*param* `value` — Real number

@*return* `float` — Real number
## get_random_angle

```lua
function Math.get_random_angle()
  -> number
```

Get random Angle
## get_random_seed

```lua
function Math.get_random_seed()
  -> seed: integer
```

Get random seeds

@*return* `seed` — Random seed
## includedAngle

```lua
function Math.includedAngle(r1: number, r2: number)
  -> angle: number
  2. direction: number
```

Calculate the Angle between 2 angles (Angle system）

@*return* `angle` — Included Angle, value range[0, 180]

@*return* `direction` — Direction: 1 is clockwise and -1 is counterclockwise
## isBetween

```lua
function Math.isBetween(number: number, min: number, max: number)
  -> boolean
```

 Check whether the number is in the [min, max] range
## random_float

```lua
function Math.random_float(min: number, max: number)
  -> float: number
```

Random real numbers in the range

@*param* `min` — The smallest real number in the range

@*param* `max` — The largest real number in the range

@*return* `float` — Random real number
## sin

```lua
function Math.sin(value: number)
  -> float: number
```

Sine (system of angles）

@*param* `value` — Real number

@*return* `float` — Real number
## tan

```lua
function Math.tan(value: number)
  -> float: number
```

Tangent (Angle system）

@*param* `value` — Real number

@*return* `float` — Real number

