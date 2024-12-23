module components.emb_score;

/*
 * Un gestor de puntaje que maneja un valor de 100 en 100.
 * Diseño. Básicamente este gestor es único para este proyecto.
 * Por lo tanto, este proyecto necesita un puntaje de 100 en 100, así que está
 * adaptado a las necesidades de esto.
*/

import joka.math : clamp, max;
import parin : format, Vec2, drawDebugText;


public enum ubyte EMB_MIN_SCORE_MULTIPLIER = 1;
public enum ubyte EMB_MAX_SCORE_MULTIPLIER = 10;

/// El valor de puntaje que maneja el gestor de puntajes.
public enum ubyte EMB_SCORE_AMOUNT = 100;
/// Bueno, mejor ser precavido.
public enum int EMB_MIN_SCORE_AMOUNT = -10_000;
/// Un número extremadamente grande. Debes tener mucha paciencia o de plano estar haciendo trampas lmao.
public enum int EMB_MAX_SCORE_AMOUNT = 900_900_900;

struct EMB_ScoreManager
{
    private ubyte multiplier;
    private int score;

    public this(ubyte multiplier)
    {
        this.multiplier = clamp(multiplier, EMB_MIN_SCORE_MULTIPLIER, EMB_MAX_SCORE_MULTIPLIER);
        score = 0;
    }

    public void draw()
    {
        drawDebugText(format("SCORE: {}", score), Vec2(0));
    }

    /// Agrega puntos de 100 o más dependiendo del multiplicador de puntaje
    public void add()
    {
        if (score < EMB_MAX_SCORE_AMOUNT)
        {
            score += clamp(EMB_SCORE_AMOUNT * multiplier, EMB_MIN_SCORE_AMOUNT, EMB_MAX_SCORE_AMOUNT);
        }
    }

    /// Resta 100 puntos multiplicado por la cantidad de veces establecida
    public void subtract(ubyte times = EMB_MIN_SCORE_MULTIPLIER)
    {
        if (score > 0)
        {
            score -= EMB_SCORE_AMOUNT * max(times, EMB_MIN_SCORE_MULTIPLIER);
        }
    }

    // Establece el multiplicador de mínimo 1.
    public void set_multiplier(ubyte multiplier)
    {
        this.multiplier = clamp(multiplier, EMB_MIN_SCORE_MULTIPLIER, EMB_MAX_SCORE_MULTIPLIER);
    }


    public void reset()
    {
        multiplier = 1;
        score = 0;
    }

    public int get_score()
    {
        return score;
    }

    public ubyte get_multiplier()
    {
        return multiplier;
    }

    public bool has_max_score()
    {
        return score >= EMB_MAX_SCORE_AMOUNT;
    }
}

unittest
{
    import joka.io : println;
    EMB_ScoreManager score_test = EMB_ScoreManager(multiplier: 1);
    println("Gestor de puntaje creado.");
    
    score_test.add(); // Agrega 100 puntos
    assert(score_test.get_score() == 100, "No se pudo añadir 100 puntos.");
    println("Añadido 100 puntos.");

    // Establecemos el multiplicador de puntos a 3
    score_test.set_multiplier(multiplier: 3);
    assert(score_test.get_multiplier() == 3, "No se pudo establecer el multiplicador de puntos a 3.");
    println("Multiplicador de puntaje establecido a 3.");

    score_test.add(); // Añade 300 puntos
    assert(score_test.get_score() == 400, "No se aplicó correctamente el multiplicador de puntos");
    println("Puntaje establecido a 400");

    // Restando 200 puntos
    score_test.subtract(times: 2);
    assert(score_test.get_score() == 200, "No se restó con éxito el puntaje,");
    println("Puntaje establecido a 200.");
}