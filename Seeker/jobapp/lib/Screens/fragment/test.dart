/*     drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.blue),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  //SizedBox(height: 20),
                  Text(
                    "Jobber",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                  ),
                  Text(
                    "XYZ",
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.reviews, color: Colors.blue),
              title: Text("My Reviews"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings, color: Colors.grey),
              title: Text("Settings", style: TextStyle(color: Colors.grey)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.grey),
              title: Text("Help", style: TextStyle(color: Colors.grey)),
              onTap: () {},
            ),

            ListTile(
              leading: Icon(Icons.policy_outlined, color: Colors.grey),
              title: Text("Terms", style: TextStyle(color: Colors.grey)),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.pending_outlined, color: Colors.grey),
              title: Text("About us", style: TextStyle(color: Colors.grey)),
              onTap: () {},
            ),
            ListTile(
              title:
                  Text("Version 1.0.0 ", style: TextStyle(color: Colors.grey)),
              onTap: () {},
            ),
            // Handle logout action
          ],
        ),
      ),*/


/* leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),*/


/// Build the job list with bookmark functionality
/*Widget _buildJobList() {
    return ListView.builder(
      itemCount: JobStorage.jobs.length,
      itemBuilder: (context, index) {
        final job = jobPosts[index];
        bool isBookmarked = bookmarkedJobs.contains(job["id"]);

        return Card(
          color: Color(0xFFf8edeb),
          margin: EdgeInsets.symmetric(vertical: 6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(job["title"],
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.blue : Colors.grey,
                        ),
                        onPressed: () => toggleBookmark(job["id"]),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(job["company"],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                SizedBox(height: 5),
                Text(job["location"],
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                SizedBox(height: 5),
                Text(job["salary"],
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      job["Active"],
                      style: TextStyle(fontSize: 10, color: Colors.grey[700]),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          */ /*style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),*/ /*
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue, // Set background color
                            foregroundColor:
                                Colors.white, // Set text/icon color
                            elevation: 5, // Shadow effect
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // Rounded corners
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => JobDetailsScreen()),
                            );
                          },
                          child: Text(
                            "Apply Now",
                            style: TextStyle(color: Colors.white),
                          ),
                        ))
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}*/

/*Widget _buildJobList() {
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        bool isBookmarked =
            bookmarkedJobs.contains(job.id); // Check if job is bookmarked

        return Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(vertical: 6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        job.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: isBookmarked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () => toggleBookmark(job.id),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(job.company,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                SizedBox(height: 5),
                Text(job.location,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                SizedBox(height: 5),
                Text(
                  job.salary,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                ),
                SizedBox(height: 10),

                // Apply Button
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle Apply Button Click (e.g., navigate to job details or open link)
                      //_applyForJob(job);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailsScreen(job: job),
                        ),
                      );
                      print("Clicked Job");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Apply", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }*/



/*  Widget _buildJobList() {
    return ListView.builder(
      itemCount: jobs.length,
      itemBuilder: (context, index) {
        final job = jobs[index];
        bool isBookmarked =
            bookmarkedJobs.contains(job.id); // Check if job is bookmarked

        return Container(
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          // Outer spacing
          padding: EdgeInsets.all(14),
          // Inner spacing
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            // Rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black12, // Soft shadow effect
                blurRadius: 5, spreadRadius: 1, offset: Offset(2, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Job Title and Bookmark Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      job.title,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      bookmarkedJobs.contains(job.id) ? Icons.bookmark : Icons.bookmark_border,
                      color: bookmarkedJobs.contains(job.id) ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () => _toggleBookmark(job.id),
                  ),
                ],
              ),

              SizedBox(height: 5),
              Text(job.company,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              SizedBox(height: 5),
              Text(job.location,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              SizedBox(height: 5),
              Text(
                job.salary,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent),
              ),

              SizedBox(height: 10),

              // Apply Button
              Row(
                children: [
                  Text(
                    "job.active", // ✅ Remove quotes to display actual value
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),

                  Spacer(),
                  // ✅ Pushes the button to the right

                  ElevatedButton(
                    onPressed: () {
                      // Navigate to job details screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JobDetailsScreen(job: job),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Apply", style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }*/


