import 'package:flutter/material.dart';
import 'package:lexicon/vocabulary_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFDCDCDC),
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(width: 6),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              padding: WidgetStatePropertyAll<EdgeInsets>(
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
              backgroundColor: WidgetStatePropertyAll<Color>(
                const Color(0xFFDCDCDC),
              ),
            ),
            child: Text(
              'Kynlygy',
              style: TextStyle(
                color: const Color(0xFF031F1D),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(width: 12,),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CategoryCard(
              header: 'Beginner',
              description: 'Maşgala agzalarynyň atlaryny öwreneliň',
              cardHeader: 'English - 1 synp',
              cardDescription:
                  'Orta mekdepleriň 1-nji synp okuw kitaby boýunça',
              bookIcon: 'assets/images/image.png',
              chapter: 'Maşgala agzalary',
              headerIcon: 'assets/images/polygon.png',
            ),
            SizedBox(height: 20,),
            CategoryCard(
              header: 'Elementary',
              description:
                  'Diňe wideo konferensiýanyň dowamynda ulanyp boljak sözleriň ýygyndysy.',
              cardHeader: 'Wideo konferensiýa',
              cardDescription:
                  'Iňlis dilinde online wideo konferensiýalarda gerek sözler',
              bookIcon: 'assets/images/image.png',
              chapter: 'Ýöriteleşdirilen sözler',
              headerIcon: 'assets/images/gulp.png',
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String cardHeader;
  final String cardDescription;
  final String bookIcon;
  final String header;
  final String chapter;
  final String? vocabulary;
  final String description;
  final String headerIcon;
  const CategoryCard({
    super.key,
    required this.header,
    required this.description,
    required this.cardHeader,
    required this.cardDescription,
    required this.bookIcon,
    required this.chapter,
    this.vocabulary,
    required this.headerIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Row(
            children: [
              Text(
                cardHeader,
                style: TextStyle(
                  color: const Color(0xFF03314A),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Ählisi',
                  style: TextStyle(
                    color: const Color(0xFF126BE9),
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(
              cardDescription,
              style: TextStyle(
                color: const Color(0xFF6D777E),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              softWrap: true,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8, left: 14),
          child: SizedBox(
            height: 300,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return HandCreatedCard(
                  bookIcon: bookIcon,
                  headerIcon: headerIcon,
                  header: header,
                  chapter: chapter,
                  description: description,
                );
              }, separatorBuilder: (BuildContext context, int index) => SizedBox(width: 8,),
            ),
          ),
        ),
      ],
    );
  }
}

class HandCreatedCard extends StatelessWidget {
  final String bookIcon;
  final String headerIcon;
  final String header;
  final String chapter;
  final String description;
  final String? vocabulary;
  const HandCreatedCard({
    super.key,
    required this.bookIcon,
    required this.headerIcon,
    required this.header,
    required this.chapter,
    required this.description,
    this.vocabulary,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.3;
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => VocabularyScreen(),),);
      },
      child: AspectRatio(
        aspectRatio: 162 / 280,
        child: Container(
          width: width,
          color: const Color(0xFFFFFFFF),
          child: Column(
            children: [
              Flexible(
                flex: 58,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset(
                    bookIcon,
                    width: width,
                    height: width,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 6),
              Flexible(
                flex: 42,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            headerIcon,
                            width: 20,
                            height: 20,
                            fit: BoxFit.cover,
                          ),
                          // Container(
                          //   //color: const Color(0xFFFEA832),
                          //   decoration: BoxDecoration(
                          //     border: Border(
                          //       bottom: BorderSide(
                          //         width: 50,
                          //         color: const Color(0xFFFEA832),
                          //       ),
                          //       left: BorderSide(
                          //         width: 50,
                          //         color: Colors.transparent,
                          //       ),
                          //       right: BorderSide(
                          //         width: 50,
                          //         color: Colors.transparent,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          SizedBox(width: 10),
                          Text(
                            header,
                            style: TextStyle(
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        chapter,
                        style: TextStyle(
                          color: const Color(0xFF03314A),
                          fontStyle: FontStyle.normal,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          color: const Color(0xFF3A4548),
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          fontStyle: FontStyle.normal,
                        ),
                        softWrap: true,
                      ),
                      vocabulary == null
                          ? Row(
                            children: [
                              Icon(
                                Icons.check,
                                size: 16,
                                color: const Color(0xFF00B46F),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Öwrendiňiz',
                                style: TextStyle(
                                  color: const Color(0xFF00B46F),
                                  fontStyle: FontStyle.normal,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          )
                          : Text(
                            vocabulary!,
                            style: TextStyle(
                              color: const Color(0xFF6D777E),
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
