resource "aws_elb" "codedeploy" {
  name = "codedeploy-application-elb"
  subnets = [
    "${aws_subnet.subnet_a.id}",
    "${aws_subnet.subnet_b.id}",
    "${aws_subnet.subnet_c.id}",
  ]

  security_groups = [
    "${aws_security_group.default_egress.id}",
    "${aws_security_group.elb_www.id}",
  ]

  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 2
    target = "HTTP:80/health"
    interval = 10
  }

  instances = ["${aws_instance.codedeploy.*.id}"]

  tags {
    Name = "codedeploy-application-elb"
  }
}
