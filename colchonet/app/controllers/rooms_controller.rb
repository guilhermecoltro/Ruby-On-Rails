class RoomsController < ApplicationController
  PER_PAGE = 10
  before_action :require_authentication, only: [:new, :edit, :create, :update, :destroy]

  # GET /rooms
  # GET /rooms.json
  def index
    @search_query = params[:q]

    rooms = Room.search(@search_query)
                .page(params[:page])
                .per(PER_PAGE)

    @rooms = RoomCollectionPresenter.new(rooms.most_recent, self)
  end

  # GET /rooms/1
  # GET /rooms/1.json
  def show
    room_model = Room.friendly.find(params[:id])
    @room = RoomPresenter.new(room_model, self)
  end

  # GET /rooms/new
  def new
    @room = current_user.rooms.build
  end

  # GET /rooms/1/edit
  def edit
    @room = current_user.rooms.friendly.find(params[:id])
  end

  # POST /rooms
  # POST /rooms.json
  def create
    @room = current_user.rooms.build(room_params)

    if @room.save
      redirect_to @room, notice: t('flash.notice.room_created')
    else
      render action: "new"
    end
  end

  # PATCH/PUT /rooms/1
  # PATCH/PUT /rooms/1.json
  def update
    @room = current_user.rooms.friendly.find(params[:id])

    if @room.update(room_params)
      redirect_to @room, notice: t('flash.notice.room_updated')
    else
      render action: "edit"
    end
  end

  # DELETE /rooms/1
  # DELETE /rooms/1.json
  def destroy
    @room = current_user.rooms.friendly.find(params[:id])
    @room.destroy

    redirect_to rooms_url
  end

  private

  def room_params
    params.
      require(:room).
      permit(:title, :location, :description, :picture)
  end
end
