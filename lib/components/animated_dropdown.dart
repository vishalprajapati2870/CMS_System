import 'package:flutter/material.dart';

class AnimatedDropdown<T> extends StatefulWidget {
  final T? value;
  final List<T> items;
  final String Function(T) itemLabelBuilder;
  final ValueChanged<T?> onChanged;
  final String hintText;
  final bool enableSearch;
  final bool isExpanded;
  final String? Function(T?)? validator;

  const AnimatedDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.itemLabelBuilder,
    required this.onChanged,
    this.hintText = 'Select Option',
    this.enableSearch = false,
    this.isExpanded = true,
    this.validator,
  });

  @override
  State<AnimatedDropdown<T>> createState() => _AnimatedDropdownState<T>();
}

class _AnimatedDropdownState<T> extends State<AnimatedDropdown<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;
  bool _isDisposed = false;
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  List<T> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.items != oldWidget.items) {
      setState(() {
        _filteredItems = widget.items;
      });
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    if (_overlayEntry != null && _overlayEntry!.mounted) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
    _animationController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    if (!_isDisposed) {
      _animationController.forward();
    }
    setState(() {
      _isOpen = true;
      _filteredItems = widget.items;
      _searchController.clear();
    });
    
    // Focus search field if enabled
    if (widget.enableSearch) {
       Future.delayed(const Duration(milliseconds: 50), () {
        _searchFocusNode.requestFocus();
       });
    }
  }

  void _closeDropdown() {
    if (!mounted || _isDisposed) return;
    try {
      _animationController.reverse().then((_) {
        if (!mounted || _isDisposed) return;
        _overlayEntry?.remove();
        _overlayEntry = null;
        _searchFocusNode.unfocus();
        if (mounted) {
          setState(() {
            _isOpen = false;
          });
        }
      });
    } catch (e) {
      // Ignore animation errors during disposal
    }
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        _filteredItems = widget.items
            .where((item) => widget
                .itemLabelBuilder(item)
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
      _overlayEntry?.markNeedsBuild();
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    
    // Calculate available space
    final mediaQuery = MediaQuery.of(context);
    final double screenHeight = mediaQuery.size.height;
    final double paddingBottom = mediaQuery.padding.bottom;
    final double viewInsetsBottom = mediaQuery.viewInsets.bottom; // Keyboard height
    final double paddingTop = mediaQuery.padding.top;
    
    final double spaceBelow = screenHeight - (offset.dy + size.height) - paddingBottom - viewInsetsBottom - 10;
    final double spaceAbove = offset.dy - paddingTop - 10;
    
    // Determine if we should show above
    // Prefer below if enough space (e.g. > 150), otherwise pick larger space
    bool showAbove = (spaceBelow < 150) && (spaceAbove > spaceBelow);

    // Calculate constrained height
    final double maxDropdownHeight = 300.0;
    final double availableHeight = showAbove ? spaceAbove : spaceBelow;
    final double constrainedHeight = availableHeight < maxDropdownHeight ? availableHeight : maxDropdownHeight;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Full screen transparent tap handler to close dropdown
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeDropdown,
              behavior: HitTestBehavior.translucent,
              child: Container(color: Colors.transparent),
            ),
          ),
          Positioned(
            width: widget.isExpanded ? size.width : null,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              // Adjust anchors based on direction
              targetAnchor: showAbove ? Alignment.topLeft : Alignment.bottomLeft,
              followerAnchor: showAbove ? Alignment.bottomLeft : Alignment.topLeft,
              offset: showAbove 
                  ? const Offset(0, -5.0)  // 5px margin above
                  : const Offset(0, 5.0),  // 5px margin below
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                child: SizeTransition(
                  axisAlignment: showAbove ? 1.0 : -1.0, // 1.0 grows from bottom, -1.0 from top
                  sizeFactor: _expandAnimation,
                  child: Container(
                    constraints: BoxConstraints(maxHeight: constrainedHeight),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.enableSearch)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                prefixIcon: const Icon(Icons.search, size: 20),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xff003a78)
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade50,
                              ),
                              onChanged: _filterItems,
                              onSubmitted: (value) {
                                if (_filteredItems.isNotEmpty) {
                                  widget.onChanged(_filteredItems.first);
                                  _closeDropdown();
                                }
                              },
                            ),
                          ),
                        Flexible(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = _filteredItems[index];
                              final isSelected = item == widget.value;
                              return InkWell(
                                onTap: () {
                                  widget.onChanged(item);
                                  _closeDropdown();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12
                                  ),
                                  color: isSelected
                                      ? const Color(0xffeaf1fb)
                                      : Colors.transparent,
                                  child: Text(
                                    widget.itemLabelBuilder(item),
                                    style: TextStyle(
                                      color: isSelected
                                          ? const Color(0xff003a78)
                                          : Colors.black87,
                                      fontWeight: isSelected
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xfff5f5f5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent),
            // Add error border support if needed later via validators
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.value != null
                      ? widget.itemLabelBuilder(widget.value as T)
                      : widget.hintText,
                  style: TextStyle(
                    color: widget.value != null
                        ? Colors.black87
                        : Colors.grey.shade600,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                _isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: const Color(0xff607286),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
