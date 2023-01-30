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
// Remove the following line if you do not want to use custom code in your
// project:

wfLoadExtension( "CustomExtension" );

// wfLoadExtension( "TinyMCE" );
// $wgTinyMCEEnabled = true;
