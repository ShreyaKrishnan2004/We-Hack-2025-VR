using UnityEngine;
using UnityEngine.Video;

public class VideoThermalShader : MonoBehaviour
{
    public Material thermalMaterial; // The material with the thermal vision shader
    private VideoPlayer videoPlayer;

    void Start()
    {
        // Get the VideoPlayer component attached to this object
        videoPlayer = GetComponent<VideoPlayer>();

        if (videoPlayer == null)
        {
            Debug.LogError("No VideoPlayer component found on this object.");
            return;
        }

        // Check if we have a valid material
        if (thermalMaterial == null)
        {
            Debug.LogError("Thermal material not assigned.");
            return;
        }

        // Assign the VideoPlayer's texture to the thermal material's main texture
        thermalMaterial.mainTexture = videoPlayer.texture;

        // Optional: Start playing the video
        videoPlayer.Play();
    }
}