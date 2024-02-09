part of '../form_shared.dart';

class ResultData extends StatelessWidget {
  final SharedPreferencesImpl sharedPreferencesImpl;
  const ResultData(
    this.sharedPreferencesImpl, {
    super.key,
  });

  String mapEntriesToString(Map<String, dynamic> map) {
    return map.entries.map((entry) => '${entry.key}: ${entry.value}\n').join();
  }

  @override
  Widget build(BuildContext context) {
    sharedPreferencesImpl.readValues;
    print(sharedPreferencesImpl.readValues);
    return sharedPreferencesImpl.readValues != null
        ? Container(
            height: 100,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: AppRadius.medium,
              color: AppColors.green,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Current Result: ', style: TextStyle(fontSize: 18)),
                Text(
                  mapEntriesToString(sharedPreferencesImpl.readValues!),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              ],
            ),
          )
        : const SizedBox.shrink();
  }
}
