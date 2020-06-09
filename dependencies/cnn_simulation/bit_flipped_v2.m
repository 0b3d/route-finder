function desc_new = bit_flipped_v2(desc, accuracy_jcf, accuracy_bdr, accuracy_jcb, accuracy_bdl)
BSD1 = bi2de(desc); prob1 = accuracy_jcf*accuracy_bdr*accuracy_jcb*accuracy_bdl;
BSD2 = bi2de([~desc(1), desc(2), desc(3), desc(4)]); prob2 = (1-accuracy_jcf)*accuracy_bdr*accuracy_jcb*accuracy_bdl;
BSD3 = bi2de([desc(1), ~desc(2), desc(3), desc(4)]); prob3 = accuracy_jcf*(1-accuracy_bdr)*accuracy_jcb*accuracy_bdl;
BSD4 = bi2de([desc(1), desc(2), ~desc(3), desc(4)]); prob4 = accuracy_jcf*accuracy_bdr*(1-accuracy_jcb)*accuracy_bdl;
BSD5 = bi2de([desc(1), desc(2), desc(3), ~desc(4)]); prob5 = accuracy_jcf*accuracy_bdr*accuracy_jcb*(1-accuracy_bdl);
BSD6 = bi2de([~desc(1), ~desc(2), desc(3), desc(4)]); prob6 = (1-accuracy_jcf)*(1-accuracy_bdr)*accuracy_jcb*accuracy_bdl;
BSD7 = bi2de([~desc(1), desc(2), ~desc(3), desc(4)]); prob7 = (1-accuracy_jcf)*accuracy_bdr*(1-accuracy_jcb)*accuracy_bdl;
BSD8 = bi2de([~desc(1), desc(2), desc(3), ~desc(4)]); prob8 = (1-accuracy_jcf)*accuracy_bdr*accuracy_jcb*(1-accuracy_bdl);
BSD9 = bi2de([desc(1), ~desc(2), ~desc(3), desc(4)]); prob9 = accuracy_jcf*(1-accuracy_bdr)*(1-accuracy_jcb)*accuracy_bdl;
BSD10 = bi2de([desc(1), ~desc(2), desc(3), ~desc(4)]); prob10 = accuracy_jcf*(1-accuracy_bdr)*accuracy_jcb*(1-accuracy_bdl);
BSD11 = bi2de([desc(1), desc(2), ~desc(3), ~desc(4)]); prob11 = accuracy_jcf*accuracy_bdr*(1-accuracy_jcb)*(1-accuracy_bdl);
BSD12 = bi2de([~desc(1), ~desc(2), ~desc(3), desc(4)]); prob12 = (1-accuracy_jcf)*(1-accuracy_bdr)*(1-accuracy_jcb)*accuracy_bdl;
BSD13 = bi2de([~desc(1), ~desc(2), desc(3), ~desc(4)]); prob13 = (1-accuracy_jcf)*(1-accuracy_bdr)*accuracy_jcb*(1-accuracy_bdl);
BSD14 = bi2de([desc(1), ~desc(2), ~desc(3), ~desc(4)]); prob14 = accuracy_jcf*(1-accuracy_bdr)*(1-accuracy_jcb)*(1-accuracy_bdl);
BSD15 = bi2de([~desc(1), desc(2), ~desc(3), ~desc(4)]); prob15 = (1-accuracy_jcf)*accuracy_bdr*(1-accuracy_jcb)*(1-accuracy_bdl);
BSD16 = bi2de([~desc(1), ~desc(2), ~desc(3), ~desc(4)]); prob16 = (1-accuracy_jcf)*(1-accuracy_bdr)*(1-accuracy_jcb)*(1-accuracy_bdl);

sum = prob1+prob2+prob3+prob4+prob5+prob6+prob7+prob8+prob9+prob10+prob11+prob12+prob13+prob14+prob15+prob16;

alphabet = [BSD1 BSD2 BSD3 BSD4 BSD5 BSD6 BSD7 BSD8 BSD9 BSD10 BSD11 BSD12 BSD13 BSD14 BSD15 BSD16];
prob = [prob1 prob2 prob3 prob4 prob5 prob6 prob7 prob8 prob9 prob10 prob11 prob12 prob13 prob14 prob15 prob16];
desc_new = de2bi(randsrc(1, 1, [alphabet;prob]),4);




end