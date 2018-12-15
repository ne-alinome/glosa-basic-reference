# Makefile of _Glosa Basic Reference_

# By Marcos Cruz (programandala.net)

# Last modified 201812151404
# See change log at the end of the file

# ==============================================================
# Requirements

# - make
# - asciidoctor
# - asciidoctor-pdf
# - pandoc

# ==============================================================
# Config

VPATH=./src:./$(target)

book=glosa_basic_reference

target=target

# ==============================================================
# Interface

.PHONY: all
all: epub html odt pdf

.PHONY: docbook
docbook: $(target)/$(book).adoc.xml

.PHONY: epub
epub: $(target)/$(book).adoc.xml.pandoc.epub

.PHONY: html
html: $(target)/$(book).adoc.html $(target)/$(book).adoc.plain.html $(target)/$(book).adoc.xml.pandoc.html

.PHONY: odt
odt: $(target)/$(book).adoc.xml.pandoc.odt

.PHONY: pdf
pdf: $(target)/$(book).adoc.pdf

.PHONY: rtf
rtf: $(target)/$(book).adoc.xml.pandoc.rtf

.PHONY: clean
clean:
	rm -f \
		$(target)/*.epub \
		$(target)/*.html \
		$(target)/*.odt \
		$(target)/*.pdf \
		$(target)/*.rtf \
		$(target)/*.xml

# ==============================================================
# Convert to DocBook

$(target)/$(book).adoc.xml: $(book).adoc
	asciidoctor --backend=docbook5 --out-file=$@ $<

# ==============================================================
# Convert to EPUB

# NB: Pandoc 1.9.4.2 does not allow alternative templates. The default
# templates must be modified or redirected instead. They are the following:
# 
# /usr/share/pandoc-1.9.4.2/templates/epub-coverimage.html
# /usr/share/pandoc-1.9.4.2/templates/epub-page.html
# /usr/share/pandoc-1.9.4.2/templates/epub-titlepage.html

$(target)/$(book).adoc.xml.pandoc.epub: $(target)/$(book).adoc.xml
	pandoc \
		--from=docbook \
		--to=epub \
		--output=$@ \
		$<

# ==============================================================
# Convert to HTML

$(target)/$(book).adoc.plain.html: $(book).adoc
	adoc \
		--attribute="stylesheet=none" \
		--quiet \
		--out-file=$@ \
		$<

$(target)/$(book).adoc.html: $(book).adoc
	adoc --out-file=$@ $<

$(target)/$(book).adoc.xml.pandoc.html: $(target)/$(book).adoc.xml
	pandoc \
		--from=docbook \
		--to=html \
		--standalone \
		--output=$@ \
		$<

# ==============================================================
# Convert to ODT

$(target)/$(book).adoc.xml.pandoc.odt: $(target)/$(book).adoc.xml
	pandoc \
		+RTS -K15000000 -RTS \
		--from=docbook \
		--to=odt \
		--output=$@ \
		$<

# ==============================================================
# Convert to PDF

$(target)/$(book).adoc.pdf: $(book).adoc
	asciidoctor-pdf --out-file=$@ $<

# ==============================================================
# Convert to RTF

$(target)/$(book).adoc.xml.pandoc.rtf: $(target)/$(book).adoc.xml
	pandoc \
		--from=docbook \
		--to=rtf \
		--standalone \
		--output=$@ \
		$<

# ==============================================================
# Change log

# 2018-11-24: Start. Adapt the Makefile of the _18 Steps to Fluency in
# Euro-Glosa_ project.
#
# 2018-12-15: Fix pandoc's HTML and RTF output. The `--standalone` option was
# missing.
