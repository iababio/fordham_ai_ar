// Copyright 2020 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math';

import 'package:english_words/english_words.dart';
// ignore: implementation_imports
import 'package:flutter/material.dart';

// This file has a number of platform-agnostic non-Widget utility functions.

const _myListOfRandomColors = [
  Colors.red,
  Colors.teal,
  Colors.green,
  Colors.orange,

];

final _random = Random();
final wordPairIterator = generateWordPairs();

String generateRandomHeadline() {
  final artist = capitalizePair(wordPairIterator.first);

  return switch (_random.nextInt(10)) {
    0 => '$artist says ${nouns[_random.nextInt(nouns.length)]}',
    1 => '$artist arrested due to ${wordPairIterator.first.join(' ')}',
    2 => '$artist releases ${capitalizePair(wordPairIterator.first)}',
    3 => '$artist talks about his ${nouns[_random.nextInt(nouns.length)]}',
    4 => '$artist talks about her ${nouns[_random.nextInt(nouns.length)]}',
    5 => '$artist talks about their ${nouns[_random.nextInt(nouns.length)]}',
    6 =>
    '$artist says their music is inspired by ${wordPairIterator.first.join(' ')}',
    7 =>
    '$artist says the world needs more ${nouns[_random.nextInt(nouns.length)]}',
    8 =>
    '$artist calls their band ${adjectives[_random.nextInt(adjectives.length)]}',
    9 =>
    '$artist finally ready to talk about ${nouns[_random.nextInt(nouns.length)]}',
    _ => 'Failed to generate news headline',
  };
}

final imagesList = [
  'lite_center.jpg',
  'fordham_health.jpeg',
  'fordham_it.jpeg',
  'fordham_library.jpeg',
];

final content = [
  ''' 
### Fordham Lite Center 💡

Learning Commons, LITE: Learning, Innovation, Technology Environment

The Learning Commons, LITE is Fordham University’s new Learning and Innovation Technology Environment.

#### Hours Opened
The LITE space at RH is open from: 

##### Monday - Friday, 10 AM - 6 PM. 
 
Access to the Service Desk, the lounge area and collaborative area with Jamboards and TV screens is open to all walk-ins.


The LITE annex at LC is open from:

##### Monday - Thursday 9 AM - 5 PM.  

Access to the Jamboard is open to all walk-ins.

The community should sign up to reserve time in the recording rooms, XR room, the 3D printers and makerspace at RH and LC.  Please sign up via Calendly here.

As a collaboration between Information Technology and Fordham University Libraries, LITE brings a much needed comprehensive, integrated learning commons to the Fordham community. LITE is meant to be accessible and available to all of Fordham’s students, faculty, and administrators.

LITE’s resources may bolster current research and open up possibilities for new or existing research grants and awards. Its resources can be used by researchers and students alike to ask questions that they may not previously have been equipped to answer and the ideas spawned may take on new life as unexplored dimensions emerge, forging new paths of study. It can also just be a destination for students in and of itself, providing fun options for those looking to exert their creativity.

LITE has been designed to constantly evolve so as to keep pace with the changing and advancing needs of our faculty and students.

In particular, LITE offers:


- __IT support__ - An integrated technology support center and information desk with day-to-day IT support from IT professionals and academic peers (similar to Apple Stores’ Genius Bars).

- __Maker Space__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __3D printers__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __Recording Rooms__ Two sound-controlled recording and podcasting rooms with microphones and green screens

- __Workshops__ Training workshops throughout the school year
Several collaborative work areas

- __Loaner Program__ Fordham’s Loaner Program, which lends out laptops, webcams, microphones, and more

- __Workstations__ High-end computer workstations for multimedia production station

- __A Virtual Reality area__
- __Assistive Technology workstations__
- __Robust scanning options__

  ''',
  ''' 
### Fordham Hospital Center

Learning Commons, LITE: Learning, Innovation, Technology Environment

The Learning Commons, LITE is Fordham University’s new Learning and Innovation Technology Environment.

#### Hours Opened
The LITE space at RH is open from: 

##### Monday - Friday, 10 AM - 6 PM. 
 
Access to the Service Desk, the lounge area and collaborative area with Jamboards and TV screens is open to all walk-ins.


The LITE annex at LC is open from:

##### Monday - Thursday 9 AM - 5 PM.  

Access to the Jamboard is open to all walk-ins.

The community should sign up to reserve time in the recording rooms, XR room, the 3D printers and makerspace at RH and LC.  Please sign up via Calendly here.

As a collaboration between Information Technology and Fordham University Libraries, LITE brings a much needed comprehensive, integrated learning commons to the Fordham community. LITE is meant to be accessible and available to all of Fordham’s students, faculty, and administrators.

LITE’s resources may bolster current research and open up possibilities for new or existing research grants and awards. Its resources can be used by researchers and students alike to ask questions that they may not previously have been equipped to answer and the ideas spawned may take on new life as unexplored dimensions emerge, forging new paths of study. It can also just be a destination for students in and of itself, providing fun options for those looking to exert their creativity.

LITE has been designed to constantly evolve so as to keep pace with the changing and advancing needs of our faculty and students.

In particular, LITE offers:


- __IT support__ - An integrated technology support center and information desk with day-to-day IT support from IT professionals and academic peers (similar to Apple Stores’ Genius Bars).

- __Maker Space__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __3D printers__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __Recording Rooms__ Two sound-controlled recording and podcasting rooms with microphones and green screens

- __Workshops__ Training workshops throughout the school year
Several collaborative work areas

- __Loaner Program__ Fordham’s Loaner Program, which lends out laptops, webcams, microphones, and more

- __Workstations__ High-end computer workstations for multimedia production station

- __A Virtual Reality area__
- __Assistive Technology workstations__
- __Robust scanning options__
  ''',
  ''' 
  __Welcome to Fordham IT Center 💡__

Learning Commons, LITE: Learning, Innovation, Technology Environment

The Learning Commons, LITE is Fordham University’s new Learning and Innovation Technology Environment.

#### Hours Opened
The LITE space at RH is open from: 

##### Monday - Friday, 10 AM - 6 PM. 
 
Access to the Service Desk, the lounge area and collaborative area with Jamboards and TV screens is open to all walk-ins.


The LITE annex at LC is open from:

##### Monday - Thursday 9 AM - 5 PM.  

Access to the Jamboard is open to all walk-ins.

The community should sign up to reserve time in the recording rooms, XR room, the 3D printers and makerspace at RH and LC.  Please sign up via Calendly here.

As a collaboration between Information Technology and Fordham University Libraries, LITE brings a much needed comprehensive, integrated learning commons to the Fordham community. LITE is meant to be accessible and available to all of Fordham’s students, faculty, and administrators.

LITE’s resources may bolster current research and open up possibilities for new or existing research grants and awards. Its resources can be used by researchers and students alike to ask questions that they may not previously have been equipped to answer and the ideas spawned may take on new life as unexplored dimensions emerge, forging new paths of study. It can also just be a destination for students in and of itself, providing fun options for those looking to exert their creativity.

LITE has been designed to constantly evolve so as to keep pace with the changing and advancing needs of our faculty and students.

In particular, LITE offers:


- __IT support__ - An integrated technology support center and information desk with day-to-day IT support from IT professionals and academic peers (similar to Apple Stores’ Genius Bars).

- __Maker Space__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __3D printers__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __Recording Rooms__ Two sound-controlled recording and podcasting rooms with microphones and green screens

- __Workshops__ Training workshops throughout the school year
Several collaborative work areas

- __Loaner Program__ Fordham’s Loaner Program, which lends out laptops, webcams, microphones, and more

- __Workstations__ High-end computer workstations for multimedia production station

- __A Virtual Reality area__
- __Assistive Technology workstations__
- __Robust scanning options__
  ''',
  ''' __Welcome to Fordham Library 💡__

Learning Commons, LITE: Learning, Innovation, Technology Environment

The Learning Commons, LITE is Fordham University’s new Learning and Innovation Technology Environment.

#### Hours Opened
The LITE space at RH is open from: 

##### Monday - Friday, 10 AM - 6 PM. 
 
Access to the Service Desk, the lounge area and collaborative area with Jamboards and TV screens is open to all walk-ins.


The LITE annex at LC is open from:

##### Monday - Thursday 9 AM - 5 PM.  

Access to the Jamboard is open to all walk-ins.

The community should sign up to reserve time in the recording rooms, XR room, the 3D printers and makerspace at RH and LC.  Please sign up via Calendly here.

As a collaboration between Information Technology and Fordham University Libraries, LITE brings a much needed comprehensive, integrated learning commons to the Fordham community. LITE is meant to be accessible and available to all of Fordham’s students, faculty, and administrators.

LITE’s resources may bolster current research and open up possibilities for new or existing research grants and awards. Its resources can be used by researchers and students alike to ask questions that they may not previously have been equipped to answer and the ideas spawned may take on new life as unexplored dimensions emerge, forging new paths of study. It can also just be a destination for students in and of itself, providing fun options for those looking to exert their creativity.

LITE has been designed to constantly evolve so as to keep pace with the changing and advancing needs of our faculty and students.

In particular, LITE offers:


- __IT support__ - An integrated technology support center and information desk with day-to-day IT support from IT professionals and academic peers (similar to Apple Stores’ Genius Bars).

- __Maker Space__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __3D printers__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __Recording Rooms__ Two sound-controlled recording and podcasting rooms with microphones and green screens

- __Workshops__ Training workshops throughout the school year
Several collaborative work areas

- __Loaner Program__ Fordham’s Loaner Program, which lends out laptops, webcams, microphones, and more

- __Workstations__ High-end computer workstations for multimedia production station

- __A Virtual Reality area__
- __Assistive Technology workstations__
- __Robust scanning options__
''',
  ''' 
  __Welcome to Fordham Sports Center 💡__

Learning Commons, LITE: Learning, Innovation, Technology Environment

The Learning Commons, LITE is Fordham University’s new Learning and Innovation Technology Environment.

#### Hours Opened
The LITE space at RH is open from: 

##### Monday - Friday, 10 AM - 6 PM. 
 
Access to the Service Desk, the lounge area and collaborative area with Jamboards and TV screens is open to all walk-ins.


The LITE annex at LC is open from:

##### Monday - Thursday 9 AM - 5 PM.  

Access to the Jamboard is open to all walk-ins.

The community should sign up to reserve time in the recording rooms, XR room, the 3D printers and makerspace at RH and LC.  Please sign up via Calendly here.

As a collaboration between Information Technology and Fordham University Libraries, LITE brings a much needed comprehensive, integrated learning commons to the Fordham community. LITE is meant to be accessible and available to all of Fordham’s students, faculty, and administrators.

LITE’s resources may bolster current research and open up possibilities for new or existing research grants and awards. Its resources can be used by researchers and students alike to ask questions that they may not previously have been equipped to answer and the ideas spawned may take on new life as unexplored dimensions emerge, forging new paths of study. It can also just be a destination for students in and of itself, providing fun options for those looking to exert their creativity.

LITE has been designed to constantly evolve so as to keep pace with the changing and advancing needs of our faculty and students.

In particular, LITE offers:


- __IT support__ - An integrated technology support center and information desk with day-to-day IT support from IT professionals and academic peers (similar to Apple Stores’ Genius Bars).

- __Maker Space__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __3D printers__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __Recording Rooms__ Two sound-controlled recording and podcasting rooms with microphones and green screens

- __Workshops__ Training workshops throughout the school year
Several collaborative work areas

- __Loaner Program__ Fordham’s Loaner Program, which lends out laptops, webcams, microphones, and more

- __Workstations__ High-end computer workstations for multimedia production station

- __A Virtual Reality area__
- __Assistive Technology workstations__
- __Robust scanning options__
''',
  ''' 
  __Welcome to Fordham Lite Center 💡__

Learning Commons, LITE: Learning, Innovation, Technology Environment

The Learning Commons, LITE is Fordham University’s new Learning and Innovation Technology Environment.

#### Hours Opened
The LITE space at RH is open from: 

##### Monday - Friday, 10 AM - 6 PM. 
 
Access to the Service Desk, the lounge area and collaborative area with Jamboards and TV screens is open to all walk-ins.


The LITE annex at LC is open from:

##### Monday - Thursday 9 AM - 5 PM.  

Access to the Jamboard is open to all walk-ins.

The community should sign up to reserve time in the recording rooms, XR room, the 3D printers and makerspace at RH and LC.  Please sign up via Calendly here.

As a collaboration between Information Technology and Fordham University Libraries, LITE brings a much needed comprehensive, integrated learning commons to the Fordham community. LITE is meant to be accessible and available to all of Fordham’s students, faculty, and administrators.

LITE’s resources may bolster current research and open up possibilities for new or existing research grants and awards. Its resources can be used by researchers and students alike to ask questions that they may not previously have been equipped to answer and the ideas spawned may take on new life as unexplored dimensions emerge, forging new paths of study. It can also just be a destination for students in and of itself, providing fun options for those looking to exert their creativity.

LITE has been designed to constantly evolve so as to keep pace with the changing and advancing needs of our faculty and students.

In particular, LITE offers:


- __IT support__ - An integrated technology support center and information desk with day-to-day IT support from IT professionals and academic peers (similar to Apple Stores’ Genius Bars).

- __Maker Space__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __3D printers__ - A Maker Space facility for producing with 3D printers, a laser cutter, a plotter, a large format printer and more

- __Recording Rooms__ Two sound-controlled recording and podcasting rooms with microphones and green screens

- __Workshops__ Training workshops throughout the school year
Several collaborative work areas

- __Loaner Program__ Fordham’s Loaner Program, which lends out laptops, webcams, microphones, and more

- __Workstations__ High-end computer workstations for multimedia production station

- __A Virtual Reality area__
- __Assistive Technology workstations__
- __Robust scanning options__
  ''',
];

final nameList = [
  'Emerging Tech, LITE',
  'Fordham Health Center',
  'Fordham IT Center',
  'Fordham Library',
  'Fordham Sports Center',
];

List<MaterialColor> getRandomColors(int amount) {
  return List<MaterialColor>.generate(amount, (index) {
    return _myListOfRandomColors[_random.nextInt(_myListOfRandomColors.length)];
  });
}

List<String> getRandomNames(int amount) {
  return nameList.take(amount).toList();
}

List<String> getImages(int amount) {
  return imagesList.take(amount).toList();
}

List<String> getContent(int amount) {
  return content.take(amount).toList();
}

String capitalize(String word) {
  return '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}';
}

String capitalizePair(WordPair pair) {
  return '${capitalize(pair.first)} ${capitalize(pair.second)}';
}