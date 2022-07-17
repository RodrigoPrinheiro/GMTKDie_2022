using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class QuitGame : MonoBehaviour
{
    [SerializeField] float delay = 1;
    
    public void QuitGameAfterDelay()
    {
        StartCoroutine(CInteractionDelay());
    }

    IEnumerator CInteractionDelay()
    {
        yield return new WaitForSeconds(delay);
        Debug.LogWarning("Quit Game");
        Application.Quit();
    }
}
