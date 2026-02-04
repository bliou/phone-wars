class_name MusicPlaylist
extends Resource

@export var tracks: Array[AudioStream]
@export var fade_in_time: float
@export var fade_out_time: float


func pick_random() -> AudioStream:
	return tracks.pick_random()


func get_next(track: AudioStream) -> AudioStream:
	var track_index: int = tracks.find(track)
	track_index += 1
	if track_index < tracks.size():
		return tracks.get(track_index)

	return tracks.get(0)