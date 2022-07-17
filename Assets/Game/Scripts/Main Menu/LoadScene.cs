using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LoadScene : MonoBehaviour
{
    [SerializeField] float delay = .3f;
    [SerializeField] private string _sceneName;

    public void LoadSceneAfterDelay()
    {
        StartCoroutine(CInteractionDelay());
    }

    IEnumerator CInteractionDelay()
    {
        yield return new WaitForSeconds(delay);
        SceneManager.LoadScene(_sceneName);
    }
}
