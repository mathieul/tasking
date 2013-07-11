$redis_url = "redis://localhost:6379"
$redis_pool = ConnectionPool.new(size: 10, timeout: 5) do
  Redis.new(url: $redis_url)
end