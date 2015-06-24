function mAP = EvalAP(predict_v,Test_label)




[nSample,nClass] = size(predict_v);
if nSample < nClass
    predict_v = predict_v';
    [nSample,nClass] = size(predict_v);
end

if size(Test_label,1) == 1
    Test_label = Test_label';
end

test_label = zeros(nSample,nClass);
for i = 1:nClass
    test_label(:,i) = sign(double(Test_label == i) - 0.5);
end


AP_all = [];
for i = 1:nClass
    % AP
    [so,si]=sort(-predict_v(:,i));
    tp=test_label(si,i)>0;
    fp=test_label(si,i)<0;

    fp=cumsum(fp);
    tp=cumsum(tp);
    rec=tp/sum(test_label(:,i)>0);
    prec=tp./(fp+tp);
    ap = VOCap(rec,prec);
    AP_all = [AP_all,ap];
end
%disp(['mAP = ',num2str(mean(AP_all))])
mAP = mean(AP_all);

function ap = VOCap(rec,prec)

mrec=[0 ; rec ; 1];
mpre=[0 ; prec ; 0];
for i=numel(mpre)-1:-1:1
    mpre(i)=max(mpre(i),mpre(i+1));
end
i=find(mrec(2:end)~=mrec(1:end-1))+1;
ap=sum((mrec(i)-mrec(i-1)).*mpre(i));