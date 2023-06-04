package crud::Controller::Example;
use Mojo::Base 'Mojolicious::Controller', -signatures;

# Connect to database mysql
sub connect_db_mysql {
      my $driver   = "mysql";
      my $host     = "localhost";
      my $port     = "3306";
      my $database = "test";
      my $username = "root";
      my $password = "";

      my $dsn = "DBI:$driver:database=$database;host=$host;port=$port";

      my $dbh = DBI->connect($dsn, $username, $password, {
            RaiseError => 1,
            AutoCommit => 1,
            mysql_enable_utf8 => 1,
      }) or die $DBI::errstr;

      print "Connect database successfully\n";
      return $dbh;
}

# show data
sub show {
      my $self  = shift;
      my $dbh = connect_db_mysql();
      my $sql = "SELECT * FROM users";
      my $sth = $dbh->prepare($sql);
      # Show error if false 
      my $rv  = $sth->execute() or die $DBI::errstr;
      # show item put out
      ($rv < 0) ? print $DBI::errstr : print "Operation done successfully\n"; 
      # array of data
      my @rows;
      while (my $row = $sth->fetchrow_hashref) {
            push @rows, $row;
      }
      $self->res->headers->header('Access-Control-Allow-Origin' => '*');
      
      $self->render(
            json => \@rows,
            status => 200
      );
      $sth->finish();
      $dbh->disconnect();
      return;
}

1;
