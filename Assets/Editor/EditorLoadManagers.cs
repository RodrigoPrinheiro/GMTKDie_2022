using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.SceneManagement;

[InitializeOnLoad]
public static class EditorLoadManagers
{
    private const string MENU_NAME = "Tools/Initialize Managers Scene";
    
    private static bool _enabled;
    static EditorLoadManagers()
    {
        EditorLoadManagers._enabled = EditorPrefs.GetBool(MENU_NAME, false);
        
        EditorSceneManager.activeSceneChangedInEditMode += (x, y) => 
        {
            EditorPrefs.SetString("activeEditorScene", y.path);
        };
        EditorApplication.delayCall += () => 
        {
            Action(_enabled);
        };
    }

    [MenuItem(MENU_NAME)]
    private static void ToggleAction()
    {
        Action(!_enabled);
    }

    private static void Action(bool enabled)
    {
        Menu.SetChecked(MENU_NAME, enabled);
        EditorPrefs.SetBool(MENU_NAME, enabled);

        _enabled = enabled;

        if (enabled)
        {
            if (EditorBuildSettings.scenes.Length == 0) return;
            SceneAsset asset = AssetDatabase.LoadAssetAtPath<SceneAsset>(EditorBuildSettings.scenes[0].path);
            EditorSceneManager.playModeStartScene = asset;

        }
    }
}
