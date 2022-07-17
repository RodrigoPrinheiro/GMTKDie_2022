using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventInstance : MonoBehaviour
{
    public static DieEventsManager EventsManager { get; set; }
    public DiceGameEvent Data { get; set; }
    public bool IsPersistent => Data.type == DiceEventType.Persistent;

    private float lastTimeStamp;
    private bool isRunning = false;
    private float runTime;
    public void Run()
    {
        CheckSave(Data);

        EventsManager.EventRunning = true;
        runTime = 0f;

        // Play voice line and wait for it to end before starting
        StartCoroutine(WaitForVoiceLine(Data.voiceClip));
    }
    public void End()
    {
        EventsManager.EventRunning = false;
        isRunning = false;

        transform.GetChild(0).gameObject.SetActive(false);

        if (!IsPersistent)
        {
            Destroy(gameObject);
        }
    }

    private void Update()
    {
        if (isRunning)
        {
            runTime += Time.deltaTime;
            if (runTime > Data.eventDuration)
            {
                End();
            }
        }
    }

    private IEnumerator WaitForVoiceLine(SoundDef voiceClip)
    {
        if (voiceClip != null)
        {
            float waitTime = voiceClip.audioClip[0].length;
            SoundManager.Play(voiceClip);

            yield return new WaitForSeconds(waitTime);
        }

        lastTimeStamp = Time.time;
        isRunning = true;
        transform.GetChild(0).gameObject.SetActive(true);
    }
    public bool CanTrigger()
    {
        if (!IsPersistent) return false;
        if (isRunning) return false;

        return (lastTimeStamp + Data.persistentTimeLoop) < Time.time;
    }

    private void CheckSave(DiceGameEvent gameEvent)
    {
        if (!PlayerPrefs.HasKey(gameEvent.name))
            PlayerPrefs.SetString(gameEvent.name, System.DateTime.Now.ToShortDateString());
    }
}
