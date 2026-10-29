import '../layout.dart';
import 'card.dart';

const _tableGap = 12.0;
const _headerHeight = 32.0;
const _minRows = 3;

double _tabHeightOf(DashboardDensity density) => density.isCompact ? 32 : 36;

double _rowHeightOf(DashboardDensity density) => density.isCompact ? 32 : 34;

double _tabInsetOf(DashboardDensity density) =>
    dashboardCardRadius(density) - _tabHeightOf(density) / 2;

double connectionsTableTop(DashboardDensity density, double scale) =>
    _tabInsetOf(density) + _tabHeightOf(density) * scale + _tableGap;

double connectionsTableMinHeight(DashboardDensity density, double scale) =>
    connectionsTableTop(density, scale) +
    (_headerHeight + _rowHeightOf(density) * _minRows) * scale;
