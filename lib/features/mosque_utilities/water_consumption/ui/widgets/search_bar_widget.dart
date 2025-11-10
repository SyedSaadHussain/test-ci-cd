import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mosque_management_system/core/utils/app_icons.dart';

import '../../../../../core/constants/app_colors.dart';

enum SearchType { meterNumber, serialNumber, mosqueName }

class SearchBarWidget extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<SearchType>? onSearchTypeChanged;
  final VoidCallback? onClear;
  final VoidCallback? onSubmitted;
  final TextEditingController? controller;
  final bool enabled;
  final bool autofocus;
  final SearchType searchType;

  const SearchBarWidget({
    super.key,
    this.hintText = 'Search mosques...',
    this.onChanged,
    this.onSearchTypeChanged,
    this.onClear,
    this.onSubmitted,
    this.controller,
    this.enabled = true,
    this.autofocus = false,
    this.searchType = SearchType.mosqueName,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isFocused = false;
  bool _hasText = false;
  late SearchType _searchType;

  String get _hintText {
    switch (_searchType) {
      case SearchType.meterNumber:
        return 'enter_meter_number'.tr();
      case SearchType.serialNumber:
        return 'enter_mosque_serial_number'.tr();
      case SearchType.mosqueName:
        return 'enter_mosque_name'.tr();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = FocusNode();
    _searchType = widget.searchType;

    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.isNotEmpty;
      });
    });

    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    super.dispose();
  }

  void _unfocus() {
    _focusNode.unfocus();
  }

  Widget _buildSearchTypeIcon(SearchType type) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: type == _searchType
            ? AppColors.primaryContainer.withOpacity(0.1)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        _getSearchTypeIcon(type),
        size: 18,
        color: type == _searchType
            ? AppColors.primaryContainer
            : Colors.grey.shade600,
      ),
    );
  }

  IconData _getSearchTypeIcon(SearchType type) {
    switch (type) {
      case SearchType.meterNumber:
        return Icons.water_drop;
      case SearchType.serialNumber:
        return Icons.numbers;
      case SearchType.mosqueName:
        return AppIcons.mosque;
    }
  }

  String _getSearchTypeLabel(SearchType type) {
    switch (type) {
      case SearchType.meterNumber:
        return 'meter_number'.tr();
      case SearchType.serialNumber:
        return 'mosque_serial_no'.tr();
      case SearchType.mosqueName:
        return 'mosque_name'.tr();
    }
  }

  void _handleSubmitted(String value) {
    widget.onSubmitted?.call();
    _unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.onPrimaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isFocused
              ? AppColors.primaryContainer.withOpacity(0.5)
              : AppColors.primaryContainer.withOpacity(0.2),
          width: _isFocused ? 1.5 : 1,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                  spreadRadius: 0,
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.primaryContainer.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 12),
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: AppColors.primaryContainer.withOpacity(0.15),
                  width: 1,
                ),
              ),
            ),
            child: PopupMenuButton<SearchType>(
              initialValue: _searchType,
              position: PopupMenuPosition.under,
              offset: const Offset(0, 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildSearchTypeIcon(_searchType),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_drop_down,
                      color: _isFocused
                          ? AppColors.primaryContainer
                          : Colors.grey.shade600,
                    ),
                  ],
                ),
              ),
              itemBuilder: (context) => SearchType.values.map((type) {
                return PopupMenuItem<SearchType>(
                  value: type,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildSearchTypeIcon(type),
                        const SizedBox(width: 12),
                        Text(
                          _getSearchTypeLabel(type),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: type == _searchType
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: type == _searchType
                                ? AppColors.primaryContainer
                                : Colors.grey.shade800,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onSelected: (SearchType newValue) {
                setState(() {
                  _searchType = newValue;
                });
                widget.onSearchTypeChanged?.call(newValue);
              },
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: _focusNode,
                    enabled: widget.enabled,
                    textInputAction: TextInputAction.search,
                    controller: _controller,
                    onChanged: widget.onChanged,
                    onSubmitted: _handleSubmitted,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          widget.enabled ? Colors.black : Colors.grey.shade500,
                    ),
                    decoration: InputDecoration(
                      hintText: _hintText,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey.shade600,
                      ),
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),
                    ),
                  ),
                ),
                if (_hasText)
                  Container(
                    margin: const EdgeInsets.only(right: 4),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          _controller.clear();
                          widget.onClear?.call();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            Icons.clear,
                            size: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                    ),
                  ),
                Container(
                  padding: EdgeInsets.all(2),
                  child: Tooltip(
                    message: 'search'.tr(),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: widget.enabled ? widget.onSubmitted : null,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.enabled
                                ? AppColors.primaryContainer
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: widget.enabled
                                ? [
                                    BoxShadow(
                                      color: AppColors.primaryContainer
                                          .withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Icon(
                            Icons.search,
                            size: 20,
                            color: widget.enabled
                                ? Colors.white
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
