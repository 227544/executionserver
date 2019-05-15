Use this directory as your tutorial work directory.

The source decision service projects are based on the answer projects of Rule Designer tutorial "Creating a decision service with multiple projects".
It uses the test deployment configuration with a RuleApp Name loanvalidation_for_resruleappmngt.

The modified rule is the checkAmount action rule under the Loan Validation Check > rules > validation > loan folder that checks also the minimum amount of the loan:

definitions 
    set maxAmount to 1,000,000;
    set minAmount to 1,000;
if 
    the amount of 'the loan' is less than  minAmount 
  or the amount of 'the loan' is more than maxAmount 
then 
    in 'the loan report', reject the data with the message "The loan cannot exceed " + maxAmount + " and cannot be less than " + minAmount ;

It uses the test deployment configuration with a RuleApp Name loanvalidation_for_resruleappmngt. The jar is renamed loanvalidation_for_resruleappmngt_modified.