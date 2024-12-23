module anomaly.effect;

import components.emb_timer;
import std.algorithm.mutation;

struct EMB_AnomalyEffect
{
    private void delegate() apply_effect;
    private void delegate() reverse_effect;

    private EMB_Timer duration_timer;

    private bool is_active;
    private bool is_instant;

    public this(void delegate() apply, void delegate() reverse, float duration)
    {
        apply_effect = apply;
        reverse_effect = reverse;

        is_active = false;
        is_instant = duration <= 0f;

        if (!is_instant && apply !is null)
            duration_timer = EMB_Timer(duration);
    }

    public void update(float dt)
    {
        if (!is_active || is_instant) return;

        duration_timer.start();
        duration_timer.update(dt);

        if (duration_timer.has_completed())
        {
            if (reverse_effect !is null) reverse_effect();
            is_active = false;

            duration_timer.reset();
        }
    }

    public void trigger()
    {
        if (apply_effect is null) return;

        if (is_instant)
        {
            // Aplica los efectos directamente
            apply_effect();
            if (reverse_effect !is null) reverse_effect();
        }
        else
        {
            if (!is_active)
            {
                apply_effect();
                is_active = true;
            }
        }
    }

    public bool is_effect_active() const
    {
        return is_active;
    }

    public void set_duration(float new_duration)
    {
        if (duration_timer.is_valid())
            duration_timer.set_duration(new_duration);
    }

    public void set_apply_effect(void delegate() effect)
    {
        if (effect !is null && effect !is apply_effect)
            apply_effect = effect;
    }

    public void set_reverse_effect(void delegate() effect)
    {
        if (effect !is null && effect !is reverse_effect)
            reverse_effect = effect;
    }
}