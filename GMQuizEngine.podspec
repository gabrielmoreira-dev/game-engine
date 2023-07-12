Pod::Spec.new do |spec|

  spec.name         = "GMQuizEngine"
  spec.version      = "0.0.1"
  spec.summary      = "Engine for the QuizApp"

  spec.description  = <<-DESC
This library works as an engine for the QuizApp
                   DESC

  spec.homepage     = "https://github.com/gabrielmoreira-dev/quiz-engine"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Gabriel Moreira" => "g.alves.m.2008@gmail.com" }

  spec.ios.deployment_target = "14.4"
  spec.swift_version         = "5.0"

  spec.source        = { :git => "https://github.com/gabrielmoreira-dev/quiz-engine.git", :tag => "#{spec.version}" }
  spec.source_files  = "QuizEngine/**/*.{h,m,swift}"

end
