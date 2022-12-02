% Steps Radial DVC calculations 
% Tracy compiled 02/14/20
% Edited by Cameron 12/26/20
%% 1. Crop images and select best sets
% % % % Step 1: 
% % % % use 'convert_multitiff_radialimagessequence.m' to convert all before and after sets 
% % % % view read all sets in Fiji , pick best before, 2nd best before and best after

%GO TO Fiji do contrast enhancements, then come back with the _3DCE files

%% indicate variables
LCnum='LC276';
bestbef1=1;         % best before set selection e.g.1
bestbef2=3;         % second best before set selection e.g.2
bestaft1=3;         % best after set selection e.g. 1
eye='LE';           % indicate left or ride side: e.g. 'LE'
r_space=5.81;       % r resolution, um/pixel
cc_thresh=0.055;    % cross correlation threshold

%% change directory 
% savepath=fullfile('/Users/tracy/Documents/JHU/Glaucoma/Radial DVC Matlab Scripts/Radial Images by LC/', 'LC174_nogamma');
% addpath('/Users/tracy/Documents/JHU/Glaucoma/Radial DVC Matlab Scripts/Matlab Analysis Directory auto/')
savepath=fullfile('/Users/cameron/Documents/MATLAB/Radial DVC Shared Documents/NewGoggles/', 'LC276');
addpath('/Users/cameron/Documents/MATLAB/Radial DVC Shared Documents/Matlab Analysis Directory auto/')
cd(savepath);
LCnum1=[LCnum 'L0'];
%% inpput manual tracings from excel
% %%%%%%%%%%%%%% summarize_by_manual_marks_Quadrants.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %  step 5a: import manual tracings
% % % uncomment this section once to add tracing information
BMO=[243	306.5	1
243.5	307.5	2
246	310.5	3
250	306	4
250	304	5
261	302	6
263	303	7
262	289	8
259.5	301.5	9
258.5	300	10
251	299	11
249	300	12
249.5	300.5	13
250	302.5	14
247	306	15
244	307.5	16
239.5	301.5	17
227	291.5	18
224.5	300	19
221.5	299	20
229.5	305	21
233.5	303.5	22
232	306.5	23
230.5	304	24
542	309.5	1
533	311.5	2
528	310.5	3
525	306.5	4
524.5	309	5
521.5	303.5	6
535.5	304	7
524.5	301	8
522.5	301	9
519.5	301	10
513	299	11
518	297	12
514.5	296.5	13
522	299	14
524	298.5	15
533.5	298	16
533	297.5	17
526	302	18
533	299	19
535.5	300	20
543.5	305	21
536	306	22
531	304	23
531	307	24];
BML=[2	267	1
17.5	270	1
33.5	271	1
50	272.5	1
65	275.5	1
80	277.5	1
96.5	281	1
112	283.5	1
127.5	286	1
145	290	1
161	292.5	1
177	295.5	1
195	299.5	1
210.5	303.5	1
224	308.5	1
237.5	308.5	1
2	266	2
18.5	269.5	2
37.5	271.5	2
56	273	2
74	276.5	2
93	279.5	2
109.5	282	2
127	286	2
143.5	288	2
157.5	290	2
174	293.5	2
192	297.5	2
208.5	302	2
220	307	2
231	310.5	2
238	309.5	2
3.5	268	3
20	271.5	3
38.5	272.5	3
53	274	3
70	276.5	3
86.5	279	3
103	281.5	3
119	284.5	3
135.5	288	3
152	290.5	3
166.5	293.5	3
183.5	297	3
199	301.5	3
213	306.5	3
227.5	309.5	3
240	311.5	3
1	266	4
19	268	4
37.5	271	4
58	274	4
77	277.5	4
101.5	280	4
125.5	283.5	4
147.5	287.5	4
170.5	291	4
192.5	295	4
212.5	300	4
231	305	4
244.5	308	4
3	267	5
21.5	269	5
40	270.5	5
58	273	5
79.5	276	5
97.5	279	5
117.5	282	5
137.5	285	5
164	287.5	5
182.5	291.5	5
201	296	5
219.5	302.5	5
231	308	5
244	306	5
2	267	6
19.5	268.5	6
38	270.5	6
57	273.5	6
74.5	276	6
94.5	277	6
114	279.5	6
134.5	281	6
155.5	285	6
175.5	288.5	6
193.5	291.5	6
211.5	294	6
224.5	303	6
237	307	6
253	305	6
2	267.5	7
19.5	268	7
37	270.5	7
56	271.5	7
74.5	274	7
93	276	7
110	278	7
127.5	279.5	7
147	282.5	7
164	285	7
181.5	287.5	7
199.5	291	7
215.5	295	7
233.5	302	7
245.5	306.5	7
257.5	305.5	7
3.5	268.167	8
16.833	268.167	8
33.833	268.5	8
49.5	269.833	8
65.167	271.833	8
80.167	273.5	8
96.5	275.5	8
117.167	277.167	8
135.167	280.833	8
150.167	282.167	8
166.5	285.5	8
180.833	286.167	8
196.833	289.167	8
209.167	292.5	8
222.833	296.833	8
232.5	293.5	8
243.5	291.167	8
257.167	290.167	8
1.167	267.5	9
16.833	268.833	9
34.5	269.833	9
49.833	270.833	9
63.167	271.833	9
78.833	273.5	9
94.833	275.833	9
109.167	276.833	9
123.5	278.167	9
139.833	280.5	9
157.167	284.167	9
173.5	286.5	9
188.833	287.833	9
205.5	290.5	9
220.833	295.833	9
233.833	301.5	9
243.5	303.5	9
255.5	302.833	9
1.833	268.167	10
17.833	268.5	10
34.5	270.167	10
52.5	269.833	10
69.833	272.167	10
86.167	273.167	10
102.5	274.5	10
120.833	276.5	10
138.5	278.5	10
154.833	280.5	10
173.167	283.5	10
193.167	286.833	10
207.833	290.833	10
223.833	294.833	10
236.167	302.167	10
247.5	305.167	10
255.167	301.833	10
3.5	267.833	11
16.167	267.833	11
29.833	268.167	11
45.167	269.167	11
62.5	270.167	11
78.167	271.833	11
92.5	272.5	11
104.833	273.5	11
119.5	274.833	11
132.167	276.5	11
146.167	277.833	11
161.833	279.167	11
176.833	282.833	11
189.167	284.5	11
203.5	287.5	11
215.167	291.167	11
227.167	296.167	11
236.167	301.5	11
245.5	303.167	11
1.5	267.833	12
17.833	268.167	12
33.5	268.833	12
45.5	269.167	12
61.167	271.167	12
76.5	271.167	12
91.833	272.167	12
108.167	273.167	12
123.167	275.833	12
138.167	276.167	12
152.5	278.833	12
168.5	281.5	12
181.833	283.5	12
195.833	284.833	12
208.5	287.5	12
221.167	290.167	12
229.833	295.833	12
235.5	302.167	12
245.167	302.833	12
1.167	267.5	13
15.167	268.167	13
30.5	268.833	13
43.167	269.5	13
58.167	270.833	13
70.5	271.167	13
83.167	272.5	13
94.167	273.5	13
105.833	274.5	13
118.167	275.5	13
130.5	277.167	13
142.833	278.5	13
155.167	278.833	13
169.167	280.5	13
181.5	282.5	13
193.167	284.167	13
205.5	285.833	13
215.167	289.167	13
224.5	293.5	13
231.833	298.167	13
238.833	302.833	13
246.167	302.833	13
5.5	268.5	14
17.833	268.167	14
32.833	268.5	14
45.167	269.5	14
58.167	270.5	14
69.5	271.167	14
80.5	272.167	14
95.5	273.5	14
112.167	275.167	14
124.833	276.5	14
138.5	277.167	14
152.167	278.167	14
162.167	279.5	14
173.5	281.5	14
184.167	283.5	14
196.833	286.833	14
210.5	288.167	14
222.167	291.833	14
228.5	297.833	14
236.833	303.167	14
245.833	304.167	14
2.5	267.833	15
16.5	268.5	15
31.5	269.5	15
46.5	270.5	15
61.833	271.167	15
75.833	272.167	15
91.167	273.5	15
106.833	275.167	15
122.167	275.833	15
135.833	276.167	15
150.167	278.5	15
164.167	280.833	15
178.5	282.833	15
191.167	284.5	15
202.833	287.167	15
213.167	290.167	15
223.833	295.167	15
233.167	299.167	15
242.833	306.167	15
1.833	268.833	16
15.833	268.167	16
30.833	268.833	16
43.167	269.833	16
55.833	270.833	16
68.167	271.833	16
81.167	273.5	16
94.833	275.167	16
107.5	276.5	16
121.167	277.5	16
133.833	278.5	16
148.833	280.5	16
161.167	281.5	16
174.833	283.5	16
187.5	285.5	16
201.5	288.167	16
212.5	292.833	16
224.833	299.167	16
234.833	307.167	16
4.5	269.167	17
21.5	269.167	17
35.167	269.833	17
50.833	270.833	17
65.833	272.167	17
80.5	273.167	17
96.167	275.167	17
113.167	276.833	17
127.167	278.167	17
141.167	280.5	17
156.167	282.833	17
168.167	284.167	17
183.5	286.167	17
197.5	287.833	17
210.833	291.5	17
223.5	297.833	17
234.167	301.5	17
2.167	262.5	18
17.833	263.833	18
34.5	263.833	18
50.833	265.5	18
68.167	267.5	18
83.833	269.5	18
101.5	270.5	18
116.5	272.833	18
133.5	274.5	18
149.5	277.833	18
163.833	279.5	18
178.833	281.167	18
191.833	283.833	18
203.5	285.5	18
214.833	289.167	18
222.833	292.167	18
2.5	267.167	19
16.5	268.5	19
31.5	268.5	19
47.833	270.833	19
61.5	271.833	19
75.5	272.833	19
91.833	274.833	19
108.833	277.167	19
123.833	278.5	19
139.167	281.167	19
153.833	283.167	19
169.833	285.167	19
183.167	287.833	19
197.833	290.5	19
209.833	294.167	19
220.5	299.833	19
1.833	265.167	20
18.833	267.833	20
34.5	271.167	20
49.833	272.167	20
66.833	273.5	20
83.5	274.833	20
101.833	278.167	20
118.167	280.5	20
133.5	282.5	20
151.167	285.5	20
165.5	286.167	20
180.167	289.167	20
194.167	291.833	20
210.167	295.833	20
217.833	298.5	20
1.167	267.5	21
19.5	268.5	21
37.833	271.5	21
52.5	274.167	21
69.167	274.833	21
84.5	277.167	21
102.167	279.5	21
116.167	280.833	21
131.5	283.5	21
147.833	285.5	21
163.167	288.5	21
180.167	291.167	21
196.833	295.833	21
210.833	300.5	21
222.833	305.5	21
1.833	266.167	22
15.167	267.833	22
29.5	268.5	22
41.833	270.833	22
54.5	272.833	22
71.167	275.5	22
85.5	277.5	22
99.833	279.833	22
112.5	281.833	22
127.5	283.5	22
142.5	286.167	22
152.833	286.833	22
163.167	288.833	22
174.833	291.5	22
186.833	293.833	22
202.167	297.5	22
214.833	299.833	22
225.167	301.5	22
1.167	266.167	23
15.833	267.167	23
33.5	268.833	23
49.167	271.5	23
66.833	274.167	23
81.5	276.833	23
96.833	278.5	23
114.5	280.833	23
128.167	283.167	23
143.5	284.833	23
157.833	287.167	23
173.833	291.167	23
187.833	293.833	23
200.833	296.833	23
213.833	299.833	23
224.5	304.5	23
1.833	265.5	24
15.833	267.833	24
30.833	270.167	24
44.833	271.5	24
58.5	273.833	24
73.833	275.5	24
88.5	277.167	24
101.5	277.5	24
118.167	280.167	24
133.833	283.833	24
144.833	285.167	24
156.5	286.167	24
169.167	288.5	24
182.833	291.833	24
193.833	294.833	24
205.167	297.167	24
214.5	300.167	24
226.167	303.5	24];
BMR=[545.833	310.167	1
551.5	304.167	1
563.167	300.167	1
572.167	297.167	1
583.833	293.167	1
596.167	290.833	1
608.5	288.5	1
619.167	286.5	1
630.167	284.833	1
641.833	282.5	1
654.5	280.833	1
667.5	280.167	1
680.833	277.167	1
692.5	275.833	1
708.167	273.5	1
719.833	271.833	1
728.833	271.5	1
739.5	269.5	1
751.5	267.167	1
764.5	265.833	1
536.833	311.5	2
544.5	307.167	2
554.833	303.5	2
563.5	298.167	2
576.167	295.5	2
588.833	291.5	2
601.167	288.5	2
613.5	286.167	2
626.167	284.5	2
638.5	282.833	2
651.167	281.167	2
663.833	279.167	2
675.5	277.5	2
685.833	276.833	2
697.167	274.5	2
708.5	272.5	2
719.833	271.5	2
731.167	269.833	2
742.5	268.5	2
753.833	266.167	2
762.167	265.167	2
531.5	310.833	3
539.5	304.833	3
551.5	300.5	3
562.833	297.833	3
573.167	294.5	3
583.5	293.167	3
594.833	291.167	3
606.167	288.833	3
618.167	286.167	3
631.833	285.167	3
642.833	283.5	3
656.5	281.167	3
668.5	279.833	3
680.5	278.5	3
692.167	275.833	3
706.167	273.167	3
718.833	273.167	3
730.5	271.5	3
741.833	269.833	3
754.5	268.5	3
764.833	266.167	3
529.5	305.5	4
541.167	304.167	4
553.833	300.167	4
567.833	295.167	4
583.5	291.5	4
597.167	288.5	4
612.167	285.833	4
624.167	284.5	4
639.167	282.5	4
654.833	280.167	4
666.5	278.5	4
678.833	277.833	4
693.167	275.167	4
706.167	273.167	4
718.833	272.167	4
729.833	270.167	4
741.167	268.833	4
752.833	267.833	4
764.167	265.833	4
528.5	308.833	5
540.167	303.5	5
552.5	296.5	5
566.167	293.5	5
579.833	291.833	5
592.833	289.5	5
606.167	286.5	5
619.833	284.167	5
631.5	283.167	5
646.167	281.167	5
659.167	279.833	5
672.833	278.167	5
688.833	275.167	5
704.5	273.833	5
718.5	272.167	5
731.167	271.167	5
743.5	268.833	5
755.5	267.167	5
764.833	265.833	5
526.5	304.833	6
539.833	300.833	6
555.5	296.167	6
570.5	290.833	6
582.5	289.167	6
596.5	288.5	6
613.5	283.833	6
630.5	281.5	6
645.833	279.167	6
659.833	278.167	6
674.167	276.833	6
687.167	275.5	6
701.833	273.5	6
715.5	273.5	6
728.833	272.167	6
743.5	270.167	6
756.167	267.833	6
765.167	265.167	6
539.167	303.5	7
547.833	299.167	7
559.833	294.833	7
573.167	292.5	7
586.833	289.5	7
598.5	288.5	7
610.167	287.5	7
623.5	284.5	7
636.5	282.833	7
650.5	281.167	7
663.167	279.5	7
673.5	276.833	7
685.5	276.167	7
699.5	275.833	7
713.5	274.5	7
726.167	271.5	7
738.167	270.833	7
750.833	269.5	7
763.5	268.167	7
528.167	302.5	8
537.833	299.5	8
550.167	296.833	8
563.167	292.5	8
577.5	289.833	8
591.5	286.833	8
602.833	285.5	8
617.833	283.5	8
629.5	282.167	8
645.833	280.167	8
662.167	278.833	8
676.5	276.5	8
689.167	276.167	8
703.5	273.5	8
718.833	272.833	8
733.167	270.833	8
747.167	268.5	8
761.833	267.5	8
527.167	302.167	9
544.833	297.5	9
560.833	291.5	9
575.833	288.833	9
591.5	287.167	9
606.167	285.833	9
621.5	283.5	9
636.167	280.5	9
649.833	279.5	9
664.167	279.167	9
676.833	277.167	9
689.833	276.5	9
702.833	274.833	9
719.167	272.167	9
734.833	270.833	9
746.5	270.833	9
758.833	269.833	9
525.833	301.5	10
538.167	298.5	10
550.167	293.5	10
565.5	290.167	10
582.167	286.833	10
600.5	285.5	10
616.5	283.5	10
632.5	281.833	10
648.5	279.167	10
663.5	278.833	10
679.167	276.167	10
693.833	274.167	10
707.833	273.5	10
719.833	272.833	10
735.5	271.167	10
750.167	270.167	10
763.167	268.5	10
516.833	299.167	11
530.167	296.833	11
543.833	293.833	11
558.5	291.833	11
574.833	287.833	11
589.167	285.5	11
603.5	284.167	11
619.833	282.5	11
634.167	281.5	11
649.833	279.833	11
668.167	277.833	11
684.833	275.833	11
701.833	274.167	11
717.833	273.5	11
735.5	272.167	11
750.833	270.5	11
764.5	268.833	11
522.167	296.5	12
540.5	295.167	12
557.833	292.167	12
576.833	288.833	12
595.5	286.167	12
615.5	284.167	12
631.167	282.833	12
647.167	279.833	12
663.5	279.167	12
679.167	277.5	12
694.167	275.5	12
708.167	273.5	12
725.5	272.5	12
738.833	271.833	12
752.5	270.5	12
764.5	269.167	12
519.833	295.5	13
531.167	296.167	13
545.167	293.833	13
558.167	291.167	13
573.167	288.833	13
587.833	287.167	13
602.5	285.5	13
615.833	284.167	13
630.5	282.833	13
645.833	280.833	13
660.167	279.5	13
675.167	277.833	13
691.833	276.167	13
708.5	274.5	13
726.5	273.167	13
743.167	271.5	13
755.833	269.833	13
764.167	268.833	13
526.167	301.167	14
535.167	299.833	14
545.833	295.5	14
559.833	293.833	14
574.5	291.167	14
591.5	287.833	14
607.167	287.5	14
624.833	285.5	14
639.5	283.5	14
653.833	282.167	14
669.833	280.167	14
685.167	278.833	14
699.167	277.167	14
714.5	276.833	14
730.5	274.167	14
745.5	272.833	14
759.167	271.5	14
528.5	299.167	15
543.167	296.833	15
558.833	296.167	15
572.833	293.833	15
583.5	290.833	15
598.833	288.167	15
613.5	286.833	15
627.833	285.5	15
638.833	284.833	15
650.5	284.167	15
665.833	282.167	15
682.167	280.167	15
696.5	278.167	15
712.5	277.167	15
727.167	276.833	15
739.167	275.167	15
752.167	272.5	15
761.833	271.833	15
538.167	299.167	16
551.833	297.833	16
565.167	294.833	16
580.167	292.5	16
595.167	289.833	16
612.167	288.167	16
626.167	285.5	16
642.167	284.5	16
656.5	282.167	16
670.5	280.167	16
683.5	279.5	16
698.833	277.833	16
714.167	275.167	16
728.833	273.833	16
740.833	272.833	16
755.833	270.833	16
540.167	299.167	17
555.833	297.5	17
570.833	292.833	17
585.167	290.167	17
600.833	288.5	17
617.167	286.167	17
632.5	284.5	17
647.5	282.167	17
663.167	280.167	17
678.167	278.833	17
694.167	276.5	17
705.167	275.5	17
716.167	274.5	17
726.5	272.167	17
737.167	270.833	17
749.833	270.167	17
761.5	269.167	17
532.5	302.5	18
542.833	298.167	18
554.167	296.167	18
567.167	294.5	18
579.833	292.167	18
593.833	288.833	18
607.833	286.167	18
620.167	285.5	18
634.167	282.833	18
648.5	281.833	18
660.5	280.5	18
670.167	277.833	18
681.833	276.833	18
694.833	275.833	18
705.833	274.5	18
715.833	273.167	18
728.167	271.167	18
737.5	270.833	18
748.167	269.167	18
758.167	268.167	18
765.5	267.167	18
537.167	300.5	19
550.833	301.833	19
562.833	298.5	19
575.5	294.833	19
589.833	293.5	19
601.5	290.833	19
614.167	288.833	19
627.5	286.167	19
641.833	284.5	19
655.167	283.5	19
670.167	280.5	19
684.833	278.167	19
699.5	275.5	19
712.5	274.167	19
726.833	273.167	19
739.167	271.167	19
750.833	269.5	19
761.167	266.833	19
539.167	301.833	20
550.167	303.167	20
563.833	298.5	20
579.5	296.5	20
594.5	293.167	20
611.167	289.167	20
628.167	286.833	20
643.833	283.833	20
659.167	281.167	20
675.5	279.5	20
691.167	277.167	20
703.167	276.167	20
717.5	273.833	20
730.5	272.833	20
741.833	270.833	20
752.833	268.167	20
763.833	265.5	20
548.167	303.833	21
562.167	301.833	21
578.5	298.833	21
592.833	296.833	21
607.5	294.167	21
622.167	291.5	21
635.833	289.833	21
650.167	287.5	21
664.167	283.833	21
678.167	281.167	21
691.5	279.833	21
703.167	278.5	21
715.833	275.833	21
726.167	273.833	21
738.5	271.833	21
753.833	270.5	21
765.167	268.5	21
541.167	306.833	22
553.167	303.833	22
568.167	300.833	22
581.833	297.833	22
595.167	295.5	22
608.5	293.167	22
624.5	290.167	22
640.833	288.833	22
655.167	287.167	22
669.833	284.167	22
682.167	280.833	22
693.833	279.167	22
706.833	277.5	22
717.167	275.833	22
728.167	273.5	22
738.833	271.833	22
749.167	270.833	22
760.167	268.833	22
535.167	305.5	23
546.167	305.5	23
559.167	302.167	23
569.167	298.5	23
579.167	295.5	23
589.167	293.833	23
600.167	292.167	23
611.167	290.167	23
620.5	288.167	23
630.833	285.167	23
641.833	283.833	23
652.5	282.167	23
663.5	280.5	23
673.5	278.833	23
685.5	276.833	23
697.167	274.833	23
706.5	274.5	23
716.833	272.167	23
727.833	270.167	23
739.167	268.5	23
747.833	266.5	23
757.5	264.5	23
536.167	308.167	24
547.167	308.167	24
561.167	304.5	24
572.5	299.167	24
586.5	295.833	24
601.833	294.167	24
614.5	290.833	24
625.167	288.833	24
639.167	286.5	24
652.833	283.833	24
665.833	282.5	24
678.833	280.833	24
690.833	278.5	24
702.833	275.5	24
714.5	273.833	24
726.833	272.167	24
738.5	270.833	24
749.833	269.167	24
761.833	267.5	24];
ALC=[250	337.5	1
256.5	349	1
264.5	361	1
275.5	377	1
291	391	1
313	399	1
332.5	402.5	1
355	403	1
376.5	404.5	1
392.5	401.5	1
406	401.5	1
424	402.5	1
444.5	402	1
464	402	1
480	402	1
497	401	1
509.5	401	1
521.5	401	1
530.5	397	1
537	394	1
250.5	367	2
254	384.5	2
256.5	400	2
264.5	412	2
279	416.5	2
293.5	416.5	2
309.5	415.5	2
322.5	412.5	2
338.5	406	2
350	403.5	2
365.5	403	2
380	404	2
394	403.5	2
407.5	402.5	2
424.5	403.5	2
440	404	2
458	401.5	2
472.5	401.5	2
488	402	2
504	401.5	2
518	401.5	2
531.5	399	2
535.5	391.5	2
257	406.5	3
267	411	3
277	412	3
287.5	410.5	3
298.5	411	3
312	415.5	3
322.5	410.5	3
332	404.5	3
348	402.5	3
358	399.5	3
366	401	3
378.5	400.5	3
390	400	3
402	399	3
417	396.5	3
429.5	396	3
442.5	399.5	3
455	399	3
469	398	3
482.5	396.5	3
496	393.5	3
506.5	392.5	3
516.5	389	3
523	387.5	3
531.5	383.5	3
273	397	4
278	400.5	4
289.5	405.5	4
302	410.5	4
312.5	413	4
326	412.5	4
337	407	4
347.5	401	4
360.5	396.5	4
375.5	396.5	4
392.5	396	4
408	394	4
422.5	392.5	4
437	389.5	4
457.5	387.5	4
472.5	388.5	4
483.5	389	4
496	386.5	4
505	379	4
514	369.5	4
523	366	4
259.5	394	5
270	395.5	5
287	395	5
305	396.5	5
327	396.5	5
348.5	395.5	5
370	396	5
388.5	396	5
407.5	395	5
424	393.5	5
441.5	391.5	5
461.5	386.5	5
476	385	5
490.5	383.5	5
503	377	5
514.5	371	5
274	385	6
285.5	389	6
302	389.5	6
320	393.5	6
338	397	6
356	395	6
369	391.5	6
384	392	6
399.5	386.5	6
416.5	384.5	6
432.5	384.5	6
446.5	384	6
459.5	384	6
474.5	383	6
487.5	379.5	6
499.5	374.5	6
507.5	365.5	6
512.5	356	6
286.5	388	7
300.5	389	7
316	389	7
334.5	388.5	7
350.5	387.5	7
367	382.5	7
390.5	381.5	7
410	380	7
425	381.5	7
440.5	381.5	7
457	380	7
480.5	377	7
494.5	369	7
503.5	359.5	7
512.5	344	7
518.5	333	7
525.5	325	7
531	315.5	7
276.5	386.5	8
292.5	387.5	8
307	389	8
323	388.5	8
340	388.5	8
360.5	390	8
381	389	8
393.5	389	8
415.5	384	8
430	381	8
446	376	8
463.5	375.5	8
478.5	374	8
491	369	8
503.5	364.5	8
511	355.5	8
514	345.5	8
517	334.5	8
522.5	319.5	8
273	383	9
283	385	9
293	385	9
305.5	386	9
319	385.5	9
335	385.5	9
350	385.5	9
363	385	9
378.5	382.5	9
391.5	380.5	9
403.5	381	9
415	376.5	9
428	376	9
437.5	374.5	9
451	373	9
466	371.5	9
475	365.5	9
483.5	360.5	9
492.5	351.5	9
500.5	344	9
507	335.5	9
512.5	324.5	9
517	316.5	9
521.5	310.5	9
268.5	374	10
288.5	380.5	10
303	380.5	10
320	382	10
337.5	386	10
357	386	10
371.5	384	10
385	384	10
401	383.5	10
412	381.5	10
418	377.5	10
428.5	374.5	10
446.5	367.5	10
461	364.5	10
473	358.5	10
480	349.5	10
488.5	343.5	10
500.5	332.5	10
509	324.5	10
515.5	315	10
265.5	372	11
274	379	11
287.5	381	11
299.5	378	11
321	377	11
337	378.5	11
351	379	11
368	380	11
382	380	11
394	380.5	11
407.5	374	11
424.5	374	11
438.5	376	11
451	375	11
461.5	366	11
474	361	11
483.5	352.5	11
489	342	11
497	333	11
502	320	11
507	311.5	11
269.5	377.5	12
280	378.5	12
292	376.5	12
302	377	12
331.5	372.5	12
345.5	374	12
359.5	374	12
373	374	12
391	375	12
411	374.5	12
428	370	12
441	370.5	12
455.5	370.5	12
471.5	365	12
483	359	12
489.5	349	12
495	338	12
502.5	327.5	12
508	318.5	12
512.5	312.5	12
516.5	307	12
262.5	378.5	13
272	379.5	13
285.5	378.5	13
295	379	13
305.5	379	13
339.5	378.5	13
349.5	374.5	13
360.5	370.5	13
373	367.5	13
383	369.5	13
394	370	13
406	371.5	13
419.5	371.5	13
430	368	13
441	368.5	13
454	368.5	13
467	363.5	13
480	355	13
490.5	342.5	13
500	330.5	13
504.5	322.5	13
510.5	314.5	13
514	306.5	13
264.5	384.5	14
276.5	382.5	14
286	381.5	14
297	379	14
305.5	379.5	14
340	382	14
351	379	14
361	374	14
372	369.5	14
385.5	370	14
399	373	14
417	373	14
432.5	372.5	14
447.5	367	14
467	360.5	14
480	354	14
489.5	349	14
499.5	339.5	14
508.5	328	14
515	318.5	14
518	311	14
268	378	15
277	379	15
284.5	379	15
293	378.5	15
303	374.5	15
308.5	377	15
345	380.5	15
353	378	15
366	372.5	15
380	370.5	15
391.5	375	15
406	375	15
418.5	374	15
432.5	373	15
447	371	15
463	366	15
479	365	15
489.5	360	15
496	351.5	15
500.5	340.5	15
508.5	330	15
516	320	15
524	311	15
251	386	16
262	388	16
272	388	16
286	387.5	16
296	386	16
303.5	385.5	16
345	387	16
357	380.5	16
371	380.5	16
387.5	376	16
403	373	16
411.5	371	16
423.5	365.5	16
439.5	365	16
454	366.5	16
471	365	16
490.5	359.5	16
498	354	16
503	345.5	16
511.5	330.5	16
521	317	16
529	309.5	16
258.5	394.5	17
267.5	392	17
279	388.5	17
290	383.5	17
299	383.5	17
342	375	17
350.5	372.5	17
370	367.5	17
384.5	366	17
403	366	17
417.5	366.5	17
433	367	17
447.5	368	17
469	367.5	17
486.5	360.5	17
497	351.5	17
505.5	342	17
513.5	331	17
523.5	321	17
530.5	311.5	17
329	405	18
349	398	18
363	389	18
384	387	18
405	400	18
427	402	18
448	401	18
467	395	18
479	388	18
250	400	19
265	399	19
278	400	19
294	399	19
326	390	19
352	384	19
376	384	19
395	387	19
412	389	19
427	391	19
452	387	19
470	382	19
482	381	19
500	378	19
512	378	19
242	399	20
256	399	20
271	400	20
281	403	20
322	394	20
342	392	20
358	391	20
374	393	20
391	392	20
414	389	20
434	387	20
447	388	20
466	384	20
482	385	20
496	387	20
245	406	21
254	408	21
267	408	21
320	399	21
334	397	21
348	396	21
364	396	21
380	396	21
396	396	21
413	395	21
427	393	21
441	390	21
451	390	21
465	387	21
481	389	21
490	391	21
510	391	21
522	385	21
269	406	22
283	406	22
301	405	22
316	406	22
328	408	22
341	409	22
356	405	22
372	397	22
382	398	22
396	399	22
414	403	22
428	403	22
443	403	22
460	403	22
477	401	22
490	399	22
501	396	22
248	405	23
262	405	23
278	402	23
296	399	23
312	399	23
330	408	23
345	409	23
364	408	23
376	401	23
395	402	23
416	408	23
434	410	23
452	408	23
469	408	23
482	403	23
501	403	23
504	389	23
510	373	23
514	361	23
520	349	23
527	337	23
532	327	23
258	401	24
275	401	24
290	401	24
307	401	24
324	403	24
341	407	24
355	409	24
371	405	24
382	402	24
398	401	24
412	401	24
427	401	24
446	402	24
462	402	24
478	399	24
494	396	24
508	396	24
513	385	24
516	371	24
520	356	24
526	341	24
532	327	24];
CSL=[6	304	1
25	307	1
40	312	1
66	315	1
88	318	1
112	319	1
131	319	1
151	323	1
170	328	1
187	331	1
200	330	1
215	330	1
230	330	1
4	309	2
21	311	2
40	311	2
63	317	2
88	321	2
108	322	2
128	325	2
146	328	2
166	331	2
187	336	2
200	336	2
217	335	2
230	332	2
10	306	3
24	312	3
40	319	3
58	325	3
79	326	3
102	328	3
122	329	3
138	330	3
155	333	3
177	335	3
194	337	3
211	337	3
222	329	3
4	311	4
13	311	4
30	311	4
50	317	4
74	325	4
97	328	4
119	330	4
136	331	4
152	331	4
170	331	4
190	331	4
204	329	4
213	322	4
222	311	4
6	308	5
21	312	5
38	318	5
60	324	5
84	325	5
109	330	5
134	331	5
155	331	5
176	331	5
202	328	5
212	322	5
226	319	5
4	298	6
18	299	6
40	309	6
64	315	6
92	317	6
118	327	6
151	331	6
176	329	6
188	323	6
205	325	6
218	321	6
228	319	6
7	317	7
24	314	7
42	315	7
68	317	7
96	319	7
120	325	7
145	326	7
169	330	7
198	331	7
216	331	7
226	321	7
242	323	7
6	320	8
20	317	8
38	316	8
60	321	8
80	323	8
102	319	8
127	320	8
156	319	8
170	316	8
189	320	8
206	326	8
226	331	8
243	323	8
262	322	8
10	321	9
26	327	9
48	327	9
68	327	9
87	329	9
114	331	9
138	331	9
157	325	9
173	322	9
187	317	9
210	316	9
223	314	9
4	323	10
20	323	10
41	323	10
66	327	10
89	329	10
114	331	10
138	331	10
165	329	10
184	326	10
202	318	10
218	315	10
233	313	10
6	322	11
19	323	11
34	327	11
54	326	11
68	328	11
86	331	11
98	331	11
118	331	11
135	334	11
160	326	11
183	328	11
198	329	11
209	323	11
216	316	11
230	313	11
4	319	12
20	321	12
37	331	12
52	327	12
68	325	12
83	327	12
99	336	12
124	340	12
146	334	12
163	332	12
182	332	12
200	325	12
214	327	12
224	319	12
6	325	13
31	326	13
40	326	13
62	326	13
90	327	13
111	328	13
128	337	13
148	336	13
168	335	13
185	329	13
204	322	13
219	318	13
234	313	13
14	322	14
30	323	14
52	323	14
70	323	14
91	325	14
115	328	14
142	325	14
164	325	14
182	326	14
205	327	14
221	321	14
235	315	14
7	315	15
32	321	15
56	321	15
83	321	15
116	321	15
136	319	15
162	317	15
187	311	15
208	311	15
234	313	15
8	317	16
30	317	16
51	315	16
68	315	16
90	315	16
112	314	16
134	315	16
158	313	16
186	314	16
210	312	16
228	312	16
4	315	17
16	327	17
32	330	17
51	328	17
69	323	17
86	315	17
100	311	17
116	303	17
139	303	17
154	303	17
170	301	17
185	301	17
196	302	17
206	310	17
218	315	17
226	315	17
10	306	18
27	317	18
50	316	18
72	316	18
98	317	18
120	321	18
144	327	18
165	330	18
193	327	18
204	319	18
216	314	18
228	307	18
6	327	19
21	331	19
42	332	19
61	333	19
79	329	19
98	319	19
115	315	19
131	317	19
156	315	19
184	315	19
202	317	19
216	316	19
5	334	20
26	332	20
42	332	20
67	332	20
94	331	20
122	331	20
148	331	20
170	334	20
189	336	20
201	325	20
216	319	20
5	329	21
20	329	21
38	329	21
68	329	21
91	327	21
118	325	21
140	323	21
162	327	21
180	329	21
200	327	21
214	326	21
224	323	21
2	313	22
24	317	22
44	318	22
65	319	22
85	317	22
100	319	22
123	327	22
142	327	22
158	325	22
181	320	22
210	320	22
227	320	22
237	316	22
4	330	23
19	331	23
36	332	23
48	334	23
70	331	23
90	327	23
116	325	23
136	323	23
162	324	23
186	326	23
205	325	23
218	323	23
227	317	23
4	307	24
22	309	24
44	312	24
68	319	24
86	316	24
111	313	24
130	315	24
154	315	24
172	319	24
192	319	24
213	319	24
230	319	24];
CSR=[553	317	1
563	323	1
581	328	1
599	328	1
618	328	1
639	328	1
661	327	1
680	321	1
699	325	1
721	326	1
739	322	1
755	322	1
761	321	1
548	325	2
564	328	2
582	330	2
606	340	2
635	340	2
653	333	2
675	335	2
694	337	2
719	338	2
736	336	2
756	334	2
543	328	3
566	340	3
590	336	3
616	336	3
637	338	3
660	338	3
677	329	3
694	330	3
720	331	3
744	327	3
759	324	3
546	325	4
563	339	4
580	343	4
599	338	4
616	330	4
635	325	4
654	318	4
674	316	4
698	315	4
716	315	4
732	312	4
751	311	4
760	311	4
539	324	5
555	331	5
574	332	5
594	333	5
616	331	5
637	328	5
656	324	5
677	320	5
697	320	5
720	321	5
735	316	5
754	313	5
767	307	5
545	317	6
573	318	6
591	316	6
619	308	6
646	304	6
670	304	6
695	308	6
722	312	6
746	308	6
762	298	6
549	318	7
564	315	7
580	321	7
612	328	7
642	328	7
663	322	7
680	316	7
696	312	7
715	312	7
739	312	7
756	308	7
763	308	7
538	328	8
550	336	8
567	336	8
590	335	8
611	333	8
633	330	8
654	327	8
674	324	8
696	324	8
716	326	8
736	326	8
754	324	8
765	322	8
541	318	9
556	319	9
571	324	9
591	324	9
613	324	9
632	324	9
651	325	9
670	325	9
689	325	9
708	322	9
724	322	9
744	321	9
759	321	9
552	314	10
578	312	10
606	314	10
635	314	10
661	316	10
680	316	10
701	314	10
722	320	10
743	326	10
756	336	10
540	314	11
560	316	11
573	320	11
595	321	11
612	322	11
631	322	11
654	322	11
668	319	11
687	322	11
701	319	11
723	318	11
740	318	11
758	316	11
535	314	12
553	316	12
563	317	12
585	317	12
600	317	12
619	320	12
643	324	12
666	321	12
687	324	12
700	324	12
718	322	12
734	326	12
747	326	12
761	328	12
530	323	13
550	331	13
567	327	13
577	317	13
597	316	13
618	316	13
635	319	13
658	320	13
680	316	13
693	318	13
712	316	13
730	322	13
747	321	13
763	318	13
546	320	14
560	315	14
584	316	14
606	318	14
626	317	14
649	317	14
672	317	14
692	319	14
710	322	14
730	322	14
744	323	14
757	325	14
534	328	15
551	342	15
574	344	15
598	344	15
620	339	15
632	338	15
653	338	15
678	338	15
696	340	15
730	341	15
750	340	15
760	340	15
542	331	16
566	328	16
587	320	16
606	320	16
628	320	16
648	320	16
674	320	16
694	318	16
715	320	16
732	324	16
747	323	16
758	322	16
539	333	17
560	327	17
576	324	17
594	320	17
614	318	17
632	318	17
657	315	17
676	317	17
696	312	17
718	312	17
732	314	17
748	312	17
764	310	17
555	322	18
582	318	18
607	321	18
630	321	18
651	316	18
672	314	18
695	308	18
715	308	18
738	306	18
760	306	18
556	328	19
572	325	19
594	321	19
614	316	19
639	316	19
660	314	19
680	312	19
704	307	19
728	307	19
746	301	19
761	296	19
558	320	20
573	326	20
601	326	20
631	322	20
662	316	20
694	312	20
718	310	20
740	306	20
757	298	20
548	319	21
557	330	21
578	330	21
599	330	21
628	328	21
654	321	21
677	317	21
698	309	21
724	306	21
744	304	21
760	301	21
546	322	22
562	331	22
583	326	22
604	326	22
626	326	22
646	324	22
667	323	22
688	318	22
711	312	22
734	308	22
746	306	22
762	300	22
552	322	23
573	322	23
596	322	23
614	320	23
630	314	23
648	311	23
669	311	23
693	310	23
714	310	23
730	312	23
747	312	23
761	316	23
554	324	24
577	330	24
593	332	24
610	328	24
631	327	24
647	327	24
666	324	24
686	317	24
705	317	24
721	317	24
738	312	24
754	308	24
764	306	24];
save(fullfile(savepath,[LCnum1 '-dividers.mat']),'BMO','BML','BMR','ALC','CSL','CSR')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Step 2-5b
% If you only want to rerun step 4 and 5
% update the function name to runRDVC_s45
% If you only want to rerun step 5
% update the function name to runRDVC_s5

runRDVC(LCnum1,bestbef1,bestbef2,bestaft1,eye,r_space,cc_thresh)



%% step 5c generate final plots
%  step 5c: Generate plots
sumname=fullfile(savepath, ['HOCT-' LCnum1 '-Strains-SegmentedAndSummarized.mat']);
load(sumname)
ss = 0.0501; % strain plotting range -ss to +ss
sd = 15;     % displacement plotting range -sd to +sd
title_opt = 1;
run('plot_NT_IS_DispStrain_Segmentation_Overlay.m')
run('plot_polarcircle_data.m')