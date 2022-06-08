function [] = signImage(varargin)
%% signImage - sign an image to be used 
%% in reports for the «TP Automatique»
%% usage signImage("imagepath.ext")
%%
%% A «imagepath_signed.png» image is created. 
%% 
%% PDFs created using word should export 
%% images losslessly
%% 
%% PDFs created using latex do not need 
%% special attention

%% Get PC metadata 
divider = ';';

for i=1:nargin
  imagePath=char(varargin{i});
% GET DATE with custom resolution
[~,sysDate] = system("date -Ins");
sysDate = regexprep(sysDate, '\n|\r', '');
% GET MAC from ethernet
% linux example
[~, mac] = system(['ifconfig | ' ...
  'egrep -o "([0-9a-e]{2}:){5}[0-9a-e]{2}" | sed 1q']);
mac = regexprep(mac, '\n|\r', '');

% maybe other data?

% unify all in one string
metadata= [ mac divider sysDate];

%% encrypt metadata
encryptionKey = 'key'; % change
aes = AES(encryptionKey,"SHA-1");

encryptedString = char(encrypt(aes,metadata));

% put metadata in figure
img = imread(imagePath);

charNeeded = 88 ;

[ h w d] = size(img);
paddedImage = uint8(ones(h,w,d));

paddedImage(1:h,1:w,1:d)=img;
% paddedImage(h,:,1)=[uint8(encryptedString) char(uint8(rand(1,w-88)*60)+42) ];
% paddedImage(h,:,2)=[uint8(encryptedString) char(uint8(rand(1,w-88)*60)+42) ];
% paddedImage(h,:,3)=[uint8(encryptedString) char(uint8(rand(1,w-88)*60)+42) ];
% paddedImage(h,:,2)=[0*ones(1,w) ];
paddedImage(h,:,1)=[uint8(encryptedString) char(uint8(rand(1,w-88)*60)+42) ];
paddedImage(h,:,2)=uint8(1*ones(1,w));
paddedImage(h,:,3)=uint8(0*ones(1,w));
% paddedImage(h,:,3)=uint8((2^9-1)*ones(1,w));
% paddedImage(h,1:88,1)=[uint8(encryptedString);
% paddedImage(h,1:88,2)=uint8(encryptedString);
% paddedImage(h,1:88,3)=uint8(encryptedString);
% paddedImage(h,89:end,1)=char(uint8(rand(1,w-88)*60)+42);
% paddedImage(h,89:end,2)=char(uint8(rand(1,w-88)*60)+42);
% paddedImage(h,89:end,3)=char(uint8(rand(1,w-88)*60)+42);
extChars=3;
imwrite(paddedImage,[imagePath(1:end-(extChars+1)) '_signed.png'],'Mode','lossless');

disp(['Signed ' imagePath])
end

end

% from https://fr.mathworks.com/matlabcentral/fileexchange/73037-matlab-aes-encryption-decryption-example

function encrypted = encrypt(obj, strToEncrypt)
%ENCRYPT Summary of this method goes here
% Detailed explanation goes here
import java.util.Base64;
import java.lang.String;
import javax.crypto.Cipher;

obj.cipher.init(Cipher.ENCRYPT_MODE, obj.secretKey);
encrypted = string(Base64.getEncoder().encodeToString(obj.cipher.doFinal(String(strToEncrypt).getBytes("UTF-8"))));
end

function encrypted = encryptStructuredData(obj, structuredData)
encrypted = obj.encrypt(jsonencode(structuredData));
end

function decrypted = decryptStructuredData(obj, encryptedStructuredData)
decrypted = jsondecode(obj.decrypt(encryptedStructuredData));
end

function decrypted = decrypt(obj, strToDecrypt)
%DECRYPT Summary of this method goes here
% Detailed explanation goes here
import javax.crypto.Cipher;
import java.lang.String;
import java.util.Base64;

obj.cipher.init(Cipher.DECRYPT_MODE, obj.secretKey);
decrypted = string(String(obj.cipher.doFinal(Base64.getDecoder().decode(strToDecrypt))));
end

function obj = AES(secret,algorithm)
import java.security.MessageDigest;
import java.lang.String;
import java.util.Arrays;
import javax.crypto.Cipher;

key = String(secret).getBytes("UTF-8");
sha = MessageDigest.getInstance(algorithm);
key = sha.digest(key);
key = Arrays.copyOf(key, 16);
obj.secretKey = javaObject('javax.crypto.spec.SecretKeySpec',key, "AES");
obj.cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");



end
