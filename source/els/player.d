module els.player;

import parin;
import std.stdint : uint8_t;

import components.emb_timer;
import components.emb_score;
import components.emb_utils;

public struct EMB_Player
{
    byte direction;

    float speed;
    float acceleration;
    float boost_impulse;
    float desacceleration;

    Vec2 velocity;
    Vec2 position;

    Rect hitbox;
    TextureId texture;

    DrawOptions options;

    public void setup()
    {
        direction = 0;

        speed = 200.0f;
        acceleration = 800.0f;
        desacceleration = 400.0f;
        boost_impulse = 150.0f;

        velocity = Vec2.zero;
        position = Vec2.zero;

        const Vec2 hitboxSize = Vec2(34, 52);
        hitbox = Rect(Vec2.zero, hitboxSize);
        texture = loadTexture("ELS34.PNG");
    }

    public void update(float dt)
    {
        update_input();
        update_gravity(dt);
        update_physics(dt);
        update_sprite(dt);
    }

    public void draw()
    {
        debug { drawRect(hitbox); }
        drawTexture(texture, position, options);
    }

    pragma(inline, true) private void update_gravity(float dt)
    {
        velocity.y += EMB_PhysicsConfig.gravity * dt;
    }

    private void update_input()
    {
        // Movimiento horizontal
        direction = EMB_PlayerInput.right_keydown() - EMB_PlayerInput.left_keydown();

        // Movimiento vertical
        if (EMB_PlayerInput.boost_keydown())
        {
            velocity.y = -boost_impulse;
        }
    }

    private void update_physics(float dt)
    {
        if (direction != 0)
        {
            // Aceleración
            velocity.x += (direction * acceleration) * dt;
            velocity.x = clamp(velocity.x, -speed, speed);
        }
        else
        {
            // Aplicar desaceleración
            velocity.x = velocity.x > 0.0f ?
                max(0, velocity.x - desacceleration * dt) : min(0, velocity.x + desacceleration * dt);
        }

        position += velocity * Vec2(dt);
        hitbox.position = position;
    }

    private void update_sprite(float dt)
    {
        const float resolution = EMB_ScreenConfig.get_object_center(position, hitbox.size).x;
        options.flip = position.x < resolution ? Flip.none : Flip.x;
    }
}