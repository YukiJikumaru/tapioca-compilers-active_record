# typed: true
class TestController < ApplicationController
  extend T::Sig

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

    ActiveRecord::Promise

    x = Post.find(1)
    x = Post.find_by(id: 1)



    hoge(:a, b: [], c: { d: { e: { f: { g: [123] } } }  })
  end

  sig { params(args: T.any(::Symbol, T::Hash[::Symbol, T.any(::Symbol, T::Array[::Symbol], T::Hash[::Symbol, T.any(::Symbol, T::Array[::Symbol])])])).void }
  def hoge(*args)
  end
end
