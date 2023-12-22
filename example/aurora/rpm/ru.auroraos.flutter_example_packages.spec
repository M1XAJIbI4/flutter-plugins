%global __provides_exclude_from ^%{_datadir}/%{name}/lib/.*$
%global __requires_exclude ^lib(yuv|ZXing|jpeg|dconf|flutter-embedder|maliit-glib|.+_platform_plugin)\\.so.*$

Name: ru.auroraos.flutter_example_packages
Summary: Examples of the flutter plugins for Aurora OS.
Version: 0.1.0
Release: 1
License: Proprietary
Source0: %{name}-%{version}.tar.zst

BuildRequires: ninja
BuildRequires: pkgconfig(sqlite3)
BuildRequires: pkgconfig(flutter-embedder)
BuildRequires: pkgconfig(Qt5Sensors)
BuildRequires: pkgconfig(streamcamera)

%description
%{summary}.

%prep
%autosetup

%build
%cmake -GNinja -DCMAKE_BUILD_TYPE=%{_flutter_build_type} -DPSDK_VERSION=%{_flutter_psdk_version} -DPSDK_MAJOR=%{_flutter_psdk_major}
%ninja_build

%install
%ninja_install

%files
%{_bindir}/%{name}
%{_datadir}/%{name}/*
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
