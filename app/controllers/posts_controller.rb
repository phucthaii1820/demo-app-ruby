class PostsController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :update, :destroy, :my_posts ]
  before_action :set_post, only: [ :show, :update, :destroy ]

  def index
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    posts = Post.includes(:user, :category).page(page).per(per_page)
    render json: {
      status: 200,
      message: "Posts retrieved successfully.",
      data: posts.as_json(include: [ :user, :category ]),
      meta: {
        total_pages: posts.total_pages,
        total_count: posts.total_count,
        current_page: posts.current_page,
        next_page: posts.next_page,
        prev_page: posts.prev_page
      }
    }
  end

  def show
    render json: {
      status: 200,
      message: "Post retrieved successfully.",
      data: @post.as_json(include: [ :user, :category ])
    }
  end

  def create
    post = current_user.posts.build(post_params)
    if post.save
      render json: {
        status: 201,
        message: "Post created successfully.",
        data: post.as_json(include: [ :user, :category ])
      }, status: :created
    else
      render json: {
        status: 422,
        message: "Post creation failed.",
        errors: post.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def update
    if @post.user.id == current_user.id
      if @post.update(post_params)
        render json: {
          status: 200,
          message: "Post updated successfully.",
          data: @post.as_json(include: [ :user, :category ])
        }
      else
        render json: {
          status: 422,
          message: "Post update failed.",
          errors: @post.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: {
        status: 403,
        message: "You are not authorized to update this post."
      }, status: :forbidden
    end
  end

  def destroy
    if @post.user.id == current_user.id
      if @post.destroy
        render json: {
          status: 200,
          message: "Post deleted successfully."
        }
      else
        render json: {
          status: 422,
          message: "Post deletion failed.",
          errors: @post.errors.full_messages
        }, status: :unprocessable_entity
      end
    else
      render json: {
        status: 403,
        message: "You are not authorized to delete this post."
      }, status: :forbidden
    end
  end

  def my_posts
    page = params[:page] || 1
    per_page = params[:per_page] || 10

    posts = current_user.posts.includes(:user, :category).page(page).per(per_page)
    render json: {
      status: 200,
      message: "My posts retrieved successfully.",
      data: posts.as_json(include: [ :user, :category ]),
      meta: {
        total_pages: posts.total_pages,
        total_count: posts.total_count,
        current_page: posts.current_page,
        next_page: posts.next_page,
        prev_page: posts.prev_page
      }
    }
  end

  def search
    query = params[:query].to_s.strip
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    if query.blank?
      return render json: {
        status: 400,
        message: "Query parameter cannot be blank.",
        data: [],
        meta: {}
      }, status: :bad_request
    end

    posts = Post.includes(:user, :category)
                .where("title ILIKE :q OR content ILIKE :q", q: "%#{query}%")
                .page(page).per(per_page)



    if posts.exists?
      render json: {
        status: 200,
        message: "Search results retrieved successfully.",
        data: posts.as_json(include: [ :user, :category ]),
        meta: {
          total_pages: posts.total_pages,
          total_count: posts.total_count,
          current_page: posts.current_page,
          next_page: posts.next_page,
          prev_page: posts.prev_page
        }
      }
    else
      render json: {
        status: 404,
        message: "No posts found matching the search.",
        data: [],
        meta: {}
      }, status: :not_found
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Post not found" }, status: :not_found
  end

  def post_params
    params.require(:post).permit(:title, :content, :category_id)
  end
end
