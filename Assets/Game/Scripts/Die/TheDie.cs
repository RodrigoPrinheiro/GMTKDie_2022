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
    [SerializeField] private DiceGameEvent overrideEvent;
    [SerializeField] private float rotationSpeed;
    [SerializeField] private float rotateDuration = 4f;
    [SerializeField] private float choiceRotationDuration = 0.6f;
    [SerializeField] private AnimationCurve speedIncreaseCurve;
    [SerializeField] private Transform rotationRoot;
    [SerializeField] private ParticleSystem _rotatePS;
    [SerializeField] private ParticleSystem _canBeRolledPS;
    [SerializeField] private SoundDef rollSound;
    [SerializeField] private SoundDef resultSound;
    private int rollsCount;
    private Dictionary<DieFaces.Direction, DiceGameEvent> diceState;
    public SideChoice rollPick { get; private set; }
    public static bool Rolling { get; private set; }
    public bool CantRoll => Rolling || eventsManager.EventRunning;
    private bool prevCantRollState;
    private void Awake()
    {
        faces = GetComponentInChildren<DieFaces>();
        animator = GetComponent<Animator>();

        eventsManager = GetComponent<DieEventsManager>();
        diceState = new Dictionary<DieFaces.Direction, DiceGameEvent>();
    }

    public void RotatePSPlay() // called in animation event
    {
        _rotatePS.Play();
    }

    private void Start()
    {
        rollsCount = 0;
        RandomizeFaces(0);
    }

    bool _hoveringMouse = false;
    private void Update()
    {
        InteractionFeedback();

        if (Input.GetMouseButtonDown(0))
        {
            Roll();
        }

        animator.SetBool("Hovering", _hoveringMouse);
        
        prevCantRollState = CantRoll;
    }

    private void InteractionFeedback()
    {
        _hoveringMouse = false;
        
        if (!CantRoll) // Can roll
        {
            RaycastHit hit;
            Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
            if (Physics.Raycast(ray, out hit, 100))
            {
                TheDie db = hit.collider.GetComponent<TheDie>();
                if (db == this)
                {
                    _hoveringMouse = true;
                }
            }
        }


        if (CantRoll != prevCantRollState)
        {
            if (CantRoll == false)
            {
                _canBeRolledPS.Play();
            }
        }
    }

    public DiceGameEvent GetDieFaceEvent(DieFaces.Direction direction)
    {
        return diceState[direction];
    }

    public void DestroyAllFaces()
    {
        foreach (var item in diceState)
        {
            Transform sideObject = faces.GetTransform(item.Key).GetChild(0);
            Destroy(sideObject.gameObject);
        }
    }

    public void Roll()
    {
        if (CantRoll) return;

        Rolling = true;
        rollsCount++;
        for (int i = 0; i < 6; i++)
        {
            DieFaces.Direction dir = (DieFaces.Direction)i;

            if (diceState[dir] == null)
            {
                // Get new side for this
                SetNewFace(dir);
            }
        }
        StartCoroutine(RollAndPick());
    }

    private void SetNewFace(DieFaces.Direction dir, DiceGameEvent overr = null)
    {
        if (overr != null)
        {
            diceState[dir] = overr;
            faces.SetFace(overr, dir);
            return;
        }

        var pick = GameData.instance.GetRandomEvent(rollsCount);
        diceState[dir] = pick;
        faces.SetFace(pick, dir);
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
        if (rollsCount % 3 == 0)
        {
            for (int i = 0; i < 6; i++)
            {
                var f = (DieFaces.Direction)i;
                if (diceState[f].name == "RuneTarip")
                {
                    return new SideChoice() { faceTransform = faces.GetTransform(f), diceSideEvent = diceState[f] };
                }
            }
        }

        DieFaces.Direction dir = (DieFaces.Direction)Random.Range(0, 6);
        DiceGameEvent picked = diceState[dir];

        Debug.Log($"Picked event with dice side {dir} and event {picked.name}");

        diceState[dir] = null;
        return new SideChoice() { faceTransform = faces.GetTransform(dir), diceSideEvent = picked };
    }

    public IEnumerator RollAndPick()
    {
        rollPick = GetRandomChoice();

        animator.SetTrigger("StartRoll");
        yield return new WaitForSeconds(0.46f);
        AudioSource rollSource = SoundManager.Play(rollSound);
        // Random rot
        float elapsed = 0f;
        float newRotationTimer = 0f;
        Vector3 target = Random.insideUnitSphere.normalized;
        while (elapsed <= rotateDuration)
        {
            if (newRotationTimer >= 1f)
            {
                target = Random.insideUnitSphere.normalized;
                newRotationTimer = 0;
            }
            float speed = rotationSpeed * speedIncreaseCurve.Evaluate(elapsed / rotateDuration);
            rotationRoot.Rotate(target * Time.deltaTime * speed);

            elapsed += Time.deltaTime;
            newRotationTimer += Time.deltaTime;
            yield return null;
        }

        rollSource.Stop();

        // Rotate to correct side
        elapsed = 0f;
        Quaternion finalRot = Quaternion.LookRotation(Vector3.up, Vector3.right); // Subtract
        finalRot = finalRot * Quaternion.Inverse(rollPick.faceTransform.rotation); // Add
        finalRot = finalRot * rotationRoot.rotation;

        Quaternion startRot = rotationRoot.rotation;
        while (elapsed <= choiceRotationDuration)
        {
            rotationRoot.rotation = Quaternion.Slerp(
                startRot, finalRot, elapsed / choiceRotationDuration);
            elapsed += Time.deltaTime;
            yield return null;
        }

        animator.SetTrigger("EndRoll");

    }

    //! Called via animation event to trigger the game event
    public void TriggerSide()
    {
        SoundManager.Play(resultSound);
        DiceGameEvent eventData = null;
        if (overrideEvent != null)
        {
            eventData = overrideEvent;
            overrideEvent = null;
        }
        else
            eventData = rollPick.diceSideEvent;

        if (eventData.activationParticles != null)
        {
            GameObject obj = Instantiate(eventData.activationParticles, transform.position, Quaternion.identity, transform);
            Destroy(obj, eventData.destroyParticlesAfter);
        }

        eventsManager.QueueEvent(eventData);
        StartCoroutine(HideAndDestroySide(rollPick.faceTransform));
    }

    private IEnumerator HideAndDestroySide(Transform sideTransform)
    {
        yield return new WaitForSeconds(0.6f);
        if (sideTransform.childCount > 0)
        {
            Transform sideObject = sideTransform.GetChild(0);

            float elapsed = 0;
            Vector3 start = sideObject.position;
            while (elapsed < 2f)
            {
                sideObject.position = Vector3.Lerp(
                    start,
                    start + Vector3.down * 0.5f, elapsed / 2f);
                elapsed += Time.deltaTime;
                yield return null;
            }

            Destroy(sideObject.gameObject);
        }
        Rolling = false;
    }
}
