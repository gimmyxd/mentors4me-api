# frozen_string_literal: true

RSpec.describe Context, type: :model do
  context 'fields' do
    it { is_expected.to respond_to(:description) }
    it { is_expected.to respond_to(:mentor_id) }
    it { is_expected.to respond_to(:organization_id) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:description).is_at_most(500) }
    it { is_expected.to belong_to(:mentor) }
    it { is_expected.to belong_to(:organization) }
    it { is_expected.to have_many(:messages) }
  end

  context 'methods' do
    let(:pending_context) { create(:context, :pending) }
    let(:accepted_context) { create(:context, :accepted) }
    let(:rejected_context) { create(:context, :rejected) }
    let(:context) { create(:context) }

    context '#accept!' do
        it do
            expect { pending_context.accept! }.to \
                change { pending_context.status }.from(CC::PENDING).to(CC::ACCEPTED)
        end
    end

    context '#accepted?' do
      it { expect(pending_context.accepted?).to eq(false) }
      it { expect(accepted_context.accepted?).to eq(true) }
      it { expect(rejected_context.accepted?).to eq(false) }
      it { expect(context.accepted?).to eq(false) }
    end

    context '#reject!' do
        it do
            expect { pending_context.reject! }.to \
                change { pending_context.status }.from(CC::PENDING).to(CC::REJECTED)
        end
    end

    context '#rejected?' do
      it { expect(pending_context.rejected?).to eq(false) }
      it { expect(accepted_context.rejected?).to eq(false) }
      it { expect(rejected_context.rejected?).to eq(true) }
      it { expect(context.rejected?).to eq(false) }
    end

    context '#pending' do
        it do
            expect { context.pending }.to \
                change { context.status }.from(nil).to(CC::PENDING)
        end
    end

    context '#pending?' do
      it { expect(pending_context.pending?).to eq(true) }
      it { expect(accepted_context.pending?).to eq(false) }
      it { expect(rejected_context.pending?).to eq(false) }
      it { expect(context.pending?).to eq(false) }
    end

    context '.send_notification' do
      let(:mentor) { create(:user, :mentor_user) }
      let(:organization) { create(:user, :organization_user) }
      let(:context) { create(:context, :accepted, mentor: mentor, organization: organization) }
      let!(:mentor_unread_message) do
        create(:message, context: context, sender_id: mentor.id, receiver_id: organization.id, seen: false)
      end
      let!(:mentor_read_message) do
        create(:message, context: context, sender_id: mentor.id, receiver_id: organization.id, seen: true)
      end

      let!(:organization_unread_message) do
        create(:message, context: context, sender_id: organization.id, receiver_id: mentor.id, seen: false)
      end
      let!(:organization_read_message) do
        create(:message, context: context, sender_id: organization.id, receiver_id: mentor.id, seen: true)
      end

      let(:mentors_mailer) { double(MentorsMailer) }
      let(:organizations_mailer) { double(OrganizationsMailer) }

      before do
        stub_request(:post, "https://api.sendgrid.com/v3/mail/send")
          .to_return(status: 200, body: "", headers: {})
        travel_to(Time.current - 2.hours)
        create(:message, context: context, sender_id: mentor.id, receiver_id: organization.id, seen: false)
        create(:message, context: context, sender_id: mentor.id, receiver_id: organization.id, seen: true)
        travel_back
      end

      it do
        expect(MentorsMailer).to receive(:send_unread_messages)
          .with(mentor.email,
            name: organization.full_name,
            messages: "#{SharedMethods.format_date(mentor_unread_message.created_at)}: "\
                      "#{mentor_unread_message.message}"
            )
          .and_return(mentors_mailer)

        with_modified_env(EMAIL_FROM: 'test@email.com', SENDGRID_API_KEY: 'test') do
          Context.send_notification
        end
      end

      it do
        expect(OrganizationsMailer).to receive(:send_unread_messages)
          .with(organization.email,
            name: mentor.full_name,
            messages: "#{SharedMethods.format_date(organization_unread_message.created_at)}: "\
                      "#{organization_unread_message.message}"
            )
          .and_return(organizations_mailer)

        with_modified_env(EMAIL_FROM: 'test@email.com', SENDGRID_API_KEY: 'test') do
          Context.send_notification
        end
      end
    end
  end
end
