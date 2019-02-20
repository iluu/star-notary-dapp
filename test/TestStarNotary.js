const StarNotary = artifacts.require('StarNotary');

let accounts;
var owner;

contract('StarNotary', async (accs) => {
    accounts = accs;
    owner = accounts[0];
});

it ('has correct name', async () => {
    let instance = await StarNotary.deployed();
    let starName = await instance.starName.call();
    assert.equal(starName, 'Genesis Star');
});

it ('can be claimed', async () => {
    let instance = await StarNotary.deployed();
    await instance.claimStar({from: owner});

    let starOwner = await instance.starOwner.call();
    assert.equal(starOwner, owner);
});

it ('can change owners', async () => {
    let instance = await StarNotary.deployed();
    var secondUser = accounts[1];
    var starOwner

    await instance.claimStar({from: owner});
    starOwner = await instance.starOwner.call();
    assert.equal(starOwner, owner);

    await instance.claimStar({from: secondUser});
    starOwner = await instance.starOwner.call();
    assert.equal(starOwner, secondUser);
});

it ('can change name', async () => {
    let instance = await StarNotary.deployed();
    let newName = "New Star Name";
    await instance.changeName(newName);

    let changedName = await instance.starName.call()
    assert.equal(changedName, newName);
})