import requests

class CloudflareRepository:
    api_token: str
    zone_id: str
    base_url: str

    def __init__(self, api_token: str, zone_id: str):
        self.api_token = api_token
        self.zone_id = zone_id
        self.base_url = f"https://api.cloudflare.com/client/v4/zones/{zone_id}/dns_records"
        self.headers = {
            "Authorization": f"Bearer {api_token}",
            "Content-Type": "application/json"
        }

    def create_subdomain(self, subdomain: str, ip: str, record_type="A"):

        data = {
            "type": record_type,
            "name": subdomain,
            "content": ip,
            "ttl": 120,
            "proxied": False
        }
        
        response = requests.post(self.base_url, headers=self.headers, json=data)

        return response.json()

    def delete_subdomain(self, subdomain: str):

        records = requests.get(self.base_url, headers=self.headers).json()

        for record in records.get("result", []):

            if record["name"] == subdomain:
                delete_url = f"{self.base_url}/{record['id']}"
                response = requests.delete(delete_url, headers=self.headers)
                return response.json()
            
        return {"success": False, "message": "Subdomain not found"}