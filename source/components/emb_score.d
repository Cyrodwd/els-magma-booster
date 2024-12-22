module components.emb_score;

/*
 * Un gestor de puntaje que maneja un valor de 100 en 100.
 * Diseño. Básicamente este gestor es único para este proyecto.
 * Por lo tanto, este proyecto necesita un puntaje de 100 en 100, así que está
 * adaptado a las necesidades de esto.
*/

import joka.math : max;


enum ubyte MIN_SCORE_MULTIPLIER = 1;
enum ubyte SCORE_AMOUNT = 100;
enum int MAX_SCORE_AMOUNT = 900_900_900;

struct EMB_ScoreManager
{
    private ubyte multiplier;
    private int score;

    public this(ubyte multiplier)
    {
        this.multiplier = max(multiplier, MIN_SCORE_MULTIPLIER);
        score = 0;
    }

    /// Agrega puntos de 100 o más dependiendo del multiplicador de puntaje
    public void add()
    {
        if (score < MAX_SCORE_AMOUNT)
        {
            score += SCORE_AMOUNT * multiplier;
        }
    }

    /// Resta 100 puntos multiplicado por la cantidad de veces establecida
    public void subtract(ubyte times = MIN_SCORE_MULTIPLIER)
    {
        if (score > 0)
        {
            score -= SCORE_AMOUNT * max(times, MIN_SCORE_MULTIPLIER);
        }
    }

    // Establece el multiplicador de mínimo 1.
    public void set_multiplier(ubyte multiplier)
    {
        this.multiplier = max(multiplier, MIN_SCORE_MULTIPLIER);
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
        return score >= MAX_SCORE_AMOUNT;
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