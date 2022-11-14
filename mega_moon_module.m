function main
    global fast; global delay; global precision; global years; global rad;
    global X_earth; global Y_earth; global X_moon2sun; global Y_moon2sun;
    global R1; global R2; global T1; global T2; global time;
    global P_earth; global P_earth_trase; global P_sun; global P_moon; global P_moon_trase;
    
    R1=1.496*10^8;      T1=3.156*10^7;
    R2=3.844*10^5;      T2=2.360*10^6;
    %------------------------------------------------------%
    %--------------------USER-PARAMETRS--------------------%
    fast=2;
    delay=0.005;    %time in seconds for one frame
    precision=2000; %count of points to modeling
    years=10;       %Count of years to modeling
    rad=10;         %coefficient for Moon radius
    IDD;
    %--------------------END-USER-PARAMETRS----------------%
    %------------------------------------------------------%
    %--------------------STUFF-ONLY------------------------%
    close(figure(1))
    F=figure(1);
    F.Position=[400 300 400 400];
    now=0; i=1; 
    time=0:T1/precision:years*T1;
    %--------------------END-STUFF-ONLY--------------------%
    %--------------------PLOTING---------------------------%
    build_of_orbit(R1,R2,T1,T2,time,rad);
    ylim([-2*10^8 2*10^8])
    xlim([-2*10^8 2*10^8])
    pbaspect([1 1 1])
    %--------------------END-PLOTING-----------------------%
    %--------------------MAIN-CYCLE------------------------%
    while isvalid(F)
        pause(delay);
        P_earth.XData=X_earth(i*fast);
        P_earth.YData=Y_earth(i*fast);
        P_moon.XData=X_moon2sun(i*fast);
        P_moon.YData=Y_moon2sun(i*fast);
        drawnow
        now=now+fast;
        if i==years*precision/fast  i=1;
        else i=i+1;
        end        
    end
    %--------------------END-CYCLE-------------------------%
end

function IDD
    fig = uifigure('Name','Input Data Diag (IDD)', 'Position',[800 300 300 300]);
    p = uipanel(fig,'Position',[170 70 60 160]);
    uieditfield(p,'numeric','Position',[10 130 40 20],'Value',2,'ValueChangedFcn',{@BFF, "fast"});
    uieditfield(p,'numeric','Position',[10 100 40 20],'Value',0.005,'ValueChangedFcn',{@BFF,"frame"});
    uieditfield(p,'numeric','Position',[10 70 40 20],'Value',2000,'ValueChangedFcn',{@BFF,"prec"});
    uieditfield(p,'numeric','Position',[10 40 40 20],'Value',10,'ValueChangedFcn',{@BFF,"years"});
    uieditfield(p,'numeric','Position',[10 10 40 20],'Value',10,'ValueChangedFcn',{@BFF,"rad"});
end


function BFF(p,event,t)
  global fast; global delay; global precision; global years; global rad;
  global R1; global R2; global T1; global T2; global time;
  tmp=p.Value;
  if t=="fast"
      fast=tmp;
  elseif t=="frame"
      delay=tmp;
  elseif t=="prec"
      precision=tmp;
  elseif t=="years"
      years=tmp;
  elseif t=="rad"
      rad=tmp;
      build_of_orbit(R1,R2,T1,T2,time,rad);
  end
end

function build_of_orbit(R1,R2,T1,T2,time,rad)
    global X_earth; global Y_earth; global X_moon2sun; global Y_moon2sun;
    X_earth=R1*cos(2*pi*time/T1);
    Y_earth=R1*sin(2*pi*time/T1);
    X_moon2earth=R2*rad*cos(2*pi*time/T2);
    Y_moon2earth=R2*rad*sin(2*pi*time/T2);
    X_moon2sun=X_earth+X_moon2earth;
    Y_moon2sun=Y_earth+Y_moon2earth;
    plot_of_orbit(X_earth,Y_earth,X_moon2sun,Y_moon2sun);
end

function plot_of_orbit(X_earth,Y_earth,X_moon2sun,Y_moon2sun)
    global P_earth; global P_earth_trase; global P_sun; global P_moon; global P_moon_trase;
    hold off; 
    P_earth=plot(X_earth,Y_earth,'.');              hold on;
    P_earth_trase=plot(X_earth,Y_earth,':');        hold on;
    P_sun=plot(0,0,'*r');                           hold on;
    P_moon=plot(X_moon2sun,Y_moon2sun,'.');         hold on;
    P_moon_trase=plot(X_moon2sun,Y_moon2sun,':');   hold on;
    %--------------------DESIGN----------------------------%
    Color_earth='#006600';      Color_moon='#606060';
                                Color_moon_trase='#E0E0E0';
    P_earth.Color=Color_earth;
    P_earth.MarkerSize=15;
    P_earth_trase.Color=Color_earth;
    P_moon.Color=Color_moon;
    P_moon.MarkerSize=8;
    P_moon_trase.Color=Color_moon_trase;
end
