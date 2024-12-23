module anomaly.base;

import core.bitop : popcnt;
import std.stdint : uint8_t;

import parin;

import els.player;
import anomaly.config;

import components.emb_timer;
import components.emb_utils;

import anomaly.effect;

/* 
 * NOTA: NO muevas las líneas de 'x_timer.start()' después de 'x_timer.update(dt)', ya que esto provocará que el temporizador se reinicie justo
 * al terminar. El estar antes permite que se verifique bien si ha terminado antes de volver a reiniciar.
 */

abstract class EMB_Anomaly
{
    protected bool effect_is_active;

    // Físicas
    protected Rect hitbox;
    protected Vec2 position;

    // Direcciones
    protected uint8_t available_directions;
    protected EMB_AnomalyDirection current_direction;

    // Temporizadores
    protected EMB_Timer on_spawn_timer;
    protected EMB_Timer on_active_timer;
    protected EMB_Timer on_disappear_timer;

    protected EMB_AnomalyEffect effect_handler;

    /// Estado actual de la anomalía.
    protected EMB_AnomalyState current_state;
    /// Constante inmutable para el tiempo en desaparecer de las anomalías
    protected immutable float on_disappear_time = 3.0f;

    // --------------------------------
    // Métodos públicos
    // --------------------------------

    public this(uint8_t directions, float on_spawn_time, float on_active_time,
        void delegate() effect = null, float effect_timer = 0f)
    {
        hitbox = Rect(Vec2.zero, Vec2(EMB_SpriteConfig.default_size));
        available_directions = directions;
        
        on_spawn_timer = EMB_Timer(on_spawn_time);
        on_active_timer = EMB_Timer(on_active_time);
        on_disappear_timer = EMB_Timer(on_disappear_time);

        effect_handler = EMB_AnomalyEffect(effect, null, effect_timer);
    }

    public void update(float dt, ref EMB_Player player)
    {
        if (effect_handler.is_effect_active())
            effect_handler.update(dt);

        update_state(dt, player);
        hitbox.position = position;
    }

    public abstract void draw() const;

    public void reset()
    {
        position = Vec2.zero;
        current_state = EMB_AnomalyState.none;
        hitbox.size = Vec2(EMB_SpriteConfig.default_size);
    }

    // -------------------------------
    // Setters
    // -------------------------------

    public void set_effect_time(float time)
    {
        effect_handler.set_duration(time);
    }

    public void set_effect(void delegate() effect)
    {
        effect_handler.set_apply_effect(effect);
    }

    public void set_reverse_effect(void delegate() effect)
    {
        effect_handler.set_reverse_effect(effect);
    }

    // ------------------------------
    // Métodos privados
    // ------------------------------

    private void update_state(float dt, ref EMB_Player p)
    {
        // Dependiendo del estado actual, implementar un sistema que llame a los métodos 'update_on_x'.
        final switch ( current_state )
        {
            case EMB_AnomalyState.none:
                /* No hagas nada */
                break;
            case EMB_AnomalyState.spawning:
                update_on_spawn(dt);
                break;
            case EMB_AnomalyState.active:
                update_on_active(dt, p);
                break;
            case EMB_AnomalyState.disappearing:
                update_on_disappear(dt);
                break;
        }
    }

    // ------------------------------
    // Métodos protegidos
    // ------------------------------

    final protected EMB_AnomalyDirection get_random_direction()
    {
        // Obtiene la cantidad de direcciones disponibles basado en los bits encendidos
        int bit_count = popcnt(available_directions);

        // Si no hay ningún bit encendido, entonces que no apunte a ninguna dirección.
        if (bit_count == 0) return EMB_AnomalyDirection.none;

        int random_index = randi() % bit_count;

        uint curr_bit_index = 0;
        for (uint bit = 0; bit < EMB_AnomalyDirection.max; bit++)
        {
            if (available_directions & (1 << bit))
            {
                if (curr_bit_index == random_index)
                {
                    return cast(EMB_AnomalyDirection)(1 << bit);
                }
                curr_bit_index++;
            }
        }

        // En teoría nunca debería llegar acá, pero es un por si acaso ._. ...
        return EMB_AnomalyDirection.none;
    }

    protected void update_on_spawn(float dt)
    {
        on_spawn_timer.start();
        on_spawn_timer.update(dt);
    }

    protected void update_on_active(float dt, ref EMB_Player player)
    {
        on_active_timer.start();
        on_active_timer.update(dt);

        handle_collision(player);
    }

    protected void update_on_disappear(float dt)
    {
        on_disappear_timer.start();
        on_disappear_timer.update(dt);
    }

    private void handle_collision(ref EMB_Player player)
    {
        if (hitbox.hasIntersection(player.hitbox))
        {
            effect_handler.trigger();
            // Reinicia la anomalía
            reset();
        }
    }
}