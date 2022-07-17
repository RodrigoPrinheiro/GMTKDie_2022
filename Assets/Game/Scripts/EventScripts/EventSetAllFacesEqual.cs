using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EventSetAllFacesEqual : MonoBehaviour
{
	private static bool ranOnce = false;

	private readonly List<DieFaces.Direction> _directions = new List<DieFaces.Direction>()
	{
		DieFaces.Direction.Xm,
		DieFaces.Direction.Xp,
		DieFaces.Direction.Ym,
		DieFaces.Direction.Yp,
		DieFaces.Direction.Zm,
		DieFaces.Direction.Zp
	};

	[SerializeField] private TheDie _die;
	[SerializeField] private DieFaces _dieFaces;
	[SerializeField] private bool _playOnEnable;

	private void OnEnable()
	{
		if (_playOnEnable)
		{
			SetAllFaces();
		}
	}

	private void SetAllFaces()
	{
		if (ranOnce) return;
		ranOnce = true;

		_die = FindObjectOfType<TheDie>();
		_dieFaces = _die.GetComponentInChildren<DieFaces>();


		int rnd = Random.Range(0, 5);
		var evnt = _die.GetDieFaceEvent(_directions[rnd]);

		foreach (var dir in _directions)
		{
			_dieFaces.SetFace(evnt, dir);
		}
	}
}
