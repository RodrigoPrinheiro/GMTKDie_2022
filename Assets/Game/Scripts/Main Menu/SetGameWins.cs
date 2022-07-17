using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class SetGameWins : MonoBehaviour
{
    [SerializeField] private TextMeshPro text;
    private void OnEnable() 
    {
        if (!PlayerPrefs.HasKey("Game Completed"))
        {
            gameObject.SetActive(false);
        }
        else
        {
            text.text = PlayerPrefs.GetInt("Game Completed", 0).ToString();
        }
    }
}
