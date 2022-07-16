using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SideChoice
{
    public Transform faceTransform;
    public DiceGameEvent diceSideEvent;
}

public class TheDie : MonoBehaviour
{
    private DieFaces faces;
    private DieEventsManager eventsManager;
    private Animator animator;
    [SerializeField] private float rotationSpeed;
    [SerializeField] private float rotateDuration = 4f;
    [SerializeField] private float choiceRotationDuration = 0.6f;
    [SerializeField] private AnimationCurve speedIncreaseCurve;
    private int rollsCount;
    private Dictionary<DieFaces.Direction, DiceGameEvent> diceState;
    private DiceGameEvent lastPicked;

    private void Awake() 
    {
        faces = GetComponentInChildren<DieFaces>();
        animator = GetComponent<Animator>();

        eventsManager = GetComponent<DieEventsManager>();
        diceState = new Dictionary<DieFaces.Direction, DiceGameEvent>();
    }
    
    private void Start() 
    {
        rollsCount = 0;
        RandomizeFaces(0);
        Roll();
    }

    public void Roll()
    {
        animator.SetTrigger("StartRoll");
        StartCoroutine(RollAndPick());
        animator.SetTrigger("EndRoll");
    }

    public void RandomizeFaces(int rolls)
    {
        var pickedEvents = GameData.instance.EventsForRollCount(rolls);
        int index = 0;
        foreach (var item in pickedEvents)
        {
            DieFaces.Direction d = (DieFaces.Direction)index;
            
            if (!diceState.ContainsKey(d))
                diceState.Add(d, item);
            else
                diceState[d] = item;
            
            faces.SetFace(item, d);
            index++;
        }
    }

    public SideChoice GetRandomChoice()
    {
        DieFaces.Direction dir = (DieFaces.Direction)Random.Range(0, 6);
        DiceGameEvent picked = diceState[dir];
        
        Debug.Log($"Picked event with dice side {dir} and event {picked.name}");

        return new SideChoice(){faceTransform = faces.GetTransform(dir), diceSideEvent = picked};
    }

    public IEnumerator RollAndPick()
    {
        SideChoice choice = GetRandomChoice();
        lastPicked = choice.diceSideEvent;

        // Random rot
        float elapsed = 0f;
        float newRotationTimer = 0f;
        Vector3 target = Random.insideUnitSphere.normalized;
        while(elapsed <= rotateDuration)
        {
            if (newRotationTimer >= 1f)
            {
                target = Random.insideUnitSphere.normalized;
                newRotationTimer = 0;
            }
            float speed = rotationSpeed * speedIncreaseCurve.Evaluate(elapsed / rotateDuration);
            transform.Rotate(target * Time.deltaTime * speed);

            elapsed += Time.deltaTime;
            newRotationTimer += Time.deltaTime;
            yield return null;
        }

        // Rotate to correct side
        elapsed = 0f;
        Quaternion finalRot = Quaternion.LookRotation(Vector3.up, Vector3.right); // Subtract
        finalRot = finalRot * Quaternion.Inverse(choice.faceTransform.rotation); // Add
        finalRot = finalRot * transform.rotation;

        Quaternion startRot = transform.rotation;
        while(elapsed <= choiceRotationDuration)
        {
            transform.rotation = Quaternion.Slerp(
                startRot, finalRot, elapsed / choiceRotationDuration);
            elapsed += Time.deltaTime;
            yield return null;
        }
    }
    
    //! Called via animation event to trigger the game event
    public void TriggerSide()
    {
        if (lastPicked.activationParticles != null)
        {
            GameObject obj = Instantiate(lastPicked.activationParticles, transform.position, Quaternion.identity);
            Destroy(obj, lastPicked.destroyParticlesAfter);
        }

        eventsManager.QueueEvent(lastPicked);
    }
}
