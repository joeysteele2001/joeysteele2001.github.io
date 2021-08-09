---
layout: series
series-id: field-of-ducks
subtitle: Series
---
{{ site.data.series | where: "series-id", series-id | map: "description" }}