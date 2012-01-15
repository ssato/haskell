# https://fedoraproject.org/wiki/Packaging:Haskell
# https://fedoraproject.org/wiki/PackagingDrafts/Haskell

Name:           yeganesh
Version:        2.4
Release:        1%{?dist}
Summary:        A small wrapper utitlity around dmenu
Group:          User Interface/X
License:        BSD
URL:            http://dmwit.com/yeganesh/%{name}
Source0:        http://hackage.haskell.org/packages/archive/%{name}/%{version}/%{name}-%{version}.tar.gz
ExclusiveArch:  %{ghc_arches}
Requires:       dmenu
BuildRequires:  ghc-Cabal-devel
BuildRequires:  ghc-rpm-macros
Patch1:         yeganesh-2.4-build-wo-xdg.patch
BuildRequires:  ghc-base-devel
BuildRequires:  ghc-containers-devel
BuildRequires:  ghc-directory-devel
BuildRequires:  ghc-filepath-devel
BuildRequires:  ghc-process-devel
BuildRequires:  ghc-strict-devel
BuildRequires:  ghc-time-devel
BuildRequires:  ghc-unix-devel
#
## Not available in fedora yet:
#BuildRequires:  ghc-xdg-basedir-devel


%description
Inspired by the Ion3 status bar, it supports similar features, like dynamic
color management, output templates, and extensibility through plugins.


%prep
%setup -q
%patch1 -p1 -b .xdg


%build
%ghc_bin_build


%install
%ghc_bin_install


%files
%doc LICENSE
%attr(755,root,root) %{_bindir}/*


%changelog
* Sun Jan 15 2012 Satoru SATOH <ssato@redhat.com> - 2.4-1
- initial packaging
