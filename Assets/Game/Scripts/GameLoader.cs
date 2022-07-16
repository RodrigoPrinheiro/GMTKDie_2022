using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GameLoader : MonoBehaviour
{
    [SerializeField] private string startScene;
    private void Start() 
    {
        SceneManager.LoadScene(startScene);
    }
}
