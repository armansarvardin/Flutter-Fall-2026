import 'package:flutter/material.dart';

class TwoWayCounter extends StatefulWidget {
  const TwoWayCounter({super.key});

  @override
  State<TwoWayCounter> createState() => _TwoWayCounterState();
}

class _TwoWayCounterState extends State<TwoWayCounter> {
  int _count = 0;
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    // Waiting is work, not a change of state, so it stays outside setState.
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _saving = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              // A null handler greys the button out; no check in the callback.
              onPressed: _count == 0 ? null : () => setState(() => _count--),
              child: const Icon(Icons.remove),
            ),
            SizedBox(
              width: 72,
              child: Text(
                '$_count',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
            FilledButton(
              onPressed: () => setState(() => _count++),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        // Fixed width so the button does not shrink when the spinner appears.
        SizedBox(
          width: 120,
          child: FilledButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ),
      ],
    );
  }
}
