require 'aws-sdk'
require 'yaml'

dir = File.absolute_path('..',$0)
regions = YAML.load(File.read("#{dir}/region.yml"))
regions.each_value do |aws_region|
  access_key =  YAML.load(File.read("#{dir}/access_key.yml"))
  access_key.store('ec2_endpoint', aws_region)
  AWS.config(access_key)

  ec2 = AWS::EC2.new

  ec2.instances.each do |instance|
    target_ec2 = ec2.instances[instance.id]
    image_name = "_Auto Backup_#{Time.now.strftime("%F")}_#{target_ec2.tags["Name"]}"
    puts "create AMI: #{target_ec2.tags["Name"]}"
    target_ec2.create_image(image_name, {no_reboot: true})
  end
end
