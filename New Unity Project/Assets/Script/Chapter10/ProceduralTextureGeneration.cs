using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class ProceduralTextureGeneration : MonoBehaviour
{
    //使用程序纹理的材质
    public Material material = null;
    private Texture2D m_generatedTexture = null;
    //该纹理需要的参数
    #region Material properties
    [SerializeField, SetProperty("textureWidth")]

    private int m_textureWidth = 512;

    public int textureWidth
    {
        get
        {
            return m_textureWidth;
        }

        set
        {
            m_textureWidth = value;
            _UpdateMaterial();
        }
    }

    [SerializeField, SetProperty("backgroundColor")]
    private Color m_backgroundColor = Color.white;
    public Color backgroundColor
    {
        get
        {
            return m_backgroundColor;
        }
        set
        {
            m_backgroundColor = value;
            _UpdateMaterial();
        }
    }

    [SerializeField, SetProperty("circleColor")]
    private Color m_circleColor = Color.yellow;
    public Color circleColor
    {
        get
        {
            return m_circleColor;
        }
        set
        {
            m_circleColor = value;
            _UpdateMaterial();
        }
    }

    [SerializeField, SetProperty("blurFactor")]
    private float m_blurFactor = 2.0f;
    public float blurFactor
    {
        get
        {
            return m_blurFactor;
        }
        set
        {
            m_blurFactor = value;
            _UpdateMaterial();
        }
    }

    #endregion

    private void _UpdateMaterial()
    {
        if (material != null)
        {
            m_generatedTexture = _GenerateProceduralTexture();
            material.SetTexture("_MainTex", m_generatedTexture);
        }
    }

    private Texture2D _GenerateProceduralTexture()
    {
        Texture2D proceduralTexture = new Texture2D(textureWidth, textureWidth);

        //圆间距
        float circleInterval = textureWidth / 4.0f;
        //半径
        float radius = textureWidth / 10.0f;
        //模糊度
        float edgeBlur = 1.0f / blurFactor;

        for (int w = 0; w < textureWidth; w++)
        {
            for (int h = 0; h < textureWidth; h++)
            {
                //使用背景颜色初始化
                Color pixel = backgroundColor;
                //画九个
                for (int j = 0; j < 3; j++)
                {
                    for (int i = 0; i < 3; i++)
                    {
                        //当前圆心位置
                        Vector2 circleCenter = new Vector2(circleInterval * (j + 1), circleInterval * (i + 1));
                        //当前像素与圆心的距离
                        float dist = Vector2.Distance(new Vector2(w, h), circleCenter) - radius;

                        //圆边界模糊
                        Color color = _MixColor(circleColor, new Color(pixel.r, pixel.g, pixel.b, 0.0f), Mathf.SmoothStep(0f, 1.0f, dist * edgeBlur));
                        //颜色混合
                        pixel = _MixColor(pixel, color, color.a);
                    }
                }
                proceduralTexture.SetPixel(w, h, pixel);
            }
        }
        proceduralTexture.Apply();
        return proceduralTexture;
    }

    private Color _MixColor(Color color0, Color color1, float mixFactor)
    {
        Color mixColor = Color.white;
        //rgba四个通道插值
        mixColor.r = Mathf.Lerp(color0.r, color1.r, mixFactor);
        mixColor.g = Mathf.Lerp(color0.g, color1.g, mixFactor);
        mixColor.b = Mathf.Lerp(color0.b, color1.b, mixFactor);
        mixColor.a = Mathf.Lerp(color0.a, color1.a, mixFactor);
        return mixColor;
    }


    // Start is called before the first frame update
    void Start()
    {
        if (material == null)
        {
            Renderer renderer = gameObject.GetComponent<Renderer>();
            if (renderer == null)
            {
                Debug.LogWarning("can not find a renderer!");
                return;
            }
            material = renderer.sharedMaterial;
        }
        _UpdateMaterial();
    }

    // Update is called once per frame
    void Update()
    {

    }
}
