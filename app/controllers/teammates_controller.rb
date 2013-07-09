class TeammatesController < ApplicationController
  before_action :authorize
  before_action :find_team
  before_action :find_teammate, only: [:edit, :update, :destroy]

  def index
    setup_to_render_main
  end

  def new
    @teammate = Teammate.new
    setup_to_render_main
  end

  def edit
    setup_to_render_main
  end

  def create
    @teammate = @team.teammates.build(teammate_params)
    respond_to do |format|
      if @teammate.save
        notice = "New teammate was created."
        format.html { redirect_to teammates_url, notice: notice }
        format.js   { render_refresh_main(notice: notice, auto_close: true) }
      else
        format.html {
          setup_to_render_main(true)
          render :new
        }
      end
    end
  end

  def update
    if @teammate.update(teammate_params)
      redirect_to teammates_url, notice: "Teammate #{@teammate.name.inspect} was updated."
    else
      setup_to_render_main(true)
      render :edit
    end
  end

  def destroy
    @teammate.destroy
    warning = "Teammate #{@teammate.name.inspect} was deleted."
    respond_to do |format|
      format.html { redirect_to teammates_url, warning: warning }
      format.js   { render_refresh_main(warning: warning) }
    end
  end

  def export
    respond_to do |format|
      format.csv {
        send_data(exporter.teammates(:csv, team: @team),
          filename: "teammates-#{Time.zone.today.to_s(:db)}.csv")
      }
    end
  end

  def import_form
    setup_to_render_main
  end

  private

  def setup_to_render_main(reload = false)
    @team.teammates.reload if reload
    @teammates = @team.teammates.decorate
  end

  def render_refresh_main(options = {})
    url = options.delete(:url) || teammates_url
    setup_to_render_main(true)
    render template: "shared/refresh_main", locals: {
      content: {partial: "teammates/teammates_list", teammates: @teammates},
      flash: options_to_flash(options),
      redirect_url: url
    }
  end

  def options_to_flash(options)
    supported_types = %i[info notice warning error]
    if (type = options.keys.first { |type| type.in?(supported_types) })
      message = options.delete(type)
      options.merge(type: type == :notice ? :success : type, message: message)
    else
      {}
    end
  end

  def teammate_params
    secured = params
      .require(:teammate)
      .permit(:name, :account_id, :initials, :color, :roles, roles: [])
    secured[:roles] ||= []
    secured[:roles] = secured[:roles].split(",") if secured[:roles].is_a?(String)
    secured[:roles].reject!(&:blank?)
    secured
  end

  def find_teammate
    @teammate = @team.teammates.find(params.require(:id))
  end

  def exporter
    DataExchangeService.new.export
  end
end
