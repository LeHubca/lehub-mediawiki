<?php

wfLoadExtension( "TinyMCE" );
$wgTinyMCEEnabled = true;
wfLoadExtension( 'EmbedVideo' );

$wgFileExtensions = [
  'pdf',
  'png',
  'gif',
  'jpg',
  'jpeg',
  'webp',
  'flac',
  'mkv',
  'mov',
  'mp3',
  'mp4',
  'oga',
  'ogg',
  'ogv',
  'wav',
  'webm',
];

wfLoadExtension( "Cite" );

// https://stackoverflow.com/questions/71577367/in-mediawikis-tinymce-extension-how-to-enable-disable-buttons/72014409#72014409
// https://blog.dcycle.com/blog/2022-04-22/mediawiki-customizing-tinymce/
$wgTinyMCESettings = [
  "#wpTextbox1" => [
    "toolbar+" => 'reference',
  ],
];

// https://gerrit.wikimedia.org/g/mediawiki/extensions/CirrusSearch/%2B/HEAD/README
wfLoadExtension( 'Elastica' );
wfLoadExtension( 'CirrusSearch' );
if (getenv('CIRRUS_HAS_BEEN_INSTALLED')) {
  $wgDisableSearchUpdate = false;
  $cirrusSearchType = "CirrusSearch"
}
else {
  $wgDisableSearchUpdate = true;
}
$wgCirrusSearchServers = [ 'elasticsearch' ];
$wgCirrusSearchServers = [ 'elasticsearch' ];
