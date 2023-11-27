import 'package:flutter/material.dart';

class Semester {
  //final String image;
  final String title, description;
  final int id;
  final Color color;
  Semester ({
    //required this.image,
    required this.title,
    required this.description,
    required this.color,
    required this.id,
  });
}

List<Semester> semesters = [
  Semester(
    id: 1,
    title: "Semester 1",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet",
    //image: "assets/images/graphics.png",
    color: Colors.black,
  ),
  Semester(
    id: 2,
    title: "Semester 2",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet",
    //image: "assets/images/programming.png",
    color: Colors.black,
  ),
  Semester(
    id: 3,
    title: "Semester 3",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet",
    //image: "assets/images/finance.png",
    color: Colors.black,
  ),
  Semester(
    id: 4,
    title: "Semester 4",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet",
    //image: "assets/images/ux.png",
    color: Colors.black,
  ),
  Semester(
    id: 5,
    title: "Semester 5",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet",
    //image: "assets/images/ux.png",
    color: Colors.black,
  ),
  Semester(
    id: 6,
    title: "Semester 6",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet",
    //image: "assets/images/ux.png",
    color: Colors.black,
  ),
];