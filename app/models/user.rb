class User < ActiveRecord::Base
 devise :database_authenticatable,
        :registerable,
        :recoverable,
        :rememberable,
        :trackable,
        :validatable,
        :authentication_keys => [:login]

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  has_many :projects

  enum status: { pending: 0, active: 1, tester: 2, suspended: 3 }

  # To handle gravatars
  include Gravtastic
  gravtastic

  validates :email,
    presence: true,
    uniqueness: { case_sensitive: false }

  validates :username,
    presence: true,
    exclusion: { in: proc { User.reserved_usernames } },
    uniqueness: { case_sensitive: false }

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    conditions[:email].downcase! if conditions[:email]

    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  private

  def self.reserved_usernames
  	[
  		# Companies we'd love to have use our service
  		# so we'll reserve them to be safe
  		'github',
  		'twitter',
  		'facebook',
  		'google',
  		'apple',

  		# Generic reserved words
  		'about',
  		'access',
  		'account',
  		'accounts',
  		'activate',
  		'add',
  		'address',
  		'adm',
  		'admin',
  		'administration',
  		'administrator',
  		'adult',
  		'advertising',
  		'affiliate',
  		'affiliates',
  		'ajax',
  		'analytics',
  		'android',
  		'anon',
  		'anonymous',
  		'api',
  		'app',
  		'apps',
  		'archive',
  		'archives',
  		'atom',
  		'auth',
  		'authentication',
  		'avatar',
  		'backup',
  		'banner',
  		'banners',
  		'billing',
  		'bin',
  		'blog',
  		'blogs',
  		'board',
  		'bot',
  		'bots',
  		'business',
  		'cache',
  		'calendar',
  		'campaign',
  		'cancel',
  		'careers',
  		'cart',
  		'cgi',
  		'changelog',
  		'chat',
  		'checkout',
  		'client',
  		'code',
  		'code',
  		'codereview',
  		'comercial',
  		'compare',
  		'config',
  		'configuration',
  		'connect',
  		'contact',
  		'contest',
  		'create',
  		'css',
  		'dashboard',
  		'data',
  		'db',
  		'delete',
  		'demo',
  		'design',
  		'design',
  		'designer',
  		'dev',
  		'devel',
  		'dir',
  		'directory',
  		'direct_messages',
  		'doc',
  		'docs',
  		'documentation',
  		'domain',
  		'download',
  		'downloads',
  		'ecommerce',
  		'edit',
  		'editor',
  		'email',
  		'employment',
  		'enterprise',
      'explore',
  		'faq',
  		'favorite',
  		'favorites',
  		'feed',
  		'feedback',
  		'feeds',
  		'file',
  		'files',
  		'fleet',
  		'fleets',
  		'flog',
  		'follow',
  		'followers',
  		'following',
  		'forum',
  		'forums',
  		'free',
  		'friend',
  		'friends',
  		'ftp',
  		'gadget',
  		'gadgets',
  		'games',
  		'gist',
  		'group',
  		'groups',
  		'guest',
  		'help',
  		'home',
  		'homepage',
  		'host',
  		'hosting',
  		'hostmaster',
  		'hostname',
  		'hpg',
  		'html',
  		'http',
  		'httpd',
  		'https',
  		'idea',
  		'ideas',
  		'image',
  		'images',
  		'imap',
  		'img',
  		'index',
  		'indice',
  		'info',
  		'information',
  		'intranet',
  		'invitations',
  		'invite',
  		'ipad',
  		'iphone',
  		'irc',
  		'java',
  		'javascript',
  		'job',
  		'jobs',
  		'js',
  		'json',
  		'knowledgebase',
  		'language',
  		'languages',
  		'legal',
  		'list',
  		'lists',
      'locale',
  		'log',
  		'login',
  		'logout',
  		'logs',
  		'mail',
  		'mail1',
  		'mail2',
  		'mail3',
  		'mail4',
  		'mail5',
  		'mailer',
  		'mailing',
  		'manager',
  		'map',
  		'maps',
  		'marketing',
  		'master',
  		'media',
  		'message',
  		'messenger',
  		'microblog',
  		'microblogs',
  		'mine',
  		'mis',
  		'mob',
  		'mobile',
  		'movie',
  		'movies',
  		'mp3',
  		'msg',
  		'msn',
  		'music',
  		'mysql',
  		'name',
  		'named',
  		'net',
  		'network',
  		'new',
  		'news',
  		'newsletter',
  		'nick',
  		'nickname',
  		'notes',
  		'ns',
  		'ns1',
  		'ns2',
  		'ns3',
  		'ns4',
  		'oauth',
  		'oauth_clients',
  		'offers',
  		'old',
  		'online',
  		'openid',
  		'operator',
  		'order',
  		'orders',
  		'organizations',
  		'page',
  		'pager',
  		'pages',
  		'panel',
  		'password',
  		'perl',
  		'photo',
  		'photoalbum',
  		'photos',
  		'php',
  		'pic',
  		'pics',
  		'plans',
  		'plugin',
  		'plugins',
  		'pop',
  		'pop3',
  		'popular',
  		'post',
  		'postfix',
  		'postmaster',
  		'posts',
  		'privacy',
  		'profile',
  		'project',
  		'projects',
  		'promo',
  		'pub',
  		'public',
  		'put',
  		'python',
  		'random',
  		'recruitment',
  		'register',
  		'registration',
  		'remove',
  		'replies',
  		'root',
  		'rss',
  		'ruby',
  		'sale',
  		'sales',
  		'sample',
  		'samples',
  		'save',
  		'script',
  		'scripts',
  		'search',
  		'secure',
  		'security',
  		'send',
  		'service',
  		'sessions',
  		'setting',
  		'settings',
  		'setup',
  		'shop',
  		'signin',
  		'signup',
  		'site',
  		'sitemap',
  		'sites',
  		'smtp',
  		'sql',
  		'ssh',
  		'ssl',
  		'ssladmin',
  		'ssladministrator',
  		'sslwebmaster',
  		'stage',
  		'staging',
  		'start',
  		'stat',
  		'static',
  		'stats',
  		'status',
  		'store',
  		'stores',
  		'stories',
  		'styleguide',
  		'subdomain',
  		'subscribe',
  		'subscriptions',
  		'support',
  		'sysadmin',
  		'sysadministrator',
  		'system',
  		'tablet',
  		'tablets',
  		'talk',
  		'task',
  		'tasks',
  		'tech',
  		'telnet',
  		'terms',
  		'test',
  		'test1',
  		'test2',
  		'test3',
  		'teste',
  		'tests',
  		'theme',
  		'themes',
  		'tmp',
  		'todo',
  		'tools',
  		'tour',
  		'translations',
  		'trends',
  		'tv',
  		'unfollow',
  		'unsubscribe',
  		'update',
  		'upload',
  		'url',
  		'usage',
  		'user',
  		'username',
  		'video',
  		'videos',
  		'visitor',
  		'weather',
  		'web',
  		'webmail',
  		'webmaster',
  		'website',
  		'websites',
  		'widget',
  		'widgets',
  		'wiki',
  		'win',
  		'workshop',
  		'ww',
  		'www',
  		'wwww',
  		'xfn',
  		'xml',
  		'xmpp',
  		'xpg',
  		'xxx',
  		'yaml',
  		'yml',
  		'you',
  		'yourdomain',
  		'yourname',
  		'yoursite',
  		'yourusername',

  		# Top 50 languages by speaking population
  		'chinese',
  		'mandarin',
  		'spanish',
  		'english',
  		'bengali',
  		'hindi',
  		'portuguese',
  		'russian',
  		'japanese',
  		'german',
  		'wu',
  		'javanese',
  		'korean',
  		'french',
  		'vietnamese',
  		'telugu',
  		'chinese',
  		'marathi',
  		'tamil',
  		'turkish',
  		'urdu',
  		'min-nan',
  		'jinyu',
  		'gujarati',
  		'polish',
  		'arabic',
  		'ukrainian',
  		'italian',
  		'xiang',
  		'malayalam',
  		'hakka',
  		'kannada',
  		'oriya',
  		'panjabi',
  		'sunda',
  		'panjabi',
  		'romanian',
  		'bhojpuri',
  		'azerbaijani',
  		'farsi',
  		'maithili',
  		'hausa',
  		'arabic',
  		'burmese',
  		'serbo-croatian',
  		'gan',
  		'awadhi',
  		'thai',
  		'dutch',
  		'yoruba',
  		'sindhi',

  		# Country TLDs
  		'ac', # Ascension Island
  		'ad', # Andorra
  		'ae', # United Arab Emirates
  		'af', # Afghanistan
  		'ag', # Antigua and Barbuda
  		'ai', # Anguilla
  		'al', # Albania
  		'am', # Armenia
  		'an', # Netherlands Antilles
  		'ao', # Angola
  		'aq', # Antarctica
  		'ar', # Argentina
  		'as', # American Samoa
  		'at', # Austria
  		'au', # Australia
  		'aw', # Aruba
  		'ax', # and
  		'az', # Azerbaijan
  		'ba', # Bosnia and Herzegovina
  		'bb', # Barbados
  		'bd', # Bangladesh
  		'be', # Belgium
  		'bf', # Burkina Faso
  		'bg', # Bulgaria
  		'bh', # Bahrain
  		'bi', # Burundi
  		'bj', # Benin
  		'bm', # Bermuda
  		'bn', # Brunei Darussalam
  		'bo', # Bolivia
  		'br', # Brazil
  		'bs', # Bahamas
  		'bt', # Bhutan
  		'bv', # Bouvet Island
  		'bw', # Botswana
  		'by', # Belarus
  		'bz', # Belize
  		'ca', # Canada
  		'cc', # Cocos (Keeling) Islands
  		'cd', # Democratic Republic of the Congo
  		'cf', # Central African Republic
  		'cg', # Republic of the Congo
  		'ch', # Switzerland
  		'ci', # Côte d'Ivoire
  		'ck', # Cook Islands
  		'cl', # Chile
  		'cm', # Cameroon
  		'cn', # People's Republic of China
  		'co', # Colombia
  		'cr', # Costa Rica
  		'cs', # Czechoslovakia
  		'cu', # Cuba
  		'cv', # Cape Verde
  		'cx', # Christmas Island
  		'cy', # Cyprus
  		'cz', # Czech Republic
  		'dd', # East Germany
  		'de', # Germany
  		'dj', # Djibouti
  		'dk', # Denmark
  		'dm', # Dominica
  		'do', # Dominican Republic
  		'dz', # Algeria
  		'ec', # Ecuador
  		'ee', # Estonia
  		'eg', # Egypt
  		'eh', # Western Sahara
  		'er', # Eritrea
  		'es', # Spain
  		'et', # Ethiopia
  		'eu', # European Union
  		'fi', # Finland
  		'fj', # Fiji
  		'fk', # Falkland Islands
  		'fm', # Federated States of Micronesia
  		'fo', # Faroe Islands
  		'fr', # France
  		'ga', # Gabon
  		'gb', # United Kingdom
  		'gd', # Grenada
  		'ge', # Georgia
  		'gf', # French Guiana
  		'gg', # Guernsey
  		'gh', # Ghana
  		'gi', # Gibraltar
  		'gl', # Greenland
  		'gm', # The Gambia
  		'gn', # Guinea
  		'gp', # Guadeloupe
  		'gq', # Equatorial Guinea
  		'gr', # Greece
  		'gs', # South Georgia and the South Sandwich Islands
  		'gt', # Guatemala
  		'gu', # Guam
  		'gw', # Guinea-Bissau
  		'gy', # Guyana
  		'hk', # Hong Kong
  		'hm', # Heard Island and McDonald Islands
  		'hn', # Honduras
  		'hr', # Croatia
  		'ht', # Haiti
  		'hu', # Hungary
  		'id', # Indonesia
  		'ie', # Republic of Ireland  Northern Ireland
  		'il', # Israel
  		'im', # Isle of Man
  		'in', # India
  		'io', # British Indian Ocean Territory
  		'iq', # Iraq
  		'ir', # Iran
  		'is', # Iceland
  		'it', # Italy
  		'je', # Jersey
  		'jm', # Jamaica
  		'jo', # Jordan
  		'jp', # Japan
  		'ke', # Kenya
  		'kg', # Kyrgyzstan
  		'kh', # Cambodia
  		'ki', # Kiribati
  		'km', # Comoros
  		'kn', # Saint Kitts and Nevis
  		'kp', # Democratic People's Republic of Korea
  		'kr', # Republic of Korea
  		'kw', # Kuwait
  		'ky', # Cayman Islands
  		'kz', # Kazakhstan
  		'la', # Laos
  		'lb', # Lebanon
  		'lc', # Saint Lucia
  		'li', # Liechtenstein
  		'lk', # Sri Lanka
  		'lr', # Liberia
  		'ls', # Lesotho
  		'lt', # Lithuania
  		'lu', # Luxembourg
  		'lv', # Latvia
  		'ly', # Libya
  		'ma', # Morocco
  		'mc', # Monaco
  		'md', # Moldova
  		'me', # Montenegro
  		'mg', # Madagascar
  		'mh', # Marshall Islands
  		'mk', # Republic of Macedonia
  		'ml', # Mali
  		'mm', # Myanmar
  		'mn', # Mongolia
  		'mo', # Macau
  		'mp', # Northern Mariana Islands
  		'mq', # Martinique
  		'mr', # Mauritania
  		'ms', # Montserrat
  		'mt', # Malta
  		'mu', # Mauritius
  		'mv', # Maldives
  		'mw', # Malawi
  		'mx', # Mexico
  		'my', # Malaysia
  		'mz', # Mozambique
  		'na', # Namibia
  		'nc', # New Caledonia
  		'ne', # Niger
  		'nf', # Norfolk Island
  		'ng', # Nigeria
  		'ni', # Nicaragua
  		'nl', # Netherlands
  		'no', # Norway
  		'np', # Nepal
  		'nr', # Nauru
  		'nu', # Niue
  		'nz', # New Zealand
  		'om', # Oman
  		'pa', # Panama
  		'pe', # Peru
  		'pf', # French Polynesia
  		'pg', # Papua New Guinea
  		'ph', # Philippines
  		'pk', # Pakistan
  		'pl', # Poland
  		'pm', # Saint-Pierre and Miquelon
  		'pn', # Pitcairn Islands
  		'pr', # Puerto Rico
  		'ps', # Palestinian territories
  		'pt', # Portugal
  		'pw', # Palau
  		'py', # Paraguay
  		'qa', # Qatar
  		're', # Réunion
  		'ro', # Romania
  		'rs', # Serbia
  		'ru', # Russia
  		'rw', # Rwanda
  		'sa', # Saudi Arabia
  		'sb', # Solomon Islands
  		'sc', # Seychelles
  		'sd', # Sudan
  		'se', # Sweden
  		'sg', # Singapore
  		'sh', # Saint Helena
  		'si', # Slovenia
  		'sj', # Svalbard and Jan Mayen Islands
  		'sk', # Slovakia
  		'sl', # Sierra Leone
  		'sm', # San Marino
  		'sn', # Senegal
  		'so', # Somalia
  		'sr', # Suriname
  		'ss', # South Sudan
  		'st', # Sao Tome and Principe
  		'su', # Soviet Union
  		'sv', # El Salvador
  		'sy', # Syria
  		'sz', # Swaziland
  		'tc', # Turks and Caicos Islands
  		'td', # Chad
  		'tf', # French Southern and Antarctic Lands
  		'tg', # Togo
  		'th', # Thailand
  		'tj', # Tajikistan
  		'tk', # Tokelau
  		'tl', # East Timor
  		'tm', # Turkmenistan
  		'tn', # Tunisia
  		'to', # Tonga
  		'tp', # East Timor
  		'tr', # Turkey
  		'tt', # Trinidad and Tobago
  		'tv', # Tuvalu
  		'tw', # Republic of China (Taiwan)
  		'tz', # Tanzania
  		'ua', # Ukraine
  		'ug', # Uganda
  		'uk', # United Kingdom
  		'us', # United States of America
  		'uy', # Uruguay
  		'uz', # Uzbekistan
  		'va', # Vatican City
  		'vc', # Saint Vincent and the Grenadines
  		've', # Venezuela
  		'vg', # British Virgin Islands
  		'vi', # United States Virgin Islands
  		'vn', # Vietnam
  		'vu', # Vanuatu
  		'wf', # Wallis and Futuna
  		'ws', # Samoa
  		'ye', # Yemen
  		'yt', # Mayotte
  		'yu', # Yugoslavia
  		'za', # South Africa
  		'zm', # Zambia
  		'zw'  # Zimbabwe
  	]
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  username               :string           not null
#  status                 :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
