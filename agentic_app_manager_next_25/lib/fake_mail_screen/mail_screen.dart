import 'package:flutter/material.dart';

import 'data.dart';

class MyMailScreen extends StatefulWidget {
  const MyMailScreen({super.key});

  @override
  State<MyMailScreen> createState() => _MyMailScreenState();
}

class _MyMailScreenState extends State<MyMailScreen> {
  Set<String> _selected = {'Inbox'};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        bottom: PreferredSize(
          preferredSize: Size(100, 10),
          child: SearchBar(
            trailing: const [
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Icon(Icons.search),
              ),
            ],
            hintText: 'Search',
            elevation: WidgetStateProperty.all(0),
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24)),
              ),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox.square(dimension: 10),
          SegmentedButton(
            segments: const <ButtonSegment<String>>[
              ButtonSegment<String>(value: 'Inbox', label: Text('Inbox')),
              ButtonSegment<String>(value: 'Primary', label: Text('Primary')),
              ButtonSegment<String>(
                value: 'Everything Else',
                label: Text('Everything Else', maxLines: 1),
              ),
            ],
            showSelectedIcon: false,
            selected: _selected,
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _selected = newSelection;
              });
            },
          ),
          const SizedBox.square(dimension: 10),
          Expanded(
            child: ListView.builder(
              itemCount: emails.length,
              itemBuilder: (BuildContext context, int index) {
                Email email = emails[index];
                if (_selected.first == 'Inbox' ||
                    _selected.first == 'Primary' &&
                        email.tag == EmailType.primary ||
                    _selected.first == 'Everything Else' &&
                        email.tag == EmailType.everything) {
                  return ListTile(
                    isThreeLine: true,
                    leading: CircleAvatar(
                      child: Text(
                        email.fromFirstName[0].toUpperCase() +
                            email.fromLastName[0].toUpperCase(),
                      ),
                    ),
                    title: Text(
                      '${email.fromFirstName} ${email.fromLastName}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          email.subject,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          email.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        email.favorited
                            ? const Icon(Icons.star, color: Colors.amber)
                            : const Icon(Icons.star_outline),
                      ],
                    ),
                  );
                }
                return const SizedBox(height: 0, width: 0);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.edit),
      ),
    );
  }
}
