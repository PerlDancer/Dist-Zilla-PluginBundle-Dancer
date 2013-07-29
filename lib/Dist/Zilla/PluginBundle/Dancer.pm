package Dist::Zilla::PluginBundle::Dancer;

# ABSTRACT: dzil plugins used by Dancer projects

=head1 DESCRIPTION

This is the plugin bundle that the core L<Dancer> crew use to release
their distributions. It's roughly equivalent to

    [GatherDir]
    [PruneCruft]
    [ManifestSkip]
    [ExecDir]

    [AutoPrereqs]
    [MetaProvides::Package]
    [License]
    [MakeMaker]
    [ModuleBuild]
    [MetaYAML]
    [MetaJSON]
    [Manifest]

    [PkgVersion]

    [Authority]

    [ContributorsFromGit]

    [ContributorsFile]

    [Test::Compile]
    [MetaTests]
    [NoTabTests]
    [PodSyntaxTests]
    [Test::ReportPrereqs]

    [PodWeaver]

    [UploadToCPAN]

=head2 ARGUMENTS

=head3 authority

For L<Dist::Zilla::Plugin::Authority>.

=head3 test_compile_skip

I<skip> option for L<Dist::Zilla::Plugin::Test::Compile>.

=head3 autoprereqs_skip

I<skip> option for L<Dist::Zilla::Plugin::AutoPrereqs>.

=head3 include_dotfiles

For L<Dist::Zilla::Plugin::GatherDir>. Defaults to I<1>.

=cut

use 5.10.0;

use strict;

use Moose;

use Dist::Zilla::Plugin::GatherDir;
use Dist::Zilla::Plugin::Test::Compile 2.011;
use Dist::Zilla::Plugin::MetaTests;
use Dist::Zilla::Plugin::NoTabsTests;
use Dist::Zilla::Plugin::PodSyntaxTests;
use Dist::Zilla::Plugin::ExtraTests;
use Dist::Zilla::Plugin::PodWeaver;
use Dist::Zilla::Plugin::PruneCruft;
use Dist::Zilla::Plugin::ManifestSkip;
use Dist::Zilla::Plugin::ExecDir;
use Dist::Zilla::Plugin::AutoPrereqs;
use Dist::Zilla::Plugin::PkgVersion;
use Dist::Zilla::Plugin::MetaProvides::Package;
use Dist::Zilla::Plugin::License;
use Dist::Zilla::Plugin::MakeMaker;
use Dist::Zilla::Plugin::ModuleBuild;
use Dist::Zilla::Plugin::MetaYAML;
use Dist::Zilla::Plugin::MetaJSON;
use Dist::Zilla::Plugin::Manifest;
use Dist::Zilla::Plugin::Test::ReportPrereqs;
use Dist::Zilla::Plugin::ContributorsFromGit;
use Dist::Zilla::Plugin::ContributorsFile;
use Dist::Zilla::Plugin::UploadToCPAN;
use Dist::Zilla::Plugin::Authority;

with 'Dist::Zilla::Role::PluginBundle::Easy';

sub configure {
    my ( $self ) = @_;
    my $arg = $self->payload;

    $self->add_plugins(
        [ 'GatherDir' => { 
                include_dotfiles => $arg->{include_dotfiles} // 1
            },
        ],
        [ 'Test::Compile' => { skip => $arg->{test_compile_skip} } ],
        qw/ 
            MetaTests
            NoTabsTests
            PodSyntaxTests
            ExtraTests
            Test::ReportPrereqs
            PodWeaver
            PruneCruft
            ManifestSkip
            ExecDir
        /,
        [ 'AutoPrereqs' => { 
                ( skip => $arg->{autoprereqs_skip} )x!!$arg->{autoprereqs_skip} 
        } ],
        'MetaProvides::Package',
        'PkgVersion',
        [ 'Authority' => { authority => $arg->{authority} } ],
        qw/
            ContributorsFromGit
            ContributorsFile
            License
            MakeMaker
            ModuleBuild
            MetaYAML
            MetaJSON
            Manifest
            UploadToCPAN
        /,
    );

    return;
}

1;
