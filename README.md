# NIST XDS Toolkit in a docker container

[NIST](https://www.nist.gov/) supports the [IHE](https://www.ihe.net/) effort in Document Sharing as part of the IT Infrastructure Domain with [testing, tools, and technical](https://ihexds.nist.gov/). Here are just instructions to use the NIST [XDS Toolkit](https://github.com/usnistgov/iheos-toolkit2/releases) in a [docker](https://www.docker.com/) container.

## Build & run XDS Toolkit in a docker container

Prerequisites:

- **Docker** installed and running  
- **Postman**

Build the docker image:

```sh
docker build -t xdstools .

```

Run an instance:

```sh
docker run --rm -it -p 8080:8080 -p 8888:8888 -p 8443:8443 -v $PWD/cache:/your/external/cache/location xdstools
```

With this setup, xdstool's external cache will be saved in the `cache` directory. Due to how Docker works, the data in this folder will belong to the root user. This might cause some issues, e.g. when trying to access the files or when rebuilding the image. This can be solved by reclaiming ownership of the files:

```sh
sudo chown -R $USER:$(id -gn) cache/
```

## Technical Notes

During setup, Java 17 compatibility issues were encountered and fixed by updating the Dockerfile and Tomcat server.xml as follows:

1. JAXB dependencies added: Newer Java versions (11+) don’t include JAXB (used for XML handling), so the required JAXB libraries are added back to ensure XDS Toolkit can process XML properly.

2. Java module access fixes: Java 17 has stricter access rules, so a setenv.sh configuration is included with --add-opens settings to prevent runtime errors (like IllegalAccessError).

3. Base image pinned: The Docker image is changed from tomcat:latest to tomcat:9-jdk17 so the environment consistently uses Java 17.

4. APR SSL engine disabled: The APR SSL setting is turned off (SSLEngine="off") in server.xml to avoid failures when APR/native libraries are not available inside the container.

5. AJP connector disabled: The AJP connector (port 8009) is commented out because it isn’t needed for this standalone setup.

For complete setup, refer to [XDS Explained: Build a Working Document Exchange on Your Laptop
](https://medblocks.com/blog/xds-explained-build-a-working-document-exchange-on-your-laptop)

## Postman Collection

A Postman collection for testing XDS Toolkit endpoints is included: `XDS_Tutorial.postman_collection.json`

### Importing the Collection

1. Open Postman
2. Click **Import** button
3. Select **File** tab
4. Choose `XDS_Tutorial.postman_collection.json`
5. Click **Import**

### Using the Collection

The collection includes the following endpoints (use in this order):

1. **Check Registry** - Verify registry simulator status
2. **Check Repository** - Verify repository simulator status
3. **Get Documents for a Patient** - List all documents for a patient (replace `[PATIENT_ID]` with actual patient ID)
4. **Get XML Metadata of a Patient Document** - Retrieve document metadata (replace `[DOCUMENT_ENTRY_ID]` with actual document entry ID from the previous request)
5. **Retrieve Document Content** - Get document content from repository (replace `[DOCUMENT_UNIQUE_ID]` with actual document unique ID)

All endpoints target `http://localhost:8080/xdstools6` by default. Make sure the XDS Toolkit is running before making requests.
