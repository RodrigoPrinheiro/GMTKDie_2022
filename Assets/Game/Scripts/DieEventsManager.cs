using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DieEventsManager : MonoBehaviour
{
    private List<EventInstance> activePersistentEvents;
    private Queue<EventInstance> queuedGameEvents;
    private EventInstance activeEvent;
    public bool EventRunning { get; set; }
    private void Awake()
    {
        queuedGameEvents = new Queue<EventInstance>();
        activePersistentEvents = new List<EventInstance>();

        EventInstance.EventsManager = this;
    }

    private void Update()
    {
        if (EventRunning) return;

        if (queuedGameEvents.Count > 0)
        {
            EventInstance e = queuedGameEvents.Dequeue();
            e.Run();
            return;
        }

        for (int i = 0; i < activePersistentEvents.Count; i++)
        {
            if (activePersistentEvents[i].CanTrigger())
            {
                activePersistentEvents[i].Run();
            }
        }
    }

    public void QueueEvent(DiceGameEvent gameEvent)
    {
        if (gameEvent.unlocksEvent != null)
        {
            GameData.instance.Unlock(gameEvent.unlocksEvent);
        }

        if (gameEvent.eventPack == null) return;
        
        GameObject g = Instantiate(gameEvent.eventPack, Vector3.zero, Quaternion.identity);
        EventInstance newEvent = g.GetComponent<EventInstance>();

        newEvent.Data = gameEvent;
        
        if (gameEvent.byPassQueue)
        {
            newEvent.Run();
        }
        else
        {
            queuedGameEvents.Enqueue(newEvent);
        }

        if (newEvent.IsPersistent)
        {
            activePersistentEvents.Add(newEvent);
        }
    }


}
