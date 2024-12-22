module components.emb_timer;

import joka.math : max;
import parin.timer;

/*
 * La ausencia de un bucle integrado es parte del diseño.
 * Esto se debe a que me da flojera lidiar con los bucles en esto.
 * También para darle al usuario mayor control. Así, si necesita reiniciar el temporizador, simplemente 'start()' es suficiente.
 * El diseño de tener que implementar un bucle manualmente, es para darle al usuario la flexibilidad de tener un comportamiento lógico
 * específico al completarse el temporizador.
*/

// 0.1f => Un temporizador con una duración de cero para bajo, no tiene sentido.
enum float EMB_TIMER_MIN_DURATION = 0.1f;

/** 
 * Un temporizador personalizado. No incluye un bucle integrado.
 */
struct EMB_Timer
{
    private bool running;
    private bool completed;

    /// Duración del temporizador
    private float duration;
    /// Tiempo transcurrido
    private float elapsed;

    /// Establece un nuevo temporizador de una duración mínima de 0.1 segundos (No cero ni valores negativos)
    public this(float duration)
    {
        running = false;
        completed = false;

        this.duration = max(duration, EMB_TIMER_MIN_DURATION);
        elapsed = 0f;
    }

    // Actualiza el temporizador (para actualizar el tiempo transcurrido)
    public void update(float dt)
    {
        // En teoría esto no es probable, pero mejor ser precavido
        if (dt < 0)
        {
            stop();
            return;
        }

        if (running)
        {
            elapsed += dt;

            if (elapsed >= duration)
            {
                completed = true;
                stop();
            }
        }
    }

    /// Inicializa el temporizador, únicamente si no está activo.
    public void start()
    {
        if (!running)
        {
            running = true;
            reset();
        }
    }

    /// Reanuda el tiempo del temporizador (Solo si está pausado)
    public void resume()
    {
        if (!running && !completed)
            running = true;
    }

    /// Detiene el tiempo (similar a una pausa)
    public void stop()
    {
        if (running) running = false;
    }

    /// Reinicia el tiempo
    public void reset()
    {
        elapsed = 0f;
        completed = false;
    }

    /// El temporizador sigue transcurriendo
    public bool is_running()
    {
        return running;
    }

    /// El temporizador ha terminado y llegado a su máxima duración
    public bool has_completed()
    {
        return (!running && completed);
    }

    /// Establece una nueva duración de mínimo 0.1 segundos (No se permite cero ni valores negativos)
    public void set_duration(float duration)
    {
        if (this.duration != duration)
        {
            this.duration = max(duration, EMB_TIMER_MIN_DURATION);
        }
    }

    /// La duración total del temporizador
    public float get_duration()
    {
        return duration;
    }

    /// El tiempo transcurrido
    public float get_elapsed()
    {
        return elapsed;
    }

    /// El tiempo restante para terminar
    public float get_remaining()
    {
        return duration - elapsed;
    }
}