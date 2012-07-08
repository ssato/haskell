# cabal2spec-0.25
# https://fedoraproject.org/wiki/Packaging:Haskell
# https://fedoraproject.org/wiki/PackagingDrafts/Haskell

%global pkg_name syb-with-class
%global common_summary Haskell %{pkg_name} library
%global common_description A %{pkg_name} library for Haskell.


Name:           ghc-%{pkg_name}
Version:        0.6.1.3
Release:        1%{?dist}
Summary:        %{common_summary}
Group:          System Environment/Libraries
License:        BSD
# BEGIN cabal2spec
URL:            http://hackage.haskell.org/package/%{pkg_name}
Source0:        http://hackage.haskell.org/packages/archive/%{pkg_name}/%{version}/%{pkg_name}-%{version}.tar.gz
ExclusiveArch:  %{ghc_arches}
BuildRequires:  ghc-Cabal-devel
BuildRequires:  ghc-rpm-macros %{!?without_hscolour:hscolour}
# END cabal2spec
BuildRequires:  ghc-base-devel
BuildRequires:  ghc-template-haskell-devel
BuildRequires:  ghc-bytestring-devel
BuildRequires:  ghc-array-devel
BuildRequires:  ghc-containers-devel


%description
%{common_description}


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

%ghc_files LICENSE


%changelog
* Mon Jul  9 2012 Satoru SATOH <ssato@redhat.com> - 0.6.1.3-1
- Added build-time dependencies

* Sun Jul  8 2012 Fedora Haskell SIG <haskell-devel@lists.fedoraproject.org>
- spec file template generated by cabal2spec-0.25.5
