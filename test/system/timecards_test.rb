require "application_system_test_case"

class TimecardTest < ApplicationSystemTestCase
  # Deputy tests 
  
    # Log timecard
    test 'log timecard' do
      login_as(users(:deputy))
      visit root_path
      click_link "Timecards"
      click_button "Log new workday"
      fill_in('Description', with: "I AM DEFINITELY A HUMAN.")
      select('00', from: 'timecard_start_4i')
      select('01', from: 'timecard_start_5i')
      click_button "Log it!"
      assert_text "Timecard logged!"
      assert_text "I AM DEF"
    end

     
 # view timecard list
   # filter timecards
   # total time displays

   
 
 # view a specific timecard
   # edit a timecard
   # delete a timecard
 
 
end
