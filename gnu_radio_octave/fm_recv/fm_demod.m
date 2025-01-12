pkg load zeromq;

fs = 250e3;
fm_dev = 50e3; 

msg_size = 2097152;
msg_item_size_bytes = 2 * 4;
msg_size_bytes = msg_size * msg_item_size_bytes;

sock_gr_rx = zmq_socket(ZMQ_SUB);
zmq_connect(sock_gr_rx, "tcp://127.0.0.1:5555");
zmq_setsockopt(sock_gr_rx, ZMQ_SUBSCRIBE, "");

sock_gr_tx = zmq_socket(ZMQ_PUB);
zmq_bind(sock_gr_tx, "tcp://127.0.0.1:5556");

last_angle = 0;

while true
    tic;
    
    recv_raw = zmq_recv(sock_gr_rx, msg_size_bytes, 0);
    recv_complex = typecast(recv_raw, "single complex");

    sig_len = length(recv_complex);
    fm_demod_sig = zeros(1, sig_len);

    for ii = 1:sig_len
        i = real(recv_complex(ii));
        q = imag(recv_complex(ii));
        angle = atan2(q, i);

        angle_change = angle - last_angle;

        if angle_change > pi
            angle_change -= 2 * pi;
        elseif angle_change < -pi
            angle_change += 2 * pi;
        end

        last_angle = angle;

        fm_demod_sig(ii) = angle_change * fs / (2 * pi * fm_dev);
    end
    
    zmq_send(sock_gr_tx, typecast(single(fm_demod_sig), 'uint8'), 0);
    toc;
    
end
