class Libadwaita < Formula
  desc "Building blocks for modern adaptive GNOME applications"
  homepage "https://gnome.pages.gitlab.gnome.org/libadwaita/"
  url "https://download.gnome.org/sources/libadwaita/1.3/libadwaita-1.3.4.tar.xz"
  sha256 "801ccaf3a760213b59ebb9b8185327df225049544aee68a1340b165710acb1bd"
  license "LGPL-2.1-or-later"

  # libadwaita doesn't use GNOME's "even-numbered minor is stable" version
  # scheme. This regex is the same as the one generated by the `Gnome` strategy
  # but it's necessary to avoid the related version scheme logic.
  livecheck do
    url :stable
    regex(/libadwaita-(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "e2908ac3790f2706c3739fdab2c2100d693ca9e2ec82b019a99e7b13510cc5a6"
    sha256 arm64_monterey: "ec6e42b6ae622d975cff68e8d32562fac7da0d420078e8d78f3bf2c5b8fe26d9"
    sha256 arm64_big_sur:  "79430eb51035c011bfadcf0b865ac46e129398d109109e6c622ee8c26fc22c99"
    sha256 ventura:        "a54ab75b0c49290b790478f08b5c10783c69255b05cb998d9f95f28deeb6cae0"
    sha256 monterey:       "684363e4a363eec59ddd34f36b7d5ae8f351f82b4a0ea736901ea3b04beec331"
    sha256 big_sur:        "08389a84c8bc3e7ec8e28484f3f21112c12871a33128585b84133c27cb5b23a6"
    sha256 x86_64_linux:   "0648439a56b7e5c2f53c6d97f385f9542590d2965456ef9396eed31a245a991c"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "vala" => :build
  depends_on "gtk4"

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    # Remove when `jpeg-turbo` is no longer keg-only.
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["jpeg-turbo"].opt_lib/"pkgconfig"

    (testpath/"test.c").write <<~EOS
      #include <adwaita.h>

      int main(int argc, char *argv[]) {
        g_autoptr (AdwApplication) app = NULL;
        app = adw_application_new ("org.example.Hello", G_APPLICATION_FLAGS_NONE);
        return g_application_run (G_APPLICATION (app), argc, argv);
      }
    EOS
    flags = shell_output("#{Formula["pkg-config"].opt_bin}/pkg-config --cflags --libs libadwaita-1").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test", "--help"

    # include a version check for the pkg-config files
    assert_match version.to_s, (lib/"pkgconfig/libadwaita-1.pc").read
  end
end
