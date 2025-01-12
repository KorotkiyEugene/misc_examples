pkg load zeromq;
pkg load control;

fs = 1e6;
nfft = 8192;
f = linspace(-fs/2, fs/2, nfft);

sock_gr_rx = zmq_socket(ZMQ_PULL);
zmq_connect(sock_gr_rx, "tcp://127.0.0.1:5555");

msg_size_bytes = 2*nfft*2*4;

msg_cnt = 0;
update_interval = 50;

window = blackman(nfft).';

while true
    tic;
    
    recv_raw = zmq_recv(sock_gr_rx, msg_size_bytes, 0);
    msg_cnt = msg_cnt + 1;
    
    recv_complex = typecast(recv_raw, "single complex");
    
    sig1 = recv_complex(1:2:length(recv_complex)); 
    sig2 = recv_complex(2:2:length(recv_complex)); 
    
    if mod(msg_cnt, update_interval) == 0
        plot(f, fftshift(mag2db(abs(fft(sig1.*window)/nfft)))); ylim([-150 0]); hold on; drawnow;
        plot(f, fftshift(mag2db(abs(fft(sig2.*window)/nfft)))); ylim([-150 0]); hold off; drawnow; 
    end
    
    toc;
end  