function wavplays(c1,c2)
fs=48000;

s=[c1 c2];
wavplay(s,fs,'async')
