import json
import os

RESOURCES_FOLDER = "res"
# RESOURCES_FOLDER = "resources"
RESOURCE_HEADING = """


"""
def compile(resourceName, resourceStucture) -> str:
    compiledOutput = f"# {resourceName}\n"
    compiledOutput += f"## Index\n"
    compiledOutput += f"- [Courses](#courses)"
    compiledOutput += f"- [Games](#games)"
    compiledOutput += f"- [PDFs](#pdfs)"

    for resource in resourceStucture:
        compiledOutput += f"- [{resource['title']}]({resource['link']})\n"
        if resource.get('description'):
            compiledOutput += f"  __{resource['description']}__"
    return compiledOutput

if __name__ == '__main__':
    for resourceFolder in os.listdir(RESOURCES_FOLDER):
        with open(os.path.join(RESOURCES_FOLDER, resourceFolder, "resources.json"), "r") as fh:
            resourceStucture = json.load(fh)
        with open(os.path.join(RESOURCES_FOLDER, resourceFolder, "README.md"), "w") as fh:
            print(compile(resourceFolder, resourceStucture))
            fh.write(compile(resourceFolder, resourceStucture))
