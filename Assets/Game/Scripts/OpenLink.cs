using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OpenLink : MonoBehaviour
{
    public string link = "https://thetip-studios.itch.io";
    private void OnMouseUp()
    {
        Application.OpenURL(link);

    }
}
