using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Video;

public class VideoSwitch : MonoBehaviour
{
    public GameObject video1;
    public GameObject video2;
    private VideoPlayer videoplayer1;
    private VideoPlayer videoplayer2;

    private bool wasPressedLastFrame = false;
    private bool wasButtonTwoPressed = false;
    //False - Video 1, True - Video 2
    private bool videoPlaying = false;

    void Start()
    {
        if (video1 != null)
        {
            videoplayer1 = video1.GetComponent<VideoPlayer>();

            if (videoplayer1 == null)
            {
                Debug.LogWarning("VideoPlayer1 component not found on the assigned GameObject.");
            }
        }
        if (video2 != null)
        {
            videoplayer2 = video2.GetComponent<VideoPlayer>();

            if (videoplayer2 == null)
            {
                Debug.LogWarning("VideoPlayer2 component not found on the assigned GameObject.");
            }
        }
    }

    void Update()
    {
        // Check if Button.One (A button) is pressed on the right controller
        bool isPressed = OVRInput.Get(OVRInput.Button.One, OVRInput.Controller.RTouch);

        if (isPressed && !wasPressedLastFrame)
        {
            ToggleObject();
        }
        wasPressedLastFrame = isPressed;

        bool buttonTwoPressed = OVRInput.Get(OVRInput.Button.Two, OVRInput.Controller.RTouch);
        if (buttonTwoPressed && !wasButtonTwoPressed)
        {
            TogglePlayPause();
        }
        wasButtonTwoPressed = buttonTwoPressed;
    }

    void ToggleObject()
    {
        if (video1 != null && video2 != null)
        {
            video1.SetActive(!video1.activeSelf);
            video2.SetActive(!video2.activeSelf);
        }
    }
    void TogglePlayPause()
    {
        if (videoplayer1 != null && videoplayer2 != null)
        {
            if(videoPlaying)
            {
                if (videoplayer2.isPlaying)
                {
                    videoplayer2.Pause();
                }
                else
                {
                    videoplayer2.Play();
                }
            }
            else
            {
                if (videoplayer1.isPlaying)
                {
                    videoplayer1.Pause();
                }
                else
                {
                    videoplayer1.Play();
                }
            }
        }
    }
}
