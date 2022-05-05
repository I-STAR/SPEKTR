function fig2file(varargin)

%% function fig2file.m    v.2.1.beta contribution of Riccardo Meldolesi <rmeldolesi@swri.org>
%						  v.2.0.beta Salem Benramdane <benramdane@ecole-navale.fr>
% routine to save figures into files in different formats fig, eps, jpg & ai

% provided as is. send complaints to dev@null.org

% please send incremented versions and bug reports to benramdane@ecole-navale.fr

% input:    fig_handle (optional): figure handle (ex: gcf, 1, myfig..etc) or name (ex: 'toto')

%           file_name (optional): figure file name (char type => between '') (ex:'myfigname'...etc)

%           i (optional): default i=0 (ypu may change it) (see table below)

% usage:    ex1: fig2file(gcf,'toto',1) : saves current figure(gcf) into file 'toto.fig'

%           ex2: fig2file(1,'toto') : saves figure 1 into specified default file formats, here: 'toto.jpg'

%           ex3: fig2file('synchro') : saves figure named "synchro" into specified default file formats, here: 'toto.jpg'

%           ex4: fig2file(1,2) : saves figure 1 into files 'Figure_1.fig' and 'Figure_1.eps'

%           ex5: fig2file(0) : saves the current figure named "chirp" into default specified file type

%           ex6: fig2file : saves current figure into default file format 'Figure_1.jpg' (provided figure number is "1" with no figure name)

%           ex7: fig2file all : saves all the current figures with either "figure_name" or "figure_number" as the file_name with default

%           extension

%           ex8: fig2file toto : saves current figure into file 'toto.jpg'

%           ex9:  fig2file(gcf,'toto',{'jpg'}) : saves current figure into file 'toto.jpg'

%           ex10: fig2file(gcf,'toto',{'jpg' ; 'pdf'}) : saves current figure into file 'toto.jpg'  and 'toto.pdf'

%           ex11: fig2file(gcf,{'jpg' ; 'pdf'}) : saves current figure named "chirp" into file 'chirp.jpg'  and 'chirp.pdf'

%           ex12: fig2file({'jpg' ; 'pdf'}) : saves current figure named "chirp" into file 'chirp.jpg'  and 'chirp.pdf'
%
%
% modification: you can freely add/modify the formats you want to be affected to different optional argument
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   i   %   saved figure

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   4   %   fig, eps, jpg, ai

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   3   %   fig, eps, jpg

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   2   %   fig, eps

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   1   %   fig

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   0   %   default

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   10   %   AI

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 

 

switch nargin

   case 3      % ### all arguments entered

      fct_saveas(varargin{:});

     

   case 2      % ### only two arguments entered

     

      %==> we consider either:

            %  "all"        and "i"         OR

            %  "fig_handle" and "file_name" OR

            %  "fig_handle" and "i"

 

      if ischar(varargin{1})                          % if the first argument is character => "all":

         switch upper(varargin{1})

            case 'ALL'                                % if the argument is "all"

               iteratePrint(varargin{2});             % save option "i" is the second argument

               return

            otherwise

               error('ErrorTests:convertTest','argument error! first argument "all" expected, \n Or if you entered figure name, please re-enter figure number instead', varargin{1},'found')

         end

      elseif ischar(varargin{2})                      % if the second argument is character => "file_name":

        

         fct_saveas(varargin{1},varargin{2},0);

      elseif isreal(varargin{2})  || iscell(varargin{2})                      % if the second argument is "i" => no file_name entered

 

         fct_saveas(varargin{1},getFileName(varargin{1}),varargin{2});

      else

         error('argument error! type "help fig2file" for more details')

      end

   case 1      % ### only one argument entered

     

      if ischar(varargin{1})                       % if the argument is a string:

         %==> supposed (string): "file_name" or 'all'

         if strcmpi(varargin{1},'all')                              % if the argument is "all"

            iteratePrint(i);

            return

         else                                   % if the argument is the file_name

            fct_saveas(getCurrentFigureHandle,varargin{1},0);

         end

      elseif isreal(varargin{1})  || iscell(varargin{1})                        % if the argument is integer "i" or a cell array

 

         fct_saveas(getCurrentFigureHandle,getFileName(getCurrentFigureHandle),varargin{1});

      else

         error('argument error! type "help fig2file" for more details')

      end

   case 0      % ### no arguments entered

 

      %==> save current figure with figure name as file name and with default options

      fct_saveas(getCurrentFigureHandle,getFileName(getCurrentFigureHandle),0);

   otherwise

      error('argument error! type "help fig2file" for more details')

end

return

 

% -------------------------------------------

function iteratePrint(printFormatIdentifier)

   h = findobj(get(0,'Children'), 'flat','type','figure');   % find all figures

   for j=1:length(h)                                         % for  all figures

      fct_saveas(h(j),getFileName(fig_handle),printFormatIdentifier)

   end

   return

 

% -------------------------------------------

function result = getFileName(fig_handle)

  

   result  = get(fig_handle,'name');               % set file_name = figure name

   if isempty(result)                              % if no figure name

      result=(['Figure_',int2str(fig_handle)]);    % set file_name = figure number

   end

   return

 

% -------------------------------------------

function result = getCurrentFigureHandle

   result = get(0,'CurrentFigure');              % find current fig handles (don't create one if no figures found)

   if isempty(result)                              % if no figure found

      error('no figure found')

   end

 

% -------------------------------------------

function fct_saveas(fig_handle,file_name,printFormat)

    if ~ishandle(fig_handle)                     % if handle is invalid

       fig_handle = findobj(get(0,'children'),'flat','name',fig_handle);

       if isempty(fig_handle)

          error('invalid figure handle')

       end

    end

   

    if isreal(printFormat)

       printFormat = processFormat(printFormat);

    end

   

    for k = 1:length(printFormat(:))

       switch upper(printFormat{k})

          case 'FIG'

             saveas(fig_handle,sprintf('%s',file_name),'fig');

          case 'JPG'

             saveas(fig_handle,sprintf('%s',file_name),'jpeg');

          case 'EPS'

             print(fig_handle,'-dpsc2', sprintf('%s.eps',file_name));

          case 'AI'

             saveas(fig_handle,sprintf('%s',file_name),'ai');

          case 'PDF'

             print(fig_handle,'-dpdf',sprintf('%s',file_name));

          otherwise

             error('unregognised printing option')

       end

    end

      

% -------------------------------------------

function printFormat = processFormat(printFormat)

   if isreal(printFormat)

      switch printFormat

         case 0

            printFormat = {'jpg'};

         case 1

            printFormat = {'fig'};

         case 2

            printFormat = {'fig';'eps'};

         case 3

            printFormat = {'fig';'jpg';'eps'};

          case 4

             printFormat = {'fig';'jpg';'eps';'ai'};

          case 10

             printFormat = {'pdf'};

          otherwise

             error('input argument printFormat must be between 0 < printFormat <= 4')

      end

   end