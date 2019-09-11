function desc_new = bit_flipped(desc, accuracy)
BSD1 = bi2de(desc); prob1 = accuracy*accuracy*accuracy*accuracy;
BSD2 = bi2de([~desc(1), desc(2), desc(3), desc(4)]); prob2 = (1-accuracy)*accuracy*accuracy*accuracy;
BSD3 = bi2de([desc(1), ~desc(2), desc(3), desc(4)]); prob3 = accuracy*(1-accuracy)*accuracy*accuracy;
BSD4 = bi2de([desc(1), desc(2), ~desc(3), desc(4)]); prob4 = accuracy*accuracy*(1-accuracy)*accuracy;
BSD5 = bi2de([desc(1), desc(2), desc(3), ~desc(4)]); prob5 = accuracy*accuracy*accuracy*(1-accuracy);
BSD6 = bi2de([~desc(1), ~desc(2), desc(3), desc(4)]); prob6 = (1-accuracy)*(1-accuracy)*accuracy*accuracy;
BSD7 = bi2de([~desc(1), desc(2), ~desc(3), desc(4)]); prob7 = (1-accuracy)*accuracy*(1-accuracy)*accuracy;
BSD8 = bi2de([~desc(1), desc(2), desc(3), ~desc(4)]); prob8 = (1-accuracy)*accuracy*accuracy*(1-accuracy);
BSD9 = bi2de([desc(1), ~desc(2), ~desc(3), desc(4)]); prob9 = accuracy*(1-accuracy)*(1-accuracy)*accuracy;
BSD10 = bi2de([desc(1), ~desc(2), desc(3), ~desc(4)]); prob10 = accuracy*(1-accuracy)*accuracy*(1-accuracy);
BSD11 = bi2de([desc(1), desc(2), ~desc(3), ~desc(4)]); prob11 = accuracy*accuracy*(1-accuracy)*(1-accuracy);
BSD12 = bi2de([~desc(1), ~desc(2), ~desc(3), desc(4)]); prob12 = (1-accuracy)*(1-accuracy)*(1-accuracy)*accuracy;
BSD13 = bi2de([~desc(1), ~desc(2), desc(3), ~desc(4)]); prob13 = (1-accuracy)*(1-accuracy)*accuracy*(1-accuracy);
BSD14 = bi2de([desc(1), ~desc(2), ~desc(3), ~desc(4)]); prob14 = accuracy*(1-accuracy)*(1-accuracy)*(1-accuracy);
BSD15 = bi2de([~desc(1), desc(2), ~desc(3), ~desc(4)]); prob15 = (1-accuracy)*accuracy*(1-accuracy)*(1-accuracy);
BSD16 = bi2de([~desc(1), ~desc(2), ~desc(3), ~desc(4)]); prob16 = (1-accuracy)*(1-accuracy)*(1-accuracy)*(1-accuracy);

%sum = prob1+prob2+prob3+prob4+prob5+prob6+prob7+prob8+prob9+prob10+prob11+prob12+prob13+prob14+prob15+prob16;

alphabet = [BSD1 BSD2 BSD3 BSD4 BSD5 BSD6 BSD7 BSD8 BSD9 BSD10 BSD11 BSD12 BSD13 BSD14 BSD15 BSD16];
prob = [prob1 prob2 prob3 prob4 prob5 prob6 prob7 prob8 prob9 prob10 prob11 prob12 prob13 prob14 prob15 prob16];
desc_new = de2bi(randsrc(1, 1, [alphabet;prob]),4);




end