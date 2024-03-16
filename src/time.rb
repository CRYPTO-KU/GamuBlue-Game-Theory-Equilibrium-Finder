WARMUP    = 2
RUNS      = 5
IOC_GAMES = "../games/nfg/ioc/ioc-"
FD_GAMES  = "../games/nfg/fd/fd-"
SCRIPTS   = [
  "k-resiliency.py",
  "l-repellence.py",
  "t-immunity.py",
  "m-stability.py",
  "k-t-robustness.py",
  "l-t-resistance.py"
]

SCRIPTS.each do |s|
  (9..12).each do |i|
    j = i < 10 ? "0#{i}" : "#{i}"

    sN = ([1] * i).join " "
    puts "IOC - #{s} - #{j}"
    system("hyperfine -w #{WARMUP} -r #{RUNS} --export-csv ioc-#{s}-#{j}.csv -N './algorithms/nfg/#{s} #{IOC_GAMES}#{j}.nfg #{sN}'")
  end
end

SCRIPTS.each do |s|
  (13..16).each do |i|
    j = i < 10 ? "0#{i}" : "#{i}"

    sN = ([1] + ([0] * (i - 1))).join " "
    puts "FD - #{s} - #{j}"
    system("hyperfine -w #{WARMUP} -r #{RUNS} --export-csv fd-#{s}-#{j}.csv -N './algorithms/nfg/#{s} #{FD_GAMES}#{j}.nfg #{sN}'")
  end
end
