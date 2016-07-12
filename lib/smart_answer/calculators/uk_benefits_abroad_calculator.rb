module SmartAnswer::Calculators
  class UkBenefitsAbroadCalculator
    include ActiveModel::Model

    COUNTRIES_OF_FORMER_YUGOSLAVIA = %w(bosnia-and-herzegovina kosovo macedonia montenegro serbia).freeze

    attr_accessor :country

    def eea_country?
      %w(austria belgium bulgaria croatia cyprus czech-republic denmark estonia
         finland france germany gibraltar greece hungary iceland ireland italy
         latvia liechtenstein lithuania luxembourg malta netherlands norway
         poland portugal romania slovakia slovenia spain sweden switzerland).include?(country)
    end
  end
end
