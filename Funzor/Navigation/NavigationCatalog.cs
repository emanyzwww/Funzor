using Funzor.Views.Pages;
using WinUI3Localizer;

namespace Funzor.Navigation;

public sealed record NavSection(
	string Id,
	string Title,
	string IconKey,
	IReadOnlyList<NavEntry> Entries);

public sealed record NavEntry(
	string Id,
	string Title,
	Type PageType,
	object? Parameter = null);

internal static class NavigationCatalog
{
	public static NavSection[] Build()
	{
		ILocalizer localizer = Localizer.Get();

		return
		[
			BuildSettingsSection(localizer)
		];
	}

	private static NavSection BuildSettingsSection(ILocalizer localizer)
	{
		string settingsTitle = GetText(localizer, "Nav.Settings", "设置");
		string updateTitle = GetText(localizer, "Nav.Settings.Update", "更新");

		return new NavSection(
			"settings",
			settingsTitle,
			"Icon.Settings",
			new NavEntry[]
			{
				new(
					"settings.update",
					updateTitle,
					typeof(PlaceholderPage),
					updateTitle)
			});
	}

	/// <summary>
	/// resw 读取失败时退回内置文案, 避免导航栏和页面标题整块空白.
	/// </summary>
	private static string GetText(ILocalizer localizer, string key, string fallback)
	{
		string text = localizer.GetLocalizedString(key);
		return string.IsNullOrWhiteSpace(text) ? fallback : text;
	}
}
