% [[file:README.org::*Student][Student:1]]
clear
close all
plot(1:10,((1:10)-5).^3)
saveas(gcf,'imageExample.jpg');

plot(1:10,((1:10)-5).^5+((1:10)-5).^3)
saveas(gcf,'imageExample1.jpg');
close all
% Student:1 ends here

% [[file:README.org::*Student][Student:2]]
% Sign in one call
% signImage imageExample.jpg imageExample1.jpg;
% Student:2 ends here

% [[file:README.org::*Student][Student:3]]
% sign all images in folder
files=allFigs();
signImage(files{:});
% Student:3 ends here
