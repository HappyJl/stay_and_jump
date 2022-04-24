require daslib/media

let
    CUBE_COLOR      = 0xFF3F70
    GROUND_COLOR    = 0x504022
    SKY_COLOR       = 0xB0E0FF
    JUMP_VELOCITY = 870

struct Cube
    position: float2
    velocity: float2
    size: float
    alive: bool

var
    camera_x = 0.0
    jump_pressed = false
    cube: Cube


def reset_cube(var c: Cube)
    c.position = float2(get_screen_width()/2, 1000)
    c.velocity = float2(0.0, 0.0)
    c.size = 15.0
    c.alive = true

def update_cube(var c: Cube; dt: float)
    c.position = c.position + c.velocity * dt
    c.velocity.y += float(JUMP_VELOCITY) * dt
    if c.position.y > float(get_screen_height()) / 1.08
        c.position.y = float(get_screen_height()) / 1.08

def jump_cube(var c: Cube)
    c.velocity.y = clamp(c.velocity.y - 600.0, -600.0, -600.0)


def render_cube(var c: Cube)
    let x = int(c.position.x - camera_x - c.size * 0.5)
    let y = int(c.position.y - c.size * 0.5)
    fill_rect(x, y, int(c.size), int(c.size), CUBE_COLOR)


def render_background(t: float)
    fill_rect(0, 0, get_screen_width(), get_screen_height(), SKY_COLOR)


def render_ground()
    fill_rect(0, get_screen_height() - 50, get_screen_width(), 200, GROUND_COLOR)

[export]
def initialize
    set_window_title("jump and stay")
    reset_cube(cube)


def update_input(var c: Cube)
    let jump = get_key(VK_SPACE)
    let pos = c.position.y
    if pos == float(get_screen_height()) / 1.08
        if jump && !jump_pressed
            jump_cube(cube)    
    

def update_gameplay(dt: float)
    update_cube(cube, dt)
    

[export]
def act(dt: float)
    // print("act dt={dt}\n")
    if get_key(VK_ESCAPE)
        schedule_quit_game()
    update_input(cube)
    update_gameplay(dt)


[export]
def draw()
    render_background(camera_x)
    render_ground()
    render_cube(cube)

