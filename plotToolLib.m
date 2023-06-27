
%% // --------------------------------------------------------------
%    ***FARYADELL SIMULATION FRAMEWORK***
%    Creator:   Abolfazl Delavar
%    Web:       http://abolfazldelavar.com
%% // --------------------------------------------------------------

classdef plotToolLib
    % In this library, all functions are related to plotting and depiction are
    % provided which can be used in 'depiction.m' file.
    methods
        
        function isi(obj, varargin)
            % <- (Save or Not (string is the file name), Figure handle, Options)
            % The below function change the style similar to ISI journals.
            % It changes fonts and its sizes like LaTeX
            % OPTION ORDERS:
            %     opt.pictureWidth = 20;
            %     opt.hwRatio      = 0.65;
            %     opt.fontSize     = 17;
            %     isi(h, opt);
            % ---------------------------------------------------------
            %
            
            son          = 0;       % Save or not? What is its name?
            h            = gcf;     % The previous figure is considered
            fontSize     = 14;      % The default font size of the figure
            pictureWidth = 20;      % Set the default width of the considered figure
            hwRatio      = 0.65;    % The default ratio between height and width
            
            % Extracting the arbitraty values of properties
            for i = 1:2:numel(varargin)
                if ischar(varargin{i})
                    switch varargin{i}
                        case 'save'
                            son          = varargin{i+1};
                        case 'figure'
                            h            = varargin{i+1};
                        case 'width'
                            pictureWidth = varargin{i+1};
                        case 'hwratio'
                            hwRatio      = varargin{i+1};
                        case 'fontsize'
                            fontSize     = varargin{i+1};
                    end
                end
            end

            % All font sizes contains labels and tick labels
            set(findall(h, '-property', 'FontSize'), 'FontSize', fontSize);
            % Hiding the top and the right borders
            set(findall(h, '-property', 'Box'), 'Box', 'off');
            % Changing the labels font and set  LaTeX format
            set(findall(h, '-property', 'Interpreter'), 'Interpreter', 'latex');
            % Changing the tick labels font and set  LaTeX format
            set(findall(h, '-property', 'TickLabelInterpreter'), 'TickLabelInterpreter', 'latex');
            % Changing size of the figure as you ordered
            set(h, 'Units', 'centimeters', 'Position', [0 -2 pictureWidth hwRatio*pictureWidth]);
            % Getting figure position and size
            pos = get(h, 'Position');
            % Below line changes the printed-version size
            set(h, 'PaperPositionMode', 'Auto', 'PaperUnits', 'centimeters', 'PaperSize', [pos(3), pos(4)]);
            % Two below lines save the figure in formats PNG and PDF
            if ischar(son) %User must import the figure name as 'son' var
                obj.figureSaveCore(son, h);
            end
        end
        
        
        function figureSaveCore(~, son, h)
            % Set the focused figure if is not inserted
            if ~exist('h', 'var'); h = gcf; end
            % To get current PC time to use as a prefix in the name of file
            savePath   = 'figs';
            % Default saving format
            fFormat    = 'jpg';
            AllFormats = {'jpg', 'png', 'pdf', 'fig'};
            isSetDirec = false;
            
            % Extracting the name and the directory which inported
            if ~exist('son', 'var') || ~ischar(son)
                % Set the time as its name, if there is no input in the arguments
                son = 'faryadell';
            else
                % Split folders
                tparts = split(son, '/');
                if numel(tparts) > 1
                    % Directory maker
                    savePath   = join(tparts(1:end-1), '/');
                    fparts     = split(tparts{end}, '.');
                    isSetDirec = 1;
                else
                    % If directory is not adjusted:
                    fparts = split(tparts, '.');
                end
                
                % Name and format
                if numel(fparts) > 1
                    % The name is also adjusted:
                    if numel(fparts{1}) == 0 || numel(fparts{end}) == 0
                        error('Please inter the correct notation for the file name.');
                    elseif ~(sum(contains(AllFormats, fparts{end})) && ...
                                 contains(fparts{end}, AllFormats))
                        error('You must input one of these formats: png/jpg/pdf/fig');
                    end
                    son     = join(fparts(1:end-1), '');
                    fFormat = fparts{2};
                else
                    % One of name or format just is inserted
                    % There is just name or format. It must be checked
                    if sum(contains(AllFormats, fparts{1})) && ...
                                 contains(fparts{1}, AllFormats)
                        fFormat = fparts{1};
                        % Set the time as its name, if there is no input in the arguments
                        son = 'faryadell';
                    else
                        % Just a name is imported, without directory
                        % and any formats
                        son = fparts{1};
                    end
                end
            end
            savePath = char(savePath);
            fFormat  = char(fFormat);
            son      = char(son);
            
            fName = son;
            
            % Prepare direct
            if isSetDirec == 0
                fDir = [savePath, '/' fFormat];
            else
                fDir = savePath;
            end
            if ~isfolder(fDir); mkdir(fDir) ;end
            
            % Check the folders existance and make them if do not exist
            % Saving part
            switch fFormat
                case 'png'
                    print(h, [fDir, '/', fName], '-dpng', '-painters', '-r400');
                case 'jpg'
                    print(h, [fDir, '/', fName], '-djpeg', '-painters', '-r400');
                case 'pdf'
                    print(h, [fDir, '/', fName], '-dpdf', '-painters', '-fillpage');
                case 'fig'
                    savefig(h, [fDir, '/', fName]);
            end
            disp(['The graph named "' fName '.', fFormat, '" has been saved into "', fDir, '".']);
        end
    end
end
