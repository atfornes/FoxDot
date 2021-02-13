SynthDef.new(\windmaker, {
	|bus = 0, pan = 0.0, freq = 440, amp = 0.1, fmod = 0, gate = 1, cutoff = 100, rq = 0.1, atk = 0.01, dec = 0, sus = 1, rel = 1, delay = 0.3|
	var source, filter, env, osc, delayEnv;
	freq = In.kr(bus, 1);
	freq = [freq, freq+fmod];
	source = WhiteNoise.ar;
	filter = BLowPass4.ar(source, freq, rq) * 0.3;
	env = EnvGen.ar(envelope: Env.linen(atk, sus, rel, amp), gate: gate, doneAction: 0);
	osc = (0.7 * filter + (0.3 * filter.distort)) * env;
	osc = Mix(osc) * 0.5;
	osc = Pan2.ar(osc, pan);
	ReplaceOut.ar(bus, osc)
},
metadata: (
	credit: "Mitchell Sigman",
	modified_by: "Bruno Ruviaro, Jens Meisner",
	decription: "Description",
	category: \misc,
	tags: [\ambient, \wind, \storm]
)).add;