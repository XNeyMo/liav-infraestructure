resource "aws_security_group" "allow_http" {
  name        = "allow_http_traffic"
  description = "Allow HTTP traffic"

  # Reglas de entrada (Inbound rules)
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  # Reglas de salida (Outbound rules)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 significa todo el tráfico
    cidr_blocks = ["0.0.0.0/0"]  # Permite el tráfico a cualquier IP
  }

  tags = {
    Name = "Allow HTTP and HTTPS"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh_traffic"
  description = "Allow SSH traffic"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite el tráfico desde cualquier IP
  }

  # Reglas de salida (Outbound rules)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 significa todo el tráfico
    cidr_blocks = ["0.0.0.0/0"]  # Permite el tráfico a cualquier IP
  }

  tags = {
    Name = "Allow SSH"
  }
}

resource "aws_security_group" "allow_mysql" {
  name        = "allow_mysql_traffic"
  description = "Allow MYSQL traffic"

  ingress {
    description = "Allow MYSQL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.access_mysql.id]
  }

  # Reglas de salida (Outbound rules)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # -1 significa todo el tráfico
    cidr_blocks = ["0.0.0.0/0"]  # Permite el tráfico a cualquier IP
  }

  tags = {
    Name = "AllowHTTP"
  }
}

resource "aws_security_group" "access_mysql" {
  name        = "access_mysql"
  description = "Access MYSQL"
  tags = {
    Name = "AccessMYSQL"
  }
}