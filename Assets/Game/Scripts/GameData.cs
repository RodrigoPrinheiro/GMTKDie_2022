using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameData : Singleton<GameData>
{
    private List<DiceGameEvent> dieEvents;
    private Dictionary<string, List<DiceGameEvent>> dieEventDictionary;
    protected override void MyDestroy()
    {
        
    }

    protected override void OnAwake()
    {
        dieEventDictionary = new Dictionary<string, List<DiceGameEvent>>();
        dieEventDictionary.Add("active", new List<DiceGameEvent>());
        dieEventDictionary.Add("locked", new List<DiceGameEvent>());

        for (int i = 0; i < dieEvents.Count; i++)
        {
            DiceGameEvent e = dieEvents[i];
            string key = e.unlockable ? "locked" : "active";
            dieEventDictionary[key].Add(e);
        }
    }
}
