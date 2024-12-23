module anomaly.static_anomaly;

import std.stdint : uint8_t;

import parin;
import els.player;

import anomaly.base;
import anomaly.config;

import components.emb_utils;

class EMB_StaticAnomaly : EMB_Anomaly
{
    private DrawOptions options;

    public this(uint8_t directions, float on_spawn_time, float on_screen_time, void delegate() effect = null,
        float effect_time = 0f)
    {
        super(directions, on_spawn_time, on_screen_time, effect, effect_time);
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
            hitbox.size.x = EMB_ScreenConfig.Dimensions.width;
            position.y = randi() % EMB_SpriteConfig.get_position_limit.y;
        }
        else
        {
            // Vertical
            position.x = randi() % EMB_SpriteConfig.get_position_limit.x;
            hitbox.size.y = EMB_ScreenConfig.Dimensions.height;
        }
    }

    override protected void update_on_spawn(float dt)
    {
        super.update_on_spawn(dt);

        const float alpha_progression = on_spawn_timer.get_elapsed() / on_spawn_timer.get_duration();
        options.color.a = EMB_EffectsUtils.get_blinking_effect(alpha_progression, 127);

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

        if (on_active_timer.has_completed())
        {
            on_active_timer.reset();
            current_state = EMB_AnomalyState.disappearing;
        }
    }

    override protected void update_on_disappear(float dt)
    {
        super.update_on_disappear(dt);

        options.color.a = 127;

        if (on_disappear_timer.has_completed())
        {
            on_disappear_timer.reset();
            reset();
        }
    }
}