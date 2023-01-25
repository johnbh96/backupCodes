# Analysis.yaml Documentation

## Introduction

### Table of Content
* Linting
* Used Link For The Rule
* Working Of Lint
* Way To Analyze And Fix


## Linting:

Code Linting is an automated verification that the code is correct.  In editors like VSCode and Android Studio, we receive errors when our code is not runnable. The visualisation of build errors are already features of our Linter. This integrated Code Linter is a tool that checks the code for build problems.

## Used Link For The Rules:
 #### The following list of rules are all from the available lints located under the following repo.


 [https://github.com/dart-lang/linter/blob/master/example/all.yaml](https://github.com/dart-lang/linter/blob/master/example/all.yaml).

## Working Of The Lint:

Basically the linter consists of set of rules that has to be followed.
 Basically if the rules are fulfilled, the linter will not display any exceptions or errors.
  But if there are certain rules that fail to match, the linter displays error in both the terminal and destination where the code is situated.

Say, if we use rule `prefer_single_quotes` which is the rule used to validate only single quotes. If there is double quotes used instead of single quotes, the linter catches error and the error is displayed both in the terminal and the destination where the code is situated.

## Way To Analyze And Fix:
 There are two ways to analyze the error thrown by the linter.
* Initially the error pops up in the **Problems** tab of the power shell terminal or in the destination where the problem exists. After determing the problems, the fixes can be applied.

* The command `flutter analyze` can be used from powershell or command prompt to determine the position where the error exists and can be fixed.
