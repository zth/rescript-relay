module Query = %relay(`
  query TestConversionPlanQuery($input: ConversionContractInput) {
    conversionContract(input: $input) {
      grid
      dates
      raw
      a_b
      a { b }
    }
  }
`)

module ReverseQuery = %relay(`
  query TestConversionPlanReverseQuery($input: ConversionContractInput) {
    conversionContract(input: $input) {
      a { b }
      a_b
      raw
      dates
      grid
    }
  }
`)
