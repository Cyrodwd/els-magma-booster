module els.player;

import parin;
import wolfmanager;
import std.stdint : uint8_t;
import components.emb_timer;
import components.emb_score;

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

        hitbox = Rect(Vec2.zero, Vec2(32));
        options.color = red;
    }

    public void update(float dt)
    {
        updateInput();
        updateGravity(dt);
        updatePhysics(dt);
    }

    public void draw()
    {
        drawRect(hitbox, options.color);
    }

    pragma(inline, true) private void updateGravity(float dt)
    {
        velocity.y += WolfConstManager.gravity * dt;
    }

    private void updateInput()
    {
        // Movimiento horizontal
        direction = WolfKeysManager.is_player_right() - WolfKeysManager.is_player_left();

        // Movimiento vertical
        if (WolfKeysManager.is_player_boost())
        {
            velocity.y = -boost_impulse;
        }
    }

    private void updatePhysics(float dt)
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
}