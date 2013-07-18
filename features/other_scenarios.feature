Feature: Other scenarios

  Scenario: Getting help
    When I run `bin/hg-blame-game --help`
    Then it should pass with:
    """
    Usage: hg-blame-game [options] path/to/filename
    """

  Scenario: Without a filepath:
    When I run `bin/hg-blame-game`
    Then it should fail with:
    """
    missing argument: You must specify a path to a file
    """

  Scenario: Specifying a rep that doesn't exist:
    When I run `bin/hg-blame-game file/that/doesnt/exist.rb`
    Then it should fail with:
    """
    abort: no repository found in
    """

  Scenario: Invalid input on hg blame view:
    Given I cd to "test/fixtures/sample_hg_repo"
    When I run `../../../bin/hg-blame-game add.rb` interactively
    And I type "foobar"
    Then I should see:
    """
      Invalid input.  Enter:
        - the line number from the above list (from 1 to 5) you are hg blaming.
        - the changeset_id to chain into.
        - 'r' to re-view the hg blame

      (h for help) >
    """

  Scenario: Invalid input on hg export view:
    Given I cd to "test/fixtures/sample_hg_repo"
    When I run `../../../bin/hg-blame-game add.rb` interactively
    And I type "3"
    And I type "blah"
    Then I should see:
    """
      Invalid input.  Enter:
        - 'q' to quit, if you have found the offending commit
        - the number from the above list (from 1 to 1) of the file to chain into.
        - the filepath to chain into.
        - 's' to chain into the 'same' file as before
        - 'r' to re-view the hg export

      (h for help) >
    """

  Scenario: With a SHA:
    Given I cd to "test/fixtures/sample_hg_repo"
    When I run `../../../bin/hg-blame-game blah.rb --rev=c043b110cc46` interactively
    Then I should see:
    """
      Alice Amos <developers+alice@foo.com> a37def2620e7:1: def add_4(x)
        Bob Barker <developers+bob@foo.com> c043b110cc46:2:   x + 5
      Alice Amos <developers+alice@foo.com> a37def2620e7:3: end
      Alice Amos <developers+alice@foo.com> a37def2620e7:4:
      Alice Amos <developers+alice@foo.com> a37def2620e7:5: puts add_4(9) # should be 13
    """

  Scenario: Entering the SHA instead of the number
    Given I cd to "test/fixtures/sample_hg_repo"
    When I run `../../../bin/hg-blame-game add.rb` interactively
    When I type "acb762f5f681"
    Then I should see:
    """
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
      @@ -1,5 +1,5 @@
       module Add
      -  def add_4(x)
      -    x + 5
      +  def add_4(y)
      +    y + 5
         end
       end
      \ No newline at end of file
    """

  Scenario: Entering 's' for the same file to hg blame into
    Given I cd to "test/fixtures/sample_hg_repo"
    When I run `../../../bin/hg-blame-game add.rb` interactively
    When I type "3"
    Then I should see:
    """
        1) add.rb
    """
    When I type "s"
    Then I should see:
    """
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:1: module Add
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:2:   def add_4(x)
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:3:     x + 5
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:4:   end
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:5: end
    """

  Scenario: Entering the filename for the file to hg blame into:
    Given I cd to "test/fixtures/sample_hg_repo"
    When I run `../../../bin/hg-blame-game add.rb` interactively
    When I type "3"
    Then I should see:
    """
        1) add.rb (or 's' for same)
    """
    When I type "add.rb"
    Then I should see:
    """
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:1: module Add
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:2:   def add_4(x)
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:3:     x + 5
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:4:   end
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:5: end
    """

  Scenario: Re-viewing a hg blame:
    Given I cd to "test/fixtures/sample_hg_repo"
    When I run `../../../bin/hg-blame-game add.rb` interactively
    Then I should see:
    """
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:1: module Add
           Danny Dover <developers+danny@foo.com> acb762f5f681:2:   def add_4(y)
           Danny Dover <developers+danny@foo.com> acb762f5f681:3:     y + 5
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:4:   end
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:5: end
    """
    When I type "r"
    Then I should see:
    """
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:1: module Add
           Danny Dover <developers+danny@foo.com> acb762f5f681:2:   def add_4(y)
           Danny Dover <developers+danny@foo.com> acb762f5f681:3:     y + 5
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:4:   end
      Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:5: end
    """

  Scenario: Re-viewing a hg export:
    Given I cd to "test/fixtures/sample_hg_repo"
    When I run `../../../bin/hg-blame-game add.rb` interactively
    And I type "3"
    Then I should see:
    """
       HG changeset patch
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
      @@ -1,5 +1,5 @@
       module Add
      -  def add_4(x)
      -    x + 5
      +  def add_4(y)
      +    y + 5
         end
       end
      \ No newline at end of file

        1) add.rb   (or 's' for same)
      """
    When I type "r"
    Then I should see:
    """
       HG changeset patch
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
      @@ -1,5 +1,5 @@
       module Add
      -  def add_4(x)
      -    x + 5
      +  def add_4(y)
      +    y + 5
         end
       end
      \ No newline at end of file

        1) add.rb   (or 's' for same)
    """

  Scenario: Getting help interactively for git blame:
    Given I cd to "test/fixtures/sample_hg_repo"
    When I run `../../../bin/hg-blame-game add.rb` interactively
    Then I should see:
    """
      (h for help) >
    """
    When I type "h"
    Then I should see:
    """
      Enter:
        - the line number from the above list (from 1 to 5) you are hg blaming.
        - the changeset_id to chain into.
        - 'r' to re-view the hg blame

      (h for help) >
    """

  Scenario: Getting help interactively for hg export:
    Given I cd to "test/fixtures/sample_hg_repo"
    When I run `../../../bin/hg-blame-game add.rb` interactively
    And I type "3"
    Then I should see:
    """
      (h for help) >
    """
    When I type "h"
    Then I should see:
    """
      Enter:
        - 'q' to quit, if you have found the offending commit
        - the number from the above list (from 1 to 1) of the file to chain into.
        - the filepath to chain into.
        - 's' to chain into the 'same' file as before
        - 'r' to re-view the hg export

      (h for help) >
    """


