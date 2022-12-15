function markerdata= marker_check(markerdata)
US1data=markerdata.marker_data.Markers.US1;
US2data=markerdata.marker_data.Markers.US2;
US4data=markerdata.marker_data.Markers.US4;
US5data=markerdata.marker_data.Markers.US5;
US45data=(US5data+US2data)/2
% plot([US4data,US5data])
% figure
vec41=US4data-US1data;
vec21=US2data-US1data;
vec451=US45data-US1data;
normalvec=cross(vec451(1,:),vec21(1,:));
[vecr,vecc]=size(vec41);
cont=0
for row=1:vecr
    ang1=atan2(norm(cross(vec41(row,:),normalvec)),dot(vec41(row,:),normalvec));
    if ang1>1.54
        extra=US4data(row,:);
        US4data(row,:)= US5data(row,:);
        US5data(row,:)= extra;
        cont=count+1;
    end
end
if cont>0
    fprintf('%d frames swapped \n', cont);
end
% plot([US4data,US5data])
markerdata.marker_data.Markers.US4=US4data;
markerdata.marker_data.Markers.US5=US5data;
end
