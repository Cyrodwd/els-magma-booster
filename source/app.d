import parin;

import els.player;
import std.stdint : uint8_t;
import components.emb_game;
import components.emb_timer;
import wolfmanager;

private EMB_Game els_magma_booster_game;

void ready()
{
    els_magma_booster_game.setup(pixel_perfect: true);
}

bool update(float dt)
{
    drawDebugText(format("FPS: {}", fps()), Vec2.zero);

    if (els_magma_booster_game.update(dt)) return true;
    return false;
}

void finish()
{
    //els_magma_booster_game.finish();
}

mixin runGame!(ready, update, finish);
