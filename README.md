# LazyLoadRefreshIndicator

A simple Flutter Widget which provide PullToRefresh and LoadMore functionality based on flutters RefreshIndicator.

## How to use

Add lazy_load_refresh_indicator to your pubspec:

```yaml
depencenies:
    lazy_load_refresh_indicator: # latest version on pub
```

Add the LazyLoadRefreshIndicator to your Widget

```dart
int itemCount = 20;
bool isLoading = false;

Future<void> onRefresh() async => Future.delayed(Duration(seconds: 2),() => setState(()=> itemCount = 20));

void onEndOfPage() async {
    setState(()=> isLoading = true);
    await Future.delayed(Duration(seconds: 2),(){});
    setState((){
        isLoading = false;
        itemCount += 20;
    });
}


Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            title: Text('Some Title'),
        ),
        body: LazyLoadRefreshIndicator(
            child: ListView.builder(
                itemBuilder: (context,index) => ListTile(
                    title: Text('$index'),
                    ),
                itemCount: itemCount,
            ),
            onEndOfPage: onEndOfPage,
            onRefresh: onRefresh,
            scrollOffset: 150,
            isLoading: isLoading,
        ),
    );
}
```
