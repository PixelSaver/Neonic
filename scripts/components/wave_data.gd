extends Resource
class_name WaveData

@export var enemies : Array[EnemySpawn]
## For an index wave i, the time it takes for the ith wave to spawn.
## If the delay is significantly below 0, it will spawn once all enemies are killed.
## If waves in EnemySpawn are not given a delay, they will not spawn.
## Delays are counted after the previous wave.
@export var wave_delays : Array[float] = [-1]
