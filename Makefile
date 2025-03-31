# h/t to @jimhester and @yihui for this parse block:
# https://github.com/yihui/knitr/blob/dc5ead7bcfc0ebd2789fe99c527c7d91afb3de4a/Makefile#L1-L4
# Note the portability change as suggested in the manual:
# https://cran.r-project.org/doc/manuals/r-release/R-exts.html#Writing-portable-packages
PKGNAME := $(shell sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGVERS := $(shell sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION)
PKGSRC  := $(shell basename `pwd`)
RM = rm -rf
RCMD = R --vanilla CMD
RSCRIPT = Rscript --vanilla


all: check clean
roxygen: docs

docs:
	@ $(RSCRIPT) -e "roxygen2::roxygenise(roclets = c('collate', 'namespace', 'rd'))"

readme:
	@ echo "Rendering README.Rmd"
	@ $(RSCRIPT) \
	-e "Sys.setenv(RSTUDIO_PANDOC='/usr/bin/pandoc/')" \
	-e "options(cli.width = 80L)" \
	-e "rmarkdown::render('README.Rmd', quiet = TRUE)"
	@ $(RM) README.html

test:
	@ $(RSCRIPT) \
	-e "Sys.setenv(TZ = 'America/Denver')" \
	-e "devtools::test(reporter = 'summary', stop_on_failure = TRUE)"

test_file:
	@ $(RSCRIPT) \
	-e "Sys.setenv(TZ = 'America/Denver', NOT_CRAN = 'true')" \
	-e "devtools::load_all()" \
	-e "testthat::test_file('$(FILE)', reporter = 'progress', stop_on_failure = TRUE)"

accept_snapshots:
	@ Rscript -e "testthat::snapshot_accept()"

build: docs
	@ cd ..;\
	$(RCMD) build --resave-data $(PKGSRC)

check: build
	@ cd ..;\
	$(RCMD) check --no-manual $(PKGNAME)_$(PKGVERS).tar.gz

install:
	@ R CMD INSTALL --use-vanilla --preclean --resave-data .

increment:
	@ echo "Adding Version '$(ver)' to DESCRIPTION"
	@ $(shell sed -i 's/^Version: .*/Version: $(ver)/' DESCRIPTION)
	@ echo "Adding new heading to 'NEWS.md'"
	@ $(shell sed -i '1s/^/# $(PKGNAME) $(ver)\n\n/' NEWS.md)

release:
	@ echo "Adding release commit"
	@ git add -u
	@ git commit -m "Increment version number"
	@ git push origin main
	@ git tag -a v$(PKGVERS) -m "Release of $(PKGVERS)"
	@ git push origin v$(PKGVERS)
	@ echo "Remember to bump the DESCRIPTION file with bump_to_dev()"

clean:
	@ cd ..;\
	$(RM) $(PKGNAME)_$(PKGVERS).tar.gz $(PKGNAME).Rcheck
