// https://discord.com/api/webhooks/1116811674964467751/uGLPnYadfLC-r3sc7mV6cKMV57ra-rH_Xe_MmhnhAwf4Mv0hRpCycTEAOExFVHMScu_8

import funkin.backend.system.Main;
import sys.Http;

function onSongEnd() {
    Main.execAsync(()->{
        var http = new Http('https://discord.com/api/webhooks/1116811674964467751/uGLPnYadfLC-r3sc7mV6cKMV57ra-rH_Xe_MmhnhAwf4Mv0hRpCycTEAOExFVHMScu_8');
        http.setParameter('content', '**' + PlayState.SONG.meta.displayName + '** results:\nAccuracy: `' + FlxMath.roundDecimal(accuracy * 100, 2) + '% ('+ curRating.rating +')` - Misses: `' + misses + '` - Score: `' + songScore + '`');
        http.request(true);
    });
}