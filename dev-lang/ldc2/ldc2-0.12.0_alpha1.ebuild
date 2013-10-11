# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI=4

inherit cmake-utils bash-completion-r1 versionator

MY_PV=$(replace_version_separator '_' '-')
GITHUB_BASE="https://github.com/ldc-developers"

PHOBOS_SHA1=89a229598dae3f8d2d0542679873f18f0436b0ee
DRUNTIME_SHA1=822720b8637bf5ad0d2301aa00807216a9d334bd

LDC_URI="${GITHUB_BASE}/ldc/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
DRUNTIME_URI="${GITHUB_BASE}/druntime/archive/${DRUNTIME_SHA1}.tar.gz -> ${P}_druntime.tar.gz"
PHOBOS_URI="${GITHUB_BASE}/phobos/archive/${PHOBOS_SHA1}.tar.gz -> ${P}_phobos.tar.gz"

SRC_URI="${LDC_URI} ${DRUNTIME_URI} ${PHOBOS_URI}"
MY_P="ldc-${MY_PV}"
S=${WORKDIR}/${MY_P}

DESCRIPTION="LLVM D Compiler"
HOMEPAGE="https://ldc-developers.github.com/ldc"
KEYWORDS="~x86 ~amd64 ~ppc64"
LICENSE="BSD"
SLOT="0"
IUSE=""

RDEPEND=">=sys-devel/llvm-3.1-r2
	>=dev-libs/libconfig-1.4.7"
DEPEND=">=dev-util/cmake-2.8
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	rm -rf "${S}/runtime/druntime"
	mv "${WORKDIR}/druntime-${DRUNTIME_SHA1}" "${S}/runtime/druntime" || die
	rm -rf "${S}/runtime/phobos"
	mv "${WORKDIR}/phobos-${PHOBOS_SHA1}" "${S}/runtime/phobos" || die
}

src_configure() {
	local mycmakeargs=(
		-DD_VERSION=2
		-DINCLUDE_INSTALL_DIR=/usr/include/ldc2
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make
}

src_install() {
	cmake-utils_src_install

	rm -rf "${ED}"/usr/share/bash-completion
	newbashcomp "bash_completion.d/ldc" ${PN}
}
