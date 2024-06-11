from selenium import webdriver
from selenium.webdriver.edge.service import Service
from selenium.webdriver.edge.options import Options

def create_edge_driver():
    options = Options()
    options.use_chromium = True
    options.add_argument('--disable-gpu')
    options.add_argument('--no-sandbox')
    options.add_argument('--disable-software-rasterizer')
    options.add_argument('--remote-debugging-port=9222')  # Enable remote debugging

    service = Service(executable_path='/home/your_username/WebDriver/msedgedriver')
    driver = webdriver.Edge(service=service, options=options)
    return driver

if __name__ == "__main__":
    driver = create_edge_driver()
    driver.get("http://172.25.48.1:5173/register")
    # Add any additional setup or testing code here if needed
    driver.quit()
