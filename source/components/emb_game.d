module components.emb_game;

import parin;
import scenes.emb_gamescene;
import wolfmanager : WolfConstManager;

public struct EMB_Game
{
    // Canales de audio

    // Gestor de escenas
    SceneManager emb_scene_manager;


    void setup(bool pixel_perfect)
    {
        lockResolution(WolfConstManager.resolution_width, WolfConstManager.resolution_height);
        setIsPixelPerfect(pixel_perfect);

        emb_scene_manager.enter!EMB_GameScene();
    }

    bool update(float dt)
    {
        emb_scene_manager.update(dt);
        return false;
    }

    void finish()
    {
        // Liberar recursos acá o algo
        emb_scene_manager.free();
    }
}