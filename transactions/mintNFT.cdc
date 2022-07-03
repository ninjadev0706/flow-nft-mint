import BottomShot from 0xf8d6e0586b0a20c7
import NonFungibleToken from 0xf8d6e0586b0a20c7

// Our transaction object now takes in arguments!
transaction(
    recipient: Address,
    name: String,
    description: String,
    thumbnail: String,
) {
  prepare(signer: AuthAccount) {
    // Check if the user sending the transaction has a collection
    if signer.borrow<&BottomShot.Collection>(from: BottomShot.CollectionStoragePath) != nil {
        // If they do, we move on to the execute stage
        return
    }

    // If they don't, we create a new empty collection
    let collection <- BottomShot.createEmptyCollection()

    // Save it to the account
    signer.save(<-collection, to: BottomShot.CollectionStoragePath)

    // Create a public capability for the collection
    signer.link<&{NonFungibleToken.CollectionPublic}>(
        BottomShot.CollectionPublicPath,
        target: BottomShot.CollectionStoragePath
    )
  }


  execute {
    // Borrow the recipient's public NFT collection reference
    let receiver = getAccount(recipient)
        .getCapability(BottomShot.CollectionPublicPath)
        .borrow<&{NonFungibleToken.CollectionPublic}>()
        ?? panic("Could not get receiver reference to the NFT Collection")

    // Mint the NFT and deposit it to the recipient's collection
    BottomShot.mintNFT(
        recipient: receiver,
        name: name,
        description: description,
        thumbnail: thumbnail,
    )
    
    log("Minted an NFT and stored it into the collection")
  } 
}