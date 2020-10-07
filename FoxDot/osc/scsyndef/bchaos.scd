SynthDef.new(\bchaos, {
    |bus = 0, pan = 0, freq = 0, amp = 1, gate = 1, atk = 0.01, sus = 1, rel = 1.5, curve = \lin,
	chaosUpStart = 0, chaosUpEnd = 0.5, chaosUpTime = 1,
	chaosDownStart = 0, chaosDownEnd = 0, chaosDownTime = 1,
	cutoff = 20000, reHashesPerCycle = 1, hashRate = 1, nyquist = 5000|
	var env, chaosRise, chaosFall, noisefunction, noise, switcha, switchb, shapea, shapeb, osc;
	freq = In.kr(bus, 1);
	env = Env.linen(attackTime: atk, sustainTime: sus, releaseTime: rel, level: amp, curve: curve).kr;
	chaosRise = Line.kr(start:  chaosUpStart,  end:  chaosUpEnd,  dur:  chaosUpTime );
	chaosFall = Line.kr(start: chaosDownStart, end: chaosDownEnd, dur: chaosDownTime);
	switcha = LFPulse.ar(freq: freq, iphase:  0 );
	switchb = LFPulse.ar(freq: freq, iphase: 0.5);
	noisefunction = Impulse.ar(freq: freq * reHashesPerCycle, mul: 1, add: -1);
	noisefunction = Sweep.ar(trig: noisefunction);
	noise = Hasher.ar(in: noisefunction);
	noise = LPF.ar(in: noise, freq: nyquist);
	noise = Latch.ar(noise, Impulse.ar(nyquist * 2));
	noise = LPF.ar(in: noise, freq: nyquist);
	noise = noise * LFTri.ar(freq: freq, iphase: 0);
	shapea = noise * switcha * chaosRise;
	shapeb = noise * switchb * chaosFall;
	shapea = LFSaw.ar(freq: freq, iphase: 1, mul:    switcha,   add: shapea);
	shapeb = LFSaw.ar(freq: freq, iphase: 1, mul: -1 * switchb, add: shapeb);
	osc = Mix.ar(shapea + shapeb);
	osc = LeakDC.ar(osc);
	osc = LPF.ar(in: osc, freq: cutoff, mul: env);
	DetectSilence.ar(in: osc, doneAction: 0);
	osc = Pan2.ar(osc,pan);
	ReplaceOut.ar(bus,osc)
}).add;