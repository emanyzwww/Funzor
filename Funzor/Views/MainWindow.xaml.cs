using Funzor.Helpers;
using Funzor.Navigation;
using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Media.Animation;

namespace Funzor.Views
{
	public sealed partial class MainWindow : Window
	{
		private IReadOnlyList<NavSection> _sections = [];
		private NavSection? _currentSection;
		private NavEntry? _currentEntry;

		public MainWindow()
		{
			InitializeComponent();

			ConfigureWindowChrome();
			WindowMinSize.Attach(this);
			TitleBar.Attach(AppWindow.Id);
			TitleBar.MinimizeRequested += TitleBar_MinimizeRequested;
			TitleBar.CloseRequested += TitleBar_CloseRequested;
			AppWindow.Changed += AppWindow_Changed;

			// App.OnLaunched 已先完成本地化初始化, 这里可以安全读取文案
			_sections = NavigationCatalog.Build();
			Rail.SetSections(_sections);

			ActivateSection(_sections[0]);
		}

		private void ConfigureWindowChrome()
		{
			// 让 XAML 内容覆盖整个窗口, 然后在 presenter 层移除系统标题栏和 caption buttons.
			ExtendsContentIntoTitleBar = true;

			if (AppWindow.Presenter is not OverlappedPresenter presenter)
			{
				return;
			}

			presenter.SetBorderAndTitleBar(true, false);
			presenter.IsMinimizable = true;
			presenter.IsMaximizable = false;
			presenter.IsResizable = true;
		}

		private void AppWindow_Changed(AppWindow sender, AppWindowChangedEventArgs args)
		{
			// 兜底: 某些系统手势仍可能尝试最大化; 本应用不提供最大化/全屏.
			if (args.DidSizeChange &&
			    sender.Presenter is OverlappedPresenter presenter &&
			    presenter.State == OverlappedPresenterState.Maximized)
			{
				presenter.Restore();
			}
		}

		private void TitleBar_MinimizeRequested(object? sender, EventArgs e)
		{
			if (AppWindow.Presenter is OverlappedPresenter presenter)
			{
				presenter.Minimize();
			}
		}

		private void TitleBar_CloseRequested(object? sender, EventArgs e)
			=> Close();

		private void Rail_SectionSelected(object? sender, NavSection section)
			=> ActivateSection(section);

		private void Panel_EntrySelected(object? sender, NavEntry entry)
			=> ActivateEntry(entry);

		private void ActivateSection(NavSection section)
		{
			if (_currentSection?.Id == section.Id)
			{
				return;
			}

			_currentSection = section;
			Rail.SelectSection(section.Id);
			Panel.SetEntries(section.Title, section.Entries);

			NavEntry? first = section.Entries.FirstOrDefault();
			if (first is null)
			{
				_currentEntry = null;
				ContentFrame.Content = null;
				return;
			}

			ActivateEntry(first);
		}

		private void ActivateEntry(NavEntry entry)
		{
			if (_currentEntry?.Id == entry.Id &&
			    ContentFrame.CurrentSourcePageType == entry.PageType)
			{
				return;
			}

			_currentEntry = entry;
			Panel.SelectEntry(entry.Id);

			ContentFrame.Navigate(
				entry.PageType,
				entry.Parameter,
				new SuppressNavigationTransitionInfo());

			// 一级/二级切换不构成"返回"语义
			ContentFrame.BackStack.Clear();
		}
	}
}
