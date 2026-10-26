refs = ARGV
samples = Hash.new { |hash, key| hash[key] = Hash.new { |inner, name| inner[name] = [] } }
7.times do
  refs.each do |ref|
    output = `ruby -I builds/#{ref}/lib bench-linux/bench.rb`
    output.split.each do |pair|
      name, ns = pair.split("=")
      samples[ref][name] << ns.to_i
    end
  end
end
names = samples[refs.first].keys
puts "| | #{refs.join(" | ")} |"
puts "|---|#{"---|" * refs.size}"
names.each do |name|
  medians = refs.map { |ref| samples[ref][name].sort[samples[ref][name].size / 2] }
  puts "| `#{name}` | #{medians.map { "#{it} ns" }.join(" | ")} |"
end
