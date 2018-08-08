process.env.NODE_TLS_REJECT_UNAUTHORIZED = 0
process.on('unhandledRejection', (reason, p) => {
    console.log('Unhandled Rejection at: Promise', p, 'reason:', reason)
    process.exit()
})

module.exports = {
	vc: {
		host: '10.117.160.100',
		user: 'asdf',
		password: 'asdf',
	},
	vms: [{
		name: 'PhotonWithConnector',
		user: 'root',
		pwd: 'VMware123'
	}]
}