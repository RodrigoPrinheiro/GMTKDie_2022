using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

public class GameData : Singleton<GameData>
{
    [SerializeField]
    private List<DiceGameEvent> dieEvents = new List<DiceGameEvent>();
    private Dictionary<string, List<DiceGameEvent>> dieEventDictionary;
    protected override void MyDestroy()
    {
        
    }

    public HashSet<DiceGameEvent> EventsForRollCount(int rollCount)
    {
        System.Random rnd = new System.Random();
        List<DiceGameEvent> choices = dieEventDictionary["active"];
        HashSet<DiceGameEvent> picks = new HashSet<DiceGameEvent>();
        int pickCount = Mathf.Min(6, choices.Count);
        do
        {
            int index = rnd.Next(0, choices.Count);
            DiceGameEvent p = choices[index];
            if (p.minRollsToAppear <= rollCount)
                picks.Add(choices[index]);
        }while(picks.Count < pickCount);

        return picks;
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
