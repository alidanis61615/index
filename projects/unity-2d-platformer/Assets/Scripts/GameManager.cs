using UnityEngine;
using UnityEngine.SceneManagement;

public class GameManager : MonoBehaviour
{
    public static GameManager Instance { get; private set; }

    public int Score { get; private set; }
    public int TotalCoins { get; private set; }
    public bool IsCompleted { get; private set; }

    private GUIStyle scoreStyle;
    private GUIStyle titleStyle;
    private GUIStyle hintStyle;

    private void Awake()
    {
        Instance = this;
        TotalCoins = FindObjectsOfType<Coin>().Length;
    }

    public void RefreshCoinCount()
    {
        TotalCoins = FindObjectsOfType<Coin>().Length;
    }

    public void CollectCoin()
    {
        Score++;
    }

    public void CompleteLevel()
    {
        IsCompleted = true;
    }

    private void Update()
    {
        if (IsCompleted && Input.GetKeyDown(KeyCode.R))
        {
            SceneManager.LoadScene(SceneManager.GetActiveScene().buildIndex);
        }
    }

    private void OnGUI()
    {
        BuildStyles();
        GUI.Label(new Rect(24, 18, 300, 50), $"Yıldız: {Score} / {TotalCoins}", scoreStyle);
        GUI.Label(new Rect(24, Screen.height - 48, 520, 34), "Hareket: A/D veya ←/→   Zıplama: W, ↑ veya Space", hintStyle);

        if (!IsCompleted) return;

        GUI.Box(new Rect(0, 0, Screen.width, Screen.height), GUIContent.none);
        GUI.Label(new Rect(0, Screen.height / 2f - 80, Screen.width, 70), "BÖLÜM TAMAMLANDI!", titleStyle);
        GUI.Label(new Rect(0, Screen.height / 2f, Screen.width, 50), $"Toplanan yıldız: {Score} / {TotalCoins}", scoreStyle);
        GUI.Label(new Rect(0, Screen.height / 2f + 48, Screen.width, 40), "Yeniden başlamak için R tuşuna bas", hintStyle);
    }

    private void BuildStyles()
    {
        if (scoreStyle != null) return;

        scoreStyle = new GUIStyle(GUI.skin.label)
        {
            fontSize = 24,
            fontStyle = FontStyle.Bold,
            alignment = TextAnchor.MiddleLeft
        };
        scoreStyle.normal.textColor = Color.white;
        titleStyle = new GUIStyle(scoreStyle)
        {
            fontSize = 42,
            alignment = TextAnchor.MiddleCenter
        };
        hintStyle = new GUIStyle(scoreStyle)
        {
            fontSize = 16,
            alignment = TextAnchor.MiddleCenter
        };
    }
}

