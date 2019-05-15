/*
 * Licensed Materials - Property of IBM                           
 * 5725-B69 5655-Y17 5655-Y31 5724-X98 5724-Y15 5655-V82                                              
 * Copyright IBM Corp. 2013, 2018. All Rights Reserved            
 * US Government Users Restricted Rights - Use, duplication or    
 * disclosure restricted by GSA ADP Schedule Contract with        
 * IBM Corp.                                                      
 */


$(document).ready(
		function() {
			hide_panels();

			// process the form
			$('form').submit(
					function(event) {
						// stop the form from submitting the normal way and
						// refreshing the page
						event.preventDefault();
						hide_panels();
						var decisionServiceUrl = '/DecisionService/rest/v1/my_deployment/my_operation';
						var loan = {
							'amount' : parseInt($('input[name=amount]').val()),
							'duration' : parseInt($('input[name=duration]').val()),
							'yearlyInterestRate' : parseFloat($('input[name=yearly-interest-rate]').val())
						};
						var borrower ={								
							'name' : $('input[name=name]').val(),
							'yearlyIncome' : parseInt($('input[name=yearly-income]').val()),
							'creditScore' : parseInt($('input[name=credit-score]').val())
						};
						var formData = {
							'loan' : loan,
							'borrower' : borrower
						};

						// process the form
						var request = $.ajax({
							type : 'POST',
							url : decisionServiceUrl,
							data : JSON.stringify(formData),
							dataType: 'json',
							contentType: 'application/json'
						});

						request.done(function(data) {
							console.log(data);
							$('#result-panel').css('visibility', 'visible');
							if (data.loan.approved == true) {
									$('#result-panel').attr('class','panel panel-success');
									$('#result-header').text('Approved')
									$('#result-text').html(format_lines("approved", data.loan.messages))

								} else if (data.loan.approved == false) {
									$('#result-panel').attr('class','panel panel-warning');
									$('#result-header').text('Rejected')
									$('#result-text').html(format_lines("rejected", data.loan.messages))
								}
						});

						request.fail(function(jqXHR, textStatus) {
							$('#result-panel').css('visibility', 'visible');
							var textStatus = "Check the decision service URL " + decisionServiceUrl +" is available.";
							console.log("Request failed: " + textStatus);
							$('#result-panel').attr('class','panel panel-danger');
							$('#result-header').text('Error')
							$('#result-text').text(textStatus)
						});

					});

		});

function format_lines(approvalStatus, messages) {
	var text = "Your loan is " + approvalStatus + "</br>";
	var i = 0;
	for (; i < messages.length; i++)
		text += messages[i] + "</br>";
	return text;
}

function hide_panels() {
	$('#result-panel').css('visibility', 'hidden');
	$('#info-panel').css('visibility', 'hidden');
}