// Weirdo //

Server.default.options.outDevice_("Soundflower (64ch)");
s.boot;

//SCVosim
(
SynthDef(\boom, {|out=2, atk=0.05, dec=0.05, sus=0.5, rel=0.1, gate=1, decay=0.8, tspeed=2, pan=0, gain=0.8|
	var env, source, nCycles, mix, trig, freq;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, doneAction:2);
	trig = Impulse.ar(tspeed);
	nCycles= LFNoise2.kr(0.5, 10, 15);
	freq = TRand.kr([40.0, 120.0, 220.0], [440.0, 990.0, 880.0], trig);
	source = VOSIM.ar(trig, freq, nCycles, decay);
	mix = Pan2.ar(source, pan, gain);
	Out.ar(out, mix);
}).add;
)

//s.sendMsg(\s_new, \boom, s.nextNodeID, 0, 1, \tspeed, 0.5, \gain, 0.7);
TempoClock.default.tempo = 120/60;

(
Pbind(\instrument, \boom, \out, 2, \gain, Pwhite(0.05, 0.2, inf),
	\tspeed, Pwrand([2, 18201, 20001], [0.99, 0.003, 0.005], inf),
	\rel, 1.0,
	\dur, Pwrand([0.25, 0.5, 1], [0.6, 0.3, 0.1], inf);
).play
)

/******************************************************************************************************************/

s.sendMsg(\b_allocRead, 11, "/Users/haighton_imac/Documents/Audio/Composities/Weirdo/Weirdo Project/Samples/BazilleBounce_mono.wav");

(
SynthDef(\grainy, {|out=2, gate=1, sndbuf=11, gain=0.9, atk=0.5, dec=0.2, sus=0.5, rel=3, tspeed=8|
	var env, source, centerPos, dur, pan, amp, gatk, gdec, mix, rate, trig;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, doneAction:2);
	trig = Impulse.kr(tspeed);
	centerPos = SinOsc.kr(0.1, 0.5pi, 0.15, 0.3) * BufDur.kr(sndbuf);
	rate = EnvGen.kr(Env([80, 0.25, 1], [1.5, 3], \exp), gate);
	dur = 0.25;
	pan = TRand.kr(-1.0, 1.0, trig);
	amp = TRand.kr(0.3, 0.8, trig);
	gatk = 0.01;
	gdec = 0.01;
	source = TGrains2.ar(2, trig, sndbuf, rate * BufRateScale.kr(sndbuf), centerPos, dur, pan, amp, gatk, gdec, 4);
	mix = (env * source) * gain;
	Out.ar(out, mix);
}).send(s);
)

s.sendMsg(\s_new, \grainy, s.nextNodeID, 0, 1, \out, 2, \tspeed, 100, \gain, 0.5);

/******************************************************************************************************************/

(
SynthDef(\loop, {|out=2, sndbuf=11, atk=0.1, dec=0.05, sus=0.7, rel=1, gate=1, startPos=2000, pos=0, gain=1, loopLength=20000, gain2=0.2|
	var env, source, startLoop, endLoop, rate, mix, trig;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, doneAction:2);
	//trig = Dust.kr(0.1);
	rate = [0.5, 1, 1.5, 2]+Saw.kr(0.1, 0.0025);
	startLoop = TRand.kr(0.05, 0.1, gate) * BufFrames.kr(sndbuf);
	endLoop = startLoop + loopLength;
	source = LoopBuf.ar(1, sndbuf, rate * BufRateScale.kr(sndbuf), gate, startPos, startLoop, endLoop, 4);
	source = BPF.ar(source, 400+SinOsc.kr(0.05, 0.5pi, 400, 400), 0.1);
	mix = Pan2.ar((env*source), pos, gain);
	Out.ar(out, mix);
}).add;
)

//s.sendMsg(\s_new, \loop, s.nextNodeID, 0, 1, \out, 2, \gain, 0.5, \rate, 1);
(
Pbind(\instrument, \loop, \out, 2, \gain, 1.5,
	\loopLength, 25000,
	\atk, 2.5,
	\rel, 8,
	\startPos, 10000,
	\dur, 4;
).play;
)

/******************************************************************************************************************/

s.sendMsg(\b_allocRead, 10, "/Users/haighton_imac/Documents/Audio/Composities/Weirdo/Weirdo Project/Samples/BazilleBounce_mono.wav");
(
SynthDef(\warp0, {|out=0, gate=1, sndbuf=10, atk=0.1, dec=0.2, sus=0.8, rel=0.5, pan=0, gain=1|
	var env, source, mix, warpFactor, freqScale, windowSize, overlaps;
	env = EnvGen.kr(Env.adsr(atk, dec, sus, rel), gate, doneAction:2);
	warpFactor = 0.5;
	freqScale = EnvGen.kr(Env([1, 0.5, 1], [3, 10], \exp), gate);
	windowSize = Line.kr(0.1, 1.0, 10);
	overlaps = EnvGen.kr(Env([10, 2, 10], [8, 6], \exp), gate);
	source = Warp0.ar(1, sndbuf, warpFactor, freqScale * BufRateScale.kr(sndbuf), windowSize, -1, overlaps, 0.1, 4);
	mix = Pan2.ar(source*env, pan, gain);
	Out.ar(out, mix);
}).send(s);
)

s.sendMsg(\s_new, \warp0, s.nextNodeID, 0, 1, \out, 0, \gain, 0.5);

/******************************************************************************************************************/

// BEAT //

(
s.sendMsg(\b_allocRead, 10, "/Users/haighton_imac/Documents/Audio/SAMPLES/DMDSB+MD Wav2496/DMDSB Wav2496/DMD2 Kicks/soft analog/dmd2_sanlgkck8.wav");
s.sendMsg(\b_allocRead, 11, "/Users/haighton_imac/Documents/Audio/SAMPLES/DMDSB+MD Wav2496/DMDSB Wav2496/DMD2 Unknown Electronic/german retro/dmd2_grmnrtro19.wav");
s.sendMsg(\b_allocRead, 12, "/Users/haighton_imac/Documents/Audio/SAMPLES/DMDSB+MD Wav2496/DMDSB Wav2496/DMD2 Unknown Electronic/clickish/dmd2_clicks25.wav");
s.sendMsg(\b_allocRead, 13, "/Users/haighton_imac/Documents/Audio/SAMPLES/DMDSB+MD Wav2496/DMDSB Wav2496/DMD2 Unknown Electronic/clickish/dmd2_clicks33.wav");
s.sendMsg(\b_allocRead, 14, "/Users/haighton_imac/Documents/Audio/SAMPLES/DMDSB+MD Wav2496/DMDSB Wav2496/DMD2 Percussion/shorty spice/dmd2_shrtspc8.wav");
s.sendMsg(\b_allocRead, 15, "/Users/haighton_imac/Documents/Audio/SAMPLES/DMDSB+MD Wav2496/DMDSB Wav2496/DMD2 Unknown Electronic/german retro/dmd2_grmnrtro1.wav");
s.sendMsg(\b_allocRead, 16,"/Users/haighton_imac/Documents/Audio/SAMPLES/DMDSB+MD Wav2496/DMDSB Wav2496/DMD2 Unknown Electronic/german retro/dmd2_grmnrtro8.wav");
s.sendMsg(\b_allocRead, 17,"/Users/haighton_imac/Documents/Audio/SAMPLES/DMDSB+MD Wav2496/DMDSB Wav2496/DMD2 Snares/really not snares/dmd2_notsnrs13.wav");
)

(
SynthDef(\sampler, {|out=0, sndbuf=10, atk=0.0001, sus=0.1, rel=0.1, lvl=1, gate=1, freq=1, startPos=0, startLoop=0, endLoop=1000, pos=0, gain=0.8, loop=0|
var source, env;
	env = EnvGen.kr(Env.linen(atk, sus, rel, lvl), gate, doneAction: 2);
	source = Select.ar(loop,
		[
		PlayBuf.ar(1, sndbuf, BufRateScale.kr(sndbuf) * freq, gate, startPos),
		LoopBuf.ar(1, sndbuf, BufRateScale.kr(sndbuf) * freq, gate, startPos, startLoop, endLoop, 4)
	]);
	Out.ar(out, Pan2.ar(env*source, pos, gain));
}).add;
)

TempoClock.default.tempo = 105/60;


(
x = Ptpar([
	//SNARE//
	0.025,
	Pbind(\instrument, \sampler, \out, 0,
		\sndbuf, 17,
		\freq, Pseq([
			Pseq([\rest, 2.0 ,\rest, 2.0, \rest, 2.0, \rest, 2.9], 7),
			Prand([\rest], 8)
	], inf),
		\lvl, 1,
		\loop, Pseq([
			Pn(0, 24),
			Pwrand([0, 1], [0.8, 0.1], 8)], inf),
		\endLoop, Pwhite(5000, 10000, inf),
		\startLoop, 1000

	),
	//PERC//
	0.03,
	Pbind(\instrument, \sampler, \out, 2,
		\sndbuf, Prand([11, 15, 16], inf),
		\freq, Pseq([
			Pn(\rest, 12),
			Prand([-1.5, 1.5, -0.5, 0.5, 1, 0.75, \rest], 4)
	], inf),
		\pos, Pwhite(-1.0, 1.0, inf),
		\lvl, Pwrand([0, 0.25, 0.5, 1], [0.5, 0.4, 0.1, 0.06], inf),
		\loop, Pwrand([0, 1], [0.9, 0.01], inf),
		\startLoop, 0,
		\endLoop, Pwhite(2000, 3000, inf),
		\dur, 0.25
	),
	//KICK//
	0,
	Pbind(\instrument, \sampler, \out, 4,
		\sndbuf, 10,
		\gain, 0.5,
		\freq, Pseq([
			Pseq([0.8, \rest, \rest, \rest, 0.8, \rest, \rest, \rest], 7),
			Pwrand([1, \rest], [0.3, 0.6], 8)
	], inf),
		\loop, 0,
		\pos, 0,
		\atk, 0.015,
		\lvl, Pseq([
			Pwhite(0.75, 0.9, 56),
			Pwhite(0.1, 0.45, 8)], inf),

		\rel, 0.3,
		\sus, 1,
		\dur, 0.25
	),
	//CLICKS//
	0.025,
	Pbind(\instrument, \sampler, \out, 6,
		\sndbuf, Pseq([12, 13, 14, 12], inf),
		\gain, 1,
		\atk, 0.0001,
		\lvl, Pwrand([0, 0.25, 0.5, 1], [0.7, 0.4, 0.1, 0.06], inf),
		\rel, 0.0001,
		\sus, 1,
		\pos, Pwhite(-0.6, 0.6, inf),
		\loop, Pwrand([1, 0], [0.04, 0.9], inf),
		\startLoop, 20,
		\endLoop, Pwhite(750000, 2000000, inf),
		\freq, Pwhite(1.0, 3.0, inf),
		\dur, 0.25
	)
], inf).play;
)

x.play;
x.stop;