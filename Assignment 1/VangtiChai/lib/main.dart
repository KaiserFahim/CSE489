import 'package:flutter/material.dart';

void main() {
  runApp(const VangtiChaiApp());
}

class VangtiChaiApp extends StatelessWidget {
  const VangtiChaiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VangtiChai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF00897B),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF00897B),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),
      home: const VangtiChaiScreen(),
    );
  }
}

const List<int> kNoteValues = [500, 100, 50, 20, 10, 5, 2, 1];

const int kMaxDigits = 9;

class VangtiChaiScreen extends StatefulWidget {
  const VangtiChaiScreen({super.key});

  @override
  State<VangtiChaiScreen> createState() => _VangtiChaiScreenState();
}

class _VangtiChaiScreenState extends State<VangtiChaiScreen> {
  String _amount = '';
  Map<int, int> _denominations = {for (final v in kNoteValues) v: 0};

  void _recalculate() {
    int remaining = int.tryParse(_amount) ?? 0;
    final next = <int, int>{};
    for (final note in kNoteValues) {
      next[note] = remaining ~/ note;
      remaining %= note;
    }
    _denominations = next;
  }

  void _onDigitPressed(String digit) {
    setState(() {
      if (_amount == '0') {
        _amount = digit;
      } else if (_amount.length < kMaxDigits) {
        _amount += digit;
      }
      _recalculate();
    });
  }

  void _onClear() {
    setState(() {
      _amount = '';
      _denominations = {for (final v in kNoteValues) v: 0};
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(title: const Text('VangtiChai')),
      body: SafeArea(
        child: Column(
          children: [
            _AmountHeader(amount: _amount),
            const Divider(height: 1),
            Expanded(
              child: isLandscape ? _buildLandscapeBody() : _buildPortraitBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitBody() {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 280),
              child: DenominationTable(
                denominations: _denominations,
                columns: 1,
              ),
            ),
          ),
        ),
        const Divider(height: 1),
        Expanded(
          flex: 5,
          child: NumberPad(
            rows: const [
              ['1', '2', '3'],
              ['4', '5', '6'],
              ['7', '8', '9'],
              ['0', 'CLEAR'],
            ],
            onDigit: _onDigitPressed,
            onClear: _onClear,
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeBody() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 4,
          child: DenominationTable(
            denominations: _denominations,
            columns: 2,
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          flex: 5,
          child: NumberPad(
            rows: const [
              ['1', '2', '3', '4'],
              ['5', '6', '7', '8'],
              ['9', '0', 'CLEAR'],
            ],
            onDigit: _onDigitPressed,
            onClear: _onClear,
          ),
        ),
      ],
    );
  }
}

class _AmountHeader extends StatelessWidget {
  final String amount;
  const _AmountHeader({required this.amount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
      child: Center(
        child: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text: 'Taka: ',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              TextSpan(
                text: amount,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          style: const TextStyle(fontSize: 26),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class DenominationTable extends StatelessWidget {
  final Map<int, int> denominations;
  final int columns;

  const DenominationTable({
    super.key,
    required this.denominations,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    final entries = denominations.entries.toList();
    final theme = Theme.of(context);

    Widget rowFor(MapEntry<int, int> e) {
      final active = e.value > 0;
      final color = active ? theme.colorScheme.primary : Colors.black54;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${e.key}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: active ? FontWeight.bold : FontWeight.normal,
                color: color,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: active
                    ? theme.colorScheme.primary.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${e.value}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (columns <= 1) {
      return ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: entries.map(rowFor).toList(),
      );
    }

    final perColumn = (entries.length / columns).ceil();
    final groups = <List<MapEntry<int, int>>>[];
    for (var i = 0; i < entries.length; i += perColumn) {
      groups.add(entries.sublist(i, (i + perColumn).clamp(0, entries.length)));
    }

    return Row(
      children: groups
          .map(
            (group) => Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: group.map(rowFor).toList(),
          ),
        ),
      )
          .toList(),
    );
  }
}

class NumberPad extends StatelessWidget {
  final List<List<String>> rows;
  final ValueChanged<String> onDigit;
  final VoidCallback onClear;

  const NumberPad({
    super.key,
    required this.rows,
    required this.onDigit,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns =
        rows.map((r) => r.length).reduce((a, b) => a > b ? a : b);
        const spacing = 8.0;

        final maxButtonWidth =
            (constraints.maxWidth - spacing * (columns + 1)) / columns;
        final maxButtonHeight =
            (constraints.maxHeight - spacing * (rows.length + 1)) /
                rows.length;
        final buttonSize =
        (maxButtonWidth < maxButtonHeight ? maxButtonWidth : maxButtonHeight)
            .clamp(32.0, 200.0);
        final fontSize = (buttonSize * 0.32).clamp(14.0, 32.0);

        return Padding(
          padding: const EdgeInsets.all(spacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rows.map((row) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: spacing / 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: row.map((key) {
                    final isClear = key == 'CLEAR';
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                      child: SizedBox(
                        width: isClear ? buttonSize * 1.3 : buttonSize,
                        height: buttonSize * 0.85,
                        child: ElevatedButton(
                          onPressed: () => isClear ? onClear() : onDigit(key),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            isClear ? Colors.red.shade100 : null,
                            foregroundColor:
                            isClear ? Colors.red.shade900 : null,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            key,
                            style: TextStyle(
                              fontSize: isClear ? fontSize * 0.6 : fontSize,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}