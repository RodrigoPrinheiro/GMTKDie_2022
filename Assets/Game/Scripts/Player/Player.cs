using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public enum PlayerState
{
    Default = 0,
    LeanLeft = 1,
    LeanRight = 2,
    LeanDown = 3,
    EyesClosed = 4
}

public class Player : MonoBehaviour
{
    [System.Serializable]
    public class StateChange
    {
        public Vector3 positionOffset;
        public Vector3 rotationOffset;
    }

    public static Player instance;
    public bool Enabled {get; set;}
    [ReadOnly] public PlayerState state;
    [SerializeField] private float leanSpeed = 0.6f;
    [SerializeField, Range(0f, 1.2f)] private float blinkTime = 0.5f;
    [SerializeField] private Transform leanTransform;
    [SerializeField] private List<StateChange> changes;

    public System.Action closeEyesEvent;
    private Vector3 holderStartPosition;
    private Quaternion holderStartRotation;
    private Vector3 targetPosition;
    private Quaternion targetRotation;
    private bool closedEyes = false;
    public int progressionCount {get; set;}
    private void Awake()
    {
        instance = this;

        progressionCount = -1;
        if (changes.Count < 5)
        {
            for (int i = 0; i < 5 - changes.Count; i++)
            {
                changes.Add(new StateChange());
            }
        }
    }

    private void Start()
    {
        SSEffects.FxAnimator.SetTrigger("OpenEyes");
        holderStartPosition = leanTransform.localPosition;
        holderStartRotation = leanTransform.localRotation;

        Enabled = true;
    }

    private void Update()
    {
        if (!Enabled) return;

        CheckState(KeyCode.A, PlayerState.LeanLeft);
        CheckState(KeyCode.D, PlayerState.LeanRight);
        CheckState(KeyCode.S, PlayerState.LeanDown);
        CheckState(KeyCode.Space, PlayerState.EyesClosed);

        leanTransform.localPosition = Vector3.Lerp(leanTransform.localPosition, targetPosition, Time.deltaTime * leanSpeed);
        leanTransform.localRotation = Quaternion.Slerp(leanTransform.localRotation, targetRotation, Time.deltaTime * leanSpeed);
    }

    private void CheckState(KeyCode key, PlayerState target)
    {
        if (Input.GetKeyDown(key))
        {
            state = target;
            UpdateState(state);
        }
        else if (state == target && Input.GetKeyUp(key))
        {
            LeaveState(state);
            state = PlayerState.Default;
            UpdateState(state);
        }
    }

    public void LeaveState(PlayerState oldState)
    {
        switch(oldState)
        {
            case PlayerState.EyesClosed:
                closedEyes = false;
                SSEffects.ActivateEffect("Blink", 0f, blinkTime);
                break;
        }
    }

    public void Die()
    {
        Enabled = false;
        GetComponent<DeathSequence>().DeathFX();
    }
    public void UpdateState(PlayerState newState)
    {
        switch (newState)
        {
            case PlayerState.EyesClosed:
                SSEffects.ActivateEffect("Blink", 1f, blinkTime, closeEyesEvent);
                closedEyes = true;
                break;
            case PlayerState.Default:
            case PlayerState.LeanRight:
            case PlayerState.LeanLeft:
            case PlayerState.LeanDown:
                if (closedEyes)
                {
                    SSEffects.ActivateEffect("Blink", 0f, blinkTime);
                    closedEyes = false;
                }
                ActState(changes[(int)newState]);
                break;
        }
    }

    private void ActState(StateChange change)
    {
        targetPosition = change.positionOffset + holderStartPosition;
        targetRotation = Quaternion.Euler(change.rotationOffset);
    }
}
