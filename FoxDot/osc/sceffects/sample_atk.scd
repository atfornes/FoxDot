SynthDef.new(\sample_atk,
{|bus, sample_atk, sample_sus|
var env;
env = EnvGen.ar(Env.new(levels: [0,1,0], times:[sample_atk, sample_sus], curve: 'lin'));
osc = osc*env;
ReplaceOut.ak(bus, osc)}).add;
