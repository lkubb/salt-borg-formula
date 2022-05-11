# frozen_string_literal: true

control 'borg.package.install' do
  title 'The required package should be installed'

  package_name = 'borgbackup'

  describe package(package_name) do
    it { should be_installed }
  end
end
