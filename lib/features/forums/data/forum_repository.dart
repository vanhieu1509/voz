import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_provider.dart';
import '../domain/forum_models.dart';

class ForumRepository {
  ForumRepository(this._reader);

  final Reader _reader;

  Future<List<ForumCategory>> listCategories() async {
    return const [
      // Đại sảnh
      ForumCategory(
        id: 'voz-announcements',
        title: 'Thông báo',
        section: 'Đại sảnh',
        description: 'Thông tin quan trọng từ ban điều hành.',
        iconName: 'campaign',
      ),
      ForumCategory(
        id: 'voz-feedback',
        title: 'Góp ý',
        section: 'Đại sảnh',
        description: 'Trao đổi và góp ý để voz tốt hơn.',
        iconName: 'emoji_objects',
      ),
      ForumCategory(
        id: 'voz-news',
        title: 'Tin tức iT',
        section: 'Đại sảnh',
        description: 'Tin tức công nghệ cập nhật hằng ngày.',
        iconName: 'article',
      ),
      ForumCategory(
        id: 'voz-reviews',
        title: 'Review sản phẩm',
        section: 'Đại sảnh',
        description: 'Đánh giá phần cứng, thiết bị mới.',
        iconName: 'rate_review',
      ),
      ForumCategory(
        id: 'voz-knowledge',
        title: 'Chia sẻ kiến thức',
        section: 'Đại sảnh',
        description: 'Kinh nghiệm và mẹo vặt hữu ích.',
        iconName: 'school',
      ),
      // Máy tính
      ForumCategory(
        id: 'pc-build-advice',
        title: 'Tư vấn cấu hình',
        section: 'Máy tính',
        description: 'Nhờ tư vấn dàn máy phù hợp nhu cầu.',
        iconName: 'support_agent',
      ),
      ForumCategory(
        id: 'overclocking-cooling-modding',
        title: 'Overclocking & Cooling & Modding',
        section: 'Máy tính',
        description: 'Ép xung, tản nhiệt và độ chế máy tính.',
        iconName: 'bolt',
      ),
      ForumCategory(
        id: 'amd-hardware',
        title: 'AMD',
        section: 'Máy tính',
        description: 'Tin tức và kinh nghiệm phần cứng AMD.',
        iconName: 'memory',
      ),
      ForumCategory(
        id: 'intel-hardware',
        title: 'Intel',
        section: 'Máy tính',
        description: 'Thảo luận về hệ sinh thái Intel.',
        iconName: 'precision_manufacturing',
      ),
      ForumCategory(
        id: 'gpu-display',
        title: 'GPU & Màn hình',
        section: 'Máy tính',
        description: 'Card đồ hoạ và màn hình hiển thị.',
        iconName: 'desktop_windows',
      ),
      ForumCategory(
        id: 'pc-general',
        title: 'Chuyện chung',
        section: 'Máy tính',
        description: 'Chia sẻ câu chuyện và xu hướng PC.',
        iconName: 'forum',
      ),
      ForumCategory(
        id: 'peripherals-accessories',
        title: 'Thiết ngoại vi & Phụ kiện & Gaming Gear',
        section: 'Máy tính',
        description: 'Bàn phím, chuột, tai nghe và phụ kiện.',
        iconName: 'sports_esports',
      ),
      ForumCategory(
        id: 'servers-nas-render',
        title: 'Server / NAS / Render Farm',
        section: 'Máy tính',
        description: 'Hệ thống máy chủ, lưu trữ và render.',
        iconName: 'dns',
      ),
      ForumCategory(
        id: 'small-form-factor',
        title: 'Small Form Factor PC',
        section: 'Máy tính',
        description: 'Máy tính nhỏ gọn, tối ưu không gian.',
        iconName: 'developer_board',
      ),
    ];
  }

  Future<List<ForumSummary>> listThreads(String categoryId, int page) async {
    // Placeholder implementation.
    return List.generate(
      10,
      (index) => ForumSummary(id: '$categoryId-$page-$index', title: 'Thread $index'),
    );
  }
}

final forumRepositoryProvider = Provider<ForumRepository>((ref) {
  ref.watch(dioProvider); // ensure dependency
  return ForumRepository(ref.read);
});
