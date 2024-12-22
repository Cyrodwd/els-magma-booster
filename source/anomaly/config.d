module anomaly.config;

// Tipos, patrones de movimiento, etc.

import std.stdint : uint8_t;

public enum EMB_AnomalyState : uint8_t
{
    none = 0, // Inactivo
    disappearing, // Desapareciendo (Es decir, después de estar activo)
    spawning, // Reaparaciendo (Es decir, preparando antes de activarse)
    active // Activo, puede hacer daño y moverse (Dinámicos-Semiestáticos)
}

public enum EMB_AnomalyDirection : uint8_t
{
    none = 0x0,
    horizontal = 0x1,
    vertical = 0x2,
}