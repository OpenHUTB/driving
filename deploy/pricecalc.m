function price = pricecalc(face_value, coupon_payment,...
                           interest_rate, num_payments)
    M = face_value;
    C = coupon_payment;
    N = num_payments;
    i = interest_rate;
    
    price = C * ( (1 - (1 + i)^-N) / i ) + M * (1 + i)^-N;

    