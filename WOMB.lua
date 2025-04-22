-- WOMB: random basslines
--
-- by HANJO, Tokyo, Japan
--
-- K2: INT (internal) and MIDI
-- K3: New 16-step bassline
-- E1: Scale
-- E2: Root note
-- E3: adjust density
--
-- Output: INT = sound via PolyPerc / Norns
--         MIDI = note output via USB
--
-- Uses Norns global tempo, internal clock-sync

engine.name = "PolyPerc"

local musicutil = require "musicutil"
local midi_device
local scale_names = {}
local current_scale
local notes = {}
local step = 1
local root_note = 36 -- C2
local scale_index = 1
local density = 0.5 -- 0.00 to 1.00
local output_mode = "INT" -- or "MIDI"
local midi_channel = 1
local k2_held = false

function init()
  for i, scale in ipairs(musicutil.SCALES) do
    table.insert(scale_names, scale.name)
  end

  current_scale = musicutil.SCALES[scale_index]
  generate_sequence()

  midi_device = midi.connect()
  midi_device.channel = midi_channel

  clock.run(play_sequence)

  clock.run(function()
    while true do
      clock.sleep(1/15)
      redraw()
    end
  end)
end

function generate_sequence()
  notes = {}
  local scale = musicutil.generate_scale_of_length(root_note, current_scale.name, 8)
  local active_steps = math.max(1, math.floor(density * 16))

  for i = 1, 16 do
    if i <= active_steps then
      local note = scale[math.random(#scale)]
      table.insert(notes, note)
    else
      table.insert(notes, nil)
    end
  end

  for i = #notes, 2, -1 do
    local j = math.random(i)
    notes[i], notes[j] = notes[j], notes[i]
  end
end

function play_sequence()
  while true do
    local note = notes[step]
    if note then
      if output_mode == "INT" then
        engine.hz(musicutil.note_num_to_freq(note))
      elseif output_mode == "MIDI" then
        midi_device:note_on(note, 100, midi_channel)
      end
    end
    clock.sync(1/4)
    if note and output_mode == "MIDI" then
      midi_device:note_off(note, nil, midi_channel)
    end
    step = (step % 16) + 1
  end
end

function quantize_sequence()
  local scale = musicutil.generate_scale_of_length(root_note, current_scale.name, 8)
  for i, note in ipairs(notes) do
    if note ~= nil then
      local closest = musicutil.snap_note_to_array(note, scale)
      notes[i] = closest
    end
  end
end

function transpose_sequence()
  local transposition = root_note - musicutil.snap_note_to_array(notes[1] or root_note, musicutil.generate_scale_of_length(notes[1] or root_note, current_scale.name, 1))
  for i, note in ipairs(notes) do
    if note ~= nil then
      notes[i] = note + transposition
    end
  end
end

function enc(n, d)
  if n == 1 then
    scale_index = util.clamp(scale_index + d, 1, #musicutil.SCALES)
    current_scale = musicutil.SCALES[scale_index]
    quantize_sequence()
  elseif n == 2 then
    root_note = util.clamp(root_note + d, 24, 72)
    transpose_sequence()
  elseif n == 3 then
    if k2_held then
      midi_channel = util.clamp(midi_channel + d, 1, 16)
      midi_device.channel = midi_channel
    else
      density = util.clamp(density + d * 0.01, 0.0, 1.0)
    end
  end
end

function key(n, z)
  if n == 2 then
    k2_held = (z == 1)
    if z == 1 then
      output_mode = output_mode == "INT" and "MIDI" or "INT"
    end
  elseif n == 3 and z == 1 then
    generate_sequence()
  end
end

function redraw()
  screen.clear()
  screen.level(15)
  screen.move(10, 20)
  screen.text("WOMB Bassline")

  screen.level(10)
  screen.move(10, 35)
  screen.text("Scale: " .. current_scale.name)

  screen.move(10, 45)
  screen.text("Root: " .. musicutil.note_num_to_name(root_note))

  screen.move(10, 55)
  screen.text(string.format("Density: %.2f", density))

  -- output info aligned
  if output_mode == "MIDI" then
    screen.move(103, 45)
    screen.text(string.format("CH:%02d", midi_channel))
  end

  screen.move(103, 55)
  screen.text(output_mode)

  screen.update()
end
