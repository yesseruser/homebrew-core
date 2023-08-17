class Javatutorinkt < Formula
  desc "A Java Tutorial but in Kotlin (at least partially). Prints \"Hello World.\""
  homepage "https://github.com/yesseruser/JavaTutorialButInKotlin"
  url "https://github.com/yesseruser/JavaTutorialButInKotlin/releases/download/1.1/JavaTutorialButInKotlin-1.1.tar.gz"
  sha256 "34de5d9790376da923a595fa3c9dead7fc8683ecb383f2b6c70392aa1f29d868"
  license "mit"

  depends_on "java"

    def install
      libexec.install "JavaTutorialButInKotlin-1.1.jar"
      bin.write_jar_script libexec/"JavaTutorialButInKotlin-1.1.jar", "javatutorinkt"
    end

    test do
      assert_predicate bin/"javatutorinkt", :exist?
      assert_predicate bin/"javatutorinkt", :executable?
      
      output = shell_output("#{bin}/javatutorinkt")
      assert_match "Hello World!", output
    end
end
