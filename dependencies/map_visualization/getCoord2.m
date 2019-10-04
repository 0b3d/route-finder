function getCoord2(aH,evnt,dataset)
drawnow
parameters
f = ancestor(aH,'figure');
click_type = get(f,'SelectionType');
ptH = getappdata(aH,'CurrentPoint');
delete(ptH);

%Finding the closest point and highlighting it
lH = findobj(aH,'Type','line','Marker','o');
minDist = realmax;
finalIdx = NaN;
finalH = NaN;
pt = get(aH,'CurrentPoint'); %Getting click position
for ii = lH'
    xp=get(ii,'Xdata'); %Getting coordinates of line object
    yp=get(ii,'Ydata');
    dx=daspect(aH);      %Aspect ratio is needed to compensate for uneven axis when calculating the distance
    %dx=[1 1];
    [newDist idx] = min( ((pt(1,1)-xp).*dx(2)).^2 + ((pt(1,2)-yp).*dx(1)).^2 );
    if (newDist < minDist)
        finalH = ii;
        finalIdx = idx;
        minDist = newDist;
    end
end
xp=get(finalH,'Xdata'); %Getting coordinates of line object
yp=get(finalH,'Ydata');
ptH = plot(aH,xp(finalIdx),yp(finalIdx),'k*','MarkerSize',20);
setappdata(aH,'CurrentPoint',ptH);

index = get(finalH,'tag');
load(['Data/',dataset,'/routes_small.mat'], 'routes');
pano_id = routes(str2num(index)).id;
%path = ['Data/tonbridge/panos/',pano_id,'.jpg'];
%pano = imread(path);
% read the tile
xpath = ['Data/',dataset,'/tiles/z19/',index,'.png'];
tile = imread(xpath);

[front, left, right, back] = crop_panorama(256, 90,pano_id, dataset);
image = [tile, front, left, right, back];
figure(2);
imshow(image);
uiresume(f);

end