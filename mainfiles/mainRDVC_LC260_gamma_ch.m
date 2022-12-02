% Steps Radial DVC calculations 
% Tracy compiled 02/14/20
% Edited by Cameron 12/26/20
%% 1. Crop images and select best sets
% % % % Step 1: 
% % % % use 'convert_multitiff_radialimagessequence.m' to convert all before and after sets 
% % % % view read all sets in Fiji , pick best before, 2nd best before and best after

%GO TO Fiji do contrast enhancements, then come back with the _3DCE files

%% indicate variables
LCnum='LC260';
bestbef1=1;         % best before set selection e.g.1
bestbef2=2;         % second best before set selection e.g.2
bestaft1=3;         % best after set selection e.g. 1
eye='LE';           % indicate left or ride side: e.g. 'LE'
r_space=6.27;       % r resolution, um/pixel
cc_thresh=0.055;    % cross correlation threshold

%% change directory 
% savepath=fullfile('/Users/tracy/Documents/JHU/Glaucoma/Radial DVC Matlab Scripts/Radial Images by LC/', 'LC174_nogamma');
% addpath('/Users/tracy/Documents/JHU/Glaucoma/Radial DVC Matlab Scripts/Matlab Analysis Directory auto/')
savepath=fullfile('/Users/cameron/Documents/MATLAB/Radial DVC Shared Documents/Eyes/', 'LC260_gamma');
addpath('/Users/cameron/Documents/MATLAB/Radial DVC Shared Documents/Matlab Analysis Directory auto/')
cd(savepath);
LCnum1=[LCnum 'L0'];
%% inpput manual tracings from excel
% %%%%%%%%%%%%%% summarize_by_manual_marks_Quadrants.m %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %  step 5a: import manual tracings
% % uncomment this section once to add tracing information
% BMO=[254	217	1
% 260.5	219.5	2
% 264.5	221.5	3
% 267.5	220.5	4
% 270	223.5	5
% 272.5	225	6
% 273	229.5	7
% 272.5	228	8
% 270	225.5	9
% 270	224.5	10
% 241.5	206.5	11
% 244.5	206	12
% 248.5	206.5	13
% 257	197	14
% 256.5	195	15
% 256	191.5	16
% 253	187	17
% 247	187	18
% 250	185.5	19
% 244	184.5	20
% 250	184.5	21
% 244	184	22
% 244	187	23
% 243.5	186	24
% 500	205	1
% 523.5	183	2
% 507	210.5	3
% 506	202.5	4
% 490	226.5	5
% 491.5	224	6
% 490	228	7
% 489.5	223	8
% 491.5	222	9
% 490.5	219	10
% 494.5	212.5	11
% 496.5	213.5	12
% 498.5	210	13
% 500	211.5	14
% 505.5	208.5	15
% 510	211	16
% 511	209	17
% 513	211.5	18
% 516	212	19
% 517.5	213	20
% 522	210.5	21
% 519.5	213	22
% 523	213.5	23
% 521	209.5	24];
% BML=[2	167	1
% 12	169	1
% 21	171	1
% 34	173	1
% 47	176	1
% 56	177	1
% 67	178	1
% 78	182	1
% 91	183	1
% 103	184	1
% 114	186	1
% 128	188	1
% 141	192	1
% 152	193	1
% 166	194	1
% 180	199	1
% 194	202	1
% 207	204	1
% 220	209	1
% 234	215	1
% 245	220	1
% 2	167	2
% 11	169	2
% 22	172	2
% 34	174	2
% 49	176	2
% 64	177	2
% 79	181	2
% 94	182	2
% 107	184	2
% 123	186	2
% 137	189	2
% 152	193	2
% 165	197	2
% 180	200	2
% 193	202	2
% 205	202	2
% 218	208	2
% 228	214	2
% 243	220	2
% 3	166	3
% 14	169	3
% 28	170	3
% 44	171	3
% 59	174	3
% 75	177	3
% 86	180	3
% 103	183	3
% 113	186	3
% 129	188	3
% 140	190	3
% 154	194	3
% 168	196	3
% 180	200	3
% 191	202	3
% 203	206	3
% 214	208	3
% 224	211	3
% 237	216	3
% 250	222	3
% 4	169	4
% 15	171	4
% 36	173	4
% 52	174	4
% 69	176	4
% 85	180	4
% 102	184	4
% 116	186	4
% 135	190	4
% 151	193	4
% 166	195	4
% 180	200	4
% 197	202	4
% 210	204	4
% 221	206	4
% 234	212	4
% 244	219	4
% 254	222	4
% 3	168	5
% 14	170	5
% 30	172	5
% 44	172	5
% 59	173	5
% 74	176	5
% 86	178	5
% 100	184	5
% 112	186	5
% 127	188	5
% 140	189	5
% 154	194	5
% 167	197	5
% 178	200	5
% 191	202	5
% 204	204	5
% 216	208	5
% 229	212	5
% 241	218	5
% 247	224	5
% 256	226	5
% 2	169	6
% 12	169	6
% 28	172	6
% 40	172	6
% 51	174	6
% 64	176	6
% 77	177	6
% 91	181	6
% 102	184	6
% 117	186	6
% 127	189	6
% 140	193	6
% 155	196	6
% 168	198	6
% 182	202	6
% 196	203	6
% 206	206	6
% 218	208	6
% 232	215	6
% 246	222	6
% 257	228	6
% 2	170	7
% 14	171	7
% 30	172	7
% 43	174	7
% 59	175	7
% 74	177	7
% 90	181	7
% 105	184	7
% 118	188	7
% 135	192	7
% 150	196	7
% 162	199	7
% 176	202	7
% 188	204	7
% 200	206	7
% 214	212	7
% 230	217	7
% 239	225	7
% 250	230	7
% 261	230	7
% 2	170	8
% 12	170	8
% 26	171	8
% 40	172	8
% 54	174	8
% 69	173	8
% 82	178	8
% 94	181	8
% 108	184	8
% 123	188	8
% 135	189	8
% 146	191	8
% 158	196	8
% 169	198	8
% 185	200	8
% 200	204	8
% 215	208	8
% 226	216	8
% 236	222	8
% 246	229	8
% 259	230	8
% 4	171	9
% 17	170	9
% 29	170	9
% 41	172	9
% 58	172	9
% 72	172	9
% 86	175	9
% 99	178	9
% 114	182	9
% 130	186	9
% 144	190	9
% 160	192	9
% 173	198	9
% 189	203	9
% 205	202	9
% 220	207	9
% 231	214	9
% 240	219	9
% 251	227	9
% 262	229	9
% 3	170	10
% 13	171	10
% 25	170	10
% 40	172	10
% 58	171	10
% 75	172	10
% 92	174	10
% 110	177	10
% 123	180	10
% 135	184	10
% 150	187	10
% 163	189	10
% 179	194	10
% 193	198	10
% 206	202	10
% 218	203	10
% 228	208	10
% 238	216	10
% 242	226	10
% 254	230	10
% 0	171	11
% 11	169	11
% 26	171	11
% 40	170	11
% 56	170	11
% 70	172	11
% 87	173	11
% 101	176	11
% 115	177	11
% 130	179	11
% 142	183	11
% 154	185	11
% 170	190	11
% 179	192	11
% 192	198	11
% 204	201	11
% 214	202	11
% 225	202	11
% 234	208	11
% 2	172	12
% 16	170	12
% 30	170	12
% 46	170	12
% 59	172	12
% 77	173	12
% 90	174	12
% 106	176	12
% 120	177	12
% 130	180	12
% 148	184	12
% 162	186	12
% 176	190	12
% 190	194	12
% 203	197	12
% 216	200	12
% 226	202	12
% 2	170	13
% 12	170	13
% 28	172	13
% 42	170	13
% 57	170	13
% 73	170	13
% 85	172	13
% 100	173	13
% 113	174	13
% 126	176	13
% 136	177	13
% 150	180	13
% 162	183	13
% 176	185	13
% 188	188	13
% 202	193	13
% 212	198	13
% 224	202	13
% 237	205	13
% 2	156	14
% 14	156	14
% 28	156	14
% 44	157	14
% 62	157	14
% 79	160	14
% 97	162	14
% 114	162	14
% 131	164	14
% 147	166	14
% 165	172	14
% 179	177	14
% 195	181	14
% 206	186	14
% 222	190	14
% 232	196	14
% 246	200	14
% 4	157	15
% 17	156	15
% 34	158	15
% 48	160	15
% 65	158	15
% 82	160	15
% 96	162	15
% 113	164	15
% 130	166	15
% 144	167	15
% 160	170	15
% 175	171	15
% 187	175	15
% 204	181	15
% 216	184	15
% 228	190	15
% 237	195	15
% 248	200	15
% 3	155	16
% 20	154	16
% 38	157	16
% 53	157	16
% 68	157	16
% 88	158	16
% 100	162	16
% 116	162	16
% 129	163	16
% 144	166	16
% 158	168	16
% 171	170	16
% 186	173	16
% 202	176	16
% 214	181	16
% 229	186	16
% 236	190	16
% 248	197	16
% 2	145	17
% 16	146	17
% 32	146	17
% 48	149	17
% 61	150	17
% 76	152	17
% 91	154	17
% 103	156	17
% 117	157	17
% 132	158	17
% 142	158	17
% 154	160	17
% 168	163	17
% 183	167	17
% 196	172	17
% 213	176	17
% 228	181	17
% 238	188	17
% 2	142	18
% 16	147	18
% 33	147	18
% 51	149	18
% 67	150	18
% 81	154	18
% 98	156	18
% 115	157	18
% 128	160	18
% 144	161	18
% 162	164	18
% 175	166	18
% 191	170	18
% 206	174	18
% 222	181	18
% 234	184	18
% 3	141	19
% 17	142	19
% 36	146	19
% 55	145	19
% 76	148	19
% 95	152	19
% 111	154	19
% 126	157	19
% 143	158	19
% 160	160	19
% 174	164	19
% 188	169	19
% 203	172	19
% 212	174	19
% 224	180	19
% 237	186	19
% 3	140	20
% 14	140	20
% 36	144	20
% 52	144	20
% 69	147	20
% 85	148	20
% 98	150	20
% 114	152	20
% 127	156	20
% 142	161	20
% 156	161	20
% 174	165	20
% 186	168	20
% 200	172	20
% 216	176	20
% 230	184	20
% 4	136	21
% 16	140	21
% 34	142	21
% 50	142	21
% 66	144	21
% 78	144	21
% 95	147	21
% 109	151	21
% 124	154	21
% 142	156	21
% 156	156	21
% 167	158	21
% 179	162	21
% 192	166	21
% 206	170	21
% 220	178	21
% 230	181	21
% 240	185	21
% 6	142	22
% 16	142	22
% 33	142	22
% 45	142	22
% 62	146	22
% 78	148	22
% 92	150	22
% 104	152	22
% 119	156	22
% 132	156	22
% 146	160	22
% 156	161	22
% 171	165	22
% 188	170	22
% 201	172	22
% 214	176	22
% 228	182	22
% 3	144	23
% 16	144	23
% 32	145	23
% 51	148	23
% 65	151	23
% 81	152	23
% 96	154	23
% 111	157	23
% 126	161	23
% 140	162	23
% 153	166	23
% 165	168	23
% 177	172	23
% 190	174	23
% 205	178	23
% 216	182	23
% 228	186	23
% 238	194	23
% 2	145	24
% 12	147	24
% 29	150	24
% 44	151	24
% 56	150	24
% 70	154	24
% 85	155	24
% 110	158	24
% 96	157	24
% 122	160	24
% 136	161	24
% 150	165	24
% 163	168	24
% 178	171	24
% 191	172	24
% 206	175	24
% 216	182	24
% 229	187	24
% 240	192	24];
% BMR=[682	255	1
% 510	201	1
% 531	188	1
% 540	185	1
% 553	179	1
% 564	176	1
% 579	171	1
% 591	169	1
% 602	166	1
% 621	163	1
% 636	159	1
% 654	158	1
% 671	153	1
% 687	152	1
% 702	148	1
% 714	147	1
% 729	145	1
% 745	143	1
% 757	141	1
% 532	187	2
% 543	183	2
% 555	177	2
% 567	173	2
% 582	167	2
% 597	165	2
% 610	161	2
% 624	158	2
% 639	157	2
% 652	152	2
% 667	150	2
% 683	147	2
% 696	147	2
% 708	145	2
% 722	142	2
% 734	142	2
% 746	141	2
% 760	139	2
% 518	204	3
% 524	199	3
% 536	192	3
% 546	187	3
% 560	182	3
% 573	178	3
% 586	174	3
% 599	169	3
% 612	167	3
% 627	165	3
% 640	161	3
% 654	160	3
% 670	156	3
% 682	156	3
% 697	155	3
% 712	152	3
% 727	151	3
% 742	151	3
% 755	147	3
% 514	195	4
% 527	190	4
% 538	183	4
% 551	181	4
% 567	175	4
% 580	171	4
% 596	166	4
% 612	161	4
% 629	159	4
% 645	155	4
% 660	153	4
% 677	151	4
% 692	149	4
% 708	148	4
% 723	146	4
% 739	145	4
% 756	143	4
% 501	220	5
% 515	210	5
% 526	201	5
% 539	193	5
% 555	185	5
% 572	177	5
% 587	174	5
% 600	170	5
% 616	169	5
% 634	168	5
% 650	166	5
% 667	163	5
% 685	162	5
% 700	161	5
% 719	159	5
% 736	159	5
% 752	156	5
% 502	225	6
% 517	214	6
% 522	211	6
% 531	207	6
% 542	200	6
% 555	195	6
% 570	188	6
% 582	184	6
% 598	179	6
% 609	175	6
% 624	172	6
% 634	170	6
% 647	168	6
% 666	166	6
% 678	167	6
% 695	165	6
% 712	163	6
% 728	162	6
% 744	161	6
% 758	161	6
% 501	225	7
% 514	218	7
% 528	212	7
% 542	205	7
% 558	197	7
% 570	192	7
% 586	189	7
% 600	185	7
% 613	183	7
% 626	180	7
% 640	181	7
% 654	177	7
% 668	177	7
% 681	173	7
% 696	174	7
% 712	171	7
% 728	171	7
% 742	171	7
% 756	170	7
% 500	221	8
% 514	217	8
% 527	211	8
% 541	205	8
% 558	198	8
% 572	195	8
% 591	189	8
% 608	188	8
% 625	183	8
% 639	181	8
% 655	179	8
% 667	178	8
% 684	177	8
% 695	177	8
% 710	175	8
% 728	173	8
% 744	170	8
% 759	171	8
% 502	217	9
% 512	214	9
% 524	209	9
% 538	203	9
% 551	198	9
% 566	195	9
% 584	189	9
% 596	188	9
% 610	185	9
% 623	181	9
% 636	179	9
% 651	179	9
% 667	177	9
% 683	176	9
% 701	174	9
% 715	173	9
% 726	173	9
% 740	171	9
% 752	171	9
% 763	169	9
% 501	214	10
% 511	209	10
% 526	203	10
% 541	200	10
% 557	195	10
% 574	191	10
% 589	187	10
% 600	185	10
% 614	182	10
% 628	180	10
% 640	177	10
% 654	175	10
% 672	174	10
% 683	175	10
% 698	174	10
% 710	173	10
% 724	172	10
% 737	171	10
% 744	171	10
% 758	171	10
% 504	211	11
% 516	206	11
% 532	205	11
% 546	201	11
% 560	194	11
% 575	191	11
% 588	186	11
% 602	184	11
% 614	183	11
% 628	181	11
% 642	177	11
% 656	177	11
% 670	175	11
% 685	174	11
% 700	173	11
% 712	173	11
% 726	170	11
% 738	171	11
% 751	170	11
% 762	171	11
% 508	210	12
% 519	207	12
% 530	203	12
% 546	200	12
% 558	196	12
% 575	191	12
% 591	187	12
% 603	185	12
% 620	181	12
% 634	179	12
% 653	177	12
% 665	176	12
% 680	175	12
% 711	173	12
% 693	174	12
% 726	171	12
% 738	170	12
% 752	171	12
% 764	169	12
% 510	209	13
% 524	207	13
% 541	201	13
% 556	196	13
% 574	192	13
% 590	187	13
% 604	186	13
% 622	184	13
% 633	182	13
% 650	179	13
% 666	176	13
% 681	176	13
% 700	174	13
% 715	173	13
% 733	170	13
% 746	171	13
% 755	169	13
% 509	208	14
% 524	205	14
% 544	200	14
% 562	195	14
% 582	191	14
% 598	189	14
% 614	185	14
% 626	182	14
% 642	182	14
% 661	179	14
% 678	179	14
% 697	176	14
% 713	176	14
% 730	175	14
% 744	175	14
% 759	174	14
% 518	206	15
% 528	206	15
% 545	200	15
% 559	195	15
% 578	190	15
% 593	187	15
% 611	184	15
% 628	183	15
% 640	181	15
% 654	179	15
% 670	179	15
% 684	177	15
% 697	177	15
% 711	174	15
% 726	174	15
% 742	174	15
% 758	175	15
% 518	209	16
% 531	205	16
% 543	203	16
% 556	198	16
% 572	193	16
% 586	190	16
% 602	189	16
% 616	186	16
% 631	183	16
% 647	182	16
% 664	180	16
% 679	177	16
% 709	174	16
% 696	175	16
% 721	173	16
% 737	172	16
% 752	170	16
% 763	172	16
% 522	206	17
% 531	207	17
% 544	203	17
% 556	197	17
% 568	192	17
% 584	191	17
% 598	190	17
% 614	186	17
% 633	182	17
% 653	181	17
% 666	179	17
% 679	175	17
% 693	177	17
% 708	175	17
% 725	171	17
% 738	171	17
% 751	170	17
% 762	169	17
% 521	211	18
% 527	210	18
% 536	209	18
% 547	203	18
% 556	199	18
% 566	197	18
% 579	193	18
% 589	192	18
% 600	189	18
% 614	187	18
% 628	185	18
% 642	183	18
% 658	182	18
% 673	179	18
% 687	177	18
% 702	176	18
% 715	175	18
% 730	174	18
% 741	172	18
% 754	171	18
% 526	209	19
% 538	208	19
% 552	202	19
% 566	197	19
% 581	194	19
% 596	191	19
% 611	189	19
% 628	186	19
% 643	185	19
% 659	181	19
% 673	181	19
% 686	179	19
% 700	177	19
% 712	177	19
% 723	174	19
% 738	173	19
% 750	172	19
% 762	171	19
% 528	211	20
% 539	209	20
% 548	203	20
% 560	199	20
% 574	198	20
% 586	197	20
% 600	195	20
% 613	192	20
% 627	191	20
% 640	187	20
% 653	185	20
% 670	182	20
% 687	179	20
% 704	177	20
% 718	179	20
% 736	173	20
% 754	173	20
% 532	210	21
% 540	209	21
% 552	205	21
% 561	200	21
% 572	198	21
% 584	195	21
% 597	192	21
% 610	189	21
% 622	189	21
% 632	187	21
% 646	185	21
% 660	183	21
% 672	180	21
% 682	179	21
% 694	178	21
% 706	177	21
% 718	175	21
% 730	174	21
% 742	171	21
% 754	169	21
% 764	168	21
% 530	213	22
% 541	209	22
% 552	203	22
% 568	199	22
% 582	196	22
% 600	193	22
% 616	189	22
% 633	187	22
% 646	186	22
% 658	185	22
% 673	185	22
% 680	182	22
% 692	180	22
% 706	177	22
% 718	175	22
% 731	172	22
% 747	171	22
% 756	169	22
% 534	213	23
% 546	209	23
% 557	205	23
% 572	201	23
% 583	202	23
% 592	199	23
% 604	195	23
% 614	192	23
% 628	191	23
% 644	189	23
% 658	187	23
% 672	185	23
% 691	180	23
% 710	177	23
% 724	175	23
% 738	173	23
% 754	171	23
% 531	209	24
% 544	203	24
% 557	201	24
% 572	195	24
% 588	191	24
% 605	187	24
% 624	183	24
% 638	180	24
% 655	177	24
% 666	174	24
% 680	173	24
% 690	171	24
% 703	170	24
% 714	168	24
% 726	164	24
% 738	161	24
% 753	159	24
% 760	158	24];
% ALC=[307	390	1
% 326	388	1
% 351	379	1
% 365	367	1
% 393	358	1
% 420	362	1
% 449	362	1
% 473	362	1
% 309	406	2
% 333	399	2
% 347	386	2
% 362	370	2
% 390	356	2
% 411	351	2
% 435	351	2
% 457	351	2
% 477	346	2
% 314	402	3
% 329	393	3
% 347	380	3
% 361	370	3
% 381	362	3
% 401	349	3
% 429	345	3
% 467	344	3
% 318	395	4
% 336	389	4
% 357	372	4
% 377	360	4
% 402	347	4
% 426	342	4
% 452	338	4
% 473	334	4
% 264	387	5
% 282	391	5
% 330	393	5
% 357	375	5
% 385	362	5
% 418	353	5
% 454	347	5
% 485	339	5
% 281	374	6
% 340	393	6
% 361	374	6
% 393	359	6
% 423	342	6
% 447	329	6
% 466	318	6
% 497	301	6
% 342	379	7
% 367	366	7
% 394	354	7
% 418	344	7
% 437	334	7
% 457	318	7
% 470	303	7
% 482	286	7
% 489	270	7
% 493	252	7
% 345	378	8
% 376	364	8
% 404	346	8
% 425	336	8
% 454	312	8
% 470	297	8
% 483	275	8
% 491	250	8
% 254	360	9
% 267	363	9
% 288	362	9
% 357	374	9
% 386	356	9
% 414	341	9
% 438	323	9
% 459	302	9
% 474	282	9
% 485	260	9
% 493	240	9
% 261	362	10
% 273	361	10
% 361	366	10
% 387	354	10
% 415	338	10
% 434	321	10
% 453	297	10
% 466	275	10
% 480	258	10
% 486	237	10
% 253	358	11
% 271	360	11
% 293	366	11
% 349	364	11
% 377	354	11
% 405	341	11
% 430	326	11
% 446	312	11
% 457	292	11
% 473	267	11
% 485	247	11
% 495	229	11
% 277	365	12
% 293	366	12
% 355	366	12
% 378	359	12
% 404	341	12
% 423	327	12
% 441	309	12
% 452	292	12
% 472	269	12
% 481	248	12
% 494	230	12
% 276	370	13
% 289	369	13
% 354	366	13
% 377	359	13
% 398	346	13
% 422	329	13
% 441	306	13
% 458	284	13
% 471	264	13
% 484	245	13
% 493	227	13
% 351	369	14
% 380	359	14
% 408	347	14
% 429	338	14
% 447	321	14
% 465	298	14
% 478	270	14
% 489	249	14
% 501	230	14
% 346	359	15
% 373	351	15
% 397	342	15
% 427	334	15
% 448	315	15
% 461	291	15
% 473	272	15
% 488	249	15
% 497	231	15
% 273	382	16
% 328	370	16
% 352	362	16
% 373	355	16
% 404	344	16
% 425	333	16
% 448	310	16
% 468	282	16
% 475	259	16
% 491	238	16
% 511	220	16
% 329	364	17
% 353	361	17
% 386	350	17
% 414	343	17
% 434	326	17
% 450	306	17
% 466	283	17
% 478	254	17
% 493	234	17
% 509	220	17
% 319	350	18
% 340	356	18
% 369	355	18
% 397	350	18
% 423	346	18
% 441	328	18
% 455	298	18
% 469	279	18
% 480	259	18
% 492	244	18
% 313	377	19
% 334	365	19
% 349	354	19
% 381	354	19
% 405	354	19
% 429	343	19
% 448	332	19
% 457	307	19
% 466	292	19
% 476	270	19
% 486	252	19
% 501	239	19
% 517	231	19
% 298	381	20
% 317	380	20
% 331	367	20
% 349	360	20
% 375	355	20
% 400	352	20
% 417	346	20
% 439	338	20
% 457	322	20
% 468	313	20
% 471	284	20
% 488	250	20
% 278	341	21
% 302	351	21
% 327	362	21
% 341	354	21
% 365	357	21
% 387	359	21
% 412	361	21
% 443	356	21
% 471	345	21
% 478	305	21
% 480	268	21
% 496	242	21
% 281	369	22
% 305	366	22
% 337	361	22
% 371	361	22
% 404	363	22
% 435	359	22
% 460	350	22
% 476	336	22
% 476	300	22
% 480	264	22
% 496	239	22
% 278	382	23
% 300	382	23
% 324	374	23
% 347	360	23
% 365	356	23
% 394	366	23
% 418	373	23
% 453	380	23
% 479	359	23
% 485	317	23
% 482	284	23
% 495	252	23
% 508	236	23
% 287	355	24
% 321	368	24
% 341	364	24
% 357	354	24
% 373	353	24
% 407	362	24
% 424	368	24
% 438	374	24
% 455	369	24
% 468	350	24
% 474	333	24
% 475	308	24
% 481	276	24
% 489	253	24
% 501	230	24];
% CSL=[3.5	203	1
% 19.5	206	1
% 33.5	207.5	1
% 48	208.5	1
% 63	210	1
% 80.5	212	1
% 95.5	213.5	1
% 108.5	215	1
% 122	217.5	1
% 137.5	216	1
% 153.5	220	1
% 167.5	224	1
% 181	228.5	1
% 196.5	231	1
% 208.5	230.5	1
% 220.5	230.5	1
% 235.5	229.5	1
% 248.5	230.5	1
% 3	207	2
% 12.5	209	2
% 25	211	2
% 40.5	215	2
% 56	221.5	2
% 71	225.5	2
% 89.5	226.5	2
% 109	226.5	2
% 126	227	2
% 142.5	228.5	2
% 158.5	232.5	2
% 178.5	234.5	2
% 195	233	2
% 207.5	224.5	2
% 223	223	2
% 239	223.5	2
% 2.5	201	3
% 15.5	206	3
% 28.5	210.5	3
% 42	214.5	3
% 55	222	3
% 72	224	3
% 90.5	227	3
% 106.5	230.5	3
% 121	232	3
% 137	235	3
% 150	238.5	3
% 163.5	241	3
% 176	242.5	3
% 191.5	245.5	3
% 208.5	246.5	3
% 226	250	4
% 208.5	249	4
% 189.5	246	4
% 175.5	243	4
% 160.5	238	4
% 147	235.5	4
% 135	234.5	4
% 124.5	234	4
% 114	233	4
% 101.5	231	4
% 87.5	228	4
% 71	226	4
% 52	223	4
% 38.5	221.5	4
% 23	219	4
% 9.5	218	4
% 5.5	228	5
% 23.5	231	5
% 42.5	234	5
% 63.5	237	5
% 84	240.5	5
% 104.5	243	5
% 126	245	5
% 145	247.5	5
% 164.5	249.5	5
% 184	252.5	5
% 205.5	257	5
% 224.5	259	5
% 4.5	238.5	6
% 20.5	239	6
% 40.5	241.5	6
% 60	243	6
% 75	244	6
% 92	244	6
% 107	245	6
% 123.5	247	6
% 138.5	247	6
% 153	252	6
% 169	256	6
% 184.5	257	6
% 200.5	259.5	6
% 216.5	262.5	6
% 233.5	265.5	6
% 3.5	231.5	7
% 20.5	234.5	7
% 44.5	235	7
% 65	241.5	7
% 82.5	245	7
% 99.5	249	7
% 116	250	7
% 133	250.5	7
% 150	252.5	7
% 170	256	7
% 190	259.5	7
% 207.5	263.5	7
% 220.5	266	7
% 2.5	227.5	8
% 16.5	228	8
% 33	230.5	8
% 48	234.5	8
% 62.5	236.5	8
% 79.5	239	8
% 94.5	240	8
% 111.5	240.5	8
% 125.5	243.5	8
% 140	244.5	8
% 156.5	248.5	8
% 172.5	251	8
% 188	250.5	8
% 203	252.5	8
% 218.5	247.5	8
% 235	241	8
% 246.5	232.5	8
% 4	223	9
% 22	223.5	9
% 44.5	229	9
% 65	229	9
% 81.5	232.5	9
% 98	236	9
% 114.5	240	9
% 133	243	9
% 150	244.5	9
% 169	247	9
% 187.5	249.5	9
% 204	252.5	9
% 223	252.5	9
% 240.5	253	9
% 257.5	250.5	9
% 3	215	10
% 20	214.5	10
% 38.5	217.5	10
% 55.5	218	10
% 73.5	220	10
% 94.5	221.5	10
% 117.5	224.5	10
% 140	228.5	10
% 157.5	231	10
% 172.5	235	10
% 191.5	241	10
% 207.5	243.5	10
% 224	243.5	10
% 243.5	234	10
% 2	221	11
% 22.5	221	11
% 48.5	222	11
% 66.5	224.5	11
% 87.5	225	11
% 106.5	228	11
% 124	231	11
% 147.5	231.5	11
% 169	234.5	11
% 186.5	236.5	11
% 202	240	11
% 219	244.5	11
% 231.5	246	11
% 245.5	239	11
% 3.5	215.5	12
% 22.5	214.5	12
% 44.5	215	12
% 67.5	215.5	12
% 84.5	218	12
% 99.5	219.5	12
% 116.5	221	12
% 139.5	223.5	12
% 159.5	227	12
% 174.5	230.5	12
% 194.5	233	12
% 210.5	237	12
% 224.5	240	12
% 240	241	12
% 2.5	216	13
% 18	216.5	13
% 37	217.5	13
% 57.5	218	13
% 73.5	218	13
% 91.5	220	13
% 106.5	220.5	13
% 127	221.5	13
% 145.5	223.5	13
% 162.5	227	13
% 178	230.5	13
% 197.5	233	13
% 213.5	236	13
% 231.5	236.5	13
% 244	235.5	13
% 253	211	14
% 244.5	220.5	14
% 230.5	229	14
% 212	231	14
% 195.5	228	14
% 178	222	14
% 161.5	218	14
% 147	215.5	14
% 135	212.5	14
% 121	210	14
% 109.5	209	14
% 91.5	207.5	14
% 71.5	204	14
% 54	201	14
% 35.5	199	14
% 19.5	197	14
% 5	195.5	14
% 4	199.5	15
% 24.5	200	15
% 44	202.5	15
% 65.5	207	15
% 86	210	15
% 109	214	15
% 128.5	218.5	15
% 146.5	221.5	15
% 167.5	225.5	15
% 186	230.5	15
% 205.5	235.5	15
% 222.5	237.5	15
% 239.5	236.5	15
% 254	231.5	15
% 6	195.5	16
% 32	198	16
% 61	199	16
% 84	201	16
% 108.5	203	16
% 127	205	16
% 151.5	209	16
% 173.5	211	16
% 193.5	215	16
% 214.5	220	16
% 232.5	222.5	16
% 248.5	225	16
% 5	197.5	17
% 50.5	202	17
% 26.5	200	17
% 75.5	202	17
% 106	207.5	17
% 130	208.5	17
% 152.5	212	17
% 180	215	17
% 202	218.5	17
% 221	222	17
% 241.5	223	17
% 262.5	223.5	17
% 262.5	213.5	18
% 242.5	212	18
% 226	211.5	18
% 208.5	211	18
% 194.5	211.5	18
% 180	213	18
% 159	215	18
% 143.5	212.5	18
% 127.5	209.5	18
% 114	208.5	18
% 96	206.5	18
% 77.5	206.5	18
% 59	204	18
% 45	202.5	18
% 28.5	201	18
% 12	202	18
% 1	200.5	18
% 254	207	19
% 236	206.5	19
% 218.5	202.5	19
% 202.5	200.5	19
% 189.5	200	19
% 177.5	199.5	19
% 161.5	198	19
% 148	197.5	19
% 129.5	198	19
% 110	197	19
% 95.5	197	19
% 81	195	19
% 64	193	19
% 51.5	194	19
% 34.5	195	19
% 19	194	19
% 6	193	19
% 3.5	187.5	20
% 20.5	190	20
% 37	191.5	20
% 55.5	196	20
% 76.5	195.5	20
% 92	197	20
% 107.5	198	20
% 125.5	199	20
% 141.5	200	20
% 160.5	200.5	20
% 180	202	20
% 198	203.5	20
% 219.5	205.5	20
% 237	207	20
% 253.5	204.5	20
% 2.5	177	21
% 21	179	21
% 39.5	180.5	21
% 57	181	21
% 71	183.5	21
% 89	186	21
% 111	188.5	21
% 136.5	189.5	21
% 158.5	193	21
% 177.5	197	21
% 195	198.5	21
% 211	201	21
% 228	204.5	21
% 249.5	207	21
% 5	194	22
% 26	195	22
% 47	195	22
% 70	196	22
% 94	199	22
% 117	199	22
% 141	202	22
% 167	206	22
% 186	210	22
% 208	222	22
% 227	236	22
% 2	215	23
% 28	216	23
% 46	218	23
% 69	220	23
% 90	220	23
% 110	222	23
% 123	224	23
% 151	226	23
% 179	228	23
% 198	226	23
% 218	232	23
% 236	238	23
% 5	218	24
% 29	211	24
% 57	215	24
% 74	221	24
% 92	224	24
% 116	224	24
% 138	228	24
% 160	226	24
% 188	229	24
% 213	234	24
% 234	234	24
% 256	222	24];
% CSR=[505	238	1
% 522	239	1
% 539	237	1
% 558	232	1
% 580	227	1
% 604	223	1
% 628	218	1
% 653	212	1
% 676	211	1
% 706	210	1
% 730	206	1
% 758	206	1
% 516	226	2
% 529	234	2
% 546	230	2
% 572	227	2
% 595	223	2
% 617	221	2
% 641	218	2
% 671	212	2
% 693	210	2
% 713	208	2
% 736	206	2
% 760	204	2
% 508	230	3
% 522	240	3
% 537	241	3
% 561	235	3
% 588	229	3
% 605	225	3
% 631	223	3
% 656	222	3
% 684	218	3
% 716	214	3
% 744	212	3
% 762	211	3
% 504	215	4
% 519	212	4
% 536	211	4
% 554	213	4
% 576	218	4
% 596	220	4
% 618	222	4
% 636	222	4
% 650	218	4
% 674	212	4
% 690	208	4
% 674	220	4
% 732	218	4
% 754	216	4
% 504	228	5
% 522	234	5
% 540	240	5
% 560	236	5
% 582	232	5
% 606	229	5
% 631	231	5
% 653	230	5
% 677	226	5
% 701	225	5
% 720	224	5
% 738	225	5
% 757	223	5
% 509	238	6
% 525	242	6
% 544	242	6
% 566	239	6
% 590	237	6
% 613	234	6
% 636	231	6
% 658	228	6
% 677	228	6
% 695	227	6
% 719	226	6
% 739	225	6
% 758	224	6
% 517	242	7
% 534	240	7
% 551	238	7
% 570	236	7
% 598	236	7
% 617	236	7
% 640	234	7
% 659	232	7
% 678	229	7
% 695	229	7
% 714	232	7
% 741	234	7
% 762	236	7
% 511	244	8
% 526	242	8
% 545	238	8
% 566	236	8
% 587	235	8
% 608	236	8
% 626	235	8
% 640	234	8
% 658	234	8
% 678	234	8
% 695	233	8
% 720	234	8
% 740	234	8
% 759	234	8
% 508	242	9
% 533	239	9
% 558	237	9
% 580	236	9
% 602	234	9
% 622	235	9
% 648	236	9
% 672	235	9
% 692	234	9
% 712	233	9
% 735	236	9
% 752	236	9
% 508	232	10
% 528	234	10
% 548	228	10
% 566	226	10
% 586	225	10
% 605	224	10
% 623	224	10
% 648	224	10
% 670	223	10
% 692	222	10
% 716	221	10
% 735	222	10
% 755	222	10
% 516	228	11
% 532	227	11
% 550	225	11
% 574	225	11
% 598	222	11
% 620	221	11
% 640	220	11
% 665	221	11
% 684	222	11
% 706	222	11
% 726	223	11
% 747	224	11
% 762	224	11
% 512	236	12
% 528	235	12
% 550	226	12
% 574	224	12
% 599	222	12
% 622	221	12
% 645	222	12
% 668	222	12
% 693	221	12
% 719	221	12
% 744	222	12
% 760	222	12
% 532	234	13
% 557	229	13
% 576	228	13
% 597	228	13
% 622	226	13
% 641	226	13
% 664	226	13
% 686	225	13
% 705	223	13
% 732	222	13
% 758	224	13
% 523	240	14
% 542	234	14
% 559	226	14
% 577	222	14
% 593	220	14
% 612	217	14
% 630	215	14
% 650	217	14
% 676	214	14
% 696	215	14
% 718	218	14
% 736	222	14
% 753	228	14
% 526	236	15
% 544	233	15
% 560	227	15
% 577	225	15
% 597	223	15
% 614	221	15
% 637	221	15
% 659	222	15
% 678	221	15
% 698	223	15
% 722	222	15
% 744	222	15
% 758	224	15
% 547	219	16
% 564	219	16
% 577	219	16
% 597	220	16
% 620	218	16
% 640	216	16
% 662	215	16
% 681	217	16
% 704	220	16
% 726	220	16
% 748	220	16
% 763	222	16
% 552	222	17
% 565	220	17
% 583	220	17
% 602	218	17
% 620	218	17
% 637	218	17
% 654	220	17
% 673	220	17
% 688	218	17
% 707	218	17
% 724	219	17
% 746	220	17
% 762	220	17
% 538	223	18
% 555	222	18
% 571	222	18
% 585	222	18
% 606	224	18
% 624	224	18
% 643	224	18
% 660	222	18
% 680	221	18
% 700	220	18
% 714	221	18
% 733	222	18
% 753	221	18
% 549	228	19
% 564	228	19
% 583	230	19
% 602	227	19
% 621	225	19
% 641	222	19
% 664	222	19
% 682	223	19
% 703	222	19
% 724	219	19
% 746	220	19
% 762	219	19
% 554	233	20
% 570	234	20
% 590	233	20
% 610	226	20
% 627	222	20
% 646	222	20
% 664	221	20
% 686	220	20
% 708	219	20
% 728	214	20
% 749	214	20
% 540	238	21
% 558	234	21
% 576	228	21
% 593	227	21
% 612	225	21
% 634	221	21
% 651	218	21
% 670	216	21
% 690	214	21
% 710	210	21
% 728	208	21
% 744	206	21
% 762	203	21
% 529	239	22
% 546	237	22
% 562	236	22
% 576	235	22
% 596	230	22
% 612	230	22
% 630	229	22
% 651	226	22
% 669	224	22
% 690	220	22
% 706	219	22
% 724	217	22
% 746	216	22
% 761	218	22
% 524	246	23
% 536	242	23
% 552	239	23
% 567	236	23
% 585	233	23
% 604	230	23
% 624	227	23
% 646	222	23
% 669	219	23
% 690	217	23
% 707	214	23
% 728	214	23
% 752	210	23
% 522	242	24
% 538	239	24
% 554	235	24
% 572	228	24
% 592	225	24
% 610	222	24
% 630	216	24
% 645	214	24
% 665	210	24
% 683	208	24
% 704	205	24
% 725	204	24
% 749	204	24
% 764	202	24];
% save(fullfile(savepath,[LCnum1 '-dividers.mat']),'BMO','BML','BMR','ALC','CSL','CSR')
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Step 2-5b
% If you only want to rerun step 4 and 5
% update the function name to runRDVC_s45
% If you only want to rerun step 5
% update the function name to runRDVC_s5

runRDVC_s5(LCnum1,bestbef1,bestbef2,bestaft1,eye,r_space,cc_thresh)



%% step 5c generate final plots
%  step 5c: Generate plots
sumname=fullfile(savepath, ['HOCT-' LCnum1 '-Strains-SegmentedAndSummarized.mat']);
load(sumname)
ss = 0.0501; % strain plotting range -ss to +ss
sd = 15;     % displacement plotting range -sd to +sd
title_opt = 1;
run('plot_NT_IS_DispStrain_Segmentation_Overlay.m')
run('plot_polarcircle_data.m')