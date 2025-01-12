pkg load zeromq;
pkg load control;
pkg load signal;

fs = 1e6;
nfft = 1024;

sock_gr_rx = zmq_socket(ZMQ_PULL);
zmq_connect(sock_gr_rx, "tcp://127.0.0.1:5555");

sock_gr_tx = zmq_socket(ZMQ_PUSH);
zmq_bind(sock_gr_tx, "tcp://127.0.0.1:5556");

msg_size_bytes = 2*nfft*2*4;

lag = (-nfft/2):(nfft/2-1);

msg_cnt = 0;
update_interval = 100;

while true
    tic;
    
    recv_raw = zmq_recv(sock_gr_rx, msg_size_bytes, 0);
    msg_cnt = msg_cnt + 1;
    
    recv_complex = typecast(recv_raw, "single complex");
    
    sig1 = recv_complex(1:2:length(recv_complex)); 
    sig2 = recv_complex(2:2:length(recv_complex)); 
    
    r = ifft(fft(sig1).*conj(fft(sig2)));
    
    zmq_send(sock_gr_tx, typecast(r, 'uint8'), 0);
    
    %if mod(msg_cnt, update_interval) == 0    
    %    plot(lag, abs(fftshift(r))/nfft); xlim([-nfft/2 nfft/2-1]); drawnow;
    %end
    
    toc;
end  