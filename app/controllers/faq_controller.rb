class FaqController < ApplicationController
  def show
    render params[:page]
  end
end
