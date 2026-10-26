require "bigdecimal"
require "bigdecimal/util"

def median_ns(calls)
  times = Array.new(9) do
    start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    calls.times { yield }
    Process.clock_gettime(Process::CLOCK_MONOTONIC) - start
  end
  (times.sort[4] / calls * 1e9).round
end

price = BigDecimal("129.90")
string = "129.90"
results = {
  "108.25.to_d" => median_ns(200_000) { 108.25.to_d },
  "0.2.to_d" => median_ns(200_000) { 0.2.to_d },
  "bd * 1.2" => median_ns(200_000) { price * 1.2 },
  "(1.0/3).to_d" => median_ns(200_000) { (1.0 / 3).to_d },
  "BigDecimal(\"129.90\")" => median_ns(300_000) { BigDecimal(string) },
  "BigDecimal(\"0.00\")" => median_ns(300_000) { BigDecimal("0.00") },
}
puts results.map { |name, ns| "#{name}=#{ns}" }.join(" ")
