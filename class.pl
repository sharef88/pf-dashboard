#!/usr/bin/perl
use strict;
use warnings;

use lib qw/library/;

use CGI qw/:standard -no-xhtml/;
require util;




#browsers must behave
my $q = CGI->new;

#html Header
print $q->header;

unless ( $q->param('arch') ) {
#    print $q->script( type=>'text/javascript', src =>'js/class.js' );
    print $q->start_html(
        -title  => "Class Search",
        -script => {         
            -type => "text/javascript",
            -src  => "js/class.js"
        },
        -style => [ { 'src' => 'css/class.css' } ],
      ),
      $q->br;

    #prepare the queries
    my $arch    = $sql::sql_arch;
    my $classes = $sql::sql_classes;

    $arch->execute();
    $classes->execute();

    my @classlist;
    while ( my $item = $classes->fetchrow_hashref() ) {
        push( @classlist, $item );
    }
    my @archlist;
    while ( my $item = $arch->fetchrow_hashref() ) {
        push( @archlist, $item );
    }

    print $q->start_div( { id => 'class_select' } ),
      $q->start_Select(
        {
            id       => 'select_class',
            #onchange => 'showArch(this.options[this.selectedIndex].value);',
            title    => 'Main class'
        }
      ),
      $q->option( { value => '0' }, '-----' );

    foreach (@classlist) {
        print $q->option( { value => "class_" . $_->{'id'} }, $_->{'name'} );
    }

    print $q->end_Select;

    #print "<select id='archlist' name='arch'>\n";
    print $q->start_Select( { id => 'archlist', name => 'arch', title => 'Archtype select' } );

    #null value
    print $q->start_optgroup( { id => '0' } ),
      $q->option( { value => '0' }, '-----' ), $q->end_optgroup;
    foreach my $class (@classlist) {

        print $q->start_optgroup( { id => "class_" . $class->{'id'} } );
        foreach (@archlist) {
            if ( $class->{'name'} eq $_->{'base'} ) {
                print $q->option( { value => $_->{'id'} }, $_->{'name'} );
            }
        }
        print $q->end_optgroup();
    }
    print $q->end_Select();

    print $q->input(
        {
            name  => 'level',
            id    => 'select_level',
            class => 'spinner',
            value => '20',
            title => 'level select'
        }
      ),

      $q->button(
        {
            id       => "get_class",
            type     => "button",
            value    => "Get Class"
        }
      ),
      $q->end_div(),
      $q->div(
        {     id     => "classdata" },
        "Select a class, archtype and level from above to see the level progression info"
      ),
      $q->end_html();

    #requery
}
else {

    #parameter style stuff
    my $archid  = param('arch');
    my $level = param('level');
    $level = 20 if ( $level > 20 || !$level || $level < 1 );

    #get the stuff
    my $stuff = $sql::sql_class;
    $stuff->execute( $archid, $level );
    my $meta_data = $sql::sql_class_meta;
    $meta_data->execute($archid);
    my $column_format = $sql::sql_arch_table;
    $column_format->execute($archid);

    #store the stuff in an array
    my @abilities;
    while ( my $row = $stuff->fetchrow_hashref() ) {
        push( @abilities, $row );
    }
    my @meta_list;
    while ( my $row = $meta_data->fetchrow_hashref() ) {
        push( @meta_list, $row );
    }

    my $class = $abilities[0]->{'class'};
    my $arch = $abilities[0]->{'arch'};

    my $what = "$class ";

    #if class isn't the same as archtype, suffix class with archtype name
    if ( $class ne $arch ) {
        $what .= "($arch)";
    }
    #column dictation
    my @col = split( ',', $column_format->fetchrow_array() );
    my @column;
    foreach my $id (@col) {
        foreach my $ability (@abilities) {
            if ( $ability->{'id'} == $id ) {
                my @tmp = ($id,$ability->{'name'});
                push( @column, [@tmp] );
                last;
            }
        }
    }

    #start the table, make the headers

    print $q->start_div({id=>'progression_div', class=>'ui-corner-all ui-widget-content'}),
      $q->start_table( { id => 'level_progression', style=>'text-align:center' } ),
      $q->Tr( th( { colspan => 6+@col.length, title=>$archid }, "$level Level $what" ) ),
      $q->start_Tr(),
      $q->th( [ 'Level', 'Bab', 'Fort', 'Ref', 'Will', 'Abilities' ] );

    #customize based on class
    foreach (@column) {
        print $q->th({ class=>'ability_'.$$_[0] },$$_[1]);
    }
    print $q->end_Tr;

    #print the stuff by level
    foreach our $a ( 1 .. $level ) {
        print "<tr><td class='level'> $a </td>";

        #deal with the meta-info (bab, saves)

        #base attack bonus
        print "<td class='bab'>";
        print int( $a * ( $meta_list[0]->{'bab'} / 100 ) );
        print "</td>";

        #saves
        foreach ( 'fort', 'ref', 'will' ) {
            print "<td class='saves'>";
            print int( ( $a / 2 ) + 2 ) if ( $meta_list[0]->{"$_"} eq "good" );
            print int( $a / 3 ) if ( $meta_list[0]->{"$_"} eq "poor" );
            print "</td>";
        }
        print "<td class='abilities'>";

        #start @0 abilities
        my $count = 0;

        #print abilities
        foreach my $abl (@abilities) {
            my $id = $abl->{'id'};
            if ($abl->{'level'} == $a) {
	        if ( ! array_check($id,@col) ) {

			#increment the abilities
			$count++;

			#comma seperate the abilities
			print ", " unless $count == 1;
			print $q->start_span( { class => 'ability ability_'.$abl->{'id'} } ),
			$abl->{'name'}
			;

			#make the modifier string pretty if needed.
			if ( $abl->{'mod_string'} ) {
				$abl->{'mod_string'} =~ s/\?/$abl->{'modifier'}/g;
				$abl->{'mod_string'} =~ s/any per day/at will/g;
				print ": ", $abl->{'mod_string'};
			}
			print $q->end_span;
			}
		} 
	}
	print "---&nbsp;" if $count == 0;
        #special columns, dictated by the archtypes sql column list
	foreach (@column) {
		print '</td><td class = "ability_'.$$_[0].'">';
		$count=0;
		foreach my $abl (@abilities) {
			my $id = $abl->{'id'};
			if ($abl->{'level'} == $a) {
			if ( $abl->{'id'} eq $$_[0] ) {
	
				#increment the abilities
				$count++;
	
				#comma seperate the abilities
				print ", " unless $count == 1;
	
					#make the modifier string pretty if needed.
					if ( $abl->{'mod_string'} ) {
						$abl->{'mod_string'} =~ s/\?/$abl->{'modifier'}/g;
						$abl->{'mod_string'} =~ s/any per day/at will/g;
						print  $abl->{'mod_string'};
					}
				}
			}
		}
		print "---&nbsp;" if $count == 0;
	}
			
            
        

        
        print "</td></tr>\n";
    }


    #end the table
    print $q->end_table,
      $q->end_div;

    #generate info region
    print $q->start_div( { id => 'ability_info', class => 'ui-accordion-content ui-corner-bottom ui-widget-content'} );
    my @list;
    
    foreach (@abilities) {
        my $id = $_->{'id'};

        #have I printed this one yet? lets not be wasteful
        unless ( grep { $_ eq $id } @list ) {
            push( @list, $id );
            my ( $info, $name ) = @{$_}{qw(description name)};
            $info =~ s/(\[\[class\]\])/$_->{'class'}/g;

            #start the div
            print $q->div(
                {
                    id    => 'ability_'.$id,
                    style => 'display:none;',
                    class => 'ability_info'
                },
                h3('('.$id.') '.$name),
                p($info)
            );
        }
    }

    print $q->end_div();
}
