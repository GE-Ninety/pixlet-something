"""
Applet: MPLS Snow Emergency
Summary: Minneapolis snow emergency infromation
Description: Displays the current parking restrictions related to winter weather for the city of Minneapolis
Author: Jonathan Wescott
"""

load("cache.star", "cache")
load("http.star", "http")
load("encoding/json.star", "json")
load("encoding/base64.star", "base64")
load("render.star", "render")

#main
def main(config):
    #Establish API URL
    url = "https://www.minneapolismn.gov/media/minneapolismngov/site-assets/javascript/site-wide-notices/emergency-en.json"
    cache_key = "MPLS"

    #cached data
    MPLS_cached = cache.get("cache_key")

    if MPLS_cached != None:
        print("Hit! Displaying cached data.")
        MPLS = json.decode(MPLS_cached)
        MPLS_data = MPLS
    else:
        print("Miss! Calling parking data")
        MPLS = http.get(url).json()
        cache.set(cache_key, json.encode(MPLS), ttl_seconds = 10800)
        MPLS_data = MPLS

    MPLS_TITLE = MPLS_data

    #images
    bkgnd = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAAEAAAAAgCAYAAACinX6EAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOxAAADsQBlSsOGwAAAfRJREFUaEPtmb9Kw1AUxs8t6KCliKUgUh3q3qWDCBnq5lB9CgcHN1GnurgpuugL+ASidXHSoSgOfQRFqojQRYs4uMR+13vLSZrE/hG8afKDyznnpil8X25z0xOROyvZ1OIhc4HgINcoqax3PmsNlZmNmNqZt1+X7shekD44ELeCsrWiqoie1q9knDlelDGoHp1NhsKEBBc/d77cHgDzz4VrmUMchGFoocCv/qp/0Fgho2bNRdAN2dyA+5VKOwK9CrQBQOe/RayCZLlOqVRKnmciHQZo/sqAQ3uV0um0PM9EPFcAh98HIAxAHAiqw3D1QVcG9LMbhEE8EJZl2dW9qu8ukF/Lq6o3wiAeSAOQwAQ3EB8WIf3SNgA0m02V/TDs4kFCRQkE8xEFHAZEkdgAFSNL5A0Ql6fU+QDQYvfAUpmT8kbndgnC+vl4BfDngCgS3wRVjCyxASpGlngXCPo7bG1576XDhFwBuiHiHl6mDBtdNUUHeUHCmd5/U5k5dNwD3D1BgB4/5vXQtTt6Hef5y+aE+kZz6KstDnTtjhreIebH0C0+mdyWuQl03RbngoBbeNBxoOdhgEk/hZ4M0CIAF8ijhtc8hwHvlUcamR6X9X+TgDiIBH7iNRCCAfxE6+NemCYeiOxRUV5+/RKUw8UPioniiYi+AQKqdUiCe+WuAAAAAElFTkSuQmCC""")
    odd_np = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAACAAAAAMCAYAAAADFL+5AAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOxAAADsQBlSsOGwAAAMVJREFUOE9j7GAQ/c9AZ6DJx8hw/RPEWrgDUmX4wQLoYPaTj1AWdQHMEWAHgCwP0lkBlUIF665E0NQRTMiWH9huDMcgALIcJIcrdMr/vwJjGCDExwaYoDQcOHieBWOY5bgAyOBORjEwRraEEB8dYDgABECWCz2+DeXRFmA4AGY5KBToAVAc8E5WFRzsxFgOC1pYVMAAIT46gDuAnGAHGYxsOCE+NjBg2RCUBWsVJAamIIJZzsfHx8C4kU+M7kUxzHIGBgYGALhFbv7TuvKrAAAAAElFTkSuQmCC""")
    even_np = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAACAAAAAMCAYAAAADFL+5AAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOxAAADsQBlSsOGwAAAOFJREFUOE9j3Mgn9p+BzqBbTw3KYmBg7GAQBTsgVYYfLIAOZj/5CGVRD2jyMcIdAXYAyPIgnRVgAXSw7koETR3B+FZG5T/M8gPbjcE0CDh4ngVbDpKjpSOYoGw4AFmMbDk6KP//Co5hfHQamzwIILNhAMMBIACyXOjxbSgPE3QyioExLoAuj81iGMBwAMxyUCjgAvgMBAF0eZBjcOlBccA7WVVwsOOzHATw+R4EsMnj0gN3AKFgRwYg38B8BPMdsgXI8oTAgGVDEADlggEpiEAAZPnuT78QDqAngFkuw8DKAABLS3v21kREUgAAAABJRU5ErkJggg==""")
    sn_emer = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABgAAAAgCAYAAAAIXrg4AAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOxAAADsQBlSsOGwAAAQRJREFUSEvtlsENwjAMRdMOUE7ADKzFNEzBDrAMQ8CpAxDkKB+1lh07aiIuPKmomNjPdntguIR9DJnTNOS7dnwFVPwV3ynYkpE+ehUnxp7FiTRBT34rOM/PdGlYvxPDbTpE6RlYiZzrtM93a7qvqDgB7wpTSfHiBLXr8ICaqxW1EPEarrcIF9DiEqKAkrSdStBZTVScwCOxzpgrKhUodQ6KAiBJPNMRLgGfxNM5cAkAFeadW5NUCahr3jlimkgUYAVSEmI4AzSRKEDisgCBorgkEIfIXBEl4LBWlLNsYCXgY4NlQi1JUNthDUmwpUML8xls5S8wGR9zDPfdMX9tT+d/1yF8AFqupFD3adY3AAAAAElFTkSuQmCC""")
    plow1 = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABcAAAAKCAYAAABfYsXlAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOxAAADsQBlSsOGwAAAKFJREFUOE9jtLGx+X/48GEGOGjQAFO2e0XBNCWACUrjBG/fvgVjfABZDTKb8T8QgFkgAHW11iomBmFhYYbDzq/BfDgQVgRThfcg6ggBnC5Hd+2sKKSggwJ+fn6cGAQQhiO5mlqAeiZhARDDaeBqEMBpGihCkUHaMlsoCwE+fvyIE4MA4/96dXBqgbka3VBYxKKLIwNkNchsuOHUyDSogIEBAKiDTh9C39QSAAAAAElFTkSuQmCC""")
    plow2 = base64.decode("""iVBORw0KGgoAAAANSUhEUgAAABcAAAAKCAYAAABfYsXlAAAABGdBTUEAALGPC/xhBQAAAAlwSFlzAAAOxAAADsQBlSsOGwAAAKJJREFUOE9jtLGx+c9AZXDY+TWYZgIRb9++BWN0Ni6ASw26OGNBQQFRLu9XugFhvL0PoaHAdq8oioHXwv5BGA03IC7n5+fHidHBrKjDUBYEYPMBDIANpxZAdjUIUNVwdEA1w9FdDQJgwz9+/IgTo4O0ZbZQFgQICwtDWZgAnM5hkQJSiMzGBdDVwNI1sqttbW0hLgcpgilEZuMCxKhhYGBgAAAQCVj3Z6v2MwAAAABJRU5ErkJggg==""")

    if "Snow emergency declared" in MPLS["notices"][0]["html"]:
        if "day 1" in MPLS["notices"][0]["html"]:
            return render.Root(
                render.Image(bkgnd),
            )

        elif "day 2" in MPLS["notices"][0]["html"]:
            return render.Root(
                render.Image(bkgnd),
            )

        elif "day 3" in MPLS["notices"][0]["html"]:
            return render.Root(
                render.Image(bkgnd),
            )
            
    elif "Winter parking restrictions in effect" in MPLS["notices"][2]["html"]:
        return render.Root(
            render.Image(sn_emer),
            render.Text("test", "tb-8"),
        )
    elif "There's currently no Snow Emergency." in MPLS["notices"][0]["html"]:
        return render.Root(
            render.Stack(
                children=[
                    render.Image(bkgnd),
                    render.Box(
                        padding=(25, 0, 0, 0),
                        child=(
                            render.Image(sn_emer),
                        ),
                    ),
                ],
            ),
        )
    
    #error Screen
    else:
        return render.Root(render.Text("Error: Bad Data", font = "tb-8"))