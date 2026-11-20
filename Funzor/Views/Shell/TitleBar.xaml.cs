using Microsoft.UI;
using Microsoft.UI.Input;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Automation;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using Windows.Foundation;
using Windows.Graphics;
using WinUI3Localizer;

namespace Funzor.Views.Shell;

public sealed partial class TitleBar : UserControl
{
	private InputNonClientPointerSource? _inputSource;
	private bool _xamlRootHooked;

	public event EventHandler? MinimizeRequested;
	public event EventHandler? CloseRequested;

	public TitleBar()
	{
		InitializeComponent();
		Loaded += TitleBar_Loaded;
		SizeChanged += TitleBar_SizeChanged;
		LocalizeButtons();
	}

	/// <summary>挂接窗口的非客户区输入区域; 由 MainWindow 在设置 presenter 之后调用.</summary>
	public void Attach(WindowId windowId)
	{
		_inputSource = InputNonClientPointerSource.GetForWindowId(windowId);

		if (IsLoaded)
		{
			UpdateRegions();
		}
	}

	private void TitleBar_Loaded(object sender, RoutedEventArgs e)
	{
		if (!_xamlRootHooked && XamlRoot is not null)
		{
			XamlRoot.Changed += XamlRoot_Changed;
			_xamlRootHooked = true;
		}

		UpdateRegions();
	}

	private void TitleBar_SizeChanged(object sender, SizeChangedEventArgs e)
		=> UpdateRegions();

	private void XamlRoot_Changed(XamlRoot sender, XamlRootChangedEventArgs args)
		=> UpdateRegions();

	private void UpdateRegions()
	{
		if (_inputSource is null || XamlRoot is null)
		{
			return;
		}

		if (Root.ActualWidth <= 0 || Root.ActualHeight <= 0)
		{
			return;
		}

		double scale = XamlRoot.RasterizationScale;
		Rect captionBounds = GetBounds(Root);
		RectInt32 caption = ToPixelRect(captionBounds, scale);

		var passthrough = new List<RectInt32>(2);
		AddButtonRect(passthrough, MinimizeButton, scale);
		AddButtonRect(passthrough, CloseButton, scale);

		_inputSource.ClearRegionRects(NonClientRegionKind.Caption);
		_inputSource.ClearRegionRects(NonClientRegionKind.Passthrough);
		_inputSource.SetRegionRects(NonClientRegionKind.Caption, new[] { caption });

		if (passthrough.Count > 0)
		{
			_inputSource.SetRegionRects(NonClientRegionKind.Passthrough, passthrough.ToArray());
		}
	}

	private static void AddButtonRect(List<RectInt32> rects, FrameworkElement element, double scale)
	{
		if (element.ActualWidth <= 0 || element.ActualHeight <= 0)
		{
			return;
		}

		rects.Add(ToPixelRect(GetBounds(element), scale));
	}

	private static Rect GetBounds(FrameworkElement element)
	{
		GeneralTransform transform = element.TransformToVisual(null);
		return transform.TransformBounds(new Rect(0, 0, element.ActualWidth, element.ActualHeight));
	}

	private static RectInt32 ToPixelRect(Rect bounds, double scale)
	{
		return new RectInt32(
			(int)Math.Round(bounds.X * scale),
			(int)Math.Round(bounds.Y * scale),
			(int)Math.Round(bounds.Width * scale),
			(int)Math.Round(bounds.Height * scale));
	}

	private void MinimizeButton_Click(object sender, RoutedEventArgs e)
		=> MinimizeRequested?.Invoke(this, EventArgs.Empty);

	private void CloseButton_Click(object sender, RoutedEventArgs e)
		=> CloseRequested?.Invoke(this, EventArgs.Empty);

	private void LocalizeButtons()
	{
		string minimize = GetText("TitleBar.Minimize", "最小化");
		string close = GetText("TitleBar.Close", "关闭");

		AutomationProperties.SetName(MinimizeButton, minimize);
		AutomationProperties.SetName(CloseButton, close);
		ToolTipService.SetToolTip(MinimizeButton, minimize);
		ToolTipService.SetToolTip(CloseButton, close);
	}

	private static string GetText(string key, string fallback)
	{
		string text = Localizer.Get().GetLocalizedString(key);
		return string.IsNullOrWhiteSpace(text) ? fallback : text;
	}
}
