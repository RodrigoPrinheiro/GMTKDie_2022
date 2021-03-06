using System.Collections;
using System.Collections.Generic;
using UnityEngine;
#if UNITY_EDITOR
using UnityEditor;
#endif

[CreateAssetMenu(menuName ="Game/Die Event")]
public class DiceGameEvent : ScriptableObject
{
    [Header("Design")]
    public DiceEventType type;
    public float eventDuration = 20;
    public float persistentTimeLoop = 120; // In seconds
    public int minRollsToAppear = 0;
    public bool byPassQueue = false;
    [Header("Unlockable")]
    public DiceGameEvent unlocksEvent;
    public bool unlockable;
    
    [Header("Action")]
    public GameObject diceSideVisual;
    public GameObject activationParticles;
    public float destroyParticlesAfter = 1f;
    public GameObject eventPack;
    
    [Header("Audio")]
    public SoundDef voiceClip;

    #if UNITY_EDITOR
    private void OnValidate() 
    {
        if (unlocksEvent != null && !unlocksEvent.unlockable)
        {
            unlocksEvent.unlockable = true;
            EditorUtility.SetDirty(unlocksEvent);
        }
    }
    #endif
}

public enum DiceEventType
{
    Persistent,
    Passive,
}