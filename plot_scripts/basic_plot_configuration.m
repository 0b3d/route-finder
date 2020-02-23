% Basic Configuration of plots

font = 'Times'
ax.FontName = font;
ax.FontSize = 10;

ax.XTickMode = 'manual';
ax.YTickMode = 'manual';
ax.ZTickMode = 'manual';
ax.XLimMode = 'manual';
ax.YLimMode = 'manual';
ax.ZLimMode = 'manual';
set(ax, 'defaultAxesTickLabelInterpreter','latex'); set(ax, 'defaultLegendInterpreter','latex');
grid on

fig = gcf;
fig.PaperUnits = 'centimeters';
fig.PaperPosition = [0 0 8 6];
