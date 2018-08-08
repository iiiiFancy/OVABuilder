const easyvc = require('./node_modules/easyvc/lib/index.js')();
const config = require('./config.js');

(async function() {
    console.log('Running setupPhoton.js ...')
    await easyvc.login(config.vc.host, config.vc.user, config.vc.password)
    console.log('logged in')

    for (let vm of config.vms) {
        console.log(await setup(vm.name, vm.user, vm.pwd))
    }
})().catch(err => console.error('ERROR:', err))

async function setup(vmName, guestUser, guestPwd) {
    console.log(`Setup: vm=${vmName}`)

    let vm = (await easyvc.findVMsByName(vmName))[0]
    if (!vm)
        throw 'VM not found: ' + vmName
    console.log('vm:', vm.mor.value)

    await vm.waitForVmTools(1000)
    console.log('VM tools ready')

    let ips = await vm.getIPAddress()
    console.log('ips', ips)

    let guest = await vm.guest(guestUser, guestPwd, {log: false})
    let fileMgr = guest.file()
    let processMgr = guest.process()

    console.log('Upload connector codes...')
    let folderPath = '/root'
    let fullPath = folderPath + '/connector.zip'
    await fileMgr.uploadFile('./download/connector.zip', fullPath)
    fullPath = folderPath + '/setupAutoRun.txt'
    await fileMgr.uploadFile('./setupAutoRun.txt', fullPath)
    fullPath = folderPath + '/setupPhoton.sh'
    await fileMgr.uploadFile('./setupPhoton.sh', fullPath)

    console.log('Upload completed, run script. It takes several mins.')
    let script = `
        chmod u+x ${fullPath}
        ${fullPath}
        ${process.argv[2]}
    `

    let result = await processMgr.runScript(script, 600 * 1000)
    // console.log(result.toString())

    return 'DONE'
}