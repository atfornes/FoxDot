SynthDef.new(\tremsynth, {
	|bus = 0,freq = 0, modfreq=3, amp = 1, pan = 0, atk = 0.01, sus = 1, rel = 0.1, pos = 0|
	var osc, mod, env;
	freq = In.kr(bus, 1);
	mod = SinOsc.kr(freq:modfreq,mul:1).range(0,1);
	osc = LFTri.ar(freq: freq, mul: mod);
	env = Env.linen(atk, sus, rel, curve: \lin).kr(doneAction: 0);
	osc = osc * env * amp;
	osc = Pan2.ar(osc,pan);
	ReplaceOut.ar(bus,osc)
}).add;