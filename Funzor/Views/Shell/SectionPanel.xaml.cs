using Funzor.Navigation;
using Microsoft.UI.Xaml.Controls;

namespace Funzor.Views.Shell;

public sealed partial class SectionPanel : UserControl
{
	private IReadOnlyList<NavEntry> _entries = [];
	private bool _suppressSelectionChanged;

	public event EventHandler<NavEntry>? EntrySelected;

	public SectionPanel()
	{
		InitializeComponent();
	}

	public void SetEntries(string title, IReadOnlyList<NavEntry> entries)
	{
		PanelTitle.Text = title;
		_entries = entries;
		EntryList.ItemsSource = entries;
	}

	/// <summary>程序化选中, 不触发 EntrySelected. </summary>
	public void SelectEntry(string entryId)
	{
		_suppressSelectionChanged = true;
		try
		{
			EntryList.SelectedItem = _entries.FirstOrDefault(entry => entry.Id == entryId);
		}
		finally
		{
			_suppressSelectionChanged = false;
		}
	}

	private void EntryList_SelectionChanged(object sender, SelectionChangedEventArgs e)
	{
		if (_suppressSelectionChanged)
		{
			return;
		}

		if (EntryList.SelectedItem is NavEntry entry)
		{
			EntrySelected?.Invoke(this, entry);
		}
	}
}
