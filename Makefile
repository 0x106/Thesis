#
# Makefile for use with a latex document that has a bibliography.
#
# To use: Create a directory to hold the source files and copy this file
# into it with the name "Makefile".
# Set the TITLE, CHAPTERS, and OSTYPE variables.
#
# typing "make" will make and view a .pdf file.
#
# Other Options:
#
# make clean: remove all auxiliary and temp files.
#
# make nuke: same as clean but remove main pdf file as well.
#
# make touch: force recompilation
#
# make backup: rsync the directory onto another machine
#


TITLE = thesis

# Put the names of your separate chapter files here
CHAPTERS = chapters/outline.tex chapters/intro.tex chapters/literature.tex chapters/new_ideas.tex chapters/implementation.tex chapters/results.tex chapters/conclusion.tex chapters/abstract.tex chapters/acknowledgements.tex chapters/appendices.tex

# Uncommenting the following line will convert xfig files to pdf using fig2dev.
# FIGFILES = ex1.fig ex2.fig

# Machine you wish to backup your files on.  We assume it is running
# rsync and ssh, so format should be username@host.domain
BKP = jcampbell@ssh.otago.ac.nz

# Sometimes you want to view your document after every compile, sometimes not.
# Set the following variable appropriately.
AUTOVIEW = yes
#AUTOVIEW = no


#
# ALTER THE FOLLOWING AT YOUR OWN RISK
#

OSTYPE = $(shell uname)

TEXFILE = $(TITLE).tex
PDFFILE = $(TITLE).pdf
BIBFILE = $(TITLE).bib
PDFFIGS = $(FIGFILES:.fig=.pdf)

VIEWCMD = gv
ifeq (Linux,$(OSTYPE))
VIEWCMD = gv
endif
ifeq (Darwin,$(OSTYPE))
VIEWCMD = open -a preview
endif
ifeq (no,$(AUTOVIEW))
VIEWCMD = echo finished
endif

THISDIR = $(shell basename $(PWD))

pdf : $(PDFFILE)
	$(VIEWCMD) $<

$(PDFFILE) : $(TEXFILE)  $(CHAPTERS) $(BIBFILE) $(PDFFIGS)
	pdflatex $<
	bibtex $(TITLE)
	pdflatex $<
	pdflatex $<

%.pdf: %.fig
	fig2dev -L pdf $< > $@

.PHONY : clean nuke backup touch

clean :
	rm -rf *~ *.log *.lof *.aux *.lot *.bbl *.blg *.toc \#*

touch : clean
	touch $(TEXFILE) $(CHAPTERS) $(BIBFILE)

backup : clean
	cd ..; rsync -v -v -az -e ssh $(THISDIR) $(BKP):

nuke : clean
	rm -rf $(PDFFILE) $(PDFFIGS)
