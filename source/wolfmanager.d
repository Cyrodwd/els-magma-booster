module wolfmanager;

import parin;
import els.player;
import components.emb_timer;
import std.stdint : uint8_t;

/*

***WOLF MANAGER***

'WolfManager' es básicamente un namespace para almacenar valores globales, como la
entrada del usuario y otras constantes de física.

*/

public struct WolfConstManager
{
    @disable this();

    // Ventana
    static enum ushort resolution_width = 640;
    static enum ushort resolution_height = 480;

    static enum ushort sprite_xposition_limit = resolution_width - sprite_size;
    static enum ushort sprite_yposition_limit = resolution_height - sprite_size;

    //Sprites
    static enum ubyte sprite_size = 32;

    // Físicas
    static enum float gravity = 340.0f;
}

public struct WolfKeysManager
{
    @disable this();
    static private Keyboard player_keyboard_left = Keyboard.left;
    static private Keyboard player_keyboard_right = Keyboard.right;
    static private Keyboard player_keyboard_boost = Keyboard.z;

    static bool is_player_left()
    {
        return (
            isDown(player_keyboard_left) ||
            isDown(Gamepad.left) ||
            isDown(Gamepad.lsb)
        );
    }

    static bool is_player_right()
    {
        return (
            isDown(player_keyboard_right) ||
            isDown(Gamepad.right) ||
            isDown(Gamepad.rsb)
        );
    }

    static bool is_player_boost()
    {
        return (
            isDown(player_keyboard_boost) ||
            isDown(Gamepad.x) ||
            isDown(Gamepad.rb)
        );
    }

    static void set_right_key(Keyboard key)
    {
        if (player_keyboard_right != key) player_keyboard_right = key;
    }

    static void set_left_key(Keyboard key)
    {
        if (player_keyboard_left != key) player_keyboard_left = key;
    }
    
    static void set_boost_key(Keyboard key)
    {
        if (player_keyboard_boost != key) player_keyboard_boost = key;
    }
}

public struct WolfEffectManager
{
    @disable this();

    static uint8_t get_blinking_effect(float progress, uint8_t maxAlpha = 255, float base_alpha = 1.0f,
        float frequency = 10.0f, float intensity = 0.6f)
    {
        float alpha = base_alpha * (1.0f - intensity * (sin(progress * frequency) + 1) * 0.5f);
        return cast(uint8_t)(alpha * maxAlpha);
    }
}