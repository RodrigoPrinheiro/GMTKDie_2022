using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(menuName = "Dice Scenery/Settings")]
public class ScenerySettings : ScriptableObject
{
    [field: SerializeField] public Color FogColor { get; private set; }
    [field: SerializeField] public float FogDensity { get; private set; } = .11f;
}
