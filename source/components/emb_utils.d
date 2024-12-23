module components.emb_utils;

import parin;
import std.stdint : uint8_t;

/*

***ELS MAGMA BOOSTER UTILS***

Son un conjunto de estructuras que no son instanciables.
Contienen constantes y funciones miembro estáticos para mantener
organizado el proyecto.

*/

public struct EMB_ScreenConfig
{
    @disable this();

    static:
    
    struct Dimensions
    {
        enum ushort width = 640;
        enum ushort height = 480;
    }

    Vec2 get_object_center(Vec2 obj_position, Vec2 obj_size)
    {
        Vec2 center = Vec2(Dimensions.width / 2.0f, Dimensions.height / 2.0f);
        return center - (obj_position / obj_size);
    }
}

public struct EMB_SpriteConfig
{
    @disable this();

    static:
    
    enum ushort default_size = 64;

    Vec2 get_position_limit()
    {
        const Vec2 position_limit = Vec2(
            EMB_ScreenConfig.Dimensions.width - default_size,
            EMB_ScreenConfig.Dimensions.height - default_size
        );

        return position_limit;
    }
}

public struct EMB_PhysicsConfig
{
    @disable this();

    static:
    enum float gravity = 340.0f;
}

public struct EMB_PlayerInput
{
    @disable this();

    static:
    // Teclas predeterminadas
    private 
    {
        Keyboard left_key = Keyboard.left;
        Keyboard right_key = Keyboard.right;
        Keyboard boost_key = Keyboard.z;
    }

    // --------------------------
    // Teclas presionadas
    // --------------------------

    bool left_keydown()
    {
        return isDown(left_key);
    }

    bool right_keydown()
    {
        return isDown(right_key);
    }

    bool boost_keydown()
    {
        return isDown(boost_key);
    }
    
    // ---------------------------
    // Configuración de teclas (Setters)
    // ---------------------------

    void set_left_key(Keyboard key)
    {
        if (left_key != key) left_key = key;
    }

    void set_right_key(Keyboard key)
    {
        if (right_key != key) right_key = key;
    }

    void set_boost_key(Keyboard key)
    {
        if (boost_key != key) boost_key = key;
    }
}

public struct EMB_EffectsUtils
{
    @disable this();

    static uint8_t get_blinking_effect
    (
        float progress,
        uint8_t maxAlpha = 255,
        float base_alpha = 1.0f,
        float frequency = 10.0f,
        float intensity = 0.6f
    )
    {
        float alpha = base_alpha * (1.0f - intensity * (sin(progress * frequency) + 1) * 0.5f);
        return cast(uint8_t)(alpha * maxAlpha);
    }
}