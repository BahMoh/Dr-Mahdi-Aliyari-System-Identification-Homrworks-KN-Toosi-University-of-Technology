function [Y_hat,theta_save,P_save,Trace,Norm] = RLS(Y,U,theta0,reset,lambda,power,epsilon)
 P=(10^power)*eye(size(U,2));
  theta=theta0;
  for i=1:size(U,1)
         if isequal(reset,'reset_on')==1 && norm(P)<epsilon
         P=(10^power)*eye(size(U,2));
         end
       X=U(i,:);
       P=(P/lambda)*( eye(size(U,2))- (X'*X*P)/(lambda+X*P*X') );
       theta=theta-P*X'*(X*theta-Y(i,1));
       P_save{i}=P;
       Trace(i)=trace(P);
       Norm(i)=norm(P);
       theta_save(i,:)=theta';
       temp(i,1)=X*theta;
  end
Y_hat=temp;

