import 'package:clinicc/core/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

class MessageBubble extends StatefulWidget {
  final String text;
  final bool isMe;
  final bool isRead;
  final String? attachmentUrl;
  final String? attachmentType;
  final DateTime timestamp;

  const MessageBubble({
    super.key,
    required this.text,
    required this.isMe,
    required this.isRead,
    this.attachmentUrl,
    this.attachmentType,
    required this.timestamp,
  });

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.attachmentType == 'video' && widget.attachmentUrl != null) {
      _videoController = VideoPlayerController.network(widget.attachmentUrl!)
        ..initialize().then((_) {
          setState(() {});
        });
    } else {
      _videoController = null;
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment:
            widget.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            decoration: BoxDecoration(
              color: widget.isMe ? AppColors.color1 : Colors.grey[300],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft:
                    widget.isMe ? const Radius.circular(18) : Radius.zero,
                bottomRight:
                    widget.isMe ? Radius.zero : const Radius.circular(18),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.attachmentUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildAttachment(),
                  ),
                Text(
                  widget.text,
                  style: TextStyle(
                    color: widget.isMe ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatTime(widget.timestamp),
                      style: TextStyle(
                        fontSize: 10,
                        color: widget.isMe ? Colors.white70 : Colors.black54,
                      ),
                    ),
                    if (widget.isMe)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Icon(
                          widget.isRead ? Icons.done_all : Icons.done,
                          size: 12,
                          color: widget.isRead ? Colors.blue : Colors.white70,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttachment() {
    switch (widget.attachmentType) {
      case 'image':
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: widget.attachmentUrl!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 200,
              height: 200,
              color: Colors.grey[200],
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        );
      case 'video':
        return _videoController != null && _videoController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            : Container(
                width: 200,
                height: 200,
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
      default:
        return Container(
          width: 200,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              const Icon(Icons.insert_drive_file, size: 40),
              Text(
                widget.attachmentUrl!.split('/').last,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
    }
  }
}
