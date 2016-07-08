require_relative '../chef_dk_app'

shared_context 'resources::chef_dk_app::rhel' do
  include_context 'resources::chef_dk_app'

  shared_examples_for 'any RHEL platform' do
    context 'the default action (:install)' do
      include_context description

      context 'the default source (:direct)' do
        include_context description

        shared_examples_for 'any property set' do
          it 'downloads the correct Chef-DK' do
            expect(chef_run).to create_remote_file('/tmp/cache/chefdk')
              .with(source: "http://example.com/#{channel || 'stable'}/chefdk",
                    checksum: '1234')
          end

          it 'installs the downloaded package' do
            expect(chef_run).to install_rpm_package('/tmp/cache/chefdk')
          end
        end

        [
          'all default properties',
          'an overridden channel property',
          'an overridden version property'
        ].each do |c|
          context c do
            include_context description

            it_behaves_like 'any property set'
          end
        end
      end

      context 'the :repo source' do
        include_context description

        shared_examples_for 'any property set' do
          it 'configures the Chef YUM repo' do
            expect(chef_run).to include_recipe(
              "yum-chef::#{channel || 'stable'}"
            )
          end

          it 'installs the chefdk package' do
            expect(chef_run).to install_package('chefdk').with(version: version)
          end
        end

        [
          'all default properties',
          'an overridden channel property',
          'an overridden version property'
        ].each do |c|
          context c do
            include_context description

            it_behaves_like 'any property set'
          end
        end
      end

      context 'a custom source' do
        include_context description

        context 'all default properties' do
          include_context description

          it 'downloads the correct Chef-DK' do
            expect(chef_run).to create_remote_file('/tmp/cache/cdk')
              .with(source: 'https://example.biz/cdk', checksum: '12345')
          end

          it 'installs the downloaded package' do
            expect(chef_run).to install_rpm_package('/tmp/cache/cdk')
          end
        end

        context 'an overridden channel property' do
          include_context description

          it 'raises an error' do
            pending
            expect(true).to eq(false)
          end
        end

        context 'an overridden version property' do
          include_context description

          it 'raises an error' do
            pending
            expect(true).to eq(false)
          end
        end
      end
    end

    context 'the :remove action' do
      include_context description

      shared_examples_for 'any property set' do
        it 'removes the package' do
          expect(chef_run).to remove_package('chefdk')
        end
      end

      [
        'the default source (:direct)',
        'the :repo source',
        'a custom source'
      ].each do |c|
        context c do
          include_context description

          it_behaves_like 'any property set'
        end
      end
    end
  end
end
