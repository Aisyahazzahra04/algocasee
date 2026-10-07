import 'package:flutter/material.dart';

import '../main.dart';
import '../models/case_model.dart';
import 'package:algocasee/logic/logic_checker.dart' as logic_checker;

enum _LogicType {
  input,
  output,
  process,
  decision,
}

class _FlowNode {
  final _LogicType type;
  String text;

  final List<_FlowNode> trueBranch;
  final List<_FlowNode> falseBranch;

  _FlowNode({
    required this.type,
    required this.text,
    List<_FlowNode>? trueBranch,
    List<_FlowNode>? falseBranch,
  })  : trueBranch = trueBranch ?? [],
        falseBranch = falseBranch ?? [];
}

class LogicBuilderScreen extends StatefulWidget {
  final CaseModel caseData;

  const LogicBuilderScreen({
    super.key,
    required this.caseData,
  });

  @override
  State<LogicBuilderScreen> createState() =>
      _LogicBuilderScreenState();
}

class _LogicBuilderScreenState extends State<LogicBuilderScreen> {
  final List<_FlowNode> _nodes = [];

// ============================================================
// CHECK LOGIC
// ============================================================

void _checkLogic() {
  final userLogic = _getUserLogic();

  final result = logic_checker.LogicChecker.check(
  caseData: widget.caseData,
  userLogic: userLogic,
  );

  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          result.isCorrect
              ? 'LOGIKA BENAR'
              : 'LOGIKA BELUM SESUAI',
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: result.messages
              .map((message) => Text(message))
              .toList(),
        ),
      );
    },
  );
}

// ============================================================
// GET USER LOGIC
// ============================================================

List<String> _getUserLogic() {
  final logic = <String>[];

  logic.add('START');

  for (final node in _nodes) {
    switch (node.type) {
      case _LogicType.input:
        logic.add('INPUT ${node.text}');
        break;

      case _LogicType.output:
        logic.add('OUTPUT ${node.text}');
        break;

      case _LogicType.process:
        logic.add('PROCESS ${node.text}');
        break;

      case _LogicType.decision:
        logic.add('DECISION ${node.text}');
        break;
    }
  }

  logic.add('END');

  return logic;

}
  // ============================================================
  // ADD BRANCH NODE
  // ============================================================

  Future<void> _addBranchNode(
    List<_FlowNode> branch,
    _LogicType type,
  ) async {
    final text = await _showNodeDialog(type);

    if (text == null || text.trim().isEmpty) {
      return;
    }

    setState(() {
      branch.add(
        _FlowNode(
          type: type,
          text: text.trim(),
        ),
      );
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final data = widget.caseData.inputOutputRules;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProgress(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  30,
                ),
                child: Column(
                  children: [
                    _buildStepHint(data),

                    const SizedBox(height: 22),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'ALUR LOGIKA',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: navy,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildFlowchart(),

                    const SizedBox(height: 28),

                    _buildBottomButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        0,
      ),
      child: Row(
        children: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 32,
              minHeight: 32,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 19,
            ),
            color: navy,
          ),

          Expanded(
            child: Column(
              children: [
                const Text(
                  'LOGIC BUILDER',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: navy,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  widget.caseData.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: textGrey,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 32),
        ],
      ),
    );
  }


// ============================================================
// PROGRESS
// ============================================================

Widget _buildProgress() {
  return Padding(
    padding: const EdgeInsets.fromLTRB(
      20,
      18,
      20,
      0,
    ),
    child: Row(
      children: [
        const _ProgressNumber(
          number: '1',
          active: true,
        ),

        Expanded(
          child: Container(
            height: 3,
            color: navy,
          ),
        ),

        const _ProgressNumber(
          number: '2',
          active: true,
        ),

        Expanded(
          child: Container(
            height: 3,
            color: navy,
          ),
        ),

        const _ProgressNumber(
          number: '3',
          active: true,
        ),

        Expanded(
          child: Container(
            height: 3,
            color: navy,
          ),
        ),

        const _ProgressNumber(
          number: '4',
          active: true,
        ),

        Expanded(
          child: Container(
            height: 3,
            color: borderGrey,
          ),
        ),

        const _ProgressNumber(
          number: '5',
          active: false,
        ),
      ],
    ),
  );
}
  

  // ============================================================
  // STEP HINT
  // ============================================================

  Widget _buildStepHint(dynamic data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'PETUNJUK DARI TAHAP 3',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: teal,
            ),
          ),

          const SizedBox(height: 10),

          _HintRow(
            label: 'INPUT',
            text: data.inputQuestion,
          ),

          const SizedBox(height: 7),

          _HintRow(
            label: 'OUTPUT',
            text: data.outputQuestion,
          ),

          const SizedBox(height: 7),

          _HintRow(
            label: 'RULES',
            text: data.rulesQuestion,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FLOWCHART
  // ============================================================

  Widget _buildFlowchart() {
    return Column(
      children: [
        const _TerminatorNode(
          text: 'START',
          onTap: null,
        ),

        _Connector(
          onTap: () {
            _showAddMenu(
              onSelected: (type) {
                _addNode(
                  _nodes,
                  type: type,
                );
              },
            );
          },
        ),

        if (_nodes.isEmpty)
          const _EmptyFlowHint()
        else
          _buildMainNodes(),

        // Connector menuju END
        _Connector(
          onTap: () {
            _showAddMenu(
              onSelected: (type) {
                _addNode(
                  _nodes,
                  type: type,
                );
              },
            );
          },
        ),

        const _TerminatorNode(
          text: 'END',
          onTap: null,
        ),
      ],
    );
  }

  // ============================================================
  // MAIN NODES
  // ============================================================

  Widget _buildMainNodes() {
    return ReorderableListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      buildDefaultDragHandles: false,
      itemCount: _nodes.length,

        onReorderItem: (oldIndex, newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }

          final node = _nodes.removeAt(oldIndex);
          _nodes.insert(newIndex, node);
        });
      },

      itemBuilder: (context, index) {
        final node = _nodes[index];

        return Container(
          key: ValueKey(node),
          child: Column(
            children: [
              ReorderableDelayedDragStartListener(
                index: index,
                child: _buildNode(
                  node,
                  onTap: () {
                    _editNode(node);
                  },
                  onDelete: () {
                    setState(() {
                      _nodes.remove(node);
                    });
                  },
                ),
              ),

              // Connector antar blok
              if (index < _nodes.length - 1)
                _Connector(
                  onTap: () {
                    _showAddMenu(
                      onSelected: (type) {
                        _addNode(
                          _nodes,
                          type: type,
                          insertIndex: index + 1,
                        );
                      },
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // NODE
  // ============================================================

  Widget _buildNode(
    _FlowNode node, {
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    switch (node.type) {
      case _LogicType.input:
        return _ParallelogramNode(
          title: 'INPUT',
          text: node.text,
          color: const Color(0xFFDDEAFF),
          onTap: onTap,
          onDelete: onDelete,
        );

      case _LogicType.output:
        return _ParallelogramNode(
          title: 'OUTPUT',
          text: node.text,
          color: const Color(0xFFD8F7D8),
          onTap: onTap,
          onDelete: onDelete,
        );

      case _LogicType.process:
        return _RectangleNode(
          title: 'PROCESS',
          text: node.text,
          color: const Color(0xFFFFF0B8),
          onTap: onTap,
          onDelete: onDelete,
        );

      case _LogicType.decision:
        return _DecisionNode(
          text: node.text,
          trueBranch: node.trueBranch,
          falseBranch: node.falseBranch,
          onTap: onTap,
          onDelete: onDelete,
          onAddBranchNode: _addBranchNode,
          onEditNode: _editNode,
        );
    }
  }

  // ============================================================
  // ADD NODE
  // ============================================================

  Future<void> _addNode(
    List<_FlowNode> target, {
    required _LogicType type,
    int? insertIndex,
  }) async {
    final text = await _showNodeDialog(type);

    if (text == null || text.trim().isEmpty) {
      return;
    }

    final node = _FlowNode(
      type: type,
      text: text.trim(),
    );

    setState(() {
      if (insertIndex == null ||
          insertIndex < 0 ||
          insertIndex > target.length) {
        target.add(node);
      } else {
        target.insert(insertIndex, node);
      }
    });
  }

  // ============================================================
  // EDIT NODE
  // ============================================================

  Future<void> _editNode(
    _FlowNode node,
  ) async {
    final text = await _showNodeDialog(
      node.type,
      initialText: node.text,
    );

    if (text == null || text.trim().isEmpty) {
      return;
    }

    setState(() {
      node.text = text.trim();
    });
  }

  // ============================================================
  // ADD MENU
  // ============================================================

  void _showAddMenu({
    required ValueChanged<_LogicType> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              18,
              20,
              20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'TAMBAH BLOK',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: navy,
                  ),
                ),

                const SizedBox(height: 5),

                const Text(
                  'Pilih jenis langkah yang ingin ditambahkan.',
                  style: TextStyle(
                    fontSize: 11,
                    color: textGrey,
                  ),
                ),

                const SizedBox(height: 16),
                _AddMenuItem(
                  title: 'INPUT',
                  subtitle: 'Menerima data',
                  color: const Color(0xFFDDEAFF),
                  onTap: () {
                    Navigator.pop(context);
                    onSelected(_LogicType.input);
                  },
                ),

                _AddMenuItem(
                  title: 'OUTPUT',
                  subtitle: 'Menampilkan hasil',
                  color: const Color(0xFFD8F7D8),
                  onTap: () {
                    Navigator.pop(context);
                    onSelected(_LogicType.output);
                  },
                ),

                _AddMenuItem(
                  title: 'PROCESS',
                  subtitle: 'Proses atau perhitungan',
                  color: const Color(0xFFFFF0B8),
                  onTap: () {
                    Navigator.pop(context);
                    onSelected(_LogicType.process);
                  },
                ),

                _AddMenuItem(
                  title: 'DECISION',
                  subtitle: 'Percabangan True / False',
                  color: const Color(0xFFF7D5D5),
                  onTap: () {
                    Navigator.pop(context);
                    onSelected(_LogicType.decision);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // NODE INPUT DIALOG
  // ============================================================

Future<String?> _showNodeDialog(
  _LogicType type, {
  String initialText = '',
}) async {
  final controller = TextEditingController(
    text: initialText,
  );

  String title;
  String hint;
  String suggestion;

  switch (type) {
    case _LogicType.input:
      title = 'Tambah INPUT';
      hint = 'Contoh: panjang';
      suggestion =
          'Tuliskan data yang ingin dimasukkan.';
      break;

    case _LogicType.output:
      title = 'Tambah OUTPUT';
      hint = 'Contoh: Luas taman';
      suggestion =
          'Tuliskan informasi yang ingin ditampilkan.';
      break;

    case _LogicType.process:
      title = 'Tambah PROCESS';
      hint = 'Contoh: luas = panjang × lebar';
      suggestion =
          'Tuliskan proses atau perhitungan yang dilakukan.';
      break;

    case _LogicType.decision:
      title = 'Tambah DECISION';
      hint = 'Contoh: panjang > 0';
      suggestion =
          'Tuliskan kondisi yang menentukan cabang True atau False.';
      break;
  }

  final result = await showDialog<String>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: navy,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              suggestion,
              style: const TextStyle(
                fontSize: 11,
                height: 1.4,
                color: textGrey,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: controller,
              autofocus: true,
              maxLines:
                  type == _LogicType.process ||
                          type == _LogicType.decision
                      ? 2
                      : 1,
              textInputAction:
                  type == _LogicType.process ||
                          type == _LogicType.decision
                      ? TextInputAction.newline
                      : TextInputAction.done,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(
                  fontSize: 11,
                  color: textGrey,
                ),
                filled: true,
                fillColor: const Color(0xFFF7F9FC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: borderGrey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: borderGrey,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: navy,
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'BATAL',
              style: TextStyle(
                color: textGrey,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();

              if (value.isEmpty) {
                return;
              }

              Navigator.of(dialogContext).pop(value);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: navy,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text(
              'SIMPAN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      );
    },
  );

  // Beri kesempatan route/dialog menyelesaikan proses
  // sebelum controller dibuang dan parent melakukan rebuild.
  await Future<void>.delayed(
    const Duration(milliseconds: 50),
  );

  controller.dispose();

  return result;
}

  // ============================================================
  // BUTTONS
  // ============================================================

  Widget _buildBottomButtons() {
  return Row(
    children: [
      Expanded(
        child: SizedBox(
          height: 48,
          child: OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: navy,
              side: const BorderSide(
                color: navy,
                width: 1.1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: const Text(
              'BACK',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),

      const SizedBox(width: 10),

      Expanded(
        child: SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _checkLogic,
            style: ElevatedButton.styleFrom(
              backgroundColor: navy,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(11),
              ),
            ),
            child: const Text(
              'SIMPAN',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
}

// ============================================================
// EMPTY FLOW HINT
// ============================================================

class _EmptyFlowHint extends StatelessWidget {
  const _EmptyFlowHint();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 9,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: borderGrey,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'Tekan panah untuk menambahkan blok.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          color: textGrey,
        ),
      ),
    );
  }
}

// ============================================================
// TERMINATOR
// ============================================================

class _TerminatorNode extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const _TerminatorNode({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 118,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: navy,
          borderRadius:
              BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x16000000),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// RECTANGLE NODE
// ============================================================

class _RectangleNode extends StatelessWidget {
  final String title;
  final String text;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _RectangleNode({
    required this.title,
    required this.text,
    required this.color,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 205,
            constraints:
                const BoxConstraints(
              minHeight: 55,
            ),
            padding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: color,
              border: Border.all(
                color: navy,
                width: 1,
              ),
              borderRadius:
                  BorderRadius.circular(2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x10000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 8,
                    fontWeight:
                        FontWeight.w800,
                    color: navy,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  text,
                  textAlign:
                      TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    color: textDark,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),

          _DeleteButton(
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PARALLELOGRAM NODE
// ============================================================

class _ParallelogramNode
    extends StatelessWidget {
  final String title;
  final String text;
  final Color color;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ParallelogramNode({
    required this.title,
    required this.text,
    required this.color,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 220,
        height: 68,
        child: Stack(
          children: [
            ClipPath(
              clipper:
                  _ParallelogramClipper(),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: navy,
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(1),
              child: ClipPath(
                clipper:
                    _ParallelogramClipper(),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: color,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 10,
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style:
                            const TextStyle(
                          fontSize: 8,
                          fontWeight:
                              FontWeight.w800,
                          color: navy,
                          letterSpacing:
                              0.5,
                        ),
                      ),

                      const SizedBox(
                        height: 4,
                      ),

                      Text(
                        text,
                        textAlign:
                            TextAlign.center,
                        style:
                            const TextStyle(
                          fontSize: 10,
                          color: textDark,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            _DeleteButton(
              onTap: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// DECISION NODE
// ============================================================

class _DecisionNode extends StatelessWidget {
  final String text;

  final List<_FlowNode> trueBranch;
  final List<_FlowNode> falseBranch;

  final VoidCallback onTap;
  final VoidCallback onDelete;

  final Future<void> Function(
    List<_FlowNode> branch,
    _LogicType type,
  ) onAddBranchNode;

  final Future<void> Function(
    _FlowNode node,
  ) onEditNode;

  const _DecisionNode({
    required this.text,
    required this.trueBranch,
    required this.falseBranch,
    required this.onTap,
    required this.onDelete,
    required this.onAddBranchNode,
    required this.onEditNode,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Transform.rotate(
                angle: 0.785398,
                child: Container(
                  width: 105,
                  height: 105,
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFFF7D5D5),
                    border: Border.all(
                      color: navy,
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color:
                            Color(0x10000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: 135,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight:
                        FontWeight.w700,
                    color: textDark,
                    height: 1.25,
                  ),
                ),
              ),

              Positioned(
                right: 5,
                top: 4,
                child: _DeleteButton(
                  onTap: onDelete,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        _buildBranches(context),
      ],
    );
  }

  // ============================================================
  // BRANCHES
  // ============================================================

  Widget _buildBranches(
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _BranchColumn(
            label: 'FALSE',
            labelAlignment:
                Alignment.centerLeft,
            nodes: falseBranch,
            onAdd: () {
              _showBranchAddMenu(
                context,
                falseBranch,
              );
            },
            onChanged: () {},
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _BranchColumn(
            label: 'TRUE',
            labelAlignment:
                Alignment.centerRight,
            nodes: trueBranch,
            onAdd: () {
              _showBranchAddMenu(
                context,
                trueBranch,
              );
            },
            onChanged: () {},
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BRANCH ADD MENU
  // ============================================================

  void _showBranchAddMenu(
    BuildContext context,
    List<_FlowNode> branch,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.all(20),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Text(
                  'TAMBAH KE CABANG',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        FontWeight.w800,
                    color: navy,
                  ),
                ),

                const SizedBox(height: 14),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SmallTypeButton(
                      text: 'INPUT',
                      onTap: () {
                        Navigator.pop(
                          context,
                        );

                        onAddBranchNode(
                          branch,
                          _LogicType.input,
                        );
                      },
                    ),

                    _SmallTypeButton(
                      text: 'OUTPUT',
                      onTap: () {
                        Navigator.pop(
                          context,
                        );

                        onAddBranchNode(
                          branch,
                          _LogicType.output,
                        );
                      },
                    ),

                    _SmallTypeButton(
                      text: 'PROCESS',
                      onTap: () {
                        Navigator.pop(
                          context,
                        );

                        onAddBranchNode(
                          branch,
                          _LogicType.process,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ============================================================
// BRANCH COLUMN
// ============================================================

class _BranchColumn
    extends StatelessWidget {
  final String label;
  final Alignment labelAlignment;
  final List<_FlowNode> nodes;
  final VoidCallback onAdd;
  final VoidCallback onChanged;

  const _BranchColumn({
    required this.label,
    required this.labelAlignment,
    required this.nodes,
    required this.onAdd,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: labelAlignment,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              color: navy,
            ),
          ),
        ),

        const SizedBox(height: 5),

        _BranchArrow(
          onTap: onAdd,
        ),

        if (nodes.isEmpty)
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: borderGrey,
                ),
                borderRadius:
                    BorderRadius.circular(6),
              ),
              child: const Text(
                'Tekan panah untuk menambah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8,
                  color: textGrey,
                ),
              ),
            ),
          )
        else
          ...nodes.map(
            (node) => Padding(
              padding:
                  const EdgeInsets.only(
                bottom: 7,
              ),
              child: _buildBranchNode(
                context,
                node,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBranchNode(
    BuildContext context,
    _FlowNode node,
  ) {
    final state =
        context.findAncestorStateOfType<
            _LogicBuilderScreenState>();

    if (state == null) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        state._editNode(node);
      },
      child: _MiniFlowNode(
        node: node,
      ),
    );
  }
}

// ============================================================
// MINI FLOW NODE
// ============================================================

class _MiniFlowNode
    extends StatelessWidget {
  final _FlowNode node;

  const _MiniFlowNode({
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (node.type) {
      case _LogicType.input:
        color = const Color(0xFFDDEAFF);
        break;

      case _LogicType.output:
        color = const Color(0xFFD8F7D8);
        break;

      case _LogicType.process:
        color = const Color(0xFFFFF0B8);
        break;

      default:
        color = Colors.white;
    }

    if (node.type == _LogicType.input ||
        node.type == _LogicType.output) {
      return SizedBox(
        height: 56,
        child: ClipPath(
          clipper:
              _ParallelogramClipper(),
          child: Container(
            color: color,
            alignment: Alignment.center,
            padding:
                const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Text(
              node.text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 8,
                color: textDark,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      constraints:
          const BoxConstraints(
        minHeight: 52,
      ),
      alignment: Alignment.center,
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(
          color: navy,
          width: 0.8,
        ),
      ),
      child: Text(
        node.text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 8,
          color: textDark,
        ),
      ),
    );
  }
}


// ============================================================
// CONNECTOR
// ============================================================

class _Connector extends StatelessWidget {
  final VoidCallback onTap;

  const _Connector({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 42,
        height: 50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 1.4,
              height: 27,
              color: navy,
            ),

            CustomPaint(
              size: const Size(10, 7),
              painter: _ArrowHeadPainter(),
            ),

            const SizedBox(height: 2),

            const Text(
              'tap',
              style: TextStyle(
                fontSize: 7,
                height: 1.0,
                color: textGrey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// BRANCH CONNECTOR
// ============================================================

class _BranchArrow
    extends StatelessWidget {
  final VoidCallback onTap;

  const _BranchArrow({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        height: 34,
        width: 35,
        child: Column(
          children: [
            Container(
              width: 1,
              height: 19,
              color: navy,
            ),

            CustomPaint(
              size: const Size(8, 6),
              painter:
                  _ArrowHeadPainter(),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// ADD MENU ITEM
// ============================================================

class _AddMenuItem
    extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _AddMenuItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
        margin:
            const EdgeInsets.only(
          bottom: 7,
        ),
        padding:
            const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.45),
          border: Border.all(
            color: borderGrey,
          ),
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color,
                border: Border.all(
                  color: navy,
                  width: 0.7,
                ),
                borderRadius:
                    BorderRadius.circular(6),
              ),
              child: Text(
                title.substring(0, 1),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight:
                      FontWeight.w800,
                  color: navy,
                ),
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        const TextStyle(
                      fontSize: 11,
                      fontWeight:
                          FontWeight.w800,
                      color: navy,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style:
                        const TextStyle(
                      fontSize: 9,
                      color: textGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// SMALL TYPE BUTTON
// ============================================================

class _SmallTypeButton
    extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _SmallTypeButton({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(8),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color:
              const Color(0xFFF7F9FC),
          border: Border.all(
            color: borderGrey,
          ),
          borderRadius:
              BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 9,
            fontWeight:
                FontWeight.w800,
            color: navy,
          ),
        ),
      ),
    );
  }
}

// ============================================================
// DELETE BUTTON
// ============================================================

class _DeleteButton
    extends StatelessWidget {
  final VoidCallback onTap;

  const _DeleteButton({
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 7,
      top: 5,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: const SizedBox(
          width: 24,
          height: 24,
          child: Center(
            child: Icon(
              Icons.close_rounded,
              size: 15,
              color: textGrey,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// HINT ROW
// ============================================================

class _HintRow
    extends StatelessWidget {
  final String label;
  final String text;

  const _HintRow({
    required this.label,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 8,
              fontWeight:
                  FontWeight.w800,
              color: navy,
            ),
          ),
        ),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 9,
              height: 1.35,
              color: textGrey,
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// PROGRESS NUMBER
// ============================================================

class _ProgressNumber extends StatelessWidget {
  final String number;
  final bool active;

  const _ProgressNumber({
    required this.number,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: active ? navy : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: active ? navy : borderGrey,
        ),
      ),
      alignment: Alignment.center,
      child: Text(
        number,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: active ? Colors.white : textGrey,
        ),
      ),
    );
  }
}

// ============================================================
// PARALLELOGRAM CLIPPER
// ============================================================

class _ParallelogramClipper
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const slant = 18.0;

    final path = Path();

    path.moveTo(slant, 0);

    path.lineTo(
      size.width,
      0,
    );

    path.lineTo(
      size.width - slant,
      size.height,
    );

    path.lineTo(
      0,
      size.height,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
    CustomClipper<Path> oldClipper,
  ) {
    return false;
  }
}

// ============================================================
// ARROW HEAD
// ============================================================

class _ArrowHeadPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = navy
      ..style = PaintingStyle.fill;

    final path = Path();

    path.moveTo(
      0,
      0,
    );

    path.lineTo(
      size.width,
      0,
    );

    path.lineTo(
      size.width / 2,
      size.height,
    );

    path.close();

    canvas.drawPath(
      path,
      paint,
    );
  }

  @override
  bool shouldRepaint(
    CustomPainter oldDelegate,
  ) {
    return false;
  }
}