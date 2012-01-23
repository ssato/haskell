# For Haskell Packaging Guidelines see:
# - https://fedoraproject.org/wiki/Packaging:Haskell
# - https://fedoraproject.org/wiki/PackagingDrafts/Haskell

%global pkg_name conduit

# common part of summary for all the subpackages
%global common_summary Haskell %{pkg_name} library

# main description used for all the subpackages
%global common_description A %{pkg_name} library for Haskell.

Name:           ghc-%{pkg_name}
Version:        0.1.1.1
Release:        0%{?dist}
Summary:        %{common_summary}
Group:          System Environment/Libraries
License:        BSD
# BEGIN cabal2spec
URL:            http://hackage.haskell.org/package/%{pkg_name}
Source0:        http://hackage.haskell.org/packages/archive/%{pkg_name}/%{version}/%{pkg_name}-%{version}.tar.gz
ExclusiveArch:  %{ghc_arches}
BuildRequires:  ghc-Cabal-devel
BuildRequires:  ghc-rpm-macros
%if %{undefined without_hscolour}
BuildRequires:  hscolour
%endif
# END cabal2spec
# BR any C devel dependency here
# list ghc-*-prof dependencies:
BuildRequires:  ghc-base-devel
BuildRequires:  ghc-lifted-base-devel
BuildRequires:  ghc-transformers-base-devel
BuildRequires:  ghc-monad-control-devel
BuildRequires:  ghc-containers-devel
BuildRequires:  ghc-transformers-devel
BuildRequires:  ghc-bytestring-devel
BuildRequires:  ghc-text-devel


%description
%{common_description}


%package -n ghc-%{pkg_name}-devel
Summary:        Development files for %{common_summary}
Group:          Development/Libraries
# BEGIN cabal2spec
%{?ghc_devel_requires}
Obsoletes:      ghc-%{pkg_name}-prof < %{version}-%{release}
Provides:       ghc-%{pkg_name}-prof = %{version}-%{release}
# END cabal2spec
# remember to require any C devel dependency here
# Haskell devel dependencies are autogenerated by ghc-deps.sh

%description -n ghc-%{pkg_name}-devel
%{common_description}

This package contains the development files.


%prep
%setup -q -n %{pkg_name}-%{version}


%build
#%define cabal_configure_options -f "opt1 -opt2 ..."
%ghc_lib_build


%install
%ghc_lib_install


%post -n ghc-%{pkg_name}-devel
%ghc_pkg_recache


%postun -n ghc-%{pkg_name}-devel
%ghc_pkg_recache


%if %{undefined ghc_without_shared}
%files -n ghc-%{pkg_name} -f ghc-%{pkg_name}.files
%endif


%files -n ghc-%{pkg_name}-devel -f ghc-%{pkg_name}-devel.files


%changelog
* Mon Jan 23 2012 Satoru SATOH <ssato@redhat.com> - 0.1.1.1-0
- new upstream

* Tue Jan 17 2012 Fedora Haskell SIG <haskell-devel@lists.fedoraproject.org> - 0.0.4-0
- initial packaging for Fedora automatically generated by cabal2spec-0.24.1
