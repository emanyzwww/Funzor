using Funzor.Navigation;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;

namespace Funzor.Views.Shell;

public sealed partial class NavigationRail : UserControl
{
	private IReadOnlyList<NavSection> _sections = [];
	private bool _suppressSelectionChanged;

	public event EventHandler<NavSection>? SectionSelected;

	public NavigationRail()
	{
		InitializeComponent();
	}

	public void SetSections(IReadOnlyList<NavSection> sections)
	{
		_sections = sections;
		SectionList.ItemsSource = sections;
		UpdateIconForegrounds();
	}

	/// <summary>程序化选中, 不触发 SectionSelected. </summary>
	public void SelectSection(string sectionId)
	{
		_suppressSelectionChanged = true;
		try
		{
			SectionList.SelectedItem = _sections.FirstOrDefault(section => section.Id == sectionId);
			UpdateIconForegrounds();
		}
		finally
		{
			_suppressSelectionChanged = false;
		}
	}

	private void SectionList_SelectionChanged(object sender, SelectionChangedEventArgs e)
	{
		UpdateIconForegrounds();

		if (_suppressSelectionChanged)
		{
			return;
		}

		if (SectionList.SelectedItem is NavSection section)
		{
			SectionSelected?.Invoke(this, section);
		}
	}

	private void SectionList_ContainerContentChanging(ListViewBase sender, ContainerContentChangingEventArgs args)
	{
		if (args.ItemContainer is ListViewItem container)
		{
			SetIconForeground(container);
		}
	}

	private void UpdateIconForegrounds()
	{
		foreach (object item in SectionList.Items)
		{
			if (SectionList.ContainerFromItem(item) is ListViewItem container)
			{
				SetIconForeground(container);
			}
		}
	}

	private static void SetIconForeground(ListViewItem container)
	{
		if (container.ContentTemplateRoot is not DependencyObject root)
		{
			return;
		}

		ContentControl? icon = FindDescendant<ContentControl>(root, "NavIcon");
		if (icon is null)
		{
			return;
		}

		string key = container.IsSelected
			? "PrimaryNav.Item.Foreground.Selected"
			: "PrimaryNav.Item.Foreground";

		if (Application.Current.Resources.ContainsKey(key))
		{
			icon.Foreground = (Brush)Application.Current.Resources[key];
		}
	}

	private static T? FindDescendant<T>(DependencyObject root, string name)
		where T : FrameworkElement
	{
		if (root is T element && element.Name == name)
		{
			return element;
		}

		int count = VisualTreeHelper.GetChildrenCount(root);
		for (int i = 0; i < count; i++)
		{
			T? found = FindDescendant<T>(VisualTreeHelper.GetChild(root, i), name);
			if (found is not null)
			{
				return found;
			}
		}

		return null;
	}
}
