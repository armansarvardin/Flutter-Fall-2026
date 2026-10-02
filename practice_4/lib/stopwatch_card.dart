import 'dart:async';

import 'package:flutter/material.dart';

class StopwatchCard extends StatefulWidget {
  const StopwatchCard({super.key});

  @override
  State<StopwatchCard> createState() => _StopwatchCardState();
}

class _StopwatchCardState extends State<StopwatchCard> {
  int _seconds = 0;
  Timer? _timer;

  bool get _running => _timer != null;

  // Computed from _seconds on every build: a value you can compute is not state.
  String get _time {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _start() {
    if (_running) return; // never create a second timer
    setState(() {
      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() => _seconds++),
      );
    });
  }

  void _stop() {
    _timer?.cancel();
    setState(() => _timer = null);
  }

  void _reset() {
    _stop();
    setState(() => _seconds = 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose(); // last: the mirror image of super.initState() first
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Text(
                _time,
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  // Equal-width digits, so the time does not jitter as it ticks.
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FilledButton(
                    onPressed: _running ? null : _start,
                    child: const Text('Start'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed: _running ? _stop : null,
                    child: const Text('Stop'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(onPressed: _reset, child: const Text('Reset')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
