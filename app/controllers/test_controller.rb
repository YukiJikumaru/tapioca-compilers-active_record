# typed: true
class TestController < ApplicationController
  def index
    # NG
    x = TableOne.find(1)

    # TableOne::PrivateRelation
    x = TableOne.joins(:x)

    # NG
    TableOne.joins(:x).includes(:x).last
    TableOne.joins(:x).includes(:x).where(id: 1)
    aaa = TableOne.joins(:x).includes(:x).where(id: 1).limit(1).to_a

    x = Post.find_or_create_by(id: 1)
    if x
      x.title_previously_changed?(from: nil)
    end


  end
end
