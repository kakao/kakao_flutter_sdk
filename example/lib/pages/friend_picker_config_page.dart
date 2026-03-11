import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_friend.dart';

class PickerConfigPage extends StatefulWidget {
  const PickerConfigPage({super.key});

  @override
  State<PickerConfigPage> createState() => _PickerConfigPageState();
}

enum _CallState { idle, loading, success, failure }

class _PickerConfigPageState extends State<PickerConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: '친구 선택');
  final _maxPickableCountController = TextEditingController(text: '30');
  final _minPickableCountController = TextEditingController(text: '1');
  final _returnUrlController = TextEditingController();
  final _scrollController = ScrollController();

  bool _enableSearch = true;
  bool _showMyProfile = true;
  bool _showFavorite = true;
  bool _showPickedFriend = true;
  bool _enableBackButton = true;
  bool _enableMulti = true;

  _CallState _callState = _CallState.idle;
  String _resultText = '아직 호출 결과가 없습니다.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PickerClient')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildTextField(
                          label: 'title',
                          controller: _titleController,
                        ),
                        _buildSwitchTile(
                          title: 'enableMulti',
                          value: _enableMulti,
                          onChanged: (value) =>
                              setState(() => _enableMulti = value),
                        ),
                        _buildSwitchTile(
                          title: 'enableSearch',
                          value: _enableSearch,
                          onChanged: (value) =>
                              setState(() => _enableSearch = value),
                        ),
                        _buildSwitchTile(
                          title: 'showMyProfile',
                          value: _showMyProfile,
                          onChanged: (value) =>
                              setState(() => _showMyProfile = value),
                        ),
                        _buildSwitchTile(
                          title: 'showFavorite',
                          value: _showFavorite,
                          onChanged: (value) =>
                              setState(() => _showFavorite = value),
                        ),
                        _buildSwitchTile(
                          title: 'showPickedFriend',
                          value: _showPickedFriend,
                          onChanged: (value) =>
                              setState(() => _showPickedFriend = value),
                        ),
                        _buildNumberField(
                          label: 'maxPickableCount',
                          controller: _maxPickableCountController,
                        ),
                        _buildNumberField(
                          label: 'minPickableCount',
                          controller: _minPickableCountController,
                        ),
                        _buildSwitchTile(
                          title: 'enableBackButton',
                          value: _enableBackButton,
                          onChanged: (value) =>
                              setState(() => _enableBackButton = value),
                        ),
                        _buildTextField(
                          label: 'returnUrl (웹 전용, optional)',
                          controller: _returnUrlController,
                        ),
                        const SizedBox(height: 16),
                        _buildResultCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _callSelectFriend,
                  child: Text('Picker 호출'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _maxPickableCountController.dispose();
    _minPickableCountController.dispose();
    _returnUrlController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label 값을 입력해주세요.';
          }
          if (int.tryParse(value.trim()) == null) {
            return '$label 는 숫자여야 합니다.';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      value: value,
      onChanged: onChanged,
    );
  }

  Widget _buildResultCard() {
    Color borderColor;
    switch (_callState) {
      case _CallState.success:
        borderColor = Colors.green;
        break;
      case _CallState.failure:
        borderColor = Colors.red;
        break;
      case _CallState.idle:
      case _CallState.loading:
        borderColor = Colors.grey;
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: SelectableText(_resultText),
    );
  }

  PickerFriendRequestParams _buildRequestParams() {
    return PickerFriendRequestParams(
      title: _trimmedOrNull(_titleController.text),
      enableSearch: _enableSearch,
      showMyProfile: _showMyProfile,
      showFavorite: _showFavorite,
      showPickedFriend: _showPickedFriend,
      maxPickableCount: int.parse(_maxPickableCountController.text.trim()),
      minPickableCount: int.parse(_minPickableCountController.text.trim()),
      returnUrl: _trimmedOrNull(_returnUrlController.text),
      enableBackButton: _enableBackButton,
    );
  }

  Future<void> _callSelectFriend() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final params = _buildRequestParams();

    setState(() {
      _callState = _CallState.loading;
      _resultText = '호출 중...';
    });

    try {
      final users = await PickerApi.instance.selectFriend(
        context: context,
        params: params,
        enableMulti: _enableMulti,
      );

      if (!mounted) {
        return;
      }

      final json = const JsonEncoder.withIndent('  ').convert(users.toJson());
      setState(() {
        _callState = _CallState.success;
        _resultText = '성공\n$json';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _callState = _CallState.failure;
        _resultText = '실패\n$error';
      });
    }
  }

  String? _trimmedOrNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
