using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.PostProcessing;

public class EventScriptDimmLight : MonoBehaviour
{
	[SerializeField] private PostProcessingProfile _profile;

	private void OnEnable()
	{
		StartCoroutine(Reduce());
	}

	private IEnumerator Reduce()
	{
		Vector2 newCenter = new Vector2(0.5f, 0.3f);
		float newIntensity = 0.6f;

		Vector2 center = _profile.vignette.settings.center;
		float intensity = _profile.vignette.settings.intensity;


		VignetteModel.Settings settings;

		while (_profile.vignette.settings.intensity < newIntensity - 0.01f)
		{
			settings = new VignetteModel.Settings();

			settings.rounded = true;
			settings.roundness = 1;
			settings.smoothness = 1;

			settings.intensity = Mathf.Lerp(_profile.vignette.settings.intensity, newIntensity, Time.deltaTime);
			settings.center = Vector2.Lerp(_profile.vignette.settings.center, newCenter, Time.deltaTime);

			_profile.vignette.settings = settings;

			yield return new WaitForEndOfFrame();
		}

		yield return new WaitForSeconds(20f);
		
		while (_profile.vignette.settings.intensity > intensity + 0.01f)
		{
			settings = new VignetteModel.Settings();

			settings.rounded = true;
			settings.roundness = 1;
			settings.smoothness = 1;

			settings.intensity = Mathf.Lerp(_profile.vignette.settings.intensity, intensity, Time.deltaTime);
			settings.center = Vector2.Lerp(_profile.vignette.settings.center, center, Time.deltaTime);

			_profile.vignette.settings = settings;

			yield return new WaitForEndOfFrame();
		}
		settings = new VignetteModel.Settings();

		settings.rounded = true;
		settings.roundness = 1;
		settings.smoothness = 1;

		settings.intensity = intensity;
		settings.center = center;

		_profile.vignette.settings = settings;
	}
}
