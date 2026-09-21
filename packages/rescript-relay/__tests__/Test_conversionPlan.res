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
