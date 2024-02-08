part of '../form_shared.dart';

class ResultData extends StatefulWidget {
  final SharedPreferencesImpl sharedPreferencesImpl;
  const ResultData(
    this.sharedPreferencesImpl, {
    super.key,
  });

  @override
  State<ResultData> createState() => _ResultDataState();
}

class _ResultDataState extends State<ResultData> {
  String mapEntriesToString(Map<String, dynamic> map) {
    return map.entries.map((entry) => '${entry.key}: ${entry.value}\n').join();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.sharedPreferencesImpl.readValues != null
        ? Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: AppRadius.medium,
              color: AppColors.coal,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Result: ', style: TextStyle(fontSize: 20)),
                Text(
                  mapEntriesToString(widget.sharedPreferencesImpl.readValues!),
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
