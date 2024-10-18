require 'rails_helper'

RSpec.describe "Api::V1::Posts", type: :request do
  let(:user) { create(:user) }
  let(:headers) { { "Authorization" => "Bearer #{user.auth_token}" } } 

  describe "GET /api/v1/posts" do
    it "returns all posts" do
      create_list(:post, 5, user: user) 

      get api_v1_posts_path, headers: headers

      expect(response).to have_http_status(:ok)
      expect(json.size).to eq(5)
    end
  end

  describe "POST /api/v1/posts" do
    it "creates a new post with an image" do
      post_params = {
        post: {
          title: "New Post",
          content: "New post content.",
          image: Rack::Test::UploadedFile.new(Rails.root.join('app/assets/images/download2.jpeg'), 'image/jpeg')
        }
      }

      post api_v1_posts_path, params: post_params, headers: headers

      expect(response).to have_http_status(:created)
      expect(json["post"]["title"]).to eq("New Post")
    end
  end

  describe "PATCH /api/v1/posts/:id" do
    let(:post) { create(:post, user: user) }

    it "updates the post" do
      patch_params = { post: { title: "Updated Title" } }

      patch api_v1_post_path(post), params: patch_params, headers: headers

      expect(response).to have_http_status(:ok)
      expect(post.reload.title).to eq("Updated Title")
    end
  end

  describe "DELETE /api/v1/posts/:id" do
    let!(:post) { create(:post, user: user) }

    it "deletes the post" do
      expect {
        delete api_v1_post_path(post), headers: headers
      }.to change(Post, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
