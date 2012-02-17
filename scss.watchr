watch('.*(sass|scss)/.*\.scss') do |md|
  dirname = File.dirname(md[0])

  tmp = dirname.split(/\/?#{md[1]}\/?/)

  unless tmp.empty? then
    basepath = !tmp[0].empty? ? tmp[0]+'/' : ''
    subpath = !tmp[1].empty? ? tmp[1]+'/' : ''
  end

  filename = File.basename(md[0])
  extname = File.extname(md[0])
  filename.sub!(/\.(scss|sass)/,'')

  create_dir "#{basepath}css/#{subpath}"
  res = `sass --trace #{dirname}/#{filename}#{extname} > #{basepath}css/#{subpath}#{filename}.css`

  res = `docco #{dirname}/#{filename}#{extname}`

  message = res
  unless(`which growlnotify`.empty?) then
    system "growlnotify -t complete -m '#{message}'"
  end
end

def create_dir(path)
  path = path.split('/')
  pwd = Dir.pwd
  path.each do |dir|
    unless(File.directory? dir) then
      Dir.mkdir dir
    end
    Dir.chdir dir
  end
  Dir.chdir pwd
end
