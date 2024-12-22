module scenes.emb_gamescene;

import parin;
import els.player;

import components.emb_timer;
import components.emb_score;

import anomaly.config;
import anomaly.static_anomaly;

public struct EMB_GameScene
{
    mixin extendScene;

    // Recursos de la escena
    private EMB_Player els_player;
    private EMB_StaticAnomaly red_lightbeam;

    EMB_ScoreManager emb_score_manager;
    EMB_Timer emb_score_timer;

    // Funciones miembro privados (Para las anomalías)
    void red_lightbeam_effect()
    {
        println("Score multiplier: 4x");
        emb_score_manager.set_multiplier(multiplier: 4);
    }

    void reset_score_manager()
    {
        println("Score multiplier: 1x (Default)");
        emb_score_manager.set_multiplier(multiplier: 1);
    }

    // Funciones miembro
    public void ready()
    {
        emb_score_manager = EMB_ScoreManager(multiplier: 1); // Por defecto
        emb_score_timer = EMB_Timer(1f);

        els_player.setup();
        red_lightbeam = new EMB_StaticAnomaly(EMB_AnomalyDirection.horizontal, on_spawn_time: 3f, on_screen_time:  4f,
            effect: &red_lightbeam_effect);

        if (red_lightbeam !is null)
        {
            red_lightbeam.set_reverse_effect(&reset_score_manager);
            red_lightbeam.reset();
        }

        emb_score_timer.start();
    }

    public bool update(float dt)
    {
        update_score_timer(dt);

        els_player.update(dt);
        red_lightbeam.update(dt, els_player);

        draw();

        return false;
    }

    private void draw()
    {
        els_player.draw();
        red_lightbeam.draw();
    }

    public void finish()
    {
        destroy(red_lightbeam);
    }

    private void update_score_timer(float dt)
    {
        emb_score_timer.update(dt);

        // No hagas nada lmao

        if (emb_score_timer.has_completed())
        {
            emb_score_manager.add();
            println("PUNTAJE: ", emb_score_manager.get_score());

            emb_score_timer.start();
        }
    }
}