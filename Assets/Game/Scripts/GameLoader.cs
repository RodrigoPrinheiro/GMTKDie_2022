using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
#if UNITY_EDITOR
using UnityEditor;
using UnityEditor.SceneManagement;
#endif

public class GameLoader : MonoBehaviour
{
    [SerializeField] private string startScene;
    private void Start() 
    {
        #if UNITY_EDITOR
        string mainPath = EditorBuildSettings.scenes[0].path;
        string activeScene = EditorPrefs.GetString("activeEditorScene", mainPath);
        if (activeScene != mainPath)
        {
            SceneManager.LoadScene(AssetDatabase.LoadAssetAtPath<SceneAsset>(activeScene).name, LoadSceneMode.Single);
            EditorSceneManager.playModeStartScene = null;
        }
        else
        {
            SceneManager.LoadScene(startScene);
        }
        #else
        SceneManager.LoadScene(startScene);
        #endif
    }
}
