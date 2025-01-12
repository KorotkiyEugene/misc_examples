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

    angles = atan2(imag(recv_complex), real(recv_complex));
    angle_changes = diff([last_angle, angles]);

    angle_changes(angle_changes > pi) -= 2 * pi;
    angle_changes(angle_changes < -pi) += 2 * pi;

    fm_demod_sig = angle_changes * fs / (2 * pi * fm_dev);

    last_angle = angles(end);    
    
    zmq_send(sock_gr_tx, typecast(single(fm_demod_sig), 'uint8'), 0);
    toc;
end
