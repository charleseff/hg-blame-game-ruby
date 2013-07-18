require 'spec_helper'

describe HgBlameGame do

  let(:hg_blame_game) { HgBlameGame.new('some_file') }
  let(:changeset_id_list) { %w(c8769d6446bc acb762f5f681 acb762f5f681 c8769d6446bc c8769d6446bc) }

  before do
    $stdout.stub(:print)
  end

  describe "#get_changeset_id_list" do
    let(:hg_blame_out) {
      <<-END.gsub(/^[ \t]+/m, '')
        Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:1: module Add
             Danny Dover <developers+danny@foo.com> acb762f5f681:2:   def add_4(y)
             Danny Dover <developers+danny@foo.com> acb762f5f681:3:     y + 5
        Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:4:   end
        Carmen Cummings <developers+carmen@foo.com> c8769d6446bc:5: end
      END
    }

    it "should return a list of changeset_ids" do
      hg_blame_game.send(:get_changeset_id_list,hg_blame_out).should == changeset_id_list
    end
  end

  describe "prompt_for_changeset_id" do
    before do
      $stdin.should_receive(:gets).and_return(input)
    end
    context "when user enters a correct changeset_id" do
      let(:input) { 'c8769d6446bc' }
      it "should return the correct changeset_id" do
        hg_blame_game.send(:prompt_for_changeset_id, changeset_id_list).should == 'c8769d6446bc'
      end
    end
    context "when user enters a correct number" do
      let(:input) { '1' }
      it "should return the correct changeset_id" do
        hg_blame_game.send(:prompt_for_changeset_id, changeset_id_list).should == 'c8769d6446bc'
      end
    end
  end

end