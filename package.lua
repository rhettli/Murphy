--author: liyanxi

return {

    package_name = 'oshine/Murphy',

    dependencies = {
        ['oshine/cw_any_type'] = '*|local',
        ['oshine/cw_args_capture'] = '*|local'
    },

    platform = 'all' or 'windows drawn linux',

    -- register port 8008
    port = '8008',

    remark='for dev web app',
    title='Coder Wooyri official web framework',

    -- require == 0 or false,will be download local dir
    require=0 or false
}







