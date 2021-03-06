# For Haskell Packaging Guidelines see:
# - https://fedoraproject.org/wiki/Packaging:Haskell
# - https://fedoraproject.org/wiki/PackagingDrafts/Haskell

%global pkg_name reactive

# common part of summary for all the subpackages
%global common_summary Haskell %{pkg_name} library

# main description used for all the subpackages
%global common_description A %{pkg_name} library for Haskell.

# Haskell library dependencies (used for buildrequires and devel/prof subpkg requires)
#%%global ghc_pkg_deps ghc-@DEP1@-devel, ghc-@DEP2@-devel
#
# base >=4 && <5, old-time, random, QuickCheck >= 2.1.0.2,
# TypeCompose>=0.8.0, vector-space>=0.5,
# unamb>=0.1.5, checkers >= 0.2.3,
# category-extras >= 0.53.5, Stream
#
%global ghc_pkg_deps ghc-QuickCheck-devel ghc-old-time-devel ghc-random-devel # ghc-Boolean-devel ghc-MemoTrie-devel ghc-array-devel

# foreign library dependencies (used for buildrequires and devel subpkg requires)
#%%global ghc_pkg_c_deps @CDEP1@-devel

%bcond_without shared

# debuginfo is not useful for ghc
%global debug_package %{nil}

Name:           ghc-%{pkg_name}
Version:        0.11.5
Release:        1%{?dist}
Summary:        %{common_summary}
Group:          System Environment/Libraries
License:        @LICENSE@
URL:            http://hackage.haskell.org/package/%{pkg_name}
Source0:        http://hackage.haskell.org/packages/archive/%{pkg_name}/%{version}/%{pkg_name}-%{version}.tar.gz
# fedora ghc archs:
ExclusiveArch:  %{ix86} x86_64 ppc alpha sparcv9 ppc64
BuildRequires:  ghc, ghc-doc, ghc-prof
# macros for building haskell packages
BuildRequires:  ghc-rpm-macros
BuildRequires:  hscolour
%{?ghc_pkg_deps:BuildRequires:  %{ghc_pkg_deps}, %(echo %{ghc_pkg_deps} | sed -e "s/\(ghc-[^, ]\+\)-devel/\1-doc,\1-prof/g")}
%{?ghc_pkg_c_deps:BuildRequires:  %{ghc_pkg_c_deps}}

%description
%{common_description}
%if %{with shared}
This package provides the shared library.
%endif


%{?ghc_lib_package}


%prep
%setup -q -n %{pkg_name}-%{version}


%build
%ghc_lib_build


%install
%ghc_lib_install


# define the devel and prof subpkgs, devel post[un] scripts, and filelists:
# ghc-reactive{,-devel,-prof}.files
%ghc_lib_package


%changelog
* Mon May 23 2011 Satoru SATOH <ssato@redhat.com> - 0.11.0-1
- buildrequires ghc-mtl-devel and cairo-devel

* Mon May 23 2011 Fedora Haskell SIG <haskell-devel@lists.fedoraproject.org> - 0.11.5-0
- initial packaging for Fedora automatically generated by cabal2spec-0.22.7
