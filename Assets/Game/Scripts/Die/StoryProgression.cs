using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StoryProgression : MonoBehaviour
{

    [SerializeField] private GameObject[] progressionBlocks;

    private void OnEnable()
    {
        Player.instance.progressionCount++;
        progressionBlocks[Player.instance.progressionCount].SetActive(true);
    }
}
