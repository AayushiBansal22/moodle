import 'package:flutter/material.dart';

class Course {
  //final String image;
  final String title, description;
  final int id;
  final Color color;
  Course ({
    //required this.image,
    required this.title,
    required this.description,
    required this.color,
    required this.id,
  });
}

List<Course> courses = [
  Course(
    id: 1,
    title: "Graphic Design",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet",
    //image: "assets/images/graphics.png",
    color: Colors.black,
  ),
  Course(
    id: 2,
    title: "Programming",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet",
    //image: "assets/images/programming.png",
    color: Colors.black,
  ),
  Course(
    id: 3,
    title: "Finance",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet",
    //image: "assets/images/finance.png",
    color: Colors.black,
  ),
  Course(
    id: 4,
    title: "UI/Ux design",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet",
    //image: "assets/images/ux.png",
    color: Colors.black,
  ),
];