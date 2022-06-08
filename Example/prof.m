files=allFigs();
if not(files == "")
  for file=files
    file=char(file);
    % ignore .jpg files
    if(not(strcmp(file(end-3:end),'.jpg')))
      verifyImage(file)
    end
  end
end
