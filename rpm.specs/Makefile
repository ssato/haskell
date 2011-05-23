ghc_MODULES	?= TypeCompose unamb lazysmallcheck checkers vector-space Stream category-extras

ghc_mod_VERSIONS = $(addsuffix .version,$(ghc_MODULES))


# ex. $(HOME)/.cabal/packages/hackage.haskell.org/category-extras/0.53.5/category-extras-0.53.5.tar.gz
sources_topdir	?= $(HOME)/.cabal/packages/hackage.haskell.org

mock_build_srpm = mock --buildsrpm --spec ghc-$@.spec --sources $<


all:


versions: $(ghc_mod_VERSIONS)

$(ghc_mod_VERSIONS):
	echo > $@.tmp
	m=`echo $@ | sed 's,.version,,'`; \
	mversion=`cabal info $$m | sed -nr 's,.*Latest version available: ([0-9.]+),\\1,p'`; \
		test -n "$$mversion"; \
		echo "$${m}_VERSION ?= $$mversion" >> $@.tmp
	mv $@.tmp $@

depends:
	echo > $@.tmp
	for m in $(ghc_MODULES); do \
		echo "$$m: \$$(sources_topdir)/\$$@/\$$($${m}_VERSION)/\$$@-\$$($${m}_VERSION).tar.gz" >> $@.tmp; \
		echo "$$m: ghc-$$m.spec" >> $@.tmp; \
		echo "sinclude $$m.version" >> $@.tmp; \
	done
	mv $@.tmp $@


sinclude depends

$(ghc_MODULES):
	$(mock_build_srpm)


clean:
	-rm -f depends

.PHONY: unamb lazysmallcheck
