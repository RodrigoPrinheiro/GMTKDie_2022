using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventInstance : MonoBehaviour
{
    public static DieEventsManager EventsManager { get; set; }
    public DiceGameEvent Data { get; set; }
    [ReadOnly] public float LastTimeStamp;
    public bool IsPersistent => Data.type == DiceEventType.Persistent;

    private bool isRunning = false;
    public void Run()
    {
        CheckSave(Data);
        
        EventsManager.EventRunning = true;
        LastTimeStamp = Time.time;
        isRunning = true;
        OnRun();

        transform.GetChild(0).gameObject.SetActive(true);
    }
    public void End()
    {
        EventsManager.EventRunning = false;
        isRunning = false;
        OnEnd();

        transform.GetChild(0).gameObject.SetActive(false);

        if (!IsPersistent)
        {
            Destroy(gameObject);
        }
    }
    public virtual void OnRun()
    {

    }
    public virtual void OnEnd()
    {

    }
    private void Update()
    {
        if (isRunning)
        {
            if (LastTimeStamp + Data.eventDuration > Time.time)
            {
                End();
            }
        }
    }
    public bool CanTrigger()
    {
        if (!IsPersistent) return false;

        return LastTimeStamp + Data.persistentTimeLoop > Time.time;
    }

    private void CheckSave(DiceGameEvent gameEvent)
    {
        if (!PlayerPrefs.HasKey(gameEvent.name))
            PlayerPrefs.SetString(gameEvent.name, System.DateTime.Now.ToShortDateString());
    }
}
