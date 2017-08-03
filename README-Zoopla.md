Reportportal setup:

change your reportportal details into /config/report_portal.yml and into /init/report_portal.yml

- run on desktop :

cucumber -t @rp_test -f ReportPortal::Cucumber::Formatter

- run headless :


export IN_BROWSER = 'FALSE'
cucumber -t @rp_test -f ReportPortal::Cucumber::Formatter