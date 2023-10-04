import os

source_name = '/home/tallat/CMCC/git_repo/development-catalog/Catalog/datasets/ERA5/single-levels/reanalysis/2014/total_precipitation_era5-single-levels_reanalysis_310928.nc'
destination_name = '/catalog/Catalog/datasets/ERA5/single-levels/reanalysis/2014/total_precipitation_era5-single-levels_reanalysis_310928.nc'
CATALOG_POD = os.popen("kubectl get pods \
                       -l \"geodds.component=catalog\"\
                        -o jsonpath=\'{.items[0].metadata.name}\'"\
                       ).read().strip()
os.system(f"kubectl \
          cp {source_name} development/{CATALOG_POD}:{destination_name}\
          -c catalog")
# os.system(f"kubectl exec -it {CATALOG_POD} -c catalog --bash \
#           -c 'rm -r /catalog/cache/'")

os.system(f"kubectl exec -it {CATALOG_POD} -c catalog -- bash \
          -c 'rm /catalog/cache/* && cd catalog && python generate_cache.py'")

API_POD_IPS = os.popen("kubectl get endpoints dev-api \
                       -o jsonpath='{.subsets[*].addresses[*].ip}'"\
                       ).read().strip().split()
USER_TOKEN = "User-token: 53af49a4-5948-11ee-8c99-0242ac120002:1234"
for POD_IP in API_POD_IPS:
    os.system(f"kubectl exec -it {CATALOG_POD} -c catalog -- bash \
              -c 'curl -X POST -H \"{USER_TOKEN}\" http://{POD_IP}/datasets'")
    print('')