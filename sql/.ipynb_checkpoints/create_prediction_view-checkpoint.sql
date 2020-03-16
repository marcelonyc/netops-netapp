CREATE external TABLE default.pred (
ts String,
company String,
data_center String,
device String,
index bigint,
cpu_utilization double,
cpu_utilization_hourly double,
cpu_utilization_minutely double,
latency double,
latency_hourly double,
latency_minutely double, 
packet_loss double,
packet_loss_hourly double,
packet_loss_minutely double,
throughput double,
throughput_hourly double,
throughput_minutely double,
prediction double
)
STORED AS PARQUET 
LOCATION 'v3io://users/marcelo/nfs/cloned/netops_predictions_parquet';