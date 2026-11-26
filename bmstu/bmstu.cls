%% bmstu.cls
%% Copyright 2023 Mikael Novikov
%
% This work may be distributed and/or modified under the
% conditions of the LaTeX Project Public License, either version 1.3
% of this license or (at your option) any later version.
% The latest version of this license is in
%   http://www.latex-project.org/lppl.txt
% and version 1.3 or later is part of all distributions of LaTeX
% version 2005/12/01 or later.
%
% This work has the LPPL maintenance status `maintained'.
%
% The Current Maintainer of this work is Mikael Novikov.
%
% This work consists of all files listed in manifest.txt.

\NeedsTeXFormat{LaTeX2e}

\ProvidesClass{bmstu}[2023/01/28 v2.0.0 BMSTU class]

% Установка базового класса
\LoadClass[a4paper,oneside,14pt]{extreport}

% Настройка кодировки и языков
\RequirePackage{fontspec}
\setmainfont{Times New Roman}
\setsansfont{Times New Roman}
\setmonofont{Courier New}

\RequirePackage{unicode-math}
\setmathfont{XITS Math}

% Сквозная нумерация формул по всему документу.
\counterwithout{equation}{chapter}

% \RequirePackage{cmap}
% \RequirePackage[T2A]{fontenc}
% \RequirePackage[utf8]{inputenc}
% \RequirePackage{amsmath}
% \RequirePackage{amssymb}

\RequirePackage[english,main=russian]{babel}
\RequirePackage{fix-cm}

% Настройка полей
\RequirePackage[
	left=30mm,
	right=10mm, % Является требованием МГТУ, не соответствует ГОСТ 7.32-2017
	top=20mm,
	bottom=20mm,
]{geometry}

% Плавающие объекты на отдельной странице начинаются от верхнего поля.
\setlength{\@fptop}{0pt}

% Настройка переносов
\RequirePackage{microtype}
\sloppy

% Настройка межстрочного интервала
\RequirePackage{setspace}
\onehalfspacing

% Настройка абзацного отступа
\RequirePackage{indentfirst}
\newlength{\bmstuparagraphindent}
\setlength{\bmstuparagraphindent}{12.5mm}
\setlength{\parindent}{\bmstuparagraphindent}

% Настройка заголовков
\makeatletter
\renewcommand\LARGE{\@setfontsize\LARGE{22pt}{20}}
\renewcommand\Large{\@setfontsize\Large{20pt}{20}}
\renewcommand\large{\@setfontsize\large{16pt}{20}}
\makeatother
\RequirePackage{titlesec}

% Для заголовков разрешён перенос строки только между словами.
\newcommand{\bmstuheadingformat}{%
    \bfseries
    \hyphenpenalty=10000\relax
    \exhyphenpenalty=10000\relax
}
\titleformat{\chapter}[block]{\bmstuheadingformat}
    {\hspace*{\bmstuparagraphindent}\thechapter}{0.5em}{}
\titleformat{name=\chapter,numberless}[block]{\bmstuheadingformat\centering}
    {}{0pt}{}
\titleformat{\section}[block]{\bmstuheadingformat}
    {\hspace*{\bmstuparagraphindent}\thesection}{0.5em}{}
\titleformat{\subsection}[block]{\bmstuheadingformat}
    {\hspace*{\bmstuparagraphindent}\thesubsection}{0.5em}{}
\titleformat{\subsubsection}[block]{\bmstuheadingformat}
    {\hspace*{\bmstuparagraphindent}\thesubsubsection}{0.5em}{}

% titlesec добавляет этот отступ к обычному расстоянию между строками.
% По схеме МГТУ расстояние до текста составляет около двух шагов строки.
\titlespacing{\chapter}{0pt}{-22pt}{\baselineskip}
\titlespacing{\section}{0pt}{\baselineskip}{\baselineskip}
\titlespacing{\subsection}{0pt}{\baselineskip}{\baselineskip}
\titlespacing{\subsubsection}{0pt}{\baselineskip}{\baselineskip}

% Между соседними заголовками на схеме около 1,6 шага строки.
% titlesec вызывает этот макрос после уже добавленного отступа.
\makeatletter
\renewcommand{\ttl@titlespace}[1]{\vskip-.4\baselineskip\relax}
\makeatother

\RequirePackage{titletoc}
\titlecontents{chapter}[0pt]{}{\thecontentslabel\hspace{10pt}}{}{\titlerule*[0.5em]{.}\contentspage}
\titlecontents{section}[12.5mm]{}{\thecontentslabel\hspace{10pt}}{}{\titlerule*[0.5em]{.}\contentspage}
\titlecontents{subsection}[25mm]{}{\thecontentslabel\hspace{10pt}}{}{\titlerule*[0.5em]{.}\contentspage}
\titlecontents{subsubsection}[37.5mm]{}{\thecontentslabel\hspace{10pt}}{}{\titlerule*[0.5em]{.}\contentspage}

% Подключение пакета цветов
\RequirePackage{xcolor}

\RequirePackage{bmstu-figure}
\RequirePackage{bmstu-listing}

% Подключение пакетов таблиц
\RequirePackage{xltabular}
\RequirePackage{booktabs}
\RequirePackage{tabularray}

% Оформление многостраничных таблиц longtblr
\SetTblrInner[longtblr]{width=\linewidth,hlines,vlines}
\SetTblrTemplate{caption}{simple}
\SetTblrStyle{caption,conthead}{halign=l,indent=0pt}
\SetTblrStyle{note}{font=\normalfont\footnotesize}
\SetTblrStyle{note-tag}{font=\rmfamily}
\DefTblrTemplate{caption-sep}{bmstu}{\space--\space}
\DefTblrTemplate{conthead-text}{bmstu}{Продолжение таблицы~\thetable}
\SetTblrTemplate{caption-sep,conthead-text}{bmstu}
\DefTblrTemplate{middlehead,lasthead}{bmstu}{\UseTblrTemplate{conthead}{default}}
\SetTblrTemplate{middlehead,lasthead}{bmstu}
\SetTblrTemplate{contfoot}{empty}

% Настройка подписей
\RequirePackage[
	labelsep=endash,
	figurename=Рисунок,
	singlelinecheck=false,
]{caption}
\captionsetup[figure]{justification=centering}
\captionsetup[listing]{name=Листинг, justification=raggedright, position=top, skip=6pt}


% Альбомная ориентация и вставка страниц PDF
\RequirePackage{pdflscape}
\RequirePackage{pdfpages}
\RequirePackage{afterpage}

% Настройка библиографии
\RequirePackage[
	style=gost-numeric,
	language=auto,
	autolang=other,
	sorting=none,
]{biblatex}
\RequirePackage{csquotes}
\DeclareFieldFormat[online]{title}{#1 [Электронный~ресурс]}
\DeclareFieldFormat{url}{Режим~доступа~URL: \url{#1}}
\DeclareFieldFormat{urldate}{(дата обращения:~\thefield{urlday}\adddot \thefield{urlmonth}\adddot \thefield{urlyear})}

% Подстрочные сноски внизу текстовой области
\RequirePackage[bottom]{footmisc}

% Подключение пакета гиперссылок
\RequirePackage[unicode,hidelinks]{hyperref}

% Подключение пакета управляющих конструкций
\RequirePackage{xifthen}

% Подключение пакета enumitem для использования тире в списках
\RequirePackage{enumitem}
\setlist[itemize]{label=---}

\AddEnumerateCounter{\asbuk}{\@asbuk}{малая русская}
\setlist[enumerate]{label=\arabic*)}
\setlist[enumerate,2]{label=\asbuk*)}
\setlist[itemize,enumerate,1]{labelindent=\bmstuparagraphindent,leftmargin=*}



\RequirePackage{bmstu-title}
\RequirePackage{bmstu-essay}
\RequirePackage{bmstu-toc}
\RequirePackage{bmstu-defabbr}
\RequirePackage{bmstu-biblio}
\RequirePackage{bmstu-appendix}
