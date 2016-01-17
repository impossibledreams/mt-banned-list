#!/usr/bin/pl
#
# -------------------------------------------------------------------------------
#   MT Banned List Plugin. Created by Yakov Shafranovich.
#
#   Copyright (c) 2005-2009 SolidMatrix Technologies, Inc.
#   Copyright (c) 2009-2015 Shaftek Enterprises.
#   Copyright (c) 2016- Impossible Dreams Network.
#
#   Source code can be found at:
#   https://github.com/impossibledreams/mt-banned-list
#
#   Licensed under the Apache License, Version 2.0.
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