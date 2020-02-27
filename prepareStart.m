%nameFile = 'start_spe.dat';

superFolder = strcat(pwd,'\start\');

command = ['copy ' superFolder nameFile ' ' pwd '\start.dat'];
system(command);
