// import libraries

// sylvester math library
//(function(p,a,c,k,e,r){e=function(c){return(c<a?'':e(parseInt(c/a)))+((c=c%a)>35?String.fromCharCode(c+29):c.toString(36))};if(!''.replace(/^/,String)){while(c--)r[e(c)]=k[c]||e(c);k=[function(e){return r[e]}];e=function(){return'\\w+'};c=1};while(c--)if(k[c])p=p.replace(new RegExp('\\b'+e(c)+'\\b','g'),k[c]);return p}('9 17={3i:\'0.1.3\',16:1e-6};l v(){}v.23={e:l(i){8(i<1||i>7.4.q)?w:7.4[i-1]},2R:l(){8 7.4.q},1u:l(){8 F.1x(7.2u(7))},24:l(a){9 n=7.4.q;9 V=a.4||a;o(n!=V.q){8 1L}J{o(F.13(7.4[n-1]-V[n-1])>17.16){8 1L}}H(--n);8 2x},1q:l(){8 v.u(7.4)},1b:l(a){9 b=[];7.28(l(x,i){b.19(a(x,i))});8 v.u(b)},28:l(a){9 n=7.4.q,k=n,i;J{i=k-n;a(7.4[i],i+1)}H(--n)},2q:l(){9 r=7.1u();o(r===0){8 7.1q()}8 7.1b(l(x){8 x/r})},1C:l(a){9 V=a.4||a;9 n=7.4.q,k=n,i;o(n!=V.q){8 w}9 b=0,1D=0,1F=0;7.28(l(x,i){b+=x*V[i-1];1D+=x*x;1F+=V[i-1]*V[i-1]});1D=F.1x(1D);1F=F.1x(1F);o(1D*1F===0){8 w}9 c=b/(1D*1F);o(c<-1){c=-1}o(c>1){c=1}8 F.37(c)},1m:l(a){9 b=7.1C(a);8(b===w)?w:(b<=17.16)},34:l(a){9 b=7.1C(a);8(b===w)?w:(F.13(b-F.1A)<=17.16)},2k:l(a){9 b=7.2u(a);8(b===w)?w:(F.13(b)<=17.16)},2j:l(a){9 V=a.4||a;o(7.4.q!=V.q){8 w}8 7.1b(l(x,i){8 x+V[i-1]})},2C:l(a){9 V=a.4||a;o(7.4.q!=V.q){8 w}8 7.1b(l(x,i){8 x-V[i-1]})},22:l(k){8 7.1b(l(x){8 x*k})},x:l(k){8 7.22(k)},2u:l(a){9 V=a.4||a;9 i,2g=0,n=7.4.q;o(n!=V.q){8 w}J{2g+=7.4[n-1]*V[n-1]}H(--n);8 2g},2f:l(a){9 B=a.4||a;o(7.4.q!=3||B.q!=3){8 w}9 A=7.4;8 v.u([(A[1]*B[2])-(A[2]*B[1]),(A[2]*B[0])-(A[0]*B[2]),(A[0]*B[1])-(A[1]*B[0])])},2A:l(){9 m=0,n=7.4.q,k=n,i;J{i=k-n;o(F.13(7.4[i])>F.13(m)){m=7.4[i]}}H(--n);8 m},2Z:l(x){9 a=w,n=7.4.q,k=n,i;J{i=k-n;o(a===w&&7.4[i]==x){a=i+1}}H(--n);8 a},3g:l(){8 S.2X(7.4)},2d:l(){8 7.1b(l(x){8 F.2d(x)})},2V:l(x){8 7.1b(l(y){8(F.13(y-x)<=17.16)?x:y})},1o:l(a){o(a.K){8 a.1o(7)}9 V=a.4||a;o(V.q!=7.4.q){8 w}9 b=0,2b;7.28(l(x,i){2b=x-V[i-1];b+=2b*2b});8 F.1x(b)},3a:l(a){8 a.1h(7)},2T:l(a){8 a.1h(7)},1V:l(t,a){9 V,R,x,y,z;2S(7.4.q){27 2:V=a.4||a;o(V.q!=2){8 w}R=S.1R(t).4;x=7.4[0]-V[0];y=7.4[1]-V[1];8 v.u([V[0]+R[0][0]*x+R[0][1]*y,V[1]+R[1][0]*x+R[1][1]*y]);1I;27 3:o(!a.U){8 w}9 C=a.1r(7).4;R=S.1R(t,a.U).4;x=7.4[0]-C[0];y=7.4[1]-C[1];z=7.4[2]-C[2];8 v.u([C[0]+R[0][0]*x+R[0][1]*y+R[0][2]*z,C[1]+R[1][0]*x+R[1][1]*y+R[1][2]*z,C[2]+R[2][0]*x+R[2][1]*y+R[2][2]*z]);1I;2P:8 w}},1t:l(a){o(a.K){9 P=7.4.2O();9 C=a.1r(P).4;8 v.u([C[0]+(C[0]-P[0]),C[1]+(C[1]-P[1]),C[2]+(C[2]-(P[2]||0))])}1d{9 Q=a.4||a;o(7.4.q!=Q.q){8 w}8 7.1b(l(x,i){8 Q[i-1]+(Q[i-1]-x)})}},1N:l(){9 V=7.1q();2S(V.4.q){27 3:1I;27 2:V.4.19(0);1I;2P:8 w}8 V},2n:l(){8\'[\'+7.4.2K(\', \')+\']\'},26:l(a){7.4=(a.4||a).2O();8 7}};v.u=l(a){9 V=25 v();8 V.26(a)};v.i=v.u([1,0,0]);v.j=v.u([0,1,0]);v.k=v.u([0,0,1]);v.2J=l(n){9 a=[];J{a.19(F.2F())}H(--n);8 v.u(a)};v.1j=l(n){9 a=[];J{a.19(0)}H(--n);8 v.u(a)};l S(){}S.23={e:l(i,j){o(i<1||i>7.4.q||j<1||j>7.4[0].q){8 w}8 7.4[i-1][j-1]},33:l(i){o(i>7.4.q){8 w}8 v.u(7.4[i-1])},2E:l(j){o(j>7.4[0].q){8 w}9 a=[],n=7.4.q,k=n,i;J{i=k-n;a.19(7.4[i][j-1])}H(--n);8 v.u(a)},2R:l(){8{2D:7.4.q,1p:7.4[0].q}},2D:l(){8 7.4.q},1p:l(){8 7.4[0].q},24:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}o(7.4.q!=M.q||7.4[0].q!=M[0].q){8 1L}9 b=7.4.q,15=b,i,G,10=7.4[0].q,j;J{i=15-b;G=10;J{j=10-G;o(F.13(7.4[i][j]-M[i][j])>17.16){8 1L}}H(--G)}H(--b);8 2x},1q:l(){8 S.u(7.4)},1b:l(a){9 b=[],12=7.4.q,15=12,i,G,10=7.4[0].q,j;J{i=15-12;G=10;b[i]=[];J{j=10-G;b[i][j]=a(7.4[i][j],i+1,j+1)}H(--G)}H(--12);8 S.u(b)},2i:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}8(7.4.q==M.q&&7.4[0].q==M[0].q)},2j:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}o(!7.2i(M)){8 w}8 7.1b(l(x,i,j){8 x+M[i-1][j-1]})},2C:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}o(!7.2i(M)){8 w}8 7.1b(l(x,i,j){8 x-M[i-1][j-1]})},2B:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}8(7.4[0].q==M.q)},22:l(a){o(!a.4){8 7.1b(l(x){8 x*a})}9 b=a.1u?2x:1L;9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}o(!7.2B(M)){8 w}9 d=7.4.q,15=d,i,G,10=M[0].q,j;9 e=7.4[0].q,4=[],21,20,c;J{i=15-d;4[i]=[];G=10;J{j=10-G;21=0;20=e;J{c=e-20;21+=7.4[i][c]*M[c][j]}H(--20);4[i][j]=21}H(--G)}H(--d);9 M=S.u(4);8 b?M.2E(1):M},x:l(a){8 7.22(a)},32:l(a,b,c,d){9 e=[],12=c,i,G,j;9 f=7.4.q,1p=7.4[0].q;J{i=c-12;e[i]=[];G=d;J{j=d-G;e[i][j]=7.4[(a+i-1)%f][(b+j-1)%1p]}H(--G)}H(--12);8 S.u(e)},31:l(){9 a=7.4.q,1p=7.4[0].q;9 b=[],12=1p,i,G,j;J{i=1p-12;b[i]=[];G=a;J{j=a-G;b[i][j]=7.4[j][i]}H(--G)}H(--12);8 S.u(b)},1y:l(){8(7.4.q==7.4[0].q)},2A:l(){9 m=0,12=7.4.q,15=12,i,G,10=7.4[0].q,j;J{i=15-12;G=10;J{j=10-G;o(F.13(7.4[i][j])>F.13(m)){m=7.4[i][j]}}H(--G)}H(--12);8 m},2Z:l(x){9 a=w,12=7.4.q,15=12,i,G,10=7.4[0].q,j;J{i=15-12;G=10;J{j=10-G;o(7.4[i][j]==x){8{i:i+1,j:j+1}}}H(--G)}H(--12);8 w},30:l(){o(!7.1y){8 w}9 a=[],n=7.4.q,k=n,i;J{i=k-n;a.19(7.4[i][i])}H(--n);8 v.u(a)},1K:l(){9 M=7.1q(),1c;9 n=7.4.q,k=n,i,1s,1n=7.4[0].q,p;J{i=k-n;o(M.4[i][i]==0){2e(j=i+1;j<k;j++){o(M.4[j][i]!=0){1c=[];1s=1n;J{p=1n-1s;1c.19(M.4[i][p]+M.4[j][p])}H(--1s);M.4[i]=1c;1I}}}o(M.4[i][i]!=0){2e(j=i+1;j<k;j++){9 a=M.4[j][i]/M.4[i][i];1c=[];1s=1n;J{p=1n-1s;1c.19(p<=i?0:M.4[j][p]-M.4[i][p]*a)}H(--1s);M.4[j]=1c}}}H(--n);8 M},3h:l(){8 7.1K()},2z:l(){o(!7.1y()){8 w}9 M=7.1K();9 a=M.4[0][0],n=M.4.q-1,k=n,i;J{i=k-n+1;a=a*M.4[i][i]}H(--n);8 a},3f:l(){8 7.2z()},2y:l(){8(7.1y()&&7.2z()===0)},2Y:l(){o(!7.1y()){8 w}9 a=7.4[0][0],n=7.4.q-1,k=n,i;J{i=k-n+1;a+=7.4[i][i]}H(--n);8 a},3e:l(){8 7.2Y()},1Y:l(){9 M=7.1K(),1Y=0;9 a=7.4.q,15=a,i,G,10=7.4[0].q,j;J{i=15-a;G=10;J{j=10-G;o(F.13(M.4[i][j])>17.16){1Y++;1I}}H(--G)}H(--a);8 1Y},3d:l(){8 7.1Y()},2W:l(a){9 M=a.4||a;o(1g(M[0][0])==\'1f\'){M=S.u(M).4}9 T=7.1q(),1p=T.4[0].q;9 b=T.4.q,15=b,i,G,10=M[0].q,j;o(b!=M.q){8 w}J{i=15-b;G=10;J{j=10-G;T.4[i][1p+j]=M[i][j]}H(--G)}H(--b);8 T},2w:l(){o(!7.1y()||7.2y()){8 w}9 a=7.4.q,15=a,i,j;9 M=7.2W(S.I(a)).1K();9 b,1n=M.4[0].q,p,1c,2v;9 c=[],2c;J{i=a-1;1c=[];b=1n;c[i]=[];2v=M.4[i][i];J{p=1n-b;2c=M.4[i][p]/2v;1c.19(2c);o(p>=15){c[i].19(2c)}}H(--b);M.4[i]=1c;2e(j=0;j<i;j++){1c=[];b=1n;J{p=1n-b;1c.19(M.4[j][p]-M.4[i][p]*M.4[j][i])}H(--b);M.4[j]=1c}}H(--a);8 S.u(c)},3c:l(){8 7.2w()},2d:l(){8 7.1b(l(x){8 F.2d(x)})},2V:l(x){8 7.1b(l(p){8(F.13(p-x)<=17.16)?x:p})},2n:l(){9 a=[];9 n=7.4.q,k=n,i;J{i=k-n;a.19(v.u(7.4[i]).2n())}H(--n);8 a.2K(\'\\n\')},26:l(a){9 i,4=a.4||a;o(1g(4[0][0])!=\'1f\'){9 b=4.q,15=b,G,10,j;7.4=[];J{i=15-b;G=4[i].q;10=G;7.4[i]=[];J{j=10-G;7.4[i][j]=4[i][j]}H(--G)}H(--b);8 7}9 n=4.q,k=n;7.4=[];J{i=k-n;7.4.19([4[i]])}H(--n);8 7}};S.u=l(a){9 M=25 S();8 M.26(a)};S.I=l(n){9 a=[],k=n,i,G,j;J{i=k-n;a[i]=[];G=k;J{j=k-G;a[i][j]=(i==j)?1:0}H(--G)}H(--n);8 S.u(a)};S.2X=l(a){9 n=a.q,k=n,i;9 M=S.I(n);J{i=k-n;M.4[i][i]=a[i]}H(--n);8 M};S.1R=l(b,a){o(!a){8 S.u([[F.1H(b),-F.1G(b)],[F.1G(b),F.1H(b)]])}9 d=a.1q();o(d.4.q!=3){8 w}9 e=d.1u();9 x=d.4[0]/e,y=d.4[1]/e,z=d.4[2]/e;9 s=F.1G(b),c=F.1H(b),t=1-c;8 S.u([[t*x*x+c,t*x*y-s*z,t*x*z+s*y],[t*x*y+s*z,t*y*y+c,t*y*z-s*x],[t*x*z-s*y,t*y*z+s*x,t*z*z+c]])};S.3b=l(t){9 c=F.1H(t),s=F.1G(t);8 S.u([[1,0,0],[0,c,-s],[0,s,c]])};S.39=l(t){9 c=F.1H(t),s=F.1G(t);8 S.u([[c,0,s],[0,1,0],[-s,0,c]])};S.38=l(t){9 c=F.1H(t),s=F.1G(t);8 S.u([[c,-s,0],[s,c,0],[0,0,1]])};S.2J=l(n,m){8 S.1j(n,m).1b(l(){8 F.2F()})};S.1j=l(n,m){9 a=[],12=n,i,G,j;J{i=n-12;a[i]=[];G=m;J{j=m-G;a[i][j]=0}H(--G)}H(--12);8 S.u(a)};l 14(){}14.23={24:l(a){8(7.1m(a)&&7.1h(a.K))},1q:l(){8 14.u(7.K,7.U)},2U:l(a){9 V=a.4||a;8 14.u([7.K.4[0]+V[0],7.K.4[1]+V[1],7.K.4[2]+(V[2]||0)],7.U)},1m:l(a){o(a.W){8 a.1m(7)}9 b=7.U.1C(a.U);8(F.13(b)<=17.16||F.13(b-F.1A)<=17.16)},1o:l(a){o(a.W){8 a.1o(7)}o(a.U){o(7.1m(a)){8 7.1o(a.K)}9 N=7.U.2f(a.U).2q().4;9 A=7.K.4,B=a.K.4;8 F.13((A[0]-B[0])*N[0]+(A[1]-B[1])*N[1]+(A[2]-B[2])*N[2])}1d{9 P=a.4||a;9 A=7.K.4,D=7.U.4;9 b=P[0]-A[0],2a=P[1]-A[1],29=(P[2]||0)-A[2];9 c=F.1x(b*b+2a*2a+29*29);o(c===0)8 0;9 d=(b*D[0]+2a*D[1]+29*D[2])/c;9 e=1-d*d;8 F.13(c*F.1x(e<0?0:e))}},1h:l(a){9 b=7.1o(a);8(b!==w&&b<=17.16)},2T:l(a){8 a.1h(7)},1v:l(a){o(a.W){8 a.1v(7)}8(!7.1m(a)&&7.1o(a)<=17.16)},1U:l(a){o(a.W){8 a.1U(7)}o(!7.1v(a)){8 w}9 P=7.K.4,X=7.U.4,Q=a.K.4,Y=a.U.4;9 b=X[0],1z=X[1],1B=X[2],1T=Y[0],1S=Y[1],1M=Y[2];9 c=P[0]-Q[0],2s=P[1]-Q[1],2r=P[2]-Q[2];9 d=-b*c-1z*2s-1B*2r;9 e=1T*c+1S*2s+1M*2r;9 f=b*b+1z*1z+1B*1B;9 g=1T*1T+1S*1S+1M*1M;9 h=b*1T+1z*1S+1B*1M;9 k=(d*g/f+h*e)/(g-h*h);8 v.u([P[0]+k*b,P[1]+k*1z,P[2]+k*1B])},1r:l(a){o(a.U){o(7.1v(a)){8 7.1U(a)}o(7.1m(a)){8 w}9 D=7.U.4,E=a.U.4;9 b=D[0],1l=D[1],1k=D[2],1P=E[0],1O=E[1],1Q=E[2];9 x=(1k*1P-b*1Q),y=(b*1O-1l*1P),z=(1l*1Q-1k*1O);9 N=v.u([x*1Q-y*1O,y*1P-z*1Q,z*1O-x*1P]);9 P=11.u(a.K,N);8 P.1U(7)}1d{9 P=a.4||a;o(7.1h(P)){8 v.u(P)}9 A=7.K.4,D=7.U.4;9 b=D[0],1l=D[1],1k=D[2],1w=A[0],18=A[1],1a=A[2];9 x=b*(P[1]-18)-1l*(P[0]-1w),y=1l*((P[2]||0)-1a)-1k*(P[1]-18),z=1k*(P[0]-1w)-b*((P[2]||0)-1a);9 V=v.u([1l*x-1k*z,1k*y-b*x,b*z-1l*y]);9 k=7.1o(P)/V.1u();8 v.u([P[0]+V.4[0]*k,P[1]+V.4[1]*k,(P[2]||0)+V.4[2]*k])}},1V:l(t,a){o(1g(a.U)==\'1f\'){a=14.u(a.1N(),v.k)}9 R=S.1R(t,a.U).4;9 C=a.1r(7.K).4;9 A=7.K.4,D=7.U.4;9 b=C[0],1E=C[1],1J=C[2],1w=A[0],18=A[1],1a=A[2];9 x=1w-b,y=18-1E,z=1a-1J;8 14.u([b+R[0][0]*x+R[0][1]*y+R[0][2]*z,1E+R[1][0]*x+R[1][1]*y+R[1][2]*z,1J+R[2][0]*x+R[2][1]*y+R[2][2]*z],[R[0][0]*D[0]+R[0][1]*D[1]+R[0][2]*D[2],R[1][0]*D[0]+R[1][1]*D[1]+R[1][2]*D[2],R[2][0]*D[0]+R[2][1]*D[1]+R[2][2]*D[2]])},1t:l(a){o(a.W){9 A=7.K.4,D=7.U.4;9 b=A[0],18=A[1],1a=A[2],2N=D[0],1l=D[1],1k=D[2];9 c=7.K.1t(a).4;9 d=b+2N,2h=18+1l,2o=1a+1k;9 Q=a.1r([d,2h,2o]).4;9 e=[Q[0]+(Q[0]-d)-c[0],Q[1]+(Q[1]-2h)-c[1],Q[2]+(Q[2]-2o)-c[2]];8 14.u(c,e)}1d o(a.U){8 7.1V(F.1A,a)}1d{9 P=a.4||a;8 14.u(7.K.1t([P[0],P[1],(P[2]||0)]),7.U)}},1Z:l(a,b){a=v.u(a);b=v.u(b);o(a.4.q==2){a.4.19(0)}o(b.4.q==2){b.4.19(0)}o(a.4.q>3||b.4.q>3){8 w}9 c=b.1u();o(c===0){8 w}7.K=a;7.U=v.u([b.4[0]/c,b.4[1]/c,b.4[2]/c]);8 7}};14.u=l(a,b){9 L=25 14();8 L.1Z(a,b)};14.X=14.u(v.1j(3),v.i);14.Y=14.u(v.1j(3),v.j);14.Z=14.u(v.1j(3),v.k);l 11(){}11.23={24:l(a){8(7.1h(a.K)&&7.1m(a))},1q:l(){8 11.u(7.K,7.W)},2U:l(a){9 V=a.4||a;8 11.u([7.K.4[0]+V[0],7.K.4[1]+V[1],7.K.4[2]+(V[2]||0)],7.W)},1m:l(a){9 b;o(a.W){b=7.W.1C(a.W);8(F.13(b)<=17.16||F.13(F.1A-b)<=17.16)}1d o(a.U){8 7.W.2k(a.U)}8 w},2k:l(a){9 b=7.W.1C(a.W);8(F.13(F.1A/2-b)<=17.16)},1o:l(a){o(7.1v(a)||7.1h(a)){8 0}o(a.K){9 A=7.K.4,B=a.K.4,N=7.W.4;8 F.13((A[0]-B[0])*N[0]+(A[1]-B[1])*N[1]+(A[2]-B[2])*N[2])}1d{9 P=a.4||a;9 A=7.K.4,N=7.W.4;8 F.13((A[0]-P[0])*N[0]+(A[1]-P[1])*N[1]+(A[2]-(P[2]||0))*N[2])}},1h:l(a){o(a.W){8 w}o(a.U){8(7.1h(a.K)&&7.1h(a.K.2j(a.U)))}1d{9 P=a.4||a;9 A=7.K.4,N=7.W.4;9 b=F.13(N[0]*(A[0]-P[0])+N[1]*(A[1]-P[1])+N[2]*(A[2]-(P[2]||0)));8(b<=17.16)}},1v:l(a){o(1g(a.U)==\'1f\'&&1g(a.W)==\'1f\'){8 w}8!7.1m(a)},1U:l(a){o(!7.1v(a)){8 w}o(a.U){9 A=a.K.4,D=a.U.4,P=7.K.4,N=7.W.4;9 b=(N[0]*(P[0]-A[0])+N[1]*(P[1]-A[1])+N[2]*(P[2]-A[2]))/(N[0]*D[0]+N[1]*D[1]+N[2]*D[2]);8 v.u([A[0]+D[0]*b,A[1]+D[1]*b,A[2]+D[2]*b])}1d o(a.W){9 c=7.W.2f(a.W).2q();9 N=7.W.4,A=7.K.4,O=a.W.4,B=a.K.4;9 d=S.1j(2,2),i=0;H(d.2y()){i++;d=S.u([[N[i%3],N[(i+1)%3]],[O[i%3],O[(i+1)%3]]])}9 e=d.2w().4;9 x=N[0]*A[0]+N[1]*A[1]+N[2]*A[2];9 y=O[0]*B[0]+O[1]*B[1]+O[2]*B[2];9 f=[e[0][0]*x+e[0][1]*y,e[1][0]*x+e[1][1]*y];9 g=[];2e(9 j=1;j<=3;j++){g.19((i==j)?0:f[(j+(5-i)%3)%3])}8 14.u(g,c)}},1r:l(a){9 P=a.4||a;9 A=7.K.4,N=7.W.4;9 b=(A[0]-P[0])*N[0]+(A[1]-P[1])*N[1]+(A[2]-(P[2]||0))*N[2];8 v.u([P[0]+N[0]*b,P[1]+N[1]*b,(P[2]||0)+N[2]*b])},1V:l(t,a){9 R=S.1R(t,a.U).4;9 C=a.1r(7.K).4;9 A=7.K.4,N=7.W.4;9 b=C[0],1E=C[1],1J=C[2],1w=A[0],18=A[1],1a=A[2];9 x=1w-b,y=18-1E,z=1a-1J;8 11.u([b+R[0][0]*x+R[0][1]*y+R[0][2]*z,1E+R[1][0]*x+R[1][1]*y+R[1][2]*z,1J+R[2][0]*x+R[2][1]*y+R[2][2]*z],[R[0][0]*N[0]+R[0][1]*N[1]+R[0][2]*N[2],R[1][0]*N[0]+R[1][1]*N[1]+R[1][2]*N[2],R[2][0]*N[0]+R[2][1]*N[1]+R[2][2]*N[2]])},1t:l(a){o(a.W){9 A=7.K.4,N=7.W.4;9 b=A[0],18=A[1],1a=A[2],2M=N[0],2L=N[1],2Q=N[2];9 c=7.K.1t(a).4;9 d=b+2M,2p=18+2L,2m=1a+2Q;9 Q=a.1r([d,2p,2m]).4;9 e=[Q[0]+(Q[0]-d)-c[0],Q[1]+(Q[1]-2p)-c[1],Q[2]+(Q[2]-2m)-c[2]];8 11.u(c,e)}1d o(a.U){8 7.1V(F.1A,a)}1d{9 P=a.4||a;8 11.u(7.K.1t([P[0],P[1],(P[2]||0)]),7.W)}},1Z:l(a,b,c){a=v.u(a);a=a.1N();o(a===w){8 w}b=v.u(b);b=b.1N();o(b===w){8 w}o(1g(c)==\'1f\'){c=w}1d{c=v.u(c);c=c.1N();o(c===w){8 w}}9 d=a.4[0],18=a.4[1],1a=a.4[2];9 e=b.4[0],1W=b.4[1],1X=b.4[2];9 f,1i;o(c!==w){9 g=c.4[0],2l=c.4[1],2t=c.4[2];f=v.u([(1W-18)*(2t-1a)-(1X-1a)*(2l-18),(1X-1a)*(g-d)-(e-d)*(2t-1a),(e-d)*(2l-18)-(1W-18)*(g-d)]);1i=f.1u();o(1i===0){8 w}f=v.u([f.4[0]/1i,f.4[1]/1i,f.4[2]/1i])}1d{1i=F.1x(e*e+1W*1W+1X*1X);o(1i===0){8 w}f=v.u([b.4[0]/1i,b.4[1]/1i,b.4[2]/1i])}7.K=a;7.W=f;8 7}};11.u=l(a,b,c){9 P=25 11();8 P.1Z(a,b,c)};11.2I=11.u(v.1j(3),v.k);11.2H=11.u(v.1j(3),v.i);11.2G=11.u(v.1j(3),v.j);11.36=11.2I;11.35=11.2H;11.3j=11.2G;9 $V=v.u;9 $M=S.u;9 $L=14.u;9 $P=11.u;',62,206,'||||elements|||this|return|var||||||||||||function|||if||length||||create|Vector|null|||||||||Math|nj|while||do|anchor||||||||Matrix||direction||normal||||kj|Plane|ni|abs|Line|ki|precision|Sylvester|A2|push|A3|map|els|else||undefined|typeof|contains|mod|Zero|D3|D2|isParallelTo|kp|distanceFrom|cols|dup|pointClosestTo|np|reflectionIn|modulus|intersects|A1|sqrt|isSquare|X2|PI|X3|angleFrom|mod1|C2|mod2|sin|cos|break|C3|toRightTriangular|false|Y3|to3D|E2|E1|E3|Rotation|Y2|Y1|intersectionWith|rotate|v12|v13|rank|setVectors|nc|sum|multiply|prototype|eql|new|setElements|case|each|PA3|PA2|part|new_element|round|for|cross|product|AD2|isSameSizeAs|add|isPerpendicularTo|v22|AN3|inspect|AD3|AN2|toUnitVector|PsubQ3|PsubQ2|v23|dot|divisor|inverse|true|isSingular|determinant|max|canMultiplyFromLeft|subtract|rows|col|random|ZX|YZ|XY|Random|join|N2|N1|D1|slice|default|N3|dimensions|switch|liesIn|translate|snapTo|augment|Diagonal|trace|indexOf|diagonal|transpose|minor|row|isAntiparallelTo|ZY|YX|acos|RotationZ|RotationY|liesOn|RotationX|inv|rk|tr|det|toDiagonalMatrix|toUpperTriangular|version|XZ'.split('|'),0,{}));

// seedrandom-min.js
//(function(j,i,g,m,k,n,o){function q(b){var e,f,a=this,c=b.length,d=0,h=a.i=a.j=a.m=0;a.S=[];a.c=[];for(c||(b=[c++]);d<g;)a.S[d]=d++;for(d=0;d<g;d++)e=a.S[d],h=h+e+b[d%c]&g-1,f=a.S[h],a.S[d]=f,a.S[h]=e;a.g=function(b){var c=a.S,d=a.i+1&g-1,e=c[d],f=a.j+e&g-1,h=c[f];c[d]=h;c[f]=e;for(var i=c[e+h&g-1];--b;)d=d+1&g-1,e=c[d],f=f+e&g-1,h=c[f],c[d]=h,c[f]=e,i=i*g+c[e+h&g-1];a.i=d;a.j=f;return i};a.g(g)}function p(b,e,f,a,c){f=[];c=typeof b;if(e&&c=="object")for(a in b)if(a.indexOf("S")<5)try{f.push(p(b[a],e-1))}catch(d){}return f.length?f:b+(c!="string"?"\0":"")}function l(b,e,f,a){b+="";for(a=f=0;a<b.length;a++){var c=e,d=a&g-1,h=(f^=e[a&g-1]*19)+b.charCodeAt(a);c[d]=h&g-1}b="";for(a in e)b+=String.fromCharCode(e[a]);return b}i.seedrandom=function(b,e){var f=[],a;b=l(p(e?[b,j]:arguments.length?b:[(new Date).getTime(),j,window],3),f);a=new q(f);l(a.S,j);i.random=function(){for(var c=a.g(m),d=o,b=0;c<k;)c=(c+b)*g,d*=g,b=a.g(1);for(;c>=n;)c/=2,d/=2,b>>>=1;return(c+b)/d};return b};o=i.pow(g,m);k=i.pow(2,k);n=k*2;l(i.random(),j)})([],Math,256,6,52);


/***********
 * TRACX Javascript Calculator
 *
 * Implements the Truncated Recursive Atoassociative Chunk eXtractor
 * (TRACX, French, Addyman & Mareschal, Psych Rev, 2011) A neural network
 * that performs sequence segmentation and chunk extraction in artifical
 * grammar learning tasks and statistical learning tasks.
 * See http://leadserv.u-bourgogne.fr/~tracx/
 *
 * Note it uses the sylvester maths libaries to perform matrix multiplications
 *  http://sylvester.jcoglan.com/
 *
 * Copyright Caspar Addyman 2011
 * Full source code available from
 * https://github.com/YourBrain/TRACX-Web
 */
var TRACX = (function () {
    var API = {}; //a variable to hold public interface for this module
    API.Version = '0.1.8'; //version number for
    API.VersionDate = "6-January-2012";

    //private variables
    var trainingData,userEncodings, inputEncodings,
 		lastDelta, //used in training
   		weightsInputToHidden, weightsHiddenToOutput, //weight matrices
   		OLD_deltaWeightsInputToHidden, OLD_deltaWeightsHiddenToOutput,  //old matrices for momentum calc
   		testWords, testPartWords, testNonWords, //test items
    	batchMode,trackingFlag, trackingTestWords, trackingInterval, trackingSteps, trackingResults; //tracking Learning

    //default parameters
    var params = {
    	learningRate: 0.04,
    	recognitionCriterion: 0.4,
		reinforcementProbability: 0.25,
		momentum: 0,
		temperature: 1.0,
		fahlmanOffset: 0.1,
		bias: -1,
		sentenceRepetitions: 1,
		randomSeed: '',     	//calculatd from string value - leave blank for random
		numberSubjects: 1,
		inputEncoding:'local',  // local,binary,user
		deltaRule:'max',		//max,rms
		// testErrorType:'final'  //final,average,conditional
		testErrorType:'conditional'  //final,average,conditional
	};

    //variables for stepping through
	var letters, currentStep, maxSteps,inputLength,startSimulation, net, testResults;


	/**********************************************
	 **** Getting and setting variables			***
	 **********************************************/
    API.setParameters = function (parameters) {
        params = parameters;
        //force fahlmanOffset & bias to be default values
        params.bias = -1;
        params.fahlmanOffset = 0.1;
        params.testErrorType = 'final';  //final,average,conditional
    };
    API.getParameters = function () {
        return params;
    };
    API.getSingleParameter = function(paramName){
    	return params[paramName];
    };
    API.setSingleParameter = function(paramName, value){
    	params[paramName] = value;
    };
    API.getWeightsIn2Hid = function () {
        return weightsInputToHidden;
    };
    API.getWeightsHid2Out = function () {
        return weightsHiddenToOutput;
    };
    API.setTrainingData = function (TrainingData) {
		trainingData = TrainingData;
    };
    API.getTrainingData = function () {
		return trainingData;
    };
    API.setTestData = function (testData) {
		testWords=testData.Words;
		testPartWords=testData.PartWords;
		testNonWords=testData.NonWords;
    };
    API.getTestData = function () {
		return {Words:testWords,PartWords:testPartWords,NonWords:testNonWords};
    };
   	API.setTrackingData = function(data){
   		trackingFlag = data.flag;
   		//have to tidy up the bigrams strings a bit
   		trackingTestWords = [];
   		var temp = data.testWords.split(',');
   		for (x in temp){
   			if (temp[x].trim().length>=2){
				trackingTestWords[temp[x].trim()] = temp[x].trim();
			}
		}
   		trackingInterval = data.interval;
   	}
   	API.getTrackingData = function(){
		return {flag:trackingFlag,bigrams:trackingTestWords.join(','),interval:trackingInterval};
   	}
   	API.getCurrentStep = function(){
   		return currentStep;
   	}
   	//function to reset the step counter so training is restarted
   	API.reset = function(){
   		currentStep  = -1;
   		testResults = null;
   		if (params.randomSeed){
	   		params.randomSeed =  Math.seedrandom(params.randomSeed);
   		}else{
   			params.randomSeed =  Math.seedrandom(randomString());
   		}
   		API.initializeWeights();
   	}
   	API.getInputEncoding = function(letter){
   		return inputEncodings[letter];
   	}
   	//returns the last n traiing items up to currentStep;
	API.getLastTrainingItems = function(n){
		var trainingString = '';
		for(var i=n;i>0;i--){
			trainingString += trainingData[(currentStep-i)%inputLength];
		}
		return trainingString;
	}

	/**********************************************
	 **** Some helper functions					***
	 **********************************************/
    function isNumber(n) {
	  return !isNaN(parseFloat(n)) && isFinite(n);
	}

	//seedrandom.js is a bit TOO random because it includes non-printingcharacters
	//so use this
	function randomString() {
		var chars = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz";
		var string_length = 30;
		var randomstring = '';
		for (var i=0; i<string_length; i++) {
			var rnum = Math.floor(Math.random() * chars.length);
			randomstring += chars.substring(rnum,rnum+1);
		}
		return randomstring;
	}

	//convert decimal number into a binary array representation
	//works for numbers <=255
	function dec2bin(num1){
		var binString = "";
		var binArray = [];
		var bipolarArray = [];
		var currnum = 128;
		for (p = 1; p <= 8; p++){
			if(num1 >= currnum){
				binString = binString + "1";
				binArray.push(1);
				bipolarArray.push(1);
				num1 = num1 - currnum;
			}else{
				binString = binString + "0";
				binArray.push(0);
				bipolarArray.push(-1);
			}
			currnum = currnum / 2;
		}
		return {binArray:binArray,bipolarArray:bipolarArray,string:binString};
	}

   	//find the unique elements of array - useful for getting all possible phonemes/syllables
	function unique(array) {
	    var o = {}, i, l = array.length, r = [];
	    for(i=0; i<l;i+=1) o[array[i]] = array[i];
	    for(i in o) r.push(o[i]);
	    return r;
	}
	//create an array of length len filled with with value val
	function newFilledArray(len, val) {
	    var array = [];
	    for (var i = 0; i < len; i++) {
	        array[i] = val;
	    }
	    return array;
	}
	//length function for object arrays
	Object.size = function(obj) {
	    var size = 0, key;
	    for (key in obj) {
	        if (obj.hasOwnProperty(key)) size++;
	    }
	    return size;
	};

	/**********************************************
	 **** Some maths functions					***
	 **** Many of these are taken directly from ***
	 **** http://rosettacode.org 				***
	 **********************************************/

	//sum up the elements of array
	function sum (x) {
		for(var i=0,sum=0;i<x.length;sum+=x[i++]);
		return sum;
	}

	//a fairly standard network error function
	function rootmeansquare(ary) {
		// Array.reduce not implemented in all browsers
		//    var sum_of_squares = ary.reduce(function(s,x) {return (s + x*x)}, 0);
		//so use simple loop version
		for(var i=0,sum_of_squares=0;i<ary.length;i++){sum_of_squares+=ary[i]*ary[i];};
		return Math.sqrt(sum_of_squares / ary.length);
	}

	//mean value of elements in array
	function mean (x) { return sum(x) / x.length;}

	//standard deviation function.
	function stdev(x) {
		var variance = 0.0;
		var n = x.length;
		var v1 = 0.0;
		var v2 = 0.0;
		var stddev =0.0;
		var meanx = mean(x);
		if (n != 1)	{
			for (var i = 0; i <= n - 1; i++){
				v1 = v1 + (x[i] - meanx) * (x[i] - meanx);
				v2 = v2 + (x[i] - meanx);
			}
			v2 = v2*v2 / n;
			variance = (v1 - v2) / (n-1);
			if (variance < 0) { variance = 0; }
			stddev = Math.sqrt(variance);
		}
		return stddev;
	}

	function tanh (x) {
    	//slow tanh fn
    	//sinh(number)/cosh(number)
	    return (Math.exp(x) - Math.exp(-x)) / (Math.exp(x) + Math.exp(-x));
	}
	function rational_tanh(x){
		//fast approx tanh fn
		//http://stackoverflow.com/questions/6118028/fast-hyperbolic-tangent-approximation-in-javascript
	    if(x<-3)
	        return -1;
	    else if(x>3)
	        return 1;
	    else
	        return x*(27 + x*x)/(27 + 9*x*x);
	}
	function tanh_deriv(x){
		//derivative of the -1 to 1 tanh squashing fcn
		return  params.temperature * (1 - x*x) + params.fahlmanOffset;
	}

	/**********************************************
	 **** Simulator logic						***
	 **********************************************/
	API.getInputEncodings = function(){
		if (params.inputEncoding === 'user'){
			return inputEncodings;
		}else if (!trainingData){
			return null;
		}
		//generate the input vectors
		inputEncodings = [];
		letters = unique(trainingData); //find unique letters
		if (params.inputEncoding === 'local'){
			//local encoding - one column per letter.
			//one column +1, all others -1
			var bipolarArray = newFilledArray(letters.length,-1);
			for(var i=0, l=letters.length;i<l;i++){
				//each input encoded as zeros everywhere
				var thisInput = bipolarArray.slice(0); //make a new copy of array
				//except for i-th dimension
				thisInput[i]=1;
				inputEncodings[letters[i]]=thisInput;
			}
		}else{
			//binary encoding - each letter numbered and
			//represented by corresponding 8bit binary array of -1 and 1.
			for(var i=0, l=letters.length;i<l;i++){
				//each input encoded as zeros everywhere
				var ret = dec2bin(i+1);
				inputEncodings[letters[i]] = ret.bipolarArray.slice(0); //make a new copy of array
			}
		}
		return inputEncodings;
	};

	/***
	 * create appropriately sized starting Weight matrices
	 */
	API.initializeWeights = function(){
		if (!inputEncodings){
			return null;
		}
		var N = Object.size(inputEncodings[letters[1]]); // Get the size of input vector
		if (N<2){
			return null;
		}
		//initalise to small values around -.1 to +.1
		var temp = Matrix.Random(2*N+1,N).multiply(-1);
		weightsInputToHidden = Matrix.Random(2*N+1,N).add(temp);
		var temp2 = Matrix.Random(N+1,2*N).multiply(-1);
		weightsHiddenToOutput = Matrix.Random(N+1,2*N).add(temp2);
       //remove matrices for momemtum weights too
        OLD_deltaWeightsInputToHidden = false;
        OLD_deltaWeightsHiddenToOutput = false;
	};



	/***
	 * feed forward through the network
	 */
	API.networkOutput = function(Input1,Input2){
		 //build input & treat as vector so we can right-multiply
		var InputVector = $M(Input1).transpose().augment($M(Input2).transpose());
		// }
       //add on the bias
		var InputVectorBias = InputVector.augment($V([params.bias]));
		//multiply by first weight matrix
		var Hid_net_in_acts =  InputVectorBias.x(weightsInputToHidden);
		//pass through activation fn
		//var Hid_out_acts = Hid_net_in_acts.map(rational_tanh);
		var Hid_out_acts = Hid_net_in_acts.map(tanh);
		Hid_out_acts = Hid_out_acts.augment($V([params.bias])); //add bias node
		//multiply by second weight matrix
		var Output_net_in_acts = Hid_out_acts.x(weightsHiddenToOutput);
		//pass through activation fn
		//var Output_out_acts = Output_net_in_acts.map(rational_tanh);
		var Output_out_acts = Output_net_in_acts.map(tanh);

		//calculate the delta between input and output
		//depending on which deltaRule we want to use
		var del = Output_out_acts.subtract(InputVector);
		if (params.deltaRule === 'max'){
			del = del.map(Math.abs).max();
		}else if (params.deltaRule === 'rms'){
			del = rootmeansquare(del.elements[0]);
		}
		return {In:InputVector,Hid: Hid_out_acts, Out: Output_out_acts, Delta:del};
	};

  	function backPropogateError(net){
  		//TODO
  		//This code has not been optimised in any way.

  		//we want output to be same as input
  		//so error to backProp is the difference between input and output
		var Errors_RAW = net.Out.subtract(net.In);
		//so output errors is each diff multiplied by appropriate
		//derivative of output activation
		//1st get deriv
		var dOut = net.Out.map(tanh_deriv);

		var Errors_OUTPUT = [];
		var dim = Errors_RAW.dimensions();
		for(var c=1; c<dim.cols+1;c++){
			Errors_OUTPUT.push(Errors_RAW.e(1,c) * dOut.e(1,c));
		}
		Errors_OUTPUT = $M(Errors_OUTPUT);

		//So change weights is this deriv times hidden activations
		var dE_dw = net.Hid.transpose().x(Errors_OUTPUT.transpose());
		//multiplied by learning rate and with momentum added
		var HO_dwts;
		if (OLD_deltaWeightsHiddenToOutput){
			HO_dwts = dE_dw.x(-1 * params.learningRate).add(OLD_deltaWeightsHiddenToOutput.x(params.momentum));
		}else{
			//haven't got any old deltas yet
			HO_dwts = dE_dw.x(-1 * params.learningRate);
		}
		//update 2nd layer weights
		weightsHiddenToOutput = weightsHiddenToOutput.add(HO_dwts);
		//copy old delta for momentum calc.
		OLD_deltaWeightsHiddenToOutput = HO_dwts.dup();

		//Errors on hidden layer are oouput errors back propogated
		var Errors_HIDDEN_RAW = Errors_OUTPUT.transpose().x(weightsHiddenToOutput.transpose());
		//again multiplied by appropriated activations
		var dHidOut = net.Hid.map(tanh_deriv);
		var Errors_HIDDEN = [];
		dim = Errors_HIDDEN_RAW.dimensions();
		//Errors_Hidden less bias node so skip the last col
		for(var c=1; c<dim.cols;c++){
			Errors_HIDDEN.push(Errors_HIDDEN_RAW.e(1,c) * dHidOut.e(1,c));
		}
		Errors_HIDDEN = $M(Errors_HIDDEN);

		dE_dw = net.In.augment($V([params.bias])).transpose().x(Errors_HIDDEN.transpose());  // no IH_dwts associated with the bias
		var IH_dwts;
		if (OLD_deltaWeightsInputToHidden){
			IH_dwts = dE_dw.x(-1*params.learningRate).add(OLD_deltaWeightsInputToHidden.x(params.momentum));
		}else{
			IH_dwts = dE_dw.x(-1*params.learningRate);
		}
		//update 1st layer weights
		weightsInputToHidden = weightsInputToHidden.add(IH_dwts);
		OLD_deltaWeightsInputToHidden = IH_dwts.dup();
  	}

    API.trainNetwork = function (steps, progressCallback) {
	    /*********************/
	    try{
			//how many steps do we train for on this call
			var untilStep;
			if (steps < 0){
				untilStep = maxSteps;
			}else{
				untilStep = Math.min(maxSteps,currentStep+steps);
			}
			//
			// the main training loop
	        while (currentStep< untilStep){
				// progressCallback(1,'.');
				//read and encode the first bit of training data
				var Input_t1, Input_t2;
				if (lastDelta < params.recognitionCriterion){
					//new input is hidden unit representation
					Input_t1 = net.Hid.elements[0];
					//not including bias
					Input_t1.length = Input_t1.length -1;
				}else{
					//input is next training item
					Input_t1 = inputEncodings[trainingData[currentStep%inputLength]];
				}
				Input_t2 = inputEncodings[trainingData[(currentStep+1)%inputLength]];

				net = API.networkOutput(Input_t1,Input_t2);

				// if on input the LHS comes from an internal representation then only
				// do a learning pass 25% of the time, since internal representations,
				// since internal representations are attentionally weaker than input
				// from the real, external world.
				if ((lastDelta > params.recognitionCriterion) //train netowrk if error large
				 || (Math.random() <= params.reinforcementProbability))//or if small error and below threshold
				 {
					backPropogateError(net);
					net = API.networkOutput(Input_t1,Input_t2);
				}
				lastDelta = net.Delta;
				if (!batchMode && trackingFlag && currentStep%trackingInterval == 1){
					trackingSteps.push(currentStep);
					//if tracking turned on we test the network
					//at fixed intervals with a set of test bigrams
					for(x in trackingTestWords){
						var ret = API.testString(trackingTestWords[x]);
						trackingResults[trackingTestWords[x]].push([currentStep, ret.testError]);
					}
				}
				currentStep++;
			}
			return true;
	    }
	    catch(err){
	    	console.log(err);
	    	progressCallback(1,"TRACX.trainNetwork Err: " + err.message + "<br/>");
	    	return false;
	    }
    };

    /***
     * a function to test what the network has learned.
     * pass a comma seperated list of test words, it
     * tests each one returning deltas and mean delta
     */
    API.testStrings = function (testItems) {
		var testItem = testItems.split(",");
		var deltas = [];
		var toterr = 0;
		var wordcount = 0;
		for(w in testItem){
			if (testItem[w].length>1){
		    	ret = TRACX.testString(testItem[w]);
		    	toterr += ret.testError;
		    	wordcount++;
		    	deltas.push(ret.totalDelta.toFixed(3));
			}
		}
		if (wordcount > 0){
			return {delta:deltas,testError:toterr/wordcount};
		}else{
			return {delta:null,testError:null};
		}

	};
    /***
     * a function to test what the network has learned.
     * returns the total delta error on each letter pair in a string
     * and a total delta for the word.
     */
    API.testString = function (inString) {
		try{
			var len = inString.length;
	  		var net = {Delta: 500};
	  		var delta = [];
	  		var totDelta = 0;
	  		var input1Hidden = false;
	  		var CRITERION;
	  		if (params.testErrorType === "final"){
	  			//used in the paper
	  			//always pass through hidden network activation
	  			CRITERION = 1000;
	  		}else if (params.testErrorType === "conditional"){
	  			//only use hidden activation if we have meet criterion
	  			CRITERION = params.recognitionCriterion;
	  		}else{
	  			//never pass the hidden activation
	  			CRITERION = -1;
	  		}

	  		for(var i=0; i<len-1;i++){
	  			if (i>0 && net.Delta < CRITERION){
					//new input is hidden unit representation
					Input_t1 = net.Hid.elements[0];
					//not including bias
					Input_t1.length = Input_t1.length -1;
					input1Hidden = true;
				}else{
					//input is next training item
					Input_t1 = inputEncodings[inString[i]];
					input1Hidden = false;
				}
				Input_t2 = inputEncodings[inString[i+1]];
				net = API.networkOutput(Input_t1,Input_t2);
				net.Input1Hidden = input1Hidden;
				delta.push(net.Delta);
				totDelta += net.Delta;
			}
			var meanDelta = totDelta/(len-1);
	  		return {deltas:			delta,
	  				totalDelta:		totDelta,
	  				meanDelta:	meanDelta,
	  				finalDelta: net.Delta,
	  				testError: (params.testErrorType === "final"? net.Delta : meanDelta),
	  				activations:net};
	  	}
	    /*******************/
	    catch(err){
	    	console.log(err);
			return -1000;
	    }
  	};

  	/******
  	 * The function which gets called when someone presses the calculate button.
  	 */
  	API.runFullSimulation = function(progressCallback){
   		if (params.randomSeed){
   			params.randomSeed =  Math.seedrandom(params.randomSeed);
   		}else{
   			params.randomSeed =  Math.seedrandom(randomString());
   		}
   		progressCallback(1,"Random seed used: " + params.randomSeed + "<br/>");
   		startSimulation = new Date();
  		currentStep = 0;
  		inputLength = trainingData.length -1;
  		maxSteps = params.sentenceRepetitions * inputLength;
  		if (progressCallback){
  			progressCallback(1,"Simulation started: " + startSimulation.toLocaleTimeString() + "<br/>");
  		}

  		//set up the object to store results
  		var testResults = {	trainSuccess:	false,
  						   	elapsedTime:	-1,
  						   	Words:			{mean:-1,sd:-1,all:[]},
  							PartWords:		{mean:-1,sd:-1,all:[]},
  							NonWords:		{mean:-1,sd:-1,all:[]},
  							trackingSteps:	null,
  							trackingOutputs:null};
        if (trackingFlag){
    		//initialise stacked array to store tracking data
    		trackingResults = [];
    		trackingSteps = [];
        	for(x in trackingTestWords){
    			trackingResults[trackingTestWords[x].trim()] = [];
	        }
	    }

		progressCallback(1, 'Subjects: ');
		//loop round with a new network each time
	 	for (var run_no=0; run_no<params.numberSubjects;run_no++){
		    if (run_no < params.numberSubjects-1){
		    	//in batchmode we only track results of last participant
		    	batchMode = true;
		    }
			currentStep = 0;
  			lastDelta = 500; // some very big delta to start with
	  		API.initializeWeights();
			if (progressCallback){
  				progressCallback(1,(1 + run_no) + ",");
				// progressCallback(0,"Run: " + (1 + run_no) + "<br/>");
				// progressCallback(0,'Initial Weight Matrices<br/>Input to Hidden<br/>');
				// progressCallback(0, weightsInputToHidden.inspect());
				// progressCallback(0,'<br/>Hidden to Output<br/>');
				// progressCallback(0,weightsHiddenToOutput.inspect());
			}

			if(API.trainNetwork(-1, progressCallback)){
				//training worked for this subject
				testResults.trainSuccess =true;
				/////////////////////////////////// ////
				//TESTING THE NETWORK
				var	ret = TRACX.testStrings(testWords );
				if (ret.testError){
			    	testResults.Words.all.push(ret.testError);
			   	}
				ret =  TRACX.testStrings(testPartWords );
		    	if (ret.testError){
			    	testResults.PartWords.all.push(ret.testError);
		       	}
				ret =  TRACX.testStrings(testNonWords );
		    	if (ret.testError){
			    	testResults.NonWords.all.push(ret.testError);
		       	}
	       	}
	    }
	    batchMode = false;
	    if (testResults.Words.all.length>0){
			testResults.Words.mean = mean(testResults.Words.all);
	    	testResults.Words.sd = stdev(testResults.Words.all);
	    }
	    if (testResults.PartWords.all.length>0){
			testResults.PartWords.mean = mean(testResults.PartWords.all);
	    	testResults.PartWords.sd = stdev(testResults.PartWords.all);
	    }
	    if (testResults.NonWords.all.length>0){
			testResults.NonWords.mean = mean(testResults.NonWords.all);
	    	testResults.NonWords.sd = stdev(testResults.NonWords.all);
	    }
	    var end = new Date();
	    testResults.elapsedTime = (end.getTime() - startSimulation.getTime())/1000;
	    if (progressCallback){
  			progressCallback(1,"Simulation finished: " + end.toLocaleTimeString() + "<br/>");
  			progressCallback(1,"Duration: " + testResults.elapsedTime.toFixed(3) + " secs.<br/>");
  		}
	    if (trackingFlag){
	    	testResults.trackingSteps = trackingSteps;
	    	testResults.trackingOutputs = trackingResults;
	    }
       	return testResults;
  	};


	/******
  	 * The function which will step through the training process so user can see
  	 * what is going on.
  	 */
  	API.stepThroughTraining = function(stepSize, progressCallback){
  		batchMode = false;
  		if (!currentStep || currentStep < 0){
  			//initialize things
  			startSimulation = new Date();
	  		if (progressCallback){
	  			progressCallback(1,"Random seed used: " + params.randomSeed + "<br/>");
   				progressCallback(1,"Simulation started: " + startSimulation.toLocaleTimeString() + "<br/>");
	  		}
	  		lastDelta = 500;  // some very big delta to start with
	  		currentStep = 0;
  			inputLength = trainingData.length -1;
  			maxSteps = params.sentenceRepetitions * inputLength;
  			if (progressCallback){
  				progressCallback(1, "Stepping through once,");
				progressCallback(0,"Stepping through once <br/>");
			}
	        if (trackingFlag){
				//initialise stacked array to store tracking data
	    		trackingResults = [];
	    		trackingSteps = [];
	        	for(x in trackingTestWords){
	    			trackingResults[trackingTestWords[x].trim()] = [];
		        }
		    }
  		}
  		//set up the object to store results
  		testResults = {	trainSuccess:	false,
					   	elapsedTime:	-1,
					   	Words:			{mean:-1,sd:-1,all:[]},
						PartWords:		{mean:-1,sd:-1,all:[]},
						NonWords:		{mean:-1,sd:-1,all:[]},
						trackingSteps:	null,
						trackingOutputs:null};
  		//convert percentage based step sizes
  		if (!isNumber(stepSize) && stepSize.indexOf("%")>0){
  			stepSize= 0.01 * maxSteps * parseFloat(stepSize);
  		}

		// progressCallback(1, 'Subjects: ');
		// //loop round with a new network each time
	 	// for (var run_no=0; run_no<params.numberSubjects;run_no++){
		if(API.trainNetwork(stepSize, progressCallback)){
			//training worked for this subject
			testResults.trainSuccess =true;
			/////////////////////////////////// ////
			//TESTING THE NETWORK
			var	ret = TRACX.testStrings(testWords );
			if (ret.testError){
		    	testResults.Words.all.push(ret.testError);
		   	}
			ret =  TRACX.testStrings(testPartWords );
	    	if (ret.testError){
		    	testResults.PartWords.all.push(ret.testError);
	       	}
			ret =  TRACX.testStrings(testNonWords );
	    	if (ret.testError){
		    	testResults.NonWords.all.push(ret.testError);
	       	}
       	}
	    // }
	    if (testResults.Words.all.length>0){
			testResults.Words.mean = mean(testResults.Words.all);
	    	testResults.Words.sd = stdev(testResults.Words.all);
	    }
	    if (testResults.PartWords.all.length>0){
			testResults.PartWords.mean = mean(testResults.PartWords.all);
	    	testResults.PartWords.sd = stdev(testResults.PartWords.all);
	    }
	    if (testResults.NonWords.all.length>0){
			testResults.NonWords.mean = mean(testResults.NonWords.all);
	    	testResults.NonWords.sd = stdev(testResults.NonWords.all);
	    }
	    var end = new Date();
	    testResults.elapsedTime = (end.getTime() - startSimulation.getTime())/1000;
	    if (progressCallback){
  			progressCallback(0,"Simulation finished: " + end.toLocaleTimeString() + "<br/>");
  			progressCallback(0,"Duration: " + testResults.elapsedTime.toFixed(3) + " secs.<br/>");
  		}
	    if (trackingFlag){
	    	testResults.trackingSteps = trackingSteps;
	    	testResults.trackingOutputs = trackingResults;
	    }
       	return testResults;
  	};


    return API; //makes the tracx methods available
}());
