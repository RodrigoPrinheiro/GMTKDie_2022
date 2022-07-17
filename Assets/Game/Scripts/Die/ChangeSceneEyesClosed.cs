using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeSceneEyesClosed : MonoBehaviour
{
    [SerializeField] private string scenePackName;
    private GameObject[] scenePacks;
    private EventInstance ev;
    private void Awake() {
        scenePacks = GameObject.FindGameObjectsWithTag("Scene Pack");
    }
    private void OnEnable() 
    {
        ev = GetComponentInParent<EventInstance>();
        ev.LockEvent = true;
        Player.instance.closeEyesEvent = ChangeScene;
    }

    public void ChangeScene()
    {
        int index = 0;
        for (int i = 0; i < scenePacks.Length; i++)
        {
            if (scenePacks[i].name == scenePackName)
            {
                index = i;
            }
            else if (scenePacks[i].activeInHierarchy)
            {
                scenePacks[i].gameObject.SetActive(false);
            }
        }

        scenePacks[index].SetActive(true);
        ev.LockEvent = false;

        Debug.Log("Activated scene " + scenePacks[index].name);
    }
}
