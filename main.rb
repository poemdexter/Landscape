require 'chingu'

include Gosu
include Chingu

class Main < Chingu::Window
	
  def initialize
    @width = 600
    @height = 600
    super @width, @height
    self.caption = "Landscape Prototype"
    
    @grid_h = 30
    @grid_w = 8
    init_world
    
    @ground_dg = Image["img/ground_dg.bmp"]
    @ground_dg_a = Image["img/ground_dg_bold_all.bmp"]
    @ground_dg_tlr = Image["img/ground_dg_bold_tlr.bmp"]
    @ground_dg_tl = Image["img/ground_dg_bold_tl.bmp"]
    @ground_dg_tls = Image["img/ground_dg_bold_tls.bmp"]
    @ground_dg_tlsr = Image["img/ground_dg_bold_tlsr.bmp"]
    @ground_dg_tr = Image["img/ground_dg_bold_tr.bmp"]
    @ground_dg_trs = Image["img/ground_dg_bold_trs.bmp"]
    @ground_dg_trsl = Image["img/ground_dg_bold_trsl.bmp"]
    
    @ground_lg = Image["img/ground_lg.bmp"]
    @ground_lg_a = Image["img/ground_lg_bold_all.bmp"]
    @ground_lg_tlr = Image["img/ground_lg_bold_tlr.bmp"]
    @ground_lg_tl = Image["img/ground_lg_bold_tl.bmp"]
    @ground_lg_tls = Image["img/ground_lg_bold_tls.bmp"]
    @ground_lg_tlsr = Image["img/ground_lg_bold_tlsr.bmp"]
    @ground_lg_tr = Image["img/ground_lg_bold_tr.bmp"]
    @ground_lg_trs = Image["img/ground_lg_bold_trs.bmp"]
    @ground_lg_trsl = Image["img/ground_lg_bold_trsl.bmp"]
    
    @cloud_img = Image["img/cloud.bmp"]
    
    @y_offset = 150
    @sky_color = Color.new(0xff5989D1)
    @line_color = Color.new(0xff000000)
    
    @clouds = []
    
    @max_h = 8
  end
  
  def update
    add_cloud if rand(100) < 2
    
    @clouds.each do |c|
      c[:x] += 1
    end
    
    @clouds.delete_if{|c| c[:x] > 600}
  end
  
  def draw
    fill(@sky_color)
    
    @clouds.each do |c|
      @cloud_img.draw(c[:x],c[:y]*15,1)
    end
    
    (1..@max_h).each do |h|    
      nextline = false
      @grid.each_with_index do |inner, a|
        if nextline
          inner.each_index do |b|
            if should_be_drawing(a,b,h)
              draw_dg(get_dg_sprite(a,b,h),a,b,h)
            end
          end
        else
          inner.each_index do |b|
            if should_be_drawing(a,b,h)
              draw_lg(get_lg_sprite(a,b,h),a,b,h)
            end
          end
        end
        nextline = !nextline
      end
    end
  end
  
  # TODO: BOUNDS CHECKS
  def get_lg_perimeter_values(a,b,h)
    current = @grid[a][b]
    
    w,ne,nw,e,se,sw = false
    
    w  = [current,h].min > @grid[a][b-1]   if b-1 >= 0
    ne = [current,h].min > @grid[a-1][b+1] if a-1 >= 0 && b+1 < @grid_w
    nw = [current,h].min > @grid[a-1][b]   if a-1 >= 0
    e  = [current,h].min > @grid[a][b+1]   if b+1 < @grid_w
    se = [current,h].min > @grid[a+1][b+1] if a+1 < @grid_h && b+1 < @grid_w
    sw = [current,h].min > @grid[a+1][b]   if a+1 < @grid_h
    
    return w,ne,nw,e,se,sw
  end
  
  def get_dg_perimeter_values(a,b,h)
    current = @grid[a][b]
    
    w,ne,nw,e,se,sw = false
    
    w  = [current,h].min > @grid[a][b-1]   if b-1 >= 0
    ne = [current,h].min > @grid[a-1][b]   if a-1 >= 0
    nw = [current,h].min > @grid[a-1][b-1] if a-1 >= 0 && b-1 >= 0
    e  = [current,h].min > @grid[a][b+1]   if b+1 < @grid_w
    se = [current,h].min > @grid[a+1][b]   if a+1 < @grid_h
    sw = [current,h].min > @grid[a+1][b-1] if a+1 < @grid_h && b-1 >= 0
    
     return w,ne,nw,e,se,sw
  end
  
  def get_lg_sprite(a,b,h)
    w,ne,nw,e,se,sw = get_lg_perimeter_values(a,b,h)
    
    l = sw && w && nw 
    tl = nw
    tr = ne
    r = se && e && ne
    
    return @ground_lg      if !tl && !tr
    return @ground_lg_a    if  l &&  tl &&  tr &&  r
    return @ground_lg_tlr  if !l &&  tl &&  tr && !r
    return @ground_lg_tl   if !l &&  tl && !tr && !r
    return @ground_lg_tls  if  l &&  tl && !tr && !r
    return @ground_lg_tlsr if  l &&  tl &&  tr && !r
    return @ground_lg_tr   if !l && !tl &&  tr && !r
    return @ground_lg_trs  if !l && !tl &&  tr &&  r
    return @ground_lg_trsl if !l &&  tl &&  tr &&  r
  end
  
  def get_dg_sprite(a,b,h)
    w,ne,nw,e,se,sw = get_dg_perimeter_values(a,b,h)
    
    l = sw && w && nw 
    tl = nw
    tr = ne
    r = se && e && ne
    
    return @ground_dg      if !tl && !tr
    return @ground_dg_a    if  l &&  tl &&  tr &&  r
    return @ground_dg_tlr  if !l &&  tl &&  tr && !r
    return @ground_dg_tl   if !l &&  tl && !tr && !r
    return @ground_dg_tls  if  l &&  tl && !tr && !r
    return @ground_dg_tlsr if  l &&  tl &&  tr && !r
    return @ground_dg_tr   if !l && !tl &&  tr && !r
    return @ground_dg_trs  if !l && !tl &&  tr &&  r
    return @ground_dg_trsl if !l &&  tl &&  tr &&  r
  end
  
  def should_be_drawing(a,b,h)
    @grid[a][b] >= h
  end
  
  def draw_lg(sprite,a,b,h)
    sprite.draw((b*80),(a*15) - (30 * (h-1)) + @y_offset,2)
  end
  
  def draw_dg(sprite,a,b,h)
    sprite.draw((b*80)-40,(a*15) - (30 * (h-1)) + @y_offset,2)
  end
  
  def add_cloud
    @clouds << {:x => -100, :y => rand(15)}
  end
  
  def init_world  
    @grid = Array.new(@grid_h,[])
    @grid = @grid.map {Array.new(@grid_w,0)}
    
    x = 0
    File.open('test.wd', 'r') do |l|
      while line = l.gets
        y = 0
        line.strip.chars.each do |c|
          @grid[x][y] = c.to_i
          y += 1
        end
        x += 1
      end
    end
  end
  
  def needs_cursor?
    true
  end
end

window = Main.new
window.show