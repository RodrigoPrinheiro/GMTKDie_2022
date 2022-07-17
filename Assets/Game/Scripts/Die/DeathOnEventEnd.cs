using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DeathOnEventEnd : MonoBehaviour
{
    private void OnDestroy()
    {
        int completed = PlayerPrefs.GetInt("Game Completed", 0);
        completed++;
        PlayerPrefs.SetInt("Game Completed", completed);
        Player.instance.Die(false);
    }
}
