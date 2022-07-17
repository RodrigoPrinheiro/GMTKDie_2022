using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChangeSceneEyesClosed : MonoBehaviour
{
    [SerializeField] private string scenePackName;
    private GameObject scenePacks;
    private List<GameObject> packs;
    private EventInstance ev;
    private void Awake() 
    {
        scenePacks = GameObject.FindGameObjectWithTag("Scene Pack");
        packs = new List<GameObject>();

        foreach(Transform c in scenePacks.transform)
        {
            packs.Add(c.gameObject);
        }
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
        for (int i = 0; i < packs.Count; i++)
        {
            if (packs[i].name == scenePackName)
            {
                index = i;
            }
            else if (packs[i].activeInHierarchy)
            {
                packs[i].gameObject.SetActive(false);
            }
        }

        packs[index].SetActive(true);
        ev.LockEvent = false;

        Debug.Log("Activated scene " + packs[index].name);
    }
}
