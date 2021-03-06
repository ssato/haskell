# cabal2spec-0.25
# https://fedoraproject.org/wiki/Packaging:Haskell
# https://fedoraproject.org/wiki/PackagingDrafts/Haskell

%global pkg_name HaXml


Name:           ghc-%{pkg_name}
Version:        1.23.3
Release:        1%{?dist}
Summary:        Haskell library to parse or generate XML texts
Group:          System Environment/Libraries
License:        LGPL
# BEGIN cabal2spec
URL:            http://hackage.haskell.org/package/%{pkg_name}
Source0:        http://hackage.haskell.org/packages/archive/%{pkg_name}/%{version}/%{pkg_name}-%{version}.tar.gz
ExclusiveArch:  %{ghc_arches}
BuildRequires:  ghc-Cabal-devel
BuildRequires:  ghc-rpm-macros %{!?without_hscolour:hscolour}
# END cabal2spec
BuildRequires:  ghc-base-devel
BuildRequires:  ghc-bytestring-devel
BuildRequires:  ghc-containers-devel
BuildRequires:  ghc-filepath-devel
BuildRequires:  ghc-polyparse-devel
BuildRequires:  ghc-pretty-devel
BuildRequires:  ghc-random-devel


%description
Haskell utilities for parsing, filtering, transforming and generating XML
documents.


%prep

%setup -q -n %{pkg_name}-%{version}


%build
%ghc_lib_build


%install
%ghc_lib_install


# devel subpackage
%ghc_devel_package

%ghc_devel_description


%ghc_devel_post_postun


%ghc_files %{_bindir}/*


%changelog
* Thu Jul 26 2012 Satoru SATOH <ssato@redhat.com> - 1.23.3-1
- New upstream

* Thu Jul  5 2012 Fedora Haskell SIG <haskell-devel@lists.fedoraproject.org>
- spec file template generated by cabal2spec-0.25.5
