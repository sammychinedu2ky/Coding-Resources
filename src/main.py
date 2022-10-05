import json
import os

RESOURCES_FOLDER = "res"
# RESOURCES_FOLDER = "resources"
RESOURCE_HEADING = """
# {resourceName}

### Index
- [Courses](#courses)
- [Games](#games)
- [PDFs](#pdfs)
"""

def compile(resourceName, resourceStucture) -> str:
    def compileResource (resource):
        compiledOutput = f"- [{resource['title']}]({resource['link']})\n"
        if resource.get('description'):
            compiledOutput += f"  __{resource['description']}__\n"
        return compiledOutput

    compiledOutput = RESOURCE_HEADING.format(resourceName = resourceName)
    resources = {
        "courses": [],
        "games": [],
        "pdfs": []
    }
    for resource in resourceStucture:
        if (resource["type"] == "course"):
            resources["courses"].append(resource)
        elif (resource["type"] == "game"):
            resources["games"].append(resource)
        elif (resource["type"] == "pdf"):
            resources["pdfs"].append(resource)

    compiledOutput += "\n## Courses\n"
    for resource in resources["courses"]:
        compiledOutput += compileResource(resource)

    compiledOutput += "\n## Games\n"
    for resource in resources["games"]:
        compiledOutput += compileResource(resource)

    compiledOutput += "\n## PDFs\n"
    for resource in resources["pdfs"]:
        compiledOutput += compileResource(resource)

    return compiledOutput

if __name__ == '__main__':
    for resourceFolder in os.listdir(RESOURCES_FOLDER):
        with open(os.path.join(RESOURCES_FOLDER, resourceFolder, "resources.json"), "r") as fh:
            resourceStucture = json.load(fh)
        with open(os.path.join(RESOURCES_FOLDER, resourceFolder, "README.md"), "w") as fh:
            print(compile(resourceFolder, resourceStucture))
            fh.write(compile(resourceFolder, resourceStucture))
