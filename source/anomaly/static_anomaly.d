module anomaly.static_anomaly;

import parin;
import els.player;
import wolfmanager;
import anomaly.base;
import anomaly.config;
import std.stdint : uint8_t;

class EMB_StaticAnomaly : EMB_Anomaly
{
    private DrawOptions options;

    public this(uint8_t directions, float on_spawn_time, float on_screen_time,
        void delegate() effect = null)
    {
        super(directions, on_spawn_time, on_screen_time, effect);
    }

    override public void update(float dt, ref EMB_Player player)
    {
        super.update(dt, player);

        if (current_state == EMB_AnomalyState.none && isPressed(Keyboard.space))
            current_state = EMB_AnomalyState.spawning;
    }

    override public void draw() const
    {
        if (current_state != EMB_AnomalyState.none) drawRect(hitbox, options.color);
    }

    override public void reset()
    {
        super.reset();

        current_direction = get_random_direction();

        if (current_direction == EMB_AnomalyDirection.horizontal)
        {
            hitbox.size.x = WolfConstManager.resolution_width;
            position.y = randi() % WolfConstManager.sprite_yposition_limit;
        }
        else
        {
            // Vertical
            position.x = randi() % WolfConstManager.sprite_xposition_limit;
            hitbox.size.y = WolfConstManager.resolution_height;
        }
    }

    override protected void update_on_spawn(float dt)
    {
        super.update_on_spawn(dt);

        const float alpha_progression = on_spawn_timer.get_elapsed() / on_spawn_timer.get_duration();
        options.color.a = WolfEffectManager.get_blinking_effect(alpha_progression, 127);

        if (on_spawn_timer.has_completed())
        {
            on_spawn_timer.reset();
            current_state = EMB_AnomalyState.active;
        }
    }

    override protected void update_on_active(float dt, ref EMB_Player player)
    {
        super.update_on_active(dt, player);

        options.color.a = 255;

        if (on_screen_timer.has_completed())
        {
            on_screen_timer.reset();
            current_state = EMB_AnomalyState.disappearing;
        }
    }

    override protected void update_on_disappear(float dt)
    {
        super.update_on_disappear(dt);

        if (on_disappear_timer.has_completed())
        {
            on_disappear_timer.reset();
            reset();
        }
    }
}