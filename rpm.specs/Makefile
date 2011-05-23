rpm_spec_SOURCES = ghc-reactive.spec ghc-unamb.spec

# ex. $(HOME)/.cabal/packages/hackage.haskell.org/category-extras/0.53.5/category-extras-0.53.5.tar.gz
sources_topdir	?= $(HOME)/.cabal/packages/hackage.haskell.org

unamb_VERSION	?= 0.2.4
lazysmallcheck_VERSION	?= 0.5



unamb: ghc-unamb.spec
	cabal fetch unamb || (cabal update && cabal fetch unamb)
	mock --buildsrpm --spec ghc-unamb.spec --sources $(sources_topdir)/unamb/$(unamb_VERSION)/unamb-$(unamb_VERSION).tar.gz

lazysmallcheck: ghc-lazysmallcheck.spec
	cabal fetch $@ || (cabal update && cabal fetch $@)
	mversion=`cabal info $@ | sed -nr 's,.*Latest version available: ([0-9.]+),\1,p'`
	mock --buildsrpm --spec $< --sources $(sources_topdir)/$@/$$mversion/$@-$$mversion.tar.gz


clean:
	-rm -f unamb.darcs

.PHONY: unamb lazysmallcheck
