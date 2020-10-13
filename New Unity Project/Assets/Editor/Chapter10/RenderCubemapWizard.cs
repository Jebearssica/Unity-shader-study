using UnityEngine;
using UnityEditor;
using System.Collections;

public class RenderCubemapWizard : ScriptableWizard
{
    public Transform renderFromPostion;
    public Cubemap cubemap;

    void OnWizardUpdate()
    {
        string helpString = "Select transform to render from and cubemap to render into";
        bool isValid = (renderFromPostion != null) && (cubemap != null);
    }

    void OnWizardCreate()
    {
        GameObject gameObject = new GameObject("cubemapCamera");
        gameObject.AddComponent<Camera>();
        gameObject.transform.position = renderFromPostion.position;
        gameObject.transform.rotation = Quaternion.identity;

        gameObject.GetComponent<Camera>().RenderToCubemap(cubemap);

        DestroyImmediate(gameObject);
    }

    [MenuItem("GameObject/Render into Cubemap")]
    static void RenderCubemap()
    {
        ScriptableWizard.DisplayWizard<RenderCubemapWizard>("Render cubemap","Render!");
    }
}
