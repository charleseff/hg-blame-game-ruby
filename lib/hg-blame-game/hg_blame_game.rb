class HgBlameGame
  def initialize(path_to_file, opts={})
    @path_to_file = path_to_file
    @changeset_id = !opts[:changeset_id].nil? ? opts[:changeset_id] : 'HEAD'
  end

  def run
    loop do
      p_flush("\n")

      changeset_id_to_show = show_git_blame_and_prompt_for_changeset_id

      p_flush("\n")
      files_changed = `git show --pretty="format:" --name-only #{changeset_id_to_show}`.split("\n")[1..-1]

      @path_to_file = prompt_for_file(files_changed, changeset_id_to_show)
      @changeset_id = "#{changeset_id_to_show}^"
    end
  end

  private
  def show_git_blame_and_prompt_for_changeset_id
    git_blame_out = `#{git_blame_cmd}`
    exit $?.exitstatus unless $?.success?
    changeset_id_list = get_changeset_id_list(git_blame_out)
    print_git_blame_and_prompt
    prompt_for_changeset_id(changeset_id_list)
  end

  def prompt_for_changeset_id(changeset_ids)
    loop do
      input = $stdin.gets.strip
      # changeset_id was entered, return it:
      return input if changeset_ids.include? input

      if input =~ /\A\d+\Z/
        input = input.to_i
        return changeset_ids[input - 1] if input <= changeset_ids.count && input >= 1
      end

      if input == 'r'
        print_git_blame_and_prompt
      elsif input == 'h'
        p_flush prompt_for_changeset_id_message(changeset_ids.count)
      else
        p_flush "\nInvalid input.  " + prompt_for_changeset_id_message(changeset_ids.count)
      end
    end
  end

  def print_git_blame_and_prompt
    system git_blame_cmd
    p_flush "\n" + simple_prompt
  end

  def git_blame_cmd
    "hg  blame --rev #{@changeset_id} --verbose --user --line-number --changeset #{@path_to_file}"
  end

  HG_BLAME_REGEX = / ([^\: ]+):/

  def get_changeset_id_list(git_blame_out)
    git_blame_out.strip.split("\n").map { |line| line[HG_BLAME_REGEX, 1] }
  end

  def prompt_for_file(files_changed, changeset_id)
    print_file_prompt(files_changed, changeset_id)

    loop do
      input = $stdin.gets.strip
      if input == 'q'
        p_flush "\n" + color("The responsible commit is:") + "\n\n"
        system "git log #{changeset_id} -n 1"
        exit 0
      end
      return @path_to_file if input == 's'
      return input if files_changed.include? input

      if input =~ /\A\d+\Z/
        input = input.to_i
        return files_changed[input-1] if input >= 1 && input <= files_changed.count
      end

      if input == 'r'
        print_file_prompt(files_changed, changeset_id)
      elsif input == 'h'
        p_flush prompt_for_file_message(files_changed.count)
      else
        p_flush "\nInvalid input.  " + prompt_for_file_message(files_changed.count)
      end
    end
  end

  def print_file_prompt(files, changeset_id)
    system "git show #{changeset_id}"
    print("\n")
    files.each_with_index do |file, index|
      line = sprintf("%3d) #{file}", index+1)
      line += '   ' + orange_color("(or 's' for same)") if file == @path_to_file
      print line + "\n"
    end
    p_flush "\n" + simple_prompt
  end

  def prompt_for_file_message(count)
    "Enter:\n" +
      "  - 'q' to quit, if you have found the offending commit\n" +
      "  - the number from the above list (from 1 to #{count}) of the file to git blame chain into.\n" +
      "  - the filepath to git blame chain into.\n" +
      "  - 's' to git blame chain into the 'same' file as before\n" +
      "  - 'r' to re-view the git show\n\n" +
      simple_prompt
  end

  def simple_prompt
    color("(h for help) >") + ' '
  end

  def prompt_for_changeset_id_message(count)
    "Enter:\n" +
      "  - the line number from the above list (from 1 to #{count}) you are git blaming.\n" +
      "  - the changeset_id to git blame chain into.\n" +
      "  - 'r' to re-view the git blame\n\n" + simple_prompt
  end

  def p_flush(str)
    $stdout.print str
    $stdout.flush
  end

  def color(s)
    s.colorize(:color => :light_white, :background => :magenta)
  end

  def orange_color(s)
    s.colorize(:color => :yellow, :background => :black)
  end

end