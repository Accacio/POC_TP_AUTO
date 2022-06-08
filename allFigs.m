function files = allFigs()
% linux/MACOS
[~ ,files] = system("ls | egrep '(.*png|.*jpg)'| tr '\r\n' ' '| sed 's, $,,g'");
files = split(string(regexprep(files, '\n|\r', '')))';
end