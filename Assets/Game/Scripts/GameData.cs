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
        } while (picks.Count < pickCount);

        return picks;
    }
    protected override void OnAwake()
    {
        string[] unlocked = GetUnlocked();

        dieEventDictionary = new Dictionary<string, List<DiceGameEvent>>();
        dieEventDictionary.Add("active", new List<DiceGameEvent>());
        dieEventDictionary.Add("locked", new List<DiceGameEvent>());

        for (int i = 0; i < dieEvents.Count; i++)
        {
            DiceGameEvent e = dieEvents[i];

            if (Array.Exists(unlocked, (s) => s.Contains(e.name)))
                dieEventDictionary["active"].Add(e);
            else
            {

                string key = e.unlockable ? "locked" : "active";
            }
        }
    }

    public void Unlock(DiceGameEvent e)
    {
        if(dieEventDictionary["locked"].Contains(e))
        {
            dieEventDictionary["locked"].Remove(e);
            dieEventDictionary["active"].Add(e);
        }

        string value = PlayerPrefs.GetString("unlocked", "");
        value = value + e.name + " ";
        PlayerPrefs.SetString("unlocked", value);
    }

    private string[] GetUnlocked()
    {
        string unlocked = PlayerPrefs.GetString("unlocked", "");
        string[] unlockedList = unlocked.Split(' ');

        return unlockedList;
    }
}
