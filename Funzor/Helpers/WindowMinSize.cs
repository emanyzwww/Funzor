using System.ComponentModel;
using System.Runtime.InteropServices;
using Microsoft.UI.Xaml;
using Windows.Graphics;
using WinRT.Interop;

namespace Funzor.Helpers;

/// <summary>
/// 通过 WM_GETMINMAXINFO 约束窗口最小尺寸.
/// 当前应用是单窗口; 多窗口时需要把静态状态改成每窗口实例.
/// </summary>
internal static class WindowMinSize
{
	public const int MinWidthDip = 900;
	public const int MinHeightDip = 600;

	private const uint WM_GETMINMAXINFO = 0x0024;
	private const uint DefaultDpi = 96;
	private const nuint SubclassId = 0x465A;

	private static Window? _window;
	private static nint _hwnd;
	private static SubclassProc? _subclassProc;
	private static bool _subclassInstalled;
	private static bool _initialSizeApplied;

	/// <summary>挂接窗口最小尺寸约束. 必须在窗口激活前调用.</summary>
	public static void Attach(Window window)
	{
		if (_window is not null)
		{
			return;
		}

		_window = window;
		_hwnd = WindowNative.GetWindowHandle(window);
		_initialSizeApplied = false;

		if (_hwnd == 0)
		{
			throw new InvalidOperationException("无法获取窗口句柄, 不能设置最小尺寸.");
		}

		SubclassProc subclassProc = WndProc;
		_subclassProc = subclassProc;
		_subclassInstalled = SetWindowSubclass(_hwnd, subclassProc, SubclassId, 0);

		if (!_subclassInstalled)
		{
			throw new Win32Exception(Marshal.GetLastWin32Error(), "挂接 WM_GETMINMAXINFO 失败.");
		}

		window.Activated += (_, _) => ApplyInitialSizeOnce();
		window.Closed += (_, _) => Detach();
	}

	private static void ApplyInitialSizeOnce()
	{
		if (_initialSizeApplied)
		{
			return;
		}

		_initialSizeApplied = true;
		EnsureInitialSize();
	}

	private static void EnsureInitialSize()
	{
		if (_window is null)
		{
			return;
		}

		SizeInt32 size = _window.AppWindow.Size;
		if (size.Width <= 0 || size.Height <= 0)
		{
			return;
		}

		int minWidth = ScaleToPixels(MinWidthDip, _hwnd);
		int minHeight = ScaleToPixels(MinHeightDip, _hwnd);
		if (size.Width >= minWidth && size.Height >= minHeight)
		{
			return;
		}

		_window.AppWindow.Resize(new SizeInt32(
			Math.Max(size.Width, minWidth),
			Math.Max(size.Height, minHeight)));
	}

	private static void Detach()
	{
		SubclassProc? subclassProc = _subclassProc;
		if (_subclassInstalled && subclassProc is not null)
		{
			RemoveWindowSubclass(_hwnd, subclassProc, SubclassId);
		}

		_subclassInstalled = false;
		_subclassProc = null;
		_hwnd = 0;
		_window = null;
	}

	private static nint WndProc(nint hWnd, uint message, nint wParam, nint lParam, nuint subclassId, nint refData)
	{
		nint result = DefSubclassProc(hWnd, message, wParam, lParam);

		// 先让 WinUI 处理, 再覆盖 MinTrackSize, 避免被原有窗口过程改回去.
		if (message == WM_GETMINMAXINFO)
		{
			MINMAXINFO info = Marshal.PtrToStructure<MINMAXINFO>(lParam);
			info.MinTrackSize.X = ScaleToPixels(MinWidthDip, hWnd);
			info.MinTrackSize.Y = ScaleToPixels(MinHeightDip, hWnd);
			Marshal.StructureToPtr(info, lParam, false);
		}

		return result;
	}

	private static int ScaleToPixels(int dip, nint hWnd)
	{
		uint dpi = GetDpiForWindow(hWnd);
		if (dpi == 0)
		{
			dpi = DefaultDpi;
		}

		return (int)Math.Ceiling(dip * dpi / 96.0);
	}

	[StructLayout(LayoutKind.Sequential)]
	private struct POINT
	{
		public int X;
		public int Y;
	}

	[StructLayout(LayoutKind.Sequential)]
	private struct MINMAXINFO
	{
		public POINT Reserved;
		public POINT MaxSize;
		public POINT MaxPosition;
		public POINT MinTrackSize;
		public POINT MaxTrackSize;
	}

	[UnmanagedFunctionPointer(CallingConvention.Winapi)]
	private delegate nint SubclassProc(nint hWnd, uint message, nint wParam, nint lParam, nuint subclassId, nint refData);

	[DllImport("comctl32.dll", SetLastError = true)]
	[return: MarshalAs(UnmanagedType.Bool)]
	private static extern bool SetWindowSubclass(nint hWnd, SubclassProc subclassProc, nuint subclassId, nint refData);

	[DllImport("comctl32.dll", SetLastError = true)]
	[return: MarshalAs(UnmanagedType.Bool)]
	private static extern bool RemoveWindowSubclass(nint hWnd, SubclassProc subclassProc, nuint subclassId);

	[DllImport("comctl32.dll")]
	private static extern nint DefSubclassProc(nint hWnd, uint message, nint wParam, nint lParam);

	[DllImport("user32.dll")]
	private static extern uint GetDpiForWindow(nint hWnd);
}
