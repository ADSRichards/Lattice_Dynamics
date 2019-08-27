clear

set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

blue    = [36  , 7  , 133 ]/256;
teal    = [0  , 170, 176]/256;
green   = [49  , 158, 0  ]/256;
orange  = [186, 141 , 9  ]/256;
red     = [168, 26  , 0  ]/256;
black     = [0, 0  , 0  ]/256;

f1 = figure(1); clf; hold on; box on; set(gca, "fontsize", 18)

title("{\bf Harmonic Lattice}","fontsize",24)
xlabel("$x$")
ylabel("$y$")

axis([-1.2, 1.2, -1.2, 1.2]);
%xticks([-1.0, -0.5, 0, 0.5, 1.0]);
%yticks([-1.0, -0.5, 0, 0.5, 1.0]);              

th = 0:pi/50:2*pi;
%plot(5+cos(th),5+sin(th),"color","k")

L = 1;
N1 = 16;
N2 = 16;

x1 = zeros(N1,N2);  S1 = zeros(N1,N2);  v1 = zeros(N1,N2);
x2 = zeros(N1,N2);  S2 = zeros(N1,N2);  v2 = zeros(N1,N2);

for p1=1:N1
    for p2=1:N2
        x1(p1,p2) = 0.5 + L*(p1-1);
        x2(p1,p2) = 0.5 + L*(p2-1);
    
        S1(p1,p2) = 1/sqrt(2);
        S2(p1,p2) = 1/sqrt(2);

        handp(p1,p2) = quiver(x1(p1,p2),x2(p1,p2),S1(p1,p2),S2(p1,p2),"markersize",6,"linewidth",1.5,"color",blue);
    end
end

axis([x1(1,1)-0.5, x1(N1,N2)+0.5, x2(1,1)-0.5, x2(N1,N2)+0.5])

%%
v0 = 1;

v1(2,2) = -v0;
v2(2,2) = 0;

v1(3,3) = -v0;
v2(3,3) = 0;

v1(4,4) = -v0;
v2(4,4) = 0;

v1(2,3) = -v0;
v2(2,3) = 0;

v1(3,2) = -v0;
v2(3,2) = 0;

v1(2,4) = -v0;
v2(2,4) = 0;

v1(4,2) = -v0;
v2(4,2) = 0;

v1(4,3) = -v0;
v2(4,3) = 0;

v1(3,4) = -v0;
v2(3,4) = 0;

TN = 1000;
FN = 200;

w = 1;

clear F;
F(FN) = getframe(f1);
fi = 0;
for ti = 1:TN
    
    dt = 0.1;

    F1 = zeros(N1,N2);
    F2 = zeros(N1,N2);
    
    for p1=2:(N1-1)
        for p2=2:(N2-1)
            
            F1(p1,p2) = (S1(p1,p2)-S1(p1-1,p2)) - (S1(p1+1,p2)-S1(p1,p2))...
                      + (S1(p1,p2)-S1(p1,p2-1)) - (S1(p1,p2+1)-S1(p1,p2));
                  
            F2(p1,p2) = (S2(p1,p2)-S2(p1-1,p2)) - (S2(p1+1,p2)-S2(p1,p2))...
                      + (S2(p1,p2)-S2(p1,p2-1)) - (S2(p1,p2+1)-S2(p1,p2)); 
                  
            set(handp(p1,p2),"udata",S1(p1,p2))
            set(handp(p1,p2),"vdata",S2(p1,p2))
        end
    end
    
    v1 = v1 - dt*F1;
    v2 = v2 - dt*F2;

    S1 = S1 + dt*v1;
    S2 = S2 + dt*v2;
    
    if mod(ti,5)==0 
        fi = fi + 1;
        drawnow 
        F(fi) = getframe(f1);
    end
end

v = VideoWriter('temp.avi');
open(v);
    writeVideo(v,F);
close(v);