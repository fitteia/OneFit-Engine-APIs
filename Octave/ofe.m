function [data] = ofe(datafile,varargin)

  external_program = 'curl';

  arguments = [' -F "file=@', datafile, '" '];
  arguments = [ arguments, ' http://192.168.64.40:8142/fit/ofe -s -F "download=json" '];

  if length(varargin)>0
    for i=1:length(varargin)
      arguments = [ arguments, ' -F "' ,varargin{i}, '" '];
    endfor
  end

  command = [external_program, ' ', arguments];
%  disp(command)
  disp('Running external program...');
  [status, output] = system(command);

  if status == 0
      disp('External program executed successfully.');
  else
      error('External program failed with status: %d\nOutput: %s', status, output);
  end


  data = jsondecode(output);

  if isfield(data, 'fit_curves')
      plot_fit(data)
  else
      warning('No "fit-curves" field found in the JSON data.');
  end

endfunction


function [ numeric_data ] = dados_fit(json,k)
  lines = strsplit(json.('fit_residues'){k}, '\n');
  numeric_data = [];

  for i = 1:length(lines)
    line = lines{i};

    if isempty(line) || line(1) == '#'
        continue;
    end
    numeric_data = [numeric_data; str2num(line)];
  end
  numeric_data(:,1:2);
endfunction

function [ numeric_data ] = fit_curves(json,k)
  lines = strsplit(json.('fit_curves'){k}, '\n');
  numeric_data = [];

  for i = 1:length(lines)
    line = lines{i};

    if isempty(line) || line(1) == '#'
        continue;
    end
    numeric_data = [numeric_data; str2num(line)];
  end
endfunction


function plot_fit(data)
  np = length(data.('fit_residues'))
  figure;

  for k=1:np
    t = fit_curves(data,k);
    dados = dados_fit(data,k);
    subplot(ceil(np/5),5,k);
    semilogx(t(:,1),t(:,2:end),dados(:,1),dados(:,2),'-o',0.1);
  endfor
    disp(data.('fit_results'))

endfunction
