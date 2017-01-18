resource "aws_launch_configuration" "as_conf" {
    name_prefix = "web_config"
    image_id = "ami-1e299d7e"
    instance_type = "t2.micro"
    user_data = "${file("userdata.sh")}"
    key_name = "mahi-laptop"
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_autoscaling_group" "bar" {
    name = "${aws_launch_configuration.as_conf.name}-asp"
    launch_configuration = "${aws_launch_configuration.as_conf.name}"
    availability_zones = ["us-west-2a"]
    max_size                  = 2
    min_size                  = 1
    health_check_grace_period = 300
    health_check_type         = "ELB"
    desired_capacity          = 1
    force_delete              = true
    load_balancers            = ["${aws_elb.bar.name}"]
    tag {
      key                 = "foo"
      value               = "bar"
      propagate_at_launch = true
    }
}
