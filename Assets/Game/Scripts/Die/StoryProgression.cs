using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StoryProgression : MonoBehaviour
{

    [SerializeField] private GameObject[] progressionBlocks;
    [SerializeField] private SoundDef[] audios;
    EventInstance ev;
    private void OnEnable()
    {
        ev = GetComponentInParent<EventInstance>();
        Player.instance.progressionCount++;
        SoundDef s = audios[Player.instance.progressionCount];
        GameObject p = progressionBlocks[Player.instance.progressionCount];
        p.SetActive(true);
        SoundManager.Play(s);

        ev.ChangeDuration(s.audioClip[0].length);
    }
}
