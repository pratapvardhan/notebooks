{# D, table, newcases, np, pd  #}
{% set lastdays = (D['updated'] - D['since']).days %}
{% macro kpi(name, number, growth) -%}
  <div class="kpi">
    <div class="kname">{{ name }}</div>
    <div class="num">{{ '{0:,}'.format(number) }}</div>
    <div class="grow">(+{{ '{0:,}'.format(growth) }})</div>
  </div>
{%- endmacro %}

{% macro plotstrip(arr) -%}
  <div class="d-flex" style="height: 15px;">
    {% set colorscale = ['rgba(0, 0, 0, 0.1)', 'rgba(0, 0, 0, 0.4)', 'rgba(0, 0, 0, 0.7)', 'rgba(0, 0, 0, 1)'] %}
    {% set colors = np.digitize(arr, [10, 100, 1000, np.inf]) %}
    {% for c in colors %}
    <div style="width:3px;background:{{ colorscale[c] }};border-right:1px solid rgba(255,255,255,0.5);"></div>
    {% endfor %}
  </div>
{%- endmacro %}

<div class="overview">
  <div>
    <div class="kpi-hed">World</div>
    <div class="d-flex kpi-box">
      {{ kpi(name='Confirmed Cases', number=D['Cases'], growth=D['Cases (+)']) }}
      {{ kpi(name='Deaths', number=D['Deaths'], growth=D['Deaths (+)']) }}
      {{ kpi(name='Recovered', number=D['Recovered'], growth=D['Recovered (+)']) }}
    </div>
  </div>
  <p class="text-center text-uppercase fs9">Updated on <b>{{ D['updated'].strftime('%B %d, %Y') }}</b> ( +change since {{ lastdays }} days ago.)</p>
  <div class="d-flex" style="justify-content:space-between;">
    <div class="kpi-sm">
      <div class="kpi-hed">China</div>
      <div class="d-flex kpi-box">
        {{ kpi(name='Cases', number=D['China Cases'], growth=D['China Cases (+)']) }}
        {{ kpi(name='Deaths', number=D['China Deaths'], growth=D['China Deaths (+)']) }}
      </div>
    </div>
    <div class="kpi-sm">
      <div class="kpi-hed">Europe</div>
      <div class="d-flex kpi-box">
        {{ kpi(name='Cases', number=D['EU Cases'], growth=D['EU Cases (+)']) }}
        {{ kpi(name='Deaths', number=D['EU Deaths'], growth=D['EU Deaths (+)']) }}
      </div>
    </div>
    <div class="kpi-sm">
      <div class="kpi-hed">U.S.</div>
      <div class="d-flex kpi-box">
        {{ kpi(name='Cases', number=D['US Cases'], growth=D['US Cases (+)']) }}
        {{ kpi(name='Deaths', number=D['US Deaths'], growth=D['US Deaths (+)']) }}
      </div>
    </div>
  </div>
  <p class="text-center" style="font-size: 14px;max-width: 400px;">
    In the last <b>{{ lastdays }} days</b>, <b>{{ '{0:,}'.format(D['Cases (+)']) }}</b> new Coronavirus cases have been reported worldwide.
    Of which <b>{{ '{0:,}'.format(D['EU Cases (+)']) }}</b> ({{ "{0:.0%}".format(D['EU Cases (+)'] / D['Cases (+)']) }}) are from <b>Europe</b>.
    <b>China</b> has reported <b>{{ '{0:,}'.format(D['China Cases (+)']) }}</b> new cases in the last {{ lastdays }} days.
  </p>
  <table class="table" style="width:fit-content;min-width:540px;margin:auto;text-align:right;color:black;font-size:13px;">
    <thead>
      <tr>
        <th class="text-right" style="width:110px;">Country</th>
        <th class="text-left" style="width:100px;">New<br>Cases</th>
        <th class="text-left" colspan="2">Total<br>Cases</th>
        <th colspan="2">Deaths</th>
        <th class="fs9" >Fatality</th>
        <th class="fs9" colspan="2">Recovered</th>
      </tr>
    </thead>
    <tbody>
      <tr style="font-size:9px;">
        <td></td>
        <td style="display:flex;justify-content:space-between;">
          <div>{{ pd.to_datetime(newcases.columns[0]).strftime('%b. %d') }}</div>
          <div>{{ pd.to_datetime(newcases.columns[-1]).strftime('%b. %d') }}</div>
        </td>
        <td></td>
        <td colspan="4" class="text-left change" style="font-size: 9px;">(+NEW) since {{ D['since'].strftime('%b, %d') }}</td>
        <td></td>
        <td></td>
      </tr>
    {% for index, row in table.iterrows() %}
      <tr>
        <td class="mw"><b>{{ row['Country/Region'] }}</b></td>
        <td style="vertical-align: middle;">{{ plotstrip(arr=newcases.loc[row['Country/Region']].values) }}</td>
        <td class="pl1">{{ '{0:,}'.format(row['Cases']) }}</td>
        <td class="change">(+{{ '{0:,}'.format(row['Cases (+)']) }})</td>
        <td class="pl1">{{ '{0:,}'.format(row['Deaths']) }}</td>
        <td class="change">(+{{ '{0:,}'.format(row['Deaths (+)']) }})</td>
        <td class="pl1">{{ row['Fatality Rate'] }}%</td>
        <td>{{ '{0:,}'.format(row['Recovered']) }}</td>
        <td class="change">(+{{ '{0:,}'.format(row['Recovered (+)']) }})</td>
      </tr>
    {% endfor %}
    <tbody>
  </table>
</div>
<style>
.overview {
  min-width: 500px;
  font-size: 10px;
}
.overview p {
  margin: 6px auto !important;
  padding: 0;
}
.overview .kpi-hed {
  font-weight: bold;
  font-size: 20px;
}
.overview .kpi-box {
  justify-content: space-around;
  background: #ececec;
  padding: 10px 0 !important;
  margin: 5px 0 !important;
  min-width: 180px;
}
.overview .kpi .num {
  font-size: 40px;
  line-height: 40px;
  font-weight: bold;
}
.overview .kpi .grow {
  line-height: 12px;
}
.overview .kpi .kname {
  font-size: 12px;
}
.overview .kpi-sm .kpi-hed {
  font-size: 14px;
  line-height: 10px;
  padding-top: 10px !important;
}
.overview .kpi .grow {
  font-size: 10px;
}
.overview .kpi-sm .num {
  font-size: 20px;
  line-height: 20px;
}
.overview .kpi-sm .kname {
  font-size: 11px;
  line-height: 10px;
}
.overview .table .change {
  color: #999;
  font-size: 80%;
  text-align: start;
  vertical-align: inherit;
  font-weight: normal;
  padding-left: 0 !important;
}
.overview .table th {
  font-weight: normal;
}
.overview .table tbody tr {
  border-bottom: 1px solid #eee;
  background: none;
}
.overview .table td, .overview .table th {
  padding: 1px 1px 1px 5px !important;
  vertical-align: middle;
  border: none;
  background: none;
  max-width: none;
}
.overview .table th {
  text-align: center;
  text-transform: uppercase;
}
.overview .table thead {
  border-bottom: 1px solid black;
}
.overview .table .mw {
  max-width: 20px;
}
.overview .fs9 {
  font-size: 9px;
}
.overview .d-flex {
  display: flex;
}
.overview .text-center { text-align: center !important; }
.overview .text-left { text-align: left !important; }
.overview .text-right { text-align: right !important; }
.overview .text-uppercase { text-transform: uppercase !important; }
.overview div {
  margin: 0 !important;
  padding: 0 !important;
}
</style>