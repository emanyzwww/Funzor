using Funzor.Navigation;
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

			// App.OnLaunched 已先完成本地化初始化, 这里可以安全读取文案
			_sections = NavigationCatalog.Build();
			Rail.SetSections(_sections);

			ActivateSection(_sections[0]);
		}

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
