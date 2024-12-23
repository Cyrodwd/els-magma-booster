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
    private EMB_StaticAnomaly score_ray_test;

    EMB_ScoreManager emb_score_manager;
    EMB_Timer emb_score_timer;

    // Funciones miembro privados (Para las anomalías)
    void score_ray_test_effect()
    {
        emb_score_manager.set_multiplier(EMB_MAX_SCORE_MULTIPLIER);
    }

    void reset_score_manager()
    {
        emb_score_manager.set_multiplier(multiplier: 1);
    }

    // Funciones miembro
    public void ready()
    {
        emb_score_manager = EMB_ScoreManager(multiplier: 1); // Por defecto
        emb_score_timer = EMB_Timer(duration: 1f);

        els_player.setup();

        // Anomalía instantánea
        score_ray_test = new EMB_StaticAnomaly(EMB_AnomalyDirection.horizontal, on_spawn_time: 3f, on_screen_time:  4f,
            effect: &score_ray_test_effect, 8f);

        if (score_ray_test !is null)
        {
            score_ray_test.set_reverse_effect(&reset_score_manager);
            score_ray_test.reset();
        }

        emb_score_timer.start();
    }

    public bool update(float dt)
    {
        update_score_timer(dt);

        els_player.update(dt);
        score_ray_test.update(dt, els_player);

        draw();

        return false;
    }

    private void draw()
    {
        els_player.draw();
        score_ray_test.draw();
        emb_score_manager.draw();
    }

    public void finish()
    {
        destroy(score_ray_test);
    }

    private void update_score_timer(float dt)
    {
        emb_score_timer.update(dt);

        // No hagas nada lmao

        if (emb_score_timer.has_completed())
        {
            emb_score_manager.add();
            emb_score_timer.start();
        }
    }
}