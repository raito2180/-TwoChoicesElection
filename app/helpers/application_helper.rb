module ApplicationHelper
  def default_meta_tags
    {
      site: 'Stardom',
      title: 'サッカーファン向けwebサービス',
      reverse: true,
      separator: '|',
      description: '動画検索、AI機能、フットサル募集機能でサッカーを五感で楽しめます',
      keywords: 'サッカー,AI,youtube,フットサル',
      canonical: request.original_url,
      icon: [
        { href: image_url('favicon.ico') },
        { href: image_url('logo.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' }
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('footerlogo.png'),
        locale: 'ja_JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@raito2180'
      }
    }
  end
end
