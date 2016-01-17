#!/usr/bin/pl
#
# -------------------------------------------------------------------------------
#   MT Banned List Plugin v0.1
#   Written by Yakov Shafranovich
#
#   A Project of SolidMatrix Research
#   Email:  research@solidmatrix.com
#   
#   Copyright (C) 2005 SolidMatrix Technologies, Inc.
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
# -------------------------------------------------------------------------------
# This plugin adds tags to output the internal IP ban list maintained in
# Movable Type. For example:
#
# <MTBannedList>
#    <$MTBannedListValue$>
# </MTBannedList>
#
# The purpose of this is to allow blog owners to share their blacklists. Attached,
# you will find two template files, one to generate RSS 2.0 feed of the blacklist
# and a second to generate a plain text file. To use, add this file to your
# MovableType plugins directory and add either of the two templates.
# -------------------------------------------------------------------------------
#

package MT::Plugins::BannedList;
use MT::Template::Context;
use MT::IPBanList;

MT::Template::Context->add_container_tag(BannedList => sub {
    my $ctx = shift;
    my $res = '';
    my $builder = $ctx->stash('builder');
    my $tokens = $ctx->stash('tokens');
    my $blog_id = $ctx->stash('blog_id');
    
    require MT::IPBanList;
    my $iter = MT::IPBanList->load_iter({blog_id => $blog_id });
    while (my $ban = $iter->()) {
        $ctx->stash('value', $ban->ip);
        defined(my $out = $builder->build($ctx, $tokens))
            or return $ctx->error($ctx->errstr);
        $res .= $out;
    }
    $res;
});

MT::Template::Context->add_tag(BannedListValue => sub {
    my $ctx = shift;
    $ctx->stash('value');
});