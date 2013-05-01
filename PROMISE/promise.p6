#!/usr/bin/env perl6

use Test;

class Promise {
	enum State <PENDING FULFILLED REJECTED>;

	has State $.state = PENDING;

	has @.fulfill-queue;
	has @.reject-queue;
	has $.value;
	has $.reason;

	method fulfill($value) {
		return if $!state != PENDING;
		$!state = FULFILLED;
		while my $cb = @!fulfill-queue.shift {
			$cb( $value );
		}
	}

	method reject($reason) {
		return if $!state != PENDING;
		$!state = REJECTED;
		while my $cb = @!reject-queue.shift {
			$cb( $reason ) 
		}
	}

	method then(&onFulfilled, &onRejected?) {
		if $!state == PENDING {
			@!fulfill-queue.push: &onFulfilled;
			@!reject-queue.push: &onRejected if &onRejected;	
		} elsif $!state == FULFILLED {
			&onFulfilled($!value);
		} elsif $!state == REJECTED {
			&onRejected($!reason);
		}
		return self;
	}
}

{
    my $promise = Promise.new;

    my $value = 0;
    $promise.then(sub ( $arg ) { $value = $arg });
    ok !$value, "Hasn't been fulfilled yet";

    $promise.fulfill("OH HAI");

    is $promise.state, Promise::State::FULFILLED, "Correct state";
    is $value, "OH HAI", "Code has been run";
}

{
    my $promise = Promise.new(state => Promise::State::FULFILLED, value => "yay!");
    is $promise.state, Promise::State::FULFILLED, "Already correct state";

    my $value = 0;
    $promise.then( sub ( $arg ) { $value = $arg });

    is $value, "yay!", "Code ran immediately";
}

{
    my $promise = Promise.new;

    my $value = 0;
    my $reason = 0;
    $promise.then( sub ( $arg ) { $value = $arg },  sub ( $arg ) { $reason = $arg });
    ok !$reason, "Hasn't been rejected yet";

    $promise.reject("OH NOES");

    is $promise.state, "REJECTED", "Correct state";
    ok !$value, "Fulfill code didn't run";
    is $reason, "OH NOES", "Reject code has been run";
}
{
    my $promise = Promise.new;

    my $value = 0;
    $promise.then(sub ( $arg ) { $value++ });
    $promise.then(sub ( $arg ) { $value++ });
    $promise.then(sub ( $arg ) { $value++ });
    ok !$value, "Hasn't been fulfilled yet";

    $promise.fulfill("OH HAI");

    is $promise.state, Promise::State::FULFILLED, "Correct state";
    is $value, 3, "Code has been run";
}

done;
