    When I run `../../../bin/hg-blame-game add.rb` interactively
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:1: module Add
           Danny Dover <developers+danny@foo.com> acb762f5f681:2:   def add_4(y)
           Danny Dover <developers+danny@foo.com> acb762f5f681:3:     y + 5
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:4:   end
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:5: end
      # HG changeset patch
      # User Danny Dover <developers+danny@foo.com>
      # Date 1326581406 28800
      #      Sat Jan 14 14:50:06 2012 -0800
      # Node ID acb762f5f681d31b710f49f563ba8d1562b9e4c2
      # Parent  c8769d6446bc9adf5c0ad0394d87c31594f0cd2b
      I like y's better

      committer: Charles Finkel <charles.finkel@gmail.com>

      diff -r c8769d6446bc -r acb762f5f681 add.rb
      --- a/add.rb	Sat Jan 14 14:49:00 2012 -0800
      +++ b/add.rb	Sat Jan 14 14:50:06 2012 -0800
        1) add.rb   (or 's' for same)
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:1: module Add
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:2:   def add_4(x)
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:3:     x + 5
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:4:   end
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:5: end
      # HG changeset patch
      # User Carmen Cummings <developers+carmen@foo.com>
      # Date 1326581340 28800
      #      Sat Jan 14 14:49:00 2012 -0800
      # Node ID c8769d6446bc9adf5c0ad0394d87c31594f0cd2b
      # Parent  c043b110cc46389037e207f814d251f4c7e00a7b
      moving add_4 to module

      committer: Charles Finkel <charles.finkel@gmail.com>

      diff -r c043b110cc46 -r c8769d6446bc add.rb
      --- /dev/null	Thu Jan 01 00:00:00 1970 +0000
      +++ b/add.rb	Sat Jan 14 14:49:00 2012 -0800
      diff -r c043b110cc46 -r c8769d6446bc blah.rb
      --- a/blah.rb	Sat Jan 14 14:46:53 2012 -0800
      +++ b/blah.rb	Sat Jan 14 14:49:00 2012 -0800
        1) blah.rb
        2) add.rb   (or 's' for same)
    When I type "1"
      Alice Amos <developers+alice@foo.com> a37def2620e7:1: def add_4(x)
        Bob Barker <developers+bob@foo.com> c043b110cc46:2:   x + 5
      Alice Amos <developers+alice@foo.com> a37def2620e7:3: end
      Alice Amos <developers+alice@foo.com> a37def2620e7:4:
      Alice Amos <developers+alice@foo.com> a37def2620e7:5: puts add_4(9) # should be 13
      # HG changeset patch
      # User Bob Barker <developers+bob@foo.com>
      # Date 1326581213 28800
      #      Sat Jan 14 14:46:53 2012 -0800
      # Node ID c043b110cc46389037e207f814d251f4c7e00a7b
      # Parent  a37def2620e7853b1c44aafc2b7ae528340c37aa
      being bad

      committer: Charles Finkel <charles.finkel@gmail.com>

      diff -r a37def2620e7 -r c043b110cc46 blah.rb
      --- a/blah.rb	Sat Jan 14 14:46:18 2012 -0800
      +++ b/blah.rb	Sat Jan 14 14:46:53 2012 -0800
        1) blah.rb   (or 's' for same)
    changeset:   1:c043b110cc46
    user:        Bob Barker <developers+bob@foo.com>
    date:        Sat Jan 14 14:46:53 2012 -0800
    summary:     being bad