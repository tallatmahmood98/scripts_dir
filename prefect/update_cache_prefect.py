import os
from prefect import flow, task

CATALOG_POD = os.popen("kubectl get pods \
                       -l \"geodds.component=catalog\"\
                        -o jsonpath=\'{.items[0].metadata.name}\'"\
                       ).read().strip()
API_POD_IPS = os.popen("kubectl get endpoints dev-api \
                       -o jsonpath='{.subsets[*].addresses[*].ip}'"\
                       ).read().strip().split()
USER_TOKEN = os.environ['USER_TOKEN']

@task
def cache_clean_step(dataset_id: str = None):
    """Prefect task clean the catalog cache files.

    Parameters
    ----------
    dataset_id : str
        ID of the dataset
        
    Returns
    -------
        None
    """
    if dataset_id==None:
        os.system(f"kubectl exec -it {CATALOG_POD} -c catalog -- bash \
            -c 'rm /catalog/cache/*&& cd catalog && python generate_cache.py'")
        print('Cache Cleaned for all datasets')
    else:
        # Need a mapping from dataset_id to cache file name in catalog cache
        print('Need to implement, Cache maintained for all datasets')
        pass
@task
def cache_update_step(dataset_id: str = None):
    """Prefect task update the cache for the datasets.

    Parameters
    ----------
    dataset_id : str
        ID of the dataset
        
    Returns
    -------
        None
    """
    if dataset_id==None:
        for POD_IP in API_POD_IPS:
            os.system(f"kubectl exec -it {CATALOG_POD} -c catalog -- bash \
                    -c 'curl -X POST -H \"{USER_TOKEN}\" http://{POD_IP}/datasets'")
            print('Cache Updated for all datasets')
            print('')
    else:
        for POD_IP in API_POD_IPS:
            os.system(f"kubectl exec -it {CATALOG_POD} -c catalog -- bash \
                    -c 'curl -X POST -H \"{USER_TOKEN}\" http://{POD_IP}/datasets/{dataset_id}'")
            print('')

@flow(name='Update Cache')
def update_cache(dataset_id: str = None):
    """Prefect flow update the cache for datasets.

    Parameters
    ----------
    dataset_id : str
        ID of the dataset
        
    Returns
    -------
        None
    """
    cache_clean_step(dataset_id)
    cache_update_step(dataset_id)

if __name__=='__main__':
    update_cache.serve(name='Update Cache Deployment', parameters={"dataset_id": None})