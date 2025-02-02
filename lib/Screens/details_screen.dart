import 'package:echogpt_dashboard/Models/all_user_list_model.dart';
import 'package:echogpt_dashboard/Repository/api_services.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

// Define the enum for the filter options
enum FilterList { allUsers, freeUsers, premiumUsers }

class _DetailsScreenState extends State<DetailsScreen> {
  final searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  FilterList selectedFilter = FilterList.allUsers;
  String userType = 'all_user';

  final ApiServices _apiServices = ApiServices();
  List<Data> userList = [];
  List<Data> filteredUserList = []; // List to store filtered users

  int currentPage = 1;
  final int itemsPerPage = 50;
  bool isLoadingMore = false;
  bool isLoading = true;
  bool hasMoreData = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchUserList();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          hasMoreData) {
        loadMore();
      }
    });

    // Listen for text changes in the search bar
    searchController.addListener(() {
      filterUsers(searchController.text);
    });
  }

  Future<void> fetchUserList() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final AllUserListModel? userListResponse =
          await _apiServices.getAllUserList();
      if (userListResponse != null && userListResponse.success == true) {
        setState(() {
          userList = userListResponse.data ?? [];
          filteredUserList =
              userList; // Initially, the filtered list is the full list
          applyFilter(); // Apply the initial filter
        });
      } else {
        setState(() {
          errorMessage =
              userListResponse?.message ?? "Failed to fetch user list";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function to filter users based on search input and selected filter
  void filterUsers(String query) {
    List<Data> filtered = userList.where((user) {
      bool matchesQuery = (user.username
                  ?.toLowerCase()
                  .contains(query.toLowerCase()) ??
              false) ||
          (user.email?.toLowerCase().contains(query.toLowerCase()) ?? false);

      //Filter by selected user type
      bool matchesFilter = true;

      switch (selectedFilter) {
        case FilterList.freeUsers:
          matchesFilter = user.package == 'Free';
          break;
        case FilterList.premiumUsers:
          matchesFilter = user.package != 'Free';
          break;
        case FilterList.allUsers:
        default:
          break;
      }

      return matchesQuery && matchesFilter;
    }).toList();

    setState(() {
      filteredUserList = filtered;
      // Reset pagination when filtering
      currentPage = 1;
      // Check if more data exists
      hasMoreData = filteredUserList.length > itemsPerPage;
    });
  }

  void applyFilter() {
    // Call filterUsers with an empty string to apply the initial filter
    filterUsers('');
  }

  List<Data> get paginatedUserList {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = startIndex + itemsPerPage;
    return filteredUserList.sublist(
      startIndex,
      endIndex > filteredUserList.length ? filteredUserList.length : endIndex,
    );
  }

  void loadMore() async {
    if (isLoadingMore || !hasMoreData) return;
    setState(() {
      isLoadingMore = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      if (currentPage * itemsPerPage < filteredUserList.length) {
        currentPage++;
      } else {
        hasMoreData = false;
      }
      isLoadingMore = false;
    });
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('User Details'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    width: width * 0.4,
                    height: height * 0.05,
                    child: TextField(
                      controller: searchController,
                      focusNode: searchFocusNode,
                      maxLines: 1,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(width * 0.03),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(width * 0.03),
                        ),
                        hintText: 'Search by name, email',
                        hintStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 14,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: height * 0.01,
                            horizontal:
                                width * 0.02), // Reduce vertical padding
                      ),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.03),
                Expanded(
                  child: Container(
                    width: width * 0.4,
                    height: height * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.03),
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: PopupMenuButton<FilterList>(
                      onSelected: (FilterList value) {
                        setState(() {
                          selectedFilter = value;
                          applyFilter(); // Apply the filter based on selection
                        });
                        FocusScope.of(context).unfocus();
                      },
                      itemBuilder: (BuildContext context) {
                        return <PopupMenuEntry<FilterList>>[
                          const PopupMenuItem<FilterList>(
                            value: FilterList.allUsers,
                            child: Text('All Users'),
                          ),
                          const PopupMenuItem<FilterList>(
                            value: FilterList.freeUsers,
                            child: Text('Free Users'),
                          ),
                          const PopupMenuItem<FilterList>(
                            value: FilterList.premiumUsers,
                            child: Text('Premium Users'),
                          ),
                        ];
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedFilter == FilterList.allUsers
                                  ? 'All Users'
                                  : selectedFilter == FilterList.freeUsers
                                      ? 'Free Users'
                                      : 'Premium Users',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xff4979FB),
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.02),
            Container(
              height: height * 0.05,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(width * 0.01),
                color: const Color(0xff4979FB),
              ),
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'User List',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : errorMessage != null
                      ? Center(child: Text(errorMessage!))
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: paginatedUserList.length +
                              (isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < paginatedUserList.length) {
                              final user = paginatedUserList[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: height * 0.006),
                                child: ListTile(
                                  tileColor: Colors.white,
                                  leading: Column(
                                    children: [
                                      Container(
                                        height: height * 0.04,
                                        width: width * 0.09,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              width * 0.02),
                                          color: Colors.blue,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              width * 0.02),
                                          child: Image.network(
                                            user.picture ??
                                                'https://example.com/default-avatar.png',
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Icon(
                                                Icons.error,
                                                color: Colors.red,
                                                size: width * 0.08,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 1,
                                      ),
                                      Expanded(
                                        child: Text(
                                          user.package ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: user.package == 'Free'
                                                ? Colors.black
                                                : Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                    user.username ?? 'No Name',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(user.email ?? ''),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                  trailing: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('Remain:'),
                                      Text('${user.remainingDays ?? 0} Days'),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.only(top: height * 0.02),
                                  child: const CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
