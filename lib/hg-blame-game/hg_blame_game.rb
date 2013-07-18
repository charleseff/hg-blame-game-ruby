class HgBlameGame
  def initialize(path_to_file, opts={})
    @path_to_file = path_to_file
    @changeset_id = !opts[:changeset_id].nil? ? opts[:changeset_id] : 'tip'
  end

  def run
    loop do
      p_flush("\n")

      changeset_id_to_show = show_hg_blame_and_prompt_for_changeset_id

      p_flush("\n")

      files_changed = sys("hg status --change #{changeset_id_to_show}").split("\n").map { |g| g.split(' ').last }

      @path_to_file = prompt_for_file(files_changed, changeset_id_to_show)
      @changeset_id = "#{changeset_id_to_show}^"
    end
  end

  private

  def sys(cmd)
    puts "Executing: #{cmd}" if ENV['DEBUG']
    `#{cmd}`
  end

  def show_hg_blame_and_prompt_for_changeset_id
    hg_blame_out = sys hg_blame_cmd
    exit $?.exitstatus unless $?.success?
    changeset_id_list = get_changeset_id_list(hg_blame_out)
    print_hg_blame_and_prompt
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
        print_hg_blame_and_prompt
      elsif input == 'h'
        p_flush prompt_for_changeset_id_message(changeset_ids.count)
      else
        p_flush "\nInvalid input.  " + prompt_for_changeset_id_message(changeset_ids.count)
      end
    end
  end

  def print_hg_blame_and_prompt
    system hg_blame_cmd
    p_flush "\n" + simple_prompt
  end

  def hg_blame_cmd
    "hg  blame --rev #{@changeset_id} --verbose --user --line-number --changeset #{@path_to_file}"
  end

  HG_BLAME_REGEX = / ([^\: ]+):/

  def get_changeset_id_list(hg_blame_out)
    hg_blame_out.strip.split("\n").map { |line| line[HG_BLAME_REGEX, 1] }
  end

  def prompt_for_file(files_changed, changeset_id)
    print_file_prompt(files_changed, changeset_id)

    loop do
      input = $stdin.gets.strip
      if input == 'q'
        p_flush "\n" + color("The responsible commit is:") + "\n\n"
        system "hg log --rev #{changeset_id}"
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
    system "hg export #{changeset_id}"
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
      "  - the number from the above list (from 1 to #{count}) of the file to chain into.\n" +
      "  - the filepath to chain into.\n" +
      "  - 's' to chain into the 'same' file as before\n" +
      "  - 'r' to re-view the hg export\n\n" +
      simple_prompt
  end

  def simple_prompt
    color("(h for help) >") + ' '
  end

  def prompt_for_changeset_id_message(count)
    "Enter:\n" +
      "  - the line number from the above list (from 1 to #{count}) you are hg blaming.\n" +
      "  - the changeset_id to chain into.\n" +
      "  - 'r' to re-view the hg blame\n\n" + simple_prompt
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