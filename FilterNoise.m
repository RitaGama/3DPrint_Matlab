function Sinal_Filter = FilterNoise(sinal, lable)

%ellipord
% Wp = 2.0E-4;
% Ws = 2.5E-4;
% Rp =  1;
% Rs = 75;
% [n,Wp] = ellipord(Wp,Ws,Rp,Rs);
% [z,p,k] = ellip(n,Rp,Rs,Wp);
% [sos,g] = zp2sos(z,p,k);                            % Lowpass Is The Default For All Filters

%buttord
Wp = 40/500;
Ws = 150/500;
Rp =  3;
Rs = 60;
[n,Wn] = buttord(Wp,Ws,Rp,Rs);
[z,p,k] = butter(n,Wn/200); %200
[sos,g] = zp2sos(z,p,k);   

pzFilt = filtfilt(sos,g,sinal);

Window = 5000;
pzSmooth = smoothdata(sinal, 'sgolay', Window);


if lable == 1
    Sinal_Filter = pzFilt;
    
elseif lable == 2   
    Sinal_Filter = pzSmooth;
end
end