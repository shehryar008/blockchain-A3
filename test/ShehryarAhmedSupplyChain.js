const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ShehryarAhmedSupplyChain", function () {
  async function deployFixture() {
    const [admin, manufacturer, distributor, retailer, customer] = await ethers.getSigners();
    const Factory = await ethers.getContractFactory("ShehryarAhmedSupplyChain");
    const contract = await Factory.deploy(admin.address);
    await contract.waitForDeployment();

    await contract.connect(admin).assignRole(manufacturer.address, await contract.MANUFACTURER_ROLE());
    await contract.connect(admin).assignRole(distributor.address, await contract.DISTRIBUTOR_ROLE());
    await contract.connect(admin).assignRole(retailer.address, await contract.RETAILER_ROLE());
    await contract.connect(admin).assignRole(customer.address, await contract.CUSTOMER_ROLE());

    return { contract, admin, manufacturer, distributor, retailer, customer };
  }

  it("registers a product and records history", async function () {
    const { contract, manufacturer } = await deployFixture();

    await contract.connect(manufacturer).registerProduct("Laptop", "Dell business laptop");
    const product = await contract.getProduct(1);

    expect(product.name).to.equal("Laptop");
    expect(product.status).to.equal(0);
    expect(await contract.getHistoryLength(1)).to.equal(1);
  });

  it("moves product through the supply chain", async function () {
    const { contract, manufacturer, distributor, retailer, customer } = await deployFixture();

    await contract.connect(manufacturer).registerProduct("Phone", "Smartphone");
    await contract.connect(manufacturer).transferToDistributor(1, distributor.address);
    await contract.connect(distributor).transferToRetailer(1, retailer.address);
    await contract.connect(retailer).transferToCustomer(1, customer.address);

    const product = await contract.getProduct(1);
    expect(product.currentOwner).to.equal(customer.address);
    expect(product.status).to.equal(2);
    expect(await contract.getHistoryLength(1)).to.equal(4);
  });
});
