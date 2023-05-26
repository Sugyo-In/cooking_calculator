import 'package:cooking_calulator/model/enum/amount_unit.dart';
import 'package:cooking_calulator/widget/widget.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class AddIngredientPage extends ConsumerStatefulWidget {
  static const routeName = 'addRecipeIngredient';

  const AddIngredientPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddIngredientPageState();
}

class _AddIngredientPageState extends ConsumerState<AddIngredientPage> {
  final _nameController = TextEditingController();
  List<String> _relevantNames = [];
  AmountUnit? _unit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('재료 추가'),
        actions: [
          IconButton(
            onPressed: _onSaveButtonPressed,
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: '재료명',
            ),
            onChanged: _onIngredientNameTextfieldChanged,
          ),
          if (_relevantNames.isNotEmpty)
            Column(
              children: _relevantNames
                  .map((name) => ListTile(
                        onTap: () => setState(() {
                          _nameController.text = name;
                          _relevantNames.clear();
                        }),
                        title: Text(name),
                      ))
                  .toList(),
            ),
          if (_nameController.text.isNotEmpty && _relevantNames.isEmpty)
            Row(
              children: [
                Expanded(
                  child: IntegerInput(
                    decoration: InputDecoration(
                      hintText: '용량',
                    ),
                    onChanged: (text) => setState(() {
                      if (text.isEmpty) {
                        _relevantNames.clear();
                        return;
                      }
                    }),
                  ),
                ),
                SizedBox(width: 8.0),
                DropdownButton<AmountUnit>(
                  onChanged: (value) {
                    setState(() => _unit = value);
                  },
                  value: _unit,
                  items: [
                    ...MassUnit.values.map(
                      (unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit.symbol),
                      ),
                    ),
                    ...VolumeUnit.values.map(
                      (unit) => DropdownMenuItem(
                        value: unit,
                        child: Text(unit.symbol),
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _onSaveButtonPressed() async {
    final dataPath = await getApplicationDocumentsDirectory();
    final datasource = ref.read(isarRecipeDatasourceProvider(dataPath.path));
    await ref
        .read(cachedIngredientRepositoryProvider(datasource).notifier)
        .addIngredient(const Ingredient(name: 'name'));
  }

  void _onIngredientNameTextfieldChanged(String text) {
    if (text.isEmpty) {
      setState(_relevantNames.clear);
      return;
    }

    ref.read(cachedIngredientRepositoryProvider.notifier).addIngredient(
          const Ingredient(name: 'name'),
        );
  }
}
