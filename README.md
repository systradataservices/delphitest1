# Delphi Technical Test

## Purpose and Instructions

### Purpose

As it is difficult to fully assess somebody’s abilities at an interview, particularly their programming skills, we give a small programming exercise to all potential candidates. The problem is a fairly simple one, which should be completed in the applicant’s own time.

This is an opportunity for the candidate to show their engineering knowledge and craft work.  We are looking for engineering best practice. 

This is a very important part of our hiring process. Therefore we recommend that candidates give this adequate consideration and address this task as they would do for any other professional assignments in their current workplace.

### Instructions 

-   Use any version of Delphi to complete the exercise
-   We use GitHub to host these tests to create a modern practical engineering experience. Please complete this exercise and either fork the repository and submit a pull request for your solution or submit your complete solution as a single zip file via email
-   We would much prefer that you submit a complete software implementation that demonstrates modern engineering best practices.  However we also appreciate that to provide a complete solution we may be expecting too much of the candidates time. If you are pressed for time, we recommend you use the pull request to comment on areas that, given more time, you would address or have done differently
-   Please update the RUNME.MD file with instructions how to run your application 

## Exercise

### Background

One of the key functions of our main software application is to manage bus timetable data.  Bus timetables consist of a series of trips that follow pre-defined bus routes; each trip is provided by a bus operator; each bus operator will run one or more bus services and each service will run on one or more day(s) of the week.

This exercise focuses on a subset of our bus timetables module, specifically bus operators, their services and the service days of operation.

### The Problem

You are required to create a program to read in bus service data from a comma-separated text file, to translate the data into a visual tree structure (using a vcl TTreeView control or similar) that aggregates and organises the bus services by days of operation, bus operator and finally, services.  

The treeview will contain three top level nodes representing aggregated days of operation; these will be fixed as "Monday to Friday", "Saturday" and "Sunday".

The bus operators and their associated services should be displayed under each of the days of operation headings if they provide a service that runs on one or more of the days within that period.

#### Example Input Data

We have provided two csv files which contain data related to bus operators.  

ExampleOperatorServiceDaysOfOp.csv - contains the data for the example given in these instructions

OperatorServiceDaysOfOp.csv - contains a wider range of data for testing your solution for accuracy

The column headings for the files are follows:

"Bus Operator Name", "Service Number", "Days of Operation"

For example, for one bus operator (A2B Bus and Coach Limited): 

"A2B Bus and Coach Limited","127","1101110"

"A2B Bus and Coach Limited","128","1111101"

"A2B Bus and Coach Limited","E02","1111100"

Here we can see that the bus operator "A2B Bus and Coach Limited" provides 3 services (numbers: 127, 128, E02) and each services operates on different days of the week (1101110, 1111101, 1111100).

The days of week are represented in the file as a string consisting of seven boolean values, each one representing a specific day of the week depending on their position.  A service running every day of the week (Monday to Sunday) is represented by 1111111:

| Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday |
|:------:|:-------:|:---------:|:--------:|:------:|:--------:|:------:|
|   1    |    1    |     1     |     1    |    1   |     1    |    1   | 

a service running Monday, Wednesday and Friday would be represented as 1010100:

| Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday |
|:------:|:-------:|:---------:|:--------:|:------:|:--------:|:------:|
|   1    |    0    |     1     |     0    |    1   |     0    |    0   | 

#### Example Output

Once the data has been processed, the treeview corresonding to the above example would be:

![alt text](https://github.com/systradataservices/delphitest1/blob/master/TreeviewExample.PNG "Example")

### General Considerations

Below are some hints to help with this exercise. 
-   Demonstrate engineering best practice 
-   Use the pull request to provide a 'self review' to highlight any assumptions or potential future refactoring
-   The data may well contain any number of operators with multiple services that run on a variety of days of the week
-   Service numbers are alphanumeric
-   The example input data file given is very ‘clean’. In practice data files may contain errors or the data may be in an unexpected format
