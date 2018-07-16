const TOKEN = artifacts.require("BitProjectToken.sol")

contract('BitProjectToken', (accounts) => {

	let token
	let initialSupply = 1000000

	beforeEach(async () => {
		token = await TOKEN.new(initialSupply)
	})

	describe('mint', () => {
		const mintAmount = 100

		it('increases the total amount', async () => {
			await token.mint(accounts[1], mintAmount)
			const totalSupply = await token.totalSupply()
			assert.equal(totalSupply, initialSupply + mintAmount)
		})

		it('non-admins are unable to mint, only admins can', async () => {
			assert.equal(
				await token.mint(accounts[1], mintAmount, {from: accounts[1]}).catch(err => {
					return err.message
				}),
				'VM Exception while processing transaction: revert'
			)

			await token.addAdmin(accounts[1])
			await token.mint(accounts[1], mintAmount, {from: accounts[1]})

			await token.revokeAdmin(accounts[1])
			assert.equal(
				await token.mint(accounts[1], mintAmount, {from: accounts[1]}).catch(err => {
					return err.message
				}),
				'VM Exception while processing transaction: revert'
			)

		})
	})
})