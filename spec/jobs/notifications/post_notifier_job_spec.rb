require "rails_helper"

RSpec.describe Notifications::PostNotifierJob, type: :job do
    describe "#perform" do
        let(:user) { create(:user) }
        let(:post) { create(:post, user: user) }
        
        context "when both post and user exist" do    
            let(:args) { { "post_id" => post.id, "actor_id" => user.id } }

            it "calls PostNotifier#notify" do
                expect_any_instance_of(Notifications::PostNotifier).to(receive(:notify))
                described_class.new.perform(args)
            end
        end
        
        context "when either post or user does not exist" do
            it "does not call PostNotifier#notify" do
                expect_any_instance_of(Notifications::PostNotifier).not_to(receive(:notify))
                described_class.new.perform({ "post_id" => 0, "actor_id" => user.id })
                described_class.new.perform({ "post_id" => post.id, "actor_id" => 0 })
            end
        end
    end
end