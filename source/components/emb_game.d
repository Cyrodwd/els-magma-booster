module components.emb_game;

import parin;
import scenes.emb_gamescene;
import components.emb_utils;

immutable Vec2 fps_position = Vec2(0f, EMB_ScreenConfig.Dimensions.height - 10);

public struct EMB_Game
{
    // Canales de audio

    // Gestor de escenas
    SceneManager emb_scene_manager;

    void setup(bool pixel_perfect)
    {
        lockResolution(EMB_ScreenConfig.Dimensions.width, EMB_ScreenConfig.Dimensions.height);
        setIsPixelPerfect(pixel_perfect);

        emb_scene_manager.enter!EMB_GameScene();
    }

    bool update(float dt)
    {
        debug drawDebugText(format("FRAMES PER SECOND: {}", fps()), fps_position);
        emb_scene_manager.update(dt);
        return false;
    }

    void finish()
    {
        // Liberar recursos acá o algo
        emb_scene_manager.free();
    }
}