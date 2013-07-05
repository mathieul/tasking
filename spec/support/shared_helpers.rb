module SharedHelpers
  def file_content(string)
    line1, line2, *lines = string.lines
    return line1 if line2.nil?
    common = lines.reduce(common_start(line1, line2)) do |common, line|
      common_start(common, line)
    end
    reductor = /^#{Regexp.escape(common)}/
    string.lines.map { |line| line.sub(reductor, "") }.join
  end

  def common_start(line1, line2)
    pair = line1.chomp.chars.lazy.zip(line2.chomp.chars)
    common = pair.take_while { |c1, c2| c1 == c2 }.map(&:first)
    common.to_a.join
  end
end
