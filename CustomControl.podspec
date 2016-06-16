Pod::Spec.new do |s|
  s.name         = "CustomControl"
  s.version      = "0.0.5"
  s.summary      = "custom control"
  s.homepage     = "https://github.com/jidibingren/customcontrol"
  s.license      = 'MIT'
  s.author       = { "jidibingren" => "jidibingren@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = {:git => "https://github.com/jidibingren/customcontrol.git" ,
		                :tag => s.version }
 
  s.prefix_header_contents = '#import "SCDGProjectHeaders.h"'
 
  s.source_files = 'control/*.{h,m,mm}','flatbuffers/*.{h,cpp,m}','additions/*.{h,m,cpp}'
  s.dependency   'AFNetworking', '~> 3.1.0'
  s.dependency   'MQTTClient', '~> 0.7.4'
  s.dependency   'UICKeyChainStore', '~> 2.1.0'
  s.dependency   'YYCache', '~> 1.0.3'
  s.dependency   'XRSA', '~> 1.1.1'
  s.dependency   'FlatBuffers-ObjC', '~> 0.0.1'
  s.dependency   'Realm', '= 1.0.0'
  s.requires_arc = true
end
