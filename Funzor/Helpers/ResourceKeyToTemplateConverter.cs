using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Data;

namespace Funzor.Helpers;

/// <summary>
/// 把 Icons.xaml 里的资源 key 解析成 ControlTemplate. 导航模型只保存 key, 不持有 UI 对象.
/// </summary>
public sealed class ResourceKeyToTemplateConverter : IValueConverter
{
	public object? Convert(object value, Type targetType, object parameter, string language)
	{
		if (value is not string key)
		{
			return null;
		}

		object? resource = FindResource(Application.Current.Resources, key);
		return resource is ControlTemplate template ? template : null;
	}

	public object ConvertBack(object value, Type targetType, object parameter, string language)
	{
		throw new NotSupportedException();
	}

	private static object? FindResource(ResourceDictionary dictionary, string key)
	{
		if (dictionary.ContainsKey(key))
		{
			return dictionary[key];
		}

		foreach (ResourceDictionary merged in dictionary.MergedDictionaries)
		{
			object? found = FindResource(merged, key);
			if (found is not null)
			{
				return found;
			}
		}

		return null;
	}
}
