@mod @mod_hsuforum
Feature: Students can edit or delete their advanced forum posts within a set time limit
  In order to refine forum posts
  As a user
  I need to edit or delete my forum posts within a certain period of time after posting

  Background:
    Given the following "users" exist:
      | username | firstname | lastname | email |
      | student1 | Student | 1 | student1@example.com |
    And the following "courses" exist:
      | fullname | shortname | category |
      | Course 1 | C1 | 0 |
    And the following "course enrolments" exist:
      | user | course | role |
      | student1 | C1 | student |
    And the following "activities" exist:
      | activity   | name                   | intro                   | course  | idnumber  |
      | hsuforum   | Test forum name        | Test forum description  | C1      | forum     |
    And I log in as "student1"
    And I follow "Course 1"
    And I add a new discussion to "Test forum name" advanced forum with:
      | Subject | Forum post subject |
      | Message | This is the body |

 @javascript
  Scenario: Edit forum post
    Given I follow "Forum post subject"
    And I follow "Edit"
    And I follow link "Use advanced editor" ignoring js onclick
    When I set the following fields to these values:
      | Subject | Edited post subject |
      | Message | Edited post body |
    And I press "Save changes"
    And I wait to be redirected
    Then I should see "Edited post subject"
    And I should see "Edited post body"

  @javascript
  Scenario: Delete forum post
    Given I follow "Forum post subject"
    And I follow link "Delete" ignoring js onclick
    And I press "Continue"
    Then I should see "Test forum description"
    And I should not see "Forum post subject"

  @javascript
  Scenario: Time limit expires
    Given the following config values are set as admin:
      | maxeditingtime | 1 minutes |
    And I log out
    And I log in as "admin"
    And I am on site homepage
    And I follow "Course 1"
    And I turn editing mode on
    And I add a "Advanced Forum" to section "1" and I fill the form with:
      | Forum name | Test forum name |
      | Forum type | Standard forum for general use |
      | Description | Test forum description |
    And I log out
    And I log in as "student1"
    And I follow "Course 1"
    When I wait "61" seconds
    And I follow "Test forum name"
    And I follow "Forum post subject"
    Then I should not see "Edit"
    And I should not see "Delete"
