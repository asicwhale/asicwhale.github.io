scr_input=[80 255 16 9 48 255 80 0 25 0 145]; 

s=20255; %Initialization of scrambler circuit
rand_data=zeros(size(scr_input));

for j=1:size(scr_input,2);
	for i=1:8
		msb=bitxor(bitget(s,1),bitget(s,2));
		s=bitshift(s,-1);
		s=bitset(s,15,msb);
		t=bitxor(bitget(scr_input(j),9-i),msb);
		rand_data(j)=bitset(rand_data(j),9-i,t);
	end
end
scrambler_out=rand_data;


s=20255; %Initialization of de-scrambler circuit
descrambler_in=zeros(size(scrambler_out));
for j=1:size(scrambler_out,2);
    for i=1:8
        msb=bitxor(bitget(s,1),bitget(s,2));
        s=bitshift(s,-1);
        s=bitset(s,15,msb);
        t=bitxor(bitget(scrambler_out(j),9-i),msb);
        descrambler_in(j)=bitset(descrambler_in(j),9-i,t);
    end
end
descrambler_out=descrambler_in;